import QtQuick 2.15;
import QtQuick.Window 2.15
import QtQuick.Dialogs 1.2
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
ColumnLayout {
    id: imagesMatrix
    //Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
    Layout.preferredWidth: mainAppColumn.width
    //Layout.maximumHeight: 50
    //Layout.preferredHeight: mainAppColumn.height * 0.5
    Layout.maximumHeight: mainAppColumn.height - informationDockRectangle.height
    Layout.fillHeight: true
    //clip: true
    spacing: 0

    RowLayout {
        id: modelLabelsForMatrixRow
        Layout.preferredWidth: parent.width
        //Layout.fillHeight: true
        Text {
            id: modelHeaderStartingSpace
            text: qsTr('       ')
        }
        Repeater {
            id: modelHeaderLabels
            Layout.fillWidth: true
            model: imageRowsNum;
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
        objectName: qsTr("imageLabelsForMatrixColumn")
        //Layout.preferredHeight: parent.height
        Layout.fillWidth: true
        Repeater {
            id: imageHeaderLabels
            //Layout.fillHeight: true
            //Layout.preferredHeight: parent.height
            model: imageColsNum;
            delegate: {
                //console.log("index: " + imageHeaderLabels.currentIndex);
                this.delegate = Qt.createComponent(qsTr("image_matrix_row.qml"));
            }
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:0.5;height:480;width:640}
}
##^##*/
