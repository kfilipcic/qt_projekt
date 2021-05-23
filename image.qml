import QtQuick 2.15
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5
import QtQuick.Dialogs 1.2

ColumnLayout {
    Image {
        id: matrixImage
        source: heatmapFilenamesArray[index][imageMatrixRow.currentImageColIndex]
        fillMode: Image.PreserveAspectFit
        Layout.fillWidth: true
        Layout.fillHeight: true
        MouseArea {
            id: matrixImageMouseArea
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                if (mouse.button === Qt.RightButton) {
                    imageColIndex = imageMatrixRow.currentImageColIndex;
                    imageRowIndex = index;
                    contextMenu.popup();
                }
                else if (mouse.button === Qt.LeftButton) {
                    var imagePopupComponent = Qt.createComponent(qsTr("popup_image.qml"));
                    var imagePopupObject = imagePopupComponent.createObject(imagePopupItem);
                    imagePopupObject.open();

                    var imagePopupGlobalCoords = imagePopupItem.mapToItem(windowItem, imagePopupObject.x, imagePopupObject.y);

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
                dockInfoRowLayout.sourceImagePath = imageFilenamesArray[imageMatrixRow.currentImageColIndex];
                dockInfoRowLayout.predictedClassForImage = predictedClassArray[imageMatrixRow.currentImageColIndex][index];
                dockInfoRowLayout.predictedClassProbabilityForImage = predictionProbabilityArray[imageMatrixRow.currentImageColIndex][index];
                dockInfoRowLayout.usedModelForImagePath = modelFilenamesArray[imageMatrixRow.currentImageColIndex];

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
