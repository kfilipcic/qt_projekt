import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Dialogs 1.2
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtQml.Models 2.3

TableView {
    id: idTableView
    rowSpacing: 10
    columnSpacing: 10
    model: tablemodel
    delegate: Image {
        id: matrixImage 
        source: displayImage
        fillMode: Image.PreserveAspectFit
        Layout.fillWidth: true
        Layout.fillHeight: true
        //width: parent.width / parent.columnCount
        //height: parent.height / parent.rowCount
        MouseArea {
            id: matrixImageMouseArea
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                if (mouse.button === Qt.RightButton) {
                    imageColIndex = idTableView.index.column();
                    imageRowIndex = idTableView.index.row();
                    contextMenu.popup();
                }
                else if (mouse.button === Qt.LeftButton) {
                    var imagePopupComponent = Qt.createComponent(qsTr("popup_image.qml"));
                    var imagePopupObject = imagePopupComponent.createObject(imagePopupItem);
                    imagePopupObject.open();

                    var imagePopupGlobalCoords = imagePopupItem.mapToItem(firstPage, imagePopupObject.x, imagePopupObject.y);

                    if (imagePopupGlobalCoords.x + imagePopupObject.width >= window.width) {
                        imagePopupObject.x -= (imagePopupGlobalCoords.x + imagePopupObject.width) - window.width;
                    }
                    else if (imagePopupGlobalCoords.x <= 0) {
                        imagePopupObject.x += imagePopupGlobalCoords.x;
                    }
                    if (imagePopupGlobalCoords.y + imagePopupObject.height >= window.height) {
                        imagePopupObject.y -= (imagePopupGlobalCoords.y + imagePopupObject.height) - window.height;
                    }
                    else if (imagePopupGlobalCoords.y <= 0) {
                        imagePopupObject.y += imagePopupGlobalCoords.y;
                    }
                }
            }
            onHoveredChanged: {
                // Save hovered image data so the dock component can show it
                var dockInfoRowLayout = resultsPageObjectModel.children[1].children[0];

                dockInfoRowLayout.sourceImagePath = imagePath;
                dockInfoRowLayout.usedModelForImagePath = modelPath;
                dockInfoRowLayout.predictedClassForImage = predictedClass;
                dockInfoRowLayout.predictedClassProbabilityForImage = classProbability;

                dockInfoRowLayout.sourceImageWidth = matrixImage.sourceSize.width;
                dockInfoRowLayout.sourceImageHeight = matrixImage.sourceSize.height;

                if (this.containsMouse) dockInfoRowLayout.visible = true;
                else dockInfoRowLayout.visible = false;
            }
            Item {
                id: imagePopupItem
            }
        }
    }
}