# Qt libraries
from PySide2.QtGui import QGuiApplication
from PySide2.QtQml import QQmlApplicationEngine
from PySide2.QtQml import QQmlComponent
from PySide2.QtCore import Qt
from PySide2.QtCore import QUrl, QObject, Slot, Signal
from PySide2 import QtCore as qtc
from PySide2 import QtGui as qtg

class HeatmapImagesMatrixTableModel(qtc.QAbstractTableModel):
    NameRole = qtc.Qt.UserRole + 1000
    ImageRole = qtc.Qt.UserRole + 1001
    ImagePathRole = qtc.Qt.UserRole + 1002
    ModelPathRole = qtc.Qt.UserRole + 1003
    PredictedClassRole = qtc.Qt.UserRole + 1004
    PredictionProbabilityRole = qtc.Qt.UserRole + 1005

    def __init__(self, qmlFunc):
        super(HeatmapImagesMatrixTableModel, self).__init__()
        HeatmapImagesMatrixTableModel.qmlFunctions = qmlFunc

    def rowCount(self, parent=qtc.QModelIndex()):
        return len(HeatmapImagesMatrixTableModel.qmlFunctions.img_paths)

    def columnCount(self, parent=qtc.QModelIndex()):
        return len(HeatmapImagesMatrixTableModel.qmlFunctions.model_paths)

    def headerData(self, section, orientation, role):
        if orientation == Qt.Orientation.Horizontal:
            return "Model " + str(section+1)
        elif orientation == Qt.Orientation.Vertical:
            return "Image " + str(section+1)

    
    def data(self, index, role=Qt.DisplayRole):
        i = index.row()
        j = index.column()
        if role == HeatmapImagesMatrixTableModel.NameRole: 
            return '({0}, {1})'.format(i, j)
        elif role == HeatmapImagesMatrixTableModel.ImageRole:
            return HeatmapImagesMatrixTableModel.qmlFunctions.heatmap_images_fnames_array[j-1][i-1]
        elif role == HeatmapImagesMatrixTableModel.ImagePathRole:
            return HeatmapImagesMatrixTableModel.qmlFunctions.img_paths[i-1]
        elif role == HeatmapImagesMatrixTableModel.ModelPathRole:
            return HeatmapImagesMatrixTableModel.qmlFunctions.model_paths[j-1]
        elif role == HeatmapImagesMatrixTableModel.PredictedClassRole:
            return HeatmapImagesMatrixTableModel.qmlFunctions.predicted_class_array[j-1][i-1]
        elif role == HeatmapImagesMatrixTableModel.PredictionProbabilityRole:
            return HeatmapImagesMatrixTableModel.qmlFunctions.prediction_probability_array[j-1][i-1]
        else:
            return QtCore.QVariant()

    def roleNames(self):
        roles = dict()
        roles[HeatmapImagesMatrixTableModel.NameRole] = b'displayText'
        roles[HeatmapImagesMatrixTableModel.ImageRole] = b'displayImage'
        roles[HeatmapImagesMatrixTableModel.ImagePathRole] = b'imagePath'
        roles[HeatmapImagesMatrixTableModel.ModelPathRole] = b'modelPath'
        roles[HeatmapImagesMatrixTableModel.PredictedClassRole] = b'predictedClass'
        roles[HeatmapImagesMatrixTableModel.PredictionProbabilityRole] = b'classProbability'
        return roles

    def flags(self, index):
        return QtCore.Qt.ItemIsEnabled

def determine_criterium_by_model_filename(model_filename):
    criteriums = ['fracture_binary', 'fracture', 'metal', 'osteopenia', 'cast', 'side', 'projection', 'animals']
    for crit in criteriums:
        if crit in model_filename:
            return crit
    return -1