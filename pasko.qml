import QtQuick 2.15
import QtQuick.Layouts 1.3

ColumnLayout {
    Image {
        id: matrixImage
        source: imageFilenamesArray[imageMatrixRow.currentImageIndex]
        fillMode: Image.PreserveAspectFit
        Layout.fillWidth: true
        Layout.fillHeight: true
        MouseArea {
            id: matrixImageMouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: Qt.quit()
            onHoveredChanged: {
                // Save hovered image data so the dock component can show it
                dockInfoRowLayout.sourceImagePath = imageFilenamesArray[imageMatrixRow.currentImageIndex];
                dockInfoRowLayout.sourceImageWidth = matrixImage.sourceSize.width;
                dockInfoRowLayout.sourceImageHeight = matrixImage.sourceSize.height;

                if (this.containsMouse) dockInfoRowLayout.visible = true;
                else dockInfoRowLayout.visible = false;
            }
        }
    }
}
