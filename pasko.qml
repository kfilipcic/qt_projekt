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
                    imagePopup.open();
                    var imagePopupGlobalCoords = imagePopupItem.mapToItem(windowItem, imagePopup.x, imagePopup.y);

                    if (imagePopupGlobalCoords.x + imagePopup.width >= window.width) {
                        imagePopup.x -= (imagePopupGlobalCoords.x + imagePopup.width) - window.width;
                    }
                    else if (imagePopupGlobalCoords.x <= 0) {
                        imagePopup.x += imagePopupGlobalCoords.x;
                    }
                    if (imagePopupGlobalCoords.y + imagePopup.height >= window.height) {
                        imagePopup.y -= (imagePopupGlobalCoords.y + imagePopup.height) - window.height;
                    }
                    else if (imagePopupGlobalCoords.y <= 0) {
                        imagePopup.y += imagePopupGlobalCoords.y;
                    }
                }

            }
            onHoveredChanged: {
                // Save hovered image data so the dock component can show it
                dockInfoRowLayout.sourceImagePath = imageFilenamesArray[imageMatrixRow.currentImageIndex];
                dockInfoRowLayout.sourceImageWidth = matrixImage.sourceSize.width;
                dockInfoRowLayout.sourceImageHeight = matrixImage.sourceSize.height;

                if (this.containsMouse) dockInfoRowLayout.visible = true;
                else dockInfoRowLayout.visible = false;
            }
            Item {
                id: imagePopupItem
                Popup {
                    id: imagePopup
                    width: {
                        if (window.width < window.height) Math.round(window.width / 1.5)
                        else Math.round(window.height / 1.5)
                    }
                    height: {
                        if (window.height < window.width) Math.round(window.height / 1.5)
                        else Math.round(window.width / 1.5)
                    }
                    modal: true
                    focus: true
                    background: BorderImage {
                        id: popupImage
                        source: matrixImage.source
                        width: imagePopup.width; height: imagePopup.height
                        border.left: 5; border.top: 5
                        border.right: 5; border.bottom: 5
                    }
                    x: {
                           var x_popup = Math.round(matrixImage.x + (matrixImage.width / 2) - (width / 2));
                           x_popup;
                    }
                    y: {
                           var y_popup = Math.round(matrixImage.y + (matrixImage.height / 2) - (height / 2));

                           y_popup;
                    }
                }
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
                    onAccepted: {
                        console.log("saveSingleImageDialog onAccepted!");
                    }
                }
            }
        }
    }
}
