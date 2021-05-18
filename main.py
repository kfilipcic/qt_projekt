# This Python file uses the following encoding: utf-8
import sys
import os

from PySide2.QtGui import QGuiApplication
from PySide2.QtQml import QQmlApplicationEngine
from PySide2.QtQml import QQmlComponent
from PySide2.QtCore import QUrl


if __name__ == "__main__":
    app = QGuiApplication(sys.argv)
    app.setOrganizationName("byvy");
    app.setOrganizationDomain("bzvz");
    engine = QQmlApplicationEngine()
    engine.load(os.path.join(os.path.dirname(__file__), "main.qml"))

    ## get root (ApplicationWindow casted to QQuickItem)
    #root = engine.rootObjects()[0].children()[0]

    ## create component
    #component = QQmlComponent(engine)
    #component.loadUrl(QUrl("input_path.qml"))
    #itm = component.create()
    #itm.setParentItem(root)

    def createNewPathInput(type):
        if type == 'model':
            return

    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec_())
