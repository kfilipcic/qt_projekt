import QtQuick 2.15;
import QtQuick.Window 2.15
import QtQuick.Dialogs 1.2
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
ColumnLayout {
    id: imagesMatrix

    Layout.fillHeight: true
    Layout.fillWidth: true
    Layout.alignment: Qt.AlignHCenter
    spacing: 0

    GridLayout {
        id: modelLabelsForMatrixRow
        Layout.preferredWidth: parent.width
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignHCenter

        rows: 1

        //Layout.maximumHeight: 50
        Text {
            id: modelHeaderStartingSpace
            text: qsTr('       ')
        }
        Repeater {
            id: modelHeaderLabels
            Layout.preferredWidth: parent.width
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
    GridLayout {
        id: imageLabelsForMatrixColumn
        //Layout.fillWidth: false
        columns: 1
        Layout.fillHeight: true
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignHCenter
        Repeater {
            id: imageHeaderLabels
            model: imageInputsCounter;
            Layout.fillWidth: true
            Layout.fillHeight: true
            delegate:
                GridLayout {
                    id: imageMatrixRow
                    property int currentImageIndex: index;
                    rows: 1
                    rowSpacing: 0
                    columnSpacing: 0
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.preferredWidth: parent.width;
                    Layout.preferredHeight: parent.height;
                    Layout.alignment: Qt.AlignHCenter
                Text {
                    text: {
                        qsTr('Image ' + (index+1));
                    }
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
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
