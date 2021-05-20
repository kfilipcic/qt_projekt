import QtQuick 2.15;
import QtQuick.Window 2.15
import QtQuick.Dialogs 1.2
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
ColumnLayout {
    id: imagesMatrix
    Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
    Layout.preferredWidth: parent.width
    Layout.preferredHeight: parent.height
    clip: true
    spacing: 0

    RowLayout {
        id: modelLabelsForMatrixRow
        Layout.preferredWidth: parent.width
        Layout.fillHeight: true
        Text {
            id: modelHeaderStartingSpace
            text: qsTr('       ')
        }
        Repeater {
            id: modelHeaderLabels
            Layout.fillWidth: true
            model: modelInputsCounter;
            delegate:
                ColumnLayout {
                id: modelHeaderLabelsColumnLayout
                Layout.fillWidth: true
                Text {
                    id: modelHeaderText
                    horizontalAlignment: Text.AlignHCenter
                    text: qsTr('Model ' + (index+1));
                }
            }
        }
    }
    ColumnLayout {
        id: imageLabelsForMatrixColumn
        Layout.preferredHeight: parent.height
        Layout.fillWidth: true
        Repeater {
            id: imageHeaderLabels
            Layout.fillHeight: true
            //Layout.preferredHeight: parent.height
            model: imageInputsCounter;
            delegate:
                RowLayout {
                    id: imageMatrixRow
                    property int currentImageIndex: index;
                    Layout.preferredWidth: parent.width
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
                    model: modelInputsCounter;
                    delegate: {
                        this.delegate = Qt.createComponent(qsTr('pasko.qml'));
                    }
                }
            }
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:0.5;height:480;width:640}
}
##^##*/
