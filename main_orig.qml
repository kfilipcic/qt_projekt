import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Dialogs 1.2
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

Window {
    id: window
    width: 800
    height: 700
    visible: true
    title: qsTr("Hello World")
    property int modelInputsCounter: 1
    property var modelPathTextField;

    property int imageInputsCounter: 1
    property var imagePathTextField;
    property var heatmapImagesMatrix: null;
    Grid {
        id: mainAppColumn
        anchors.fill: parent
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0
        Layout.fillWidth: true
        columns: 1
        GridLayout {
            id: addFilesObjects
            columns: 2
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin: 0
            Layout.fillWidth: true
            ColumnLayout {
                id: columnModelsSelect
                Layout.fillWidth: true
                ColumnLayout {
                    //Layout.alignment: Qt.AlignTop
                    Layout.fillWidth: true
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
                        //Layout.alignment: Text.AlignHCenter
                    }
                    RowLayout {
                        id: modelPathBrowseRow
                        //Layout.preferredWidth: parent.width
                        Layout.fillWidth: true
                        Text {
                            id: modelNumberText1
                            text: qsTr("1.");
                        }

                        TextField {
                            id: modelPathTextField1
                            width: parent.width * 0.8
                        }
                        Button {
                            id: browseModelButton1
                            text: qsTr("Browse...")
                            width: parent.width * 0.2
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
                        //Layout.fillWidth: true
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
                                columnModelsPathBrowse.children[modelInputsCounter].children[0].text = modelInputsCounter + qsTr(".")

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
                            width: parent.width * 0.8
                        }
                        Button {
                            id: browseImageButton1
                            width: parent.width * 0.2
                            text: qsTr("Browse...")
                            //anchors.right: parent
                            onClicked: {
                                imagePathTextField =  imagePathTextField1;
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
                        //nameFilters: qsTr("*.h5")
                        onAccepted: {
                            imagePathTextField.text = this.fileUrl
                        }
                    }
                }
                RowLayout {
                    id: addAnotherImageButtonRow
                    //Layout.preferredWidth: parent.width
                    Button {
                        id: addAnotherImageButton
                        //width: parent.width
                        //Layout.fillWidth: true
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
                                columnImagesPathBrowse.children[imageInputsCounter].children[0].text = imageInputsCounter + qsTr(".")

                                // Browse button for i-th row
                                columnImagesPathBrowse.children[imageInputsCounter].children[2].clicked.connect(function() {
                                    imagePathTextField = imagePathObject.children[1];
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
                Layout.fillWidth: false
                Button {
                //Layout.alignment: Qt.AlignTop
                objectName: qsTr("generateHeatmapsButton")
                //Layout.fillWidth: true
                text: qsTr("Generate heatmaps")
                Layout.fillHeight: true
                Layout.fillWidth: true
                onClicked: {
                    if (heatmapImagesMatrix !== null) mainAppColumn.children[mainAppColumn.children.length-1].destroy();
                    var heatmapImagesMatrixComponent = Qt.createComponent(qsTr("heatmap_images_matrix.qml"));
                    heatmapImagesMatrix = heatmapImagesMatrixComponent.createObject(mainAppColumn);
                }
            }
        }
        }
    }
}


