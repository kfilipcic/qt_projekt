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
    
    property var heatmapFilenamesArray: [];
    property var predictedClassArray: [];
    property var predictionProbabilityArray: [];

    property var imageColIndex: 0;
    property var imageRowIndex: 0;

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
    Item {
        id: windowItem
        anchors.fill: parent
        ColumnLayout {
            id: mainAppColumn
            width: parent.width
            height: parent.height
            anchors.fill: parent
            Repeater {
                Layout.fillHeight: true
                Layout.fillWidth: true
                model: ObjectModel {
                    id: mainAppColumnObjectModel
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    MenuBar {
                        id: topMenu

                    Layout.fillWidth: true
                        Menu {
                            title: qsTr("&File")
                            FileDialog {
                                id: exportAllImagesFileDialog 
                                folder: shortcuts.home
                                selectFolder: true
                                onAccepted: {
                                    pyMainApp.exportAllImages(this.fileUrl);
                                }
                            }

                            Action { 
                                text: qsTr("&Export images");
                                onTriggered: {
                                    exportAllImagesFileDialog.open()
                                }
                            }
                            Action { text: qsTr("&Exit"); onTriggered: Qt.quit() }
                        }
                    }
                    GridLayout {
                        id: addFilesObjects
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignTop
                        columns: 2
                        rows: 1
                        ColumnLayout {
                            id: columnModelsSelect
                            Layout.preferredWidth: 50
                            Layout.fillWidth: true
                            ColumnLayout {
                                id: columnModelsPathBrowse
                                Text {
                                    Layout.fillWidth: true
                                    id: selectInputModelsText
                                    text: qsTr("Select model files:")
                                    font.pointSize: 16
                                    minimumPointSize: 21
                                    minimumPixelSize: 21
                                    fontSizeMode: Text.Fit
                                    horizontalAlignment: Text.AlignHCenter
                                }
                                GridLayout {
                                    id: modelPathBrowseRow
                                    rows:1
                                    rowSpacing: 0
                                    Layout.fillWidth: true
                                    Text {
                                        id: modelNumberText1
                                        text: qsTr("1.");
                                    }

                                    TextField {
                                        id: modelPathTextField1
                                        Layout.fillWidth: true
                                        onEditingFinished: {
                                            browseModelsIndexClicked = 0;
                                            modelFilenamesArray[browseModelsIndexClicked] = this.text;
                                            modelPathTextField = modelPathTextField1;
                                        }
                                    }
                                    Button {
                                        id: browseModelButton1
                                        text: qsTr("Browse...")
                                        onClicked: {
                                            modelPathTextField = modelPathTextField1;
                                            browseModels.open();
                                        }
                                    }
                                }
                                FileDialog {
                                    id: browseModels
                                    objectName: qsTr("browseModels")
                                    folder: shortcuts.home
                                    nameFilters: qsTr("*.h5")
                                    onAccepted: {
                                        modelPathTextField.text = this.fileUrl
                                        modelFilenamesArray[browseModelsIndexClicked] = modelPathTextField.text;
                                    }
                                }
                            }
                            RowLayout {
                                id: addAnotherModelButtonRow
                                Layout.fillWidth: true
                                Button {
                                    id: addAnotherModelButton
                                    Layout.fillWidth: true
                                    width: parent.width
                                    text: qsTr("Add another model")
                                    onClicked: {
                                        if (modelInputsCounter < 5) {
                                            var modelPathComponent = Qt.createComponent(qsTr("model_path_object.qml"));
                                            var modelPathObject = modelPathComponent.createObject(columnModelsPathBrowse);
                                            modelInputsCounter++;

                                            for (let i = 0; i < modelPathObject.children.length; i++) {
                                                modelPathObject.children[i].objectName = modelPathObject.children[i].objectName + modelInputsCounter;
                                            }

                                            // Image text for i-th row
                                            columnModelsPathBrowse.children[modelInputsCounter].children[0].text = modelInputsCounter + qsTr(".");
                                            columnModelsPathBrowse.children[modelInputsCounter].currentModelsBrowseIndex = modelInputsCounter-1;

                                            // Browse button for i-th row
                                            columnModelsPathBrowse.children[modelInputsCounter].children[2].clicked.connect(function() {
                                                modelPathTextField = modelPathObject.children[1];
                                                browseModelsIndexClicked = modelPathObject.currentModelsBrowseIndex;
                                                browseModels.open();
                                            });
                                        }

                                    }
                                }
                            }
                        }
                        ColumnLayout {
                            id: columnImagesSelect
                            Layout.preferredWidth: 50
                            Layout.fillWidth: true
                            ColumnLayout {
                                Layout.fillWidth: true
                                id: columnImagesPathBrowse
                                Text {
                                    Layout.fillWidth: true
                                    id: selectInputImagesText
                                    text: qsTr("Select input images:")
                                    font.pointSize: 16
                                    minimumPointSize: 21
                                    minimumPixelSize: 21
                                    fontSizeMode: Text.Fit
                                    horizontalAlignment: Text.AlignHCenter
                                }
                                RowLayout {
                                    id: imagePathBrowseRow
                                    Layout.fillWidth: true
                                    Text {
                                        id: imageNumberText1
                                        text: "1."
                                    }

                                    TextField {
                                        id: imagePathTextField1
                                        Layout.fillWidth: true

                                        onEditingFinished: {
                                            browseIndexClicked = 0;
                                            imageFilenamesArray[browseIndexClicked] = this.text;
                                            imagePathTextField = imagePathTextField1;
                                        }
                                    }
                                    Button {
                                        id: browseImageButton1
                                        text: qsTr("Browse...")
                                        onClicked: {
                                            imagePathTextField =  imagePathTextField1;
                                            browseIndexClicked = 0;
                                            browseImages.open();
                                        }
                                    }
                                }
                                FileDialog {
                                    id: browseImages
                                    objectName: qsTr("browseImages")
                                    folder: shortcuts.home
                                    nameFilters: qsTr("Image files (*.jpg *.png)")
                                    onAccepted: {
                                        imagePathTextField.text = this.fileUrl;
                                        imageFilenamesArray[browseIndexClicked] = imagePathTextField.text;
                                    }
                                }
                            }
                            RowLayout {
                                id: addAnotherImageButtonRow
                                Layout.fillWidth: true
                                Button {
                                    id: addAnotherImageButton
                                    Layout.fillWidth: true
                                    text: qsTr("Add another image")
                                    onClicked: {
                                        if (imageInputsCounter < 5) {
                                            var imagePathComponent = Qt.createComponent(qsTr("image_path_object.qml"));
                                            var imagePathObject = imagePathComponent.createObject(columnImagesPathBrowse);
                                            imageInputsCounter++;

                                            for (let i = 0; i < imagePathObject.children.length; i++) {
                                                imagePathObject.children[i].objectName = imagePathObject.children[i].objectName + imageInputsCounter;
                                            }

                                            // Image number text for i-th row
                                            columnImagesPathBrowse.children[imageInputsCounter].children[0].text = imageInputsCounter + qsTr(".");
                                            columnImagesPathBrowse.children[imageInputsCounter].currentBrowseIndex = imageInputsCounter-1;

                                            // Browse button for i-th row
                                            columnImagesPathBrowse.children[imageInputsCounter].children[2].clicked.connect(function() {
                                                imagePathTextField = imagePathObject.children[1];
                                                browseIndexClicked = imagePathObject.currentBrowseIndex;
                                                browseImages.open();
                                            });
                                        }

                                    }
                                }
                            }
                        }
                        GridLayout {
                            id: generateHeatmapsGrid
                            Layout.fillHeight: false
                            Layout.fillWidth: true
                            Layout.columnSpan: 2
                            Button {
                                objectName: qsTr("generateHeatmapsButton")
                                text: qsTr("Generate heatmaps")
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                onClicked: {
                                    imageRowsNum = modelInputsCounter;
                                    imageColsNum = imageInputsCounter;
                                    if (heatmapImagesMatrix !== null) mainAppColumnObjectModel.remove(2, 1)

                                    var heatmapImagesMatrixComponent = Qt.createComponent(qsTr("heatmap_images_matrix.qml"));
                                    heatmapImagesMatrix = heatmapImagesMatrixComponent.createObject();
                                    mainAppColumnObjectModel.insert(2, heatmapImagesMatrix);

                                    // Create heatmaps and store results to appropriate arrays
                                    var gradcamDataArray = pyMainApp.loadNewModel(modelFilenamesArray, imageFilenamesArray);
                                    heatmapFilenamesArray = gradcamDataArray[0];
                                    predictedClassArray = gradcamDataArray[1];
                                    predictionProbabilityArray = gradcamDataArray[2];
                                }
                            }
                        }
                    }
                    Rectangle {
                        id: informationDockRectangle
                        color: "#e1e1e2"
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        RowLayout {
                            id: dockInfoRowLayout
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            property string sourceImagePath: qsTr("N/A");
                            property string usedModelForImagePath: qsTr("N/A");
                            property string sourceImageWidth: qsTr("N/A");
                            property string sourceImageHeight: qsTr("N/A");
                            property string predictedClassForImage: qsTr("N/A");
                            property string predictedClassProbabilityForImage: qsTr("N/A");
                            visible: false

                            Repeater {
                                model: 2
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                delegate: ColumnLayout {
                                    id: dockInfoColumnLayout
                                    Layout.minimumHeight: informationDockRectangle.Layout.minimumHeight
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true
                                    Text {
                                        id: dockInfoText1
                                        text: {
                                            informationDockRectangle.Layout.minimumHeight = this.paintedHeight * 4;
                                            if (!index) qsTr("• Source IMG path: " + dockInfoRowLayout.sourceImagePath.replace('file:///', ''));
                                            else if (index) qsTr("• Predicted class: " + dockInfoRowLayout.predictedClassForImage);
                                        }
                                    }
                                    Text {
                                        text: {
                                            if (!index) qsTr("• Source IMG dimensions: " + dockInfoRowLayout.sourceImageWidth + "x" + dockInfoRowLayout.sourceImageHeight);
                                            else qsTr("• Prediction probabilty: " + dockInfoRowLayout.predictedClassProbabilityForImage);
                                        }
                                    }
                                    Text {
                                        text: {
                                            if (!index) qsTr("• Model used: " + dockInfoRowLayout.usedModelForImagePath.replace('file:///', ''));
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
