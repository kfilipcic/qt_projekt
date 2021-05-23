import QtQuick 2.15
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5
import QtQuick.Dialogs 1.2

ColumnLayout {
    Image {
        id: matrixImage
        source: imageFilenamesArray[imageMatrixRow.currentImageIndex]
        fillMode: Image.PreserveAspectFit
        Layout.fillWidth: true
        Layout.fillHeight: true
        MouseArea {
            id: matrixImageMouseArea
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            anchors.fill: parent
            hoverEnabled: true
            //onClicked: Qt.quit()
            onClicked: {
                if (mouse.button === Qt.RightButton)
                    contextMenu.popup()
                else if (mouse.button === Qt.LeftButton) {
                    var imagePopupComponent = Qt.createComponent(qsTr("popup_image.qml"));
                    var imagePopupObject = imagePopupComponent.createObject(imagePopupItem);
                    imagePopupObject.open();

                    var imagePopupGlobalCoords = imagePopupItem.mapToItem(windowItem, imagePopupObject.x, imagePopupObject.y);
                    console.log("x: " + imagePopupGlobalCoords.x + " , y: " + imagePopupGlobalCoords.y);

                    if (imagePopupGlobalCoords.x + imagePopupObject.width >= window.width) {
                        console.log("izlazi van desno")
                        imagePopupObject.x -= (imagePopupGlobalCoords.x + imagePopupObject.width) - window.width;
                    }
                    else if (imagePopupGlobalCoords.x <= 0) {
                        console.log("izlazi van lijevo")
                        imagePopupObject.x += imagePopupGlobalCoords.x;
                    }
                    if (imagePopupGlobalCoords.y + imagePopupObject.height >= window.height) {
                        console.log("izlazi van gore")
                        imagePopupObject.y -= (imagePopupGlobalCoords.y + imagePopupObject.height) - window.height;
                    }
                    else if (imagePopupGlobalCoords.y <= 0) {
                        console.log("izlazi van dolje")
                        imagePopupObject.y += imagePopupGlobalCoords.y;
                    }
                }

            }
            onHoveredChanged: {
                // Save hovered image data so the dock component can show it
                if (imageFilenamesArray[imageMatrixRow.currentImageIndex] !== undefined)
                    dockInfoRowLayout.sourceImagePath = imageFilenamesArray[imageMatrixRow.currentImageIndex];
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
