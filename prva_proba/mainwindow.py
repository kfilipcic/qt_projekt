# This Python file uses the following encoding: utf-8
import sys
import os
CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))


from PySide2 import QtCore as qtc
from PySide2 import QtGui as qtg
from PySide2 import QtQml as qml

from PySide2.QtCore import QModelIndex
from PySide2.QtCore import Qt
from PySide2.QtCore import QUrl

img = 'E:/kfilipcic/qt_projekt/prva_proba/plasma-icon.jpg'

class TableModel(qtc.QAbstractTableModel):
    NameRole = qtc.Qt.UserRole + 1000
    ImageRole = qtc.Qt.UserRole + 1001

    def __init__(self, parent=None, *args):
        super(TableModel, self).__init__()
        img_url = os.path.join(CURRENT_DIR, img)
        self.img = qtg.QImage('file:///' + img_url)

    def rowCount(self, parent=qtc.QModelIndex()):
        return 10

    def columnCount(self, parent=qtc.QModelIndex()):
        return 5

    def data(self, index, role=Qt.DisplayRole):
        # if role == Qt.DisplayRole or role == TableModel.NameRole:
        if role == TableModel.NameRole:
            i = index.row()
            j = index.column()
            return '({0}, {1})'.format(i, j)
        elif role == TableModel.ImageRole:
            #return 'file:///' + os.path.join(CURRENT_DIR, img)
        else:
            return QtCore.QVariant()

    def roleNames(self):
        roles = dict()
        roles[TableModel.NameRole] = b'displayText'
        roles[TableModel.ImageRole] = b'displayImage'
        return roles

    def flags(self, index):
        return QtCore.Qt.ItemIsEnabled

def main():
    app = qtg.QGuiApplication(sys.argv)

    engine = qml.QQmlApplicationEngine()

    tablemodel=TableModel()
    engine.rootContext().setContextProperty('tablemodel', tablemodel)

    engine.load(qtc.QUrl.fromLocalFile(os.path.join(CURRENT_DIR, 'main.qml')))

#    test_add_item(backend.model)

    if not engine.rootObjects():
        return -1

    return app.exec_()


if __name__ == "__main__":
    sys.exit(main())
