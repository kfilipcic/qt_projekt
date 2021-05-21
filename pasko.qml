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
                else if (mouse.button === Qt.LeftButton)
                    imagePopup.open()
            }
            onHoveredChanged: {
                // Save hovered image data so the dock component can show it
                dockInfoRowLayout.sourceImagePath = imageFilenamesArray[imageMatrixRow.currentImageIndex];
                dockInfoRowLayout.sourceImageWidth = matrixImage.sourceSize.width;
                dockInfoRowLayout.sourceImageHeight = matrixImage.sourceSize.height;

                if (this.containsMouse) dockInfoRowLayout.visible = true;
                else dockInfoRowLayout.visible = false;
            }
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
                       console.log(matrixImage.x);
                       console.log("x_popup: " + x_popup + " popupImage.width: " + width + " window.width: " + window.width);
                       console.log(this.x);
                       if (x_popup + width >= window.width) {
                           x_popup = window.width - width;
                           console.log("x if");
                       }
                       else if (x_popup <= 0) {
                           x_popup = 0;
                           console.log("x else if");
                       }
                       x_popup;
                }
                y: {
                       console.log(matrixImage.y);
                       var y_popup = Math.round(matrixImage.y + (matrixImage.height / 2) - (height / 2));
                       console.log("y_popup: " + y_popup + " popupImage.height: " + height + " window.height: " + window.height);
                       console.log(this.y);
                       if (y_popup + height >= window.height) {
                           y_popup = window.height - height;
                           console.log("y if");
                       }
                       else if (y_popup <= 0) {
                           y_popup = 0;
                           console.log("y else if");
                       }
                       y_popup;
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
