# Import librarires
from __future__ import absolute_import, division, print_function, unicode_literals
import tensorflow as tf
import pathlib
import random
import os
import matplotlib.pyplot as plt
import tensorflow.keras.backend as K
from tensorflow.keras.models import load_model
from classification_models.tfkeras import Classifiers
from keras.layers.merge import concatenate
import IPython.display as display
import numpy as np
import pydot
import time
import cv2
import json
import numpy as np
from sklearn.decomposition import PCA
import math
from scipy import ndimage
import os
import imutils
import PIL
from functools import partial
keras = tf.keras

class_labels = {0: {'side':'side_left', 'cast':'no_cast', 'projection':'projection_ap', 'metal':'no_metal', 'osteopenia':'no_osteopenia', 'fracture':'fracture_zero', 'fracture_binary':'no_fracture'},
                1: {'side':'side_right', 'cast':'cast', 'projection':'projection_lat', 'metal':'metal', 'osteopenia':'osteopenia', 'fracture':'fracture_one', 'fracture_binary':'fracture'},
                2: {'fracture':'fracture_multiple'}}

def make_gradcam_heatmap(img_array, model, last_conv_layer_name, pred_index=None):
    # First, we create a model that maps the input image to the activations
    # of the last conv layer as well as the output predictions
    grad_model = tf.keras.models.Model(
        [model.inputs], [model.get_layer(last_conv_layer_name).output, model.output]
    )

    # Then, we compute the gradient of the top predicted class for our input image
    # with respect to the activations of the last conv layer
    with tf.GradientTape() as tape:
        last_conv_layer_output, preds = grad_model(img_array)
        if pred_index is None:
            pred_index = tf.argmax(preds[0])
        class_channel = preds[:, pred_index]

    # This is the gradient of the output neuron (top predicted or chosen)
    # with regard to the output feature map of the last conv layer
    grads = tape.gradient(class_channel, last_conv_layer_output)

    # This is a vector where each entry is the mean intensity of the gradient
    # over a specific feature map channel
    pooled_grads = tf.reduce_mean(grads, axis=(0, 1, 2))

    # We multiply each channel in the feature map array
    # by "how important this channel is" with regard to the top predicted class
    # then sum all the channels to obtain the heatmap class activation
    last_conv_layer_output = last_conv_layer_output[0]
    heatmap = last_conv_layer_output @ pooled_grads[..., tf.newaxis]
    heatmap = tf.squeeze(heatmap)

    # For visualization purpose, we will also normalize the heatmap between 0 & 1
    heatmap = tf.maximum(heatmap, 0) / tf.math.reduce_max(heatmap)
    return heatmap.numpy()

def apply_heatmap_to_image(img_path, heatmap, preds, criterium, classes):
    # We load the original image
    from matplotlib import cm
    img = np.array(PIL.Image.open(img_path))
    img = tf.cast(img, dtype = tf.float32) #Necessity otherwise really bad practice
    
    # We rescale heatmap to a range 0-255
    heatmap = np.uint8(255 * heatmap)

    # We use jet colormap to colorize heatmap
    jet = cm.get_cmap("jet")

    # We use RGB values of the colormap
    jet_colors = jet(np.arange(256))[:, :3]
    jet_heatmap = jet_colors[heatmap]

    # We create an image with RGB colorized heatmap
    jet_heatmap = keras.preprocessing.image.array_to_img(jet_heatmap)
    jet_heatmap = jet_heatmap.resize((img.shape[1], img.shape[0]))
    jet_heatmap = keras.preprocessing.image.img_to_array(jet_heatmap)

    # Superimpose the heatmap on original image
    superimposed_img = jet_heatmap * 0.4 + img
    superimposed_img = keras.preprocessing.image.array_to_img(superimposed_img)

    # Save the superimposed image
    img_fname = img_path.split('/')[-1]
    img_fname = img_fname.replace('.jpg', '')
    
    probability_of_predicted_class = preds[0][0]
    predicted_class = round(probability_of_predicted_class)

    if classes > 1:
        predicted_class = np.argmax(preds[0])
        probability_of_predicted_class = preds[0][predicted_class] 
        
    prob_str = str(probability_of_predicted_class)
    prob_str = prob_str[:8]
    heatmap_image_fname = 'pred_cls_' + class_labels[predicted_class][criterium] + '_' + prob_str + '_' + img_fname + '_heatmap.jpg'

    if not os.path.isdir('heatmap_images'):
        os.mkdir('heatmap_images')
    superimposed_img.save('./heatmap_images/' + heatmap_image_fname)

    return './heatmap_images/' + heatmap_image_fname, class_labels[predicted_class][criterium], prob_str

def get_last_conv_layer_name(model):
    for idx in reversed(range(len(model.layers))):
      if 'convolutional' in str(type(model.get_layer(index = idx))):
        return model.get_layer(index = idx).name