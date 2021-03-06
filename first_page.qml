import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Dialogs 1.2
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtQml.Models 2.3

Page {
    id: firstPage 
    width: parent.width
    height: parent.height

    property var addAnotherImage: function() {
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
    };

    property var addAnotherModel: function() {
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
    };

    ColumnLayout {
        
        width: parent.width
        height: parent.height
        anchors.fill: parent
        MenuBar {
            id: topMenu
            Layout.alignment: Qt.AlignTop
            Layout.fillWidth: true
            Menu {
                title: qsTr("&File")
                Layout.fillWidth: true
                FileDialog {
                    id: exportAllImagesFileDialog
                    folder: shortcuts.home
                    selectFolder: true
                    onAccepted: {
                        pyMainApp.exportAllImages(this.fileUrl);
                    }
                }
                Action { 
                    text: qsTr("&Export images      ");
                    Layout.fillWidth: true
                    onTriggered: {
                        exportAllImagesFileDialog.open()
                    }
                }
                Action { 
                    Layout.fillWidth: true
                    text: qsTr("&Exit     "); 
                    onTriggered: Qt.quit()
                }
            }
        }
        GridLayout {
            id: addFilesObjects
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignTop
            columns: 2
            rows: 1
            ColumnLayout {
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
                            addAnotherModel();
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
                            addAnotherImage();
                        }
                    }
                }
            }
            GridLayout {
                id: generateHeatmapsGrid
                Layout.fillWidth: true
                Layout.columnSpan: 2
                Button {
                    objectName: qsTr("generateHeatmapsButton")
                    text: qsTr("Generate heatmaps")
                    Layout.fillWidth: true
                    onClicked: {
                        imageRowsNum = modelInputsCounter;
                        imageColsNum = imageInputsCounter;
                        if (heatmapImagesMatrix !== null) mainAppColumnObjectModel.remove(2, 1)

                        // Create heatmaps and store results to appropriate arrays
                        var gradcamDataArray = pyMainApp.loadNewModel(modelFilenamesArray, imageFilenamesArray);
                        heatmapFilenamesArray = gradcamDataArray[0];
                        predictedClassArray = gradcamDataArray[1];
                        predictionProbabilityArray = gradcamDataArray[2];

                        var resultsPageComponent = Qt.createComponent(qsTr("results_page.qml"));
                        console.debug(resultsPageComponent.errorString());
                        resultsPageObject = resultsPageComponent.createObject();

                        var informationDockRectComponent = Qt.createComponent(qsTr("information_dock_rect.qml"));
                        console.debug(informationDockRectComponent.errorString());
                        var informationDockRectObject = informationDockRectComponent.createObject();
                        resultsPageObject.resultsPageObjectModelProp.append(informationDockRectObject);
                        
                        var pageIndicatorComponent = Qt.createComponent(qsTr("page_indicator.qml"));
                        console.debug(pageIndicatorComponent.errorString());
                        var pageIndicatorObject = pageIndicatorComponent.createObject();
                        resultsPageObject.resultsPageObjectModelProp.append(pageIndicatorObject);

                        var tableViewComponent = Qt.createComponent(qsTr("heatmap_images_table_view.qml"));
                        console.debug(tableViewComponent.errorString());
                        var pageIndicatorObject = pageIndicatorComponent.createObject();
                        var tableViewObject = tableViewComponent.createObject();
                        resultsPageObject.resultsPageObjectModelProp.insert(0, tableViewObject);

                        swipeViewId.addItem(resultsPageObject);
                        swipeViewId.currentIndex = 1;
                        firstPage.visible = false;

                        window.width += 1
                        window.width -= 1
                    }
                }
            }
        }
        PageIndicator {
            id: pageIndicatorFirstPage
            Layout.fillWidth: false
            Layout.alignment: Qt.AlignHCenter
            count: swipeViewId.count
            currentIndex: 0
        }
    }
}