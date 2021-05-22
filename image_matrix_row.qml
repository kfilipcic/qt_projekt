import QtQuick 2.0
import QtQuick.Layouts 1.3

RowLayout {
    id: imageMatrixRow
    property int currentImageIndex: index;
    //Layout.preferredWidth: parent.width
    //Layout.preferredHeight: parent.height
    //Layout.fillWidth: true
    Layout.fillHeight: true
    Text {
        text: {
            qsTr('Image ' + (index+1));
        }
        //Layout.preferredWidth: 20
        //Layout.preferredHeight: parent.height
        verticalAlignment: Text.AlignVCenter
    }
    Repeater {
        id: imagesRepeater
        Layout.fillWidth: true
        Layout.fillHeight: true
        model: imageRowsNum;
        delegate: {
            //console.log("imageFilenamesArray: " + index + ", " + imageFilenamesArray);
            //console.log("IFA: " + imageFilenamesArray[index] + " IFA undefined? " + (imageFilenamesArray[index] === undefined));
            if (imageFilenamesArray[index] !== undefined) {
                this.delegate = Qt.createComponent(qsTr('pasko.qml'));
            }
        }
    }
}
