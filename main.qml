import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Dialogs 1.2
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtQml.Models 2.3

Window {
    id: window
    width: 800
    height: 700
    visible: true
    title: qsTr("Heatmap GUI App")
    property int modelInputsCounter: 1;
    property var modelPathTextField;

    property int imageInputsCounter: 1;
    property var imagePathTextField;
    property int browseIndexClicked;
    property var heatmapImagesMatrix: null;
    property var imageFilenamesArray: [];
    property var matrixImageMouseAreaVar: null;
Item {
    id: windowItem
    anchors.fill: parent
    ColumnLayout {
        id: mainAppColumn
        width: parent.width
        height: parent.height
        anchors.fill: parent
        //clip: true
        //columns: 1
        //rows: 2
        Repeater {
            //Layout.fillHeight: true
            //Layout.fillWidth: true
            model: ObjectModel {
                id: mainAppColumnObjectModel
                //Layout.fillHeight: true
                //Layout.fillWidth: true
                GridLayout {
                    id: addFilesObjects
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignTop
                    //Layout.maximumHeight: window.height * 0.2
                    Layout.fillHeight: true
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
                                    //Layout.preferredWidth: parent.width * 0.8
                                }
                                Button {
                                    id: browseModelButton1
                                    text: qsTr("Browse...")
                                    //Layout.preferredWidth: parent.width * 0.2
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
                                selectMultiple: true
                                //nameFilters: qsTr("*.h5")
                                onAccepted: {
                                    modelPathTextField.text = this.fileUrl
                                }
                            }
                        }
                        RowLayout {
                            id: addAnotherModelButtonRow
                            Layout.fillWidth: true
                            Button {
                                id: addAnotherModelButton
                                Layout.fillWidth: true
                                //height: 50
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

                                        // Browse button for i-th row
                                        columnModelsPathBrowse.children[modelInputsCounter].children[2].clicked.connect(function() {
                                            modelPathTextField = modelPathObject.children[1];
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
                                //    anchors.horizontalCenter: parent.horizontalCenter
                                //Layout.alignment: Text.AlignHCenter
                            }
                            RowLayout {
                                id: imagePathBrowseRow
                                //Layout.preferredWidth: parent.width
                                Layout.fillWidth: true
                                Text {
                                    id: imageNumberText1
                                    text: "1."
                                }

                                TextField {
                                    id: imagePathTextField1
                                    Layout.fillWidth: true
                                }
                                Button {
                                    id: browseImageButton1
                                    text: qsTr("Browse...")
                                    //anchors.right: parent
                                    onClicked: {
                                        imagePathTextField =  imagePathTextField1;
                                        browseIndexClicked = 0;
                                        browseImages.open();
                                    }
                                    //Layout.fillWidth: true
                                }
                            }
                            FileDialog {
                                id: browseImages
                                objectName: qsTr("browseImages")
                                folder: shortcuts.home
                                selectMultiple: true
                                nameFilters: qsTr("Image files (*.jpg *.png)")
                                onAccepted: {
                                    imagePathTextField.text = this.fileUrl;
                                    imageFilenamesArray[browseIndexClicked] = imagePathTextField.text;
                                    //console.log("browseIndexcLICKED: " + browseIndexClicked);
                                }
                            }
                        }
                        RowLayout {
                            id: addAnotherImageButtonRow
                            //Layout.preferredWidth: parent.width
                            Layout.fillWidth: true
                            Button {
                                id: addAnotherImageButton
                                //width: parent.width
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
                            //Layout.alignment: Qt.AlignTop
                            objectName: qsTr("generateHeatmapsButton")
                            //Layout.fillWidth: true
                            text: qsTr("Generate heatmaps")
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            onClicked: {
                                if (heatmapImagesMatrix !== null) mainAppColumnObjectModel.remove(1, 1)

                                var heatmapImagesMatrixComponent = Qt.createComponent(qsTr("heatmap_images_matrix.qml"));
                                heatmapImagesMatrix = heatmapImagesMatrixComponent.createObject();
                                mainAppColumnObjectModel.insert(1, heatmapImagesMatrix);
                            }
                        }
                    }
                }
                Rectangle {
                    id: informationDockRectangle
                    color: "#e1e1e2"
                    Layout.alignment: Qt.AlignBottom
                    //Layout.maximumHeight: 50
                    Layout.minimumHeight: mainAppColumn.height * 0.05
                    //Layout.preferredHeight: dockInfoColumnLayout.height
                    Layout.maximumHeight: mainAppColumn.height * 0.05
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    RowLayout {
                        id: dockInfoRowLayout
                        property string sourceImagePath: qsTr("");
                        property string usedModelForImagePath: qsTr("/home/cec/model.h5");
                        property string sourceImageWidth: qsTr("");
                        property string sourceImageHeight: qsTr("");
                        property string predictedClassForImage: qsTr("default_predicted_class");
                        property string predictedClassProbabilityForImage: qsTr("0.595959");
                        property string actualClassForImage: qsTr("default_class");
                        visible: false
                        Repeater {
                            model: 2
                            delegate: ColumnLayout {
                                id: dockInfoColumnLayout
                                Layout.fillHeight: true
                                Text {
                                     text: {
                                         if (!index) qsTr("• Source IMG path: " + dockInfoRowLayout.sourceImagePath);
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
                                        if (!index) qsTr("• Model used: " + dockInfoRowLayout.usedModelForImagePath);
                                        else qsTr("• Actual class: " + dockInfoRowLayout.actualClassForImage);
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


/*##^##
Designer {
    D{i:0;formeditorZoom:0.66}
}
##^##*/
