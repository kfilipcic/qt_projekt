import QtQuick 2.0
import QtQuick.Layouts 1.3

RowLayout {
    id: imageMatrixRow
    property int currentImageColIndex: index;
    Text {
        text: {
            qsTr('Image ' + (index+1));
        }
        verticalAlignment: Text.AlignVCenter
    }
    Repeater {
        id: imagesRepeater
        property int currentImageRowIndex: index;
        Layout.fillWidth: true
        model: imageRowsNum;
        delegate: {
            if (imageFilenamesArray[index] !== undefined) {
                this.delegate = Qt.createComponent(qsTr('image.qml'));
            }
        }
    }
}
