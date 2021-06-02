import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Dialogs 1.2
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtQml.Models 2.3

Window {
    id: window
    width: 800
    height: 1000
    visible: true
    title: qsTr("Heatmap GUI App")
    property int modelInputsCounter: 1;
    property int imageInputsCounter: 1;
    property int browseModelsIndexClicked;
    property var modelFilenamesArray: [];
    property var modelPathTextField;

    property int imageRowsNum;
    property int imageColsNum;
    property int browseIndexClicked;
    property var imagePathTextField;
    property var heatmapImagesMatrix: null;
    property var imageFilenamesArray: [];
    property var matrixImageMouseAreaVar: null;
    property var firstPageObject: null;
    property var resultsPageObject: null;
    
    property var heatmapFilenamesArray: [];
    property var predictedClassArray: [];
    property var predictionProbabilityArray: [];

    property var imageColIndex: 0;
    property var imageRowIndex: 0;

    onWidthChanged: {
        resultsPageObject.resultsPageObjectModelProp.children[0].forceLayout();
    }

    Menu {
        id: contextMenu
        MenuItem {
            text: "Save image"
            onClicked: saveSingleImageDialog.open()
        }
        FileDialog {
            id: saveSingleImageDialog
            folder: shortcuts.home
            selectExisting: false
            nameFilters: qsTr("Image files (*.jpg *.png)")
            onAccepted: {
                pyMainApp.saveSingleImage(heatmapFilenamesArray[imageRowIndex][imageColIndex] ,this.fileUrl);
            }
        }
    }
    SwipeView {
        id: swipeViewId
        width: parent.width
        height: parent.height
        currentIndex: 0
        onCurrentIndexChanged: {
            firstPageObject.visible = true
        }

        Component.onCompleted: {
            var firstPageComponent = Qt.createComponent(qsTr("first_page.qml"));
            firstPageObject = firstPageComponent.createObject();
            swipeViewId.addItem(firstPageObject);
        }
    }
}