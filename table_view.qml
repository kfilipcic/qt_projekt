import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

TableView {
    id: idTableView
    model: tablemodel
    rowSpacing: 10
    columnSpacing: 10
    Layout.alignment: Qt.AlignTop
    clip: true
    Layout.fillWidth: true
    Layout.fillHeight: true
    columnWidthProvider: function (column) { 
        return window.width / tablemodel.columnCount();
    }
    rowHeightProvider: function (row) { 
        return window.height / tablemodel.rowCount(); 
    }
    delegate: Image {
        id: matrixImage 
        source: displayImage
        fillMode: Image.PreserveAspectFit
        MouseArea {
            id: matrixImageMouseArea
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                if (mouse.button === Qt.RightButton) {
                    if (index > tablemodel.rowCount()-1) {
                        imageRowIndex = index % tablemodel.rowCount();
                    } else {
                        imageRowIndex = index;
                    }
                    imageColIndex = parseInt(index / tablemodel.rowCount());
                    contextMenu.popup();
                }
                else if (mouse.button === Qt.LeftButton) {
                    var imagePopupComponent = Qt.createComponent(qsTr("popup_image.qml"));
                    var imagePopupObject = imagePopupComponent.createObject(imagePopupItem);
                    imagePopupObject.open();

                    imagePopupObject.x -= (imagePopupObject.width + idTableView.columnSpacing) * (index / tablemodel.columnCount() + 1);
                    imagePopupObject.x += Math.round(window.width / 2) - Math.round(imagePopupObject.width / 2);

                    imagePopupObject.y -= (imagePopupObject.height + idTableView.rowSpacing) * ((index+1) % tablemodel.rowCount() + 1);
                    imagePopupObject.y += Math.round(window.height / 2) - Math.round(imagePopupObject.height / 2);
                }
            }
            onHoveredChanged: {
                // Save hovered image data so the dock component can show it
                resultsPageObject.resultsPageObjectModelProp.children[1].children[0]; 

                resultsPageObject.resultsPageObjectModelProp.children[1].children[0].sourceImagePath = imagePath;
                resultsPageObject.resultsPageObjectModelProp.children[1].children[0].usedModelForImagePath = modelPath;
                resultsPageObject.resultsPageObjectModelProp.children[1].children[0].predictedClassForImage = predictedClass;
                resultsPageObject.resultsPageObjectModelProp.children[1].children[0].predictedClassProbabilityForImage = classProbability;

                resultsPageObject.resultsPageObjectModelProp.children[1].children[0].sourceImageWidth = matrixImage.sourceSize.width;
                resultsPageObject.resultsPageObjectModelProp.children[1].children[0].sourceImageHeight = matrixImage.sourceSize.height;

                if (this.containsMouse) resultsPageObject.resultsPageObjectModelProp.children[1].children[0].visible = true;
                else resultsPageObject.resultsPageObjectModelProp.children[1].children[0].visible = false;
            }
            Item {
                id: imagePopupItem
            }
        }
    }
}