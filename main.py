# This Python file uses the following encoding: utf-8
import sys
import os
import shutil
from distutils.dir_util import copy_tree

# Needed libraries for generating & storing heatmap images
import gradcam
import tensorflow as tf
import numpy as np
import PIL

# Qt libraries
from PySide2.QtGui import QGuiApplication
from PySide2.QtQml import QQmlApplicationEngine
from PySide2.QtQml import QQmlComponent
from PySide2.QtCore import QUrl, QObject, Slot, Signal

# Maximum possible number of different models and
# images that can be added inside of the app
MAX_MODELS_NUM = 5
MAX_IMAGES_NUM = 5

class_labels = {0: {'side':'side_left', 'cast':'no_cast', 'projection':'projection_ap', 'metal':'no_metal', 'osteopenia':'no_osteopenia', 'fracture':'fracture_zero', 'fracture_binary':'no_fracture'},
                1: {'side':'side_right', 'cast':'cast', 'projection':'projection_lat', 'metal':'metal', 'osteopenia':'osteopenia', 'fracture':'fracture_one', 'fracture_binary':'fracture'},
                2: {'fracture':'fracture_multiple'}}   
class_labels_animals = {0: 'cane', 1:'cavallo', 2:'elefante', 3:'farfalla', 4:'gallina', 5:'gatto', 6:'mucca', 7:'pecora', 8:'ragno', 9:'scoiattolo'}

def determine_criterium_by_model_filename(model_filename):
    criteriums = ['fracture_binary', 'fracture', 'metal', 'osteopenia', 'cast', 'side', 'projection', 'animals']
    for crit in criteriums:
        if crit in model_filename:
            return crit
    return -1

class QmlFunctions(QObject):
    @Slot(str, str)
    def saveSingleImage(str, heatmap_image_path, dest_dir):
        heatmap_image_path = heatmap_image_path.replace('file:///', '')
        dest_dir = dest_dir.replace('file:///', '')
        shutil.copy(heatmap_image_path, dest_dir)

    @Slot(str)
    def exportAllImages(str, dest_dir):
        dest_dir = dest_dir.replace('file:///', '')
        copy_tree('./heatmap_images/', dest_dir)

    @Slot(list, list, result=list)
    def loadNewModel(str, model_paths, img_paths):
        model_paths = list(filter(None, model_paths))
        img_paths = list(filter(None, img_paths))
        # Initialize None 2D arrays where wanted data will be stored and then return to QML file
        heatmap_images_fnames_array = [[None for i in range(len(img_paths))] for j in range(len(model_paths))]
        predicted_class_array = [[None for i in range(len(img_paths))] for j in range(len(model_paths))]
        prediction_probability_array = [[None for i in range(len(img_paths))] for j in range(len(model_paths))]

        # From model paths given in the GUI, load the models and use them
        # to generate heatmaps (using images also specified through the GUI)
        for i, model_path in enumerate(model_paths):
            if model_path is not None:
                model_path = model_path.replace('file:///', '')
                model_name = model_path.split('/')[-1]

                # Find out for which criteria is the model trained for
                # (based on model filename)
                criterium = determine_criterium_by_model_filename(model_name)

                # Load i-th model
                model = gradcam.load_model(model_path, compile=False)
                # Last convolutional layer of the model is needed in order to
                # use the GradCAM method which generates heatmaps
                last_conv_layer_name = gradcam.get_last_conv_layer_name(model)
                # Input model shape is also needed in order to generate heatmaps
                MODEL_INPUT_DIMS = model.layers[0].input_shape[0][1]

                # For i-th model, generate heatmaps for all input images
                for j, img_path in enumerate(img_paths):
                    if img_path is not None:
                        img_path = img_path.replace('file:///', '')

                        # Load j-th image and process it for GradCAM method 
                        image = np.array(PIL.Image.open(img_path))
                        image = tf.cast(image, dtype = tf.float32) #Necessity otherwise really bad practice
                        image = tf.image.resize(image, [MODEL_INPUT_DIMS, MODEL_INPUT_DIMS], method = 'lanczos3', preserve_aspect_ratio=True) 
                        image = image / 255.
                        image = np.expand_dims(image, axis=0)

                        # Create heatmap for j-th image
                        heatmap = gradcam.make_gradcam_heatmap(image, model, last_conv_layer_name)
                        # Make predictions for j-th image using i-th model
                        preds = model.predict(image)
                        # Binary classification by default
                        classes = 1
                        # Unless it isn't
                        if model.layers[-1].get_config()['activation'] == 'softmax':
                            if 'animals' in criterium:
                                classes = 10
                            elif 'fracture' in criterium:
                                classes = 3
                        # Superimpose the heatmap on original image,
                        # save those images, then store prediction and image
                        # data to previously initialized empty (None) arrays
                        heatmap_images_fnames_array[i][j], predicted_class_array[i][j], prediction_probability_array[i][j] = gradcam.apply_heatmap_to_image(img_path, heatmap, preds, criterium, classes)

        # Send stored data back to QML
        return [heatmap_images_fnames_array, predicted_class_array, prediction_probability_array]

if __name__ == "__main__":
    app = QGuiApplication(sys.argv)
    app.setOrganizationName("heatmap_gui_app")
    app.setOrganizationDomain("qt_projekt")
    engine = QQmlApplicationEngine()
    context = engine.rootContext()
    context.setContextProperty("main", engine)
    engine.load(os.path.join(os.path.dirname(__file__), "main.qml"))

    qmlFunctions = QmlFunctions()
    context.setContextProperty("pyMainApp", qmlFunctions)

    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec_())
