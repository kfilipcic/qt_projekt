import QtQuick 2.15
import QtQuick.Layouts 1.3

ColumnLayout {
    Image {
        id: matrixImage
        source: imageFilenamesArray[imageMatrixRow.currentImageIndex]
        Layout.fillWidth: true
        Layout.fillHeight: true
    }
}
