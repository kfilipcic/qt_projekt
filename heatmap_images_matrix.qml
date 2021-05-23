import QtQuick 2.15;
import QtQuick.Window 2.15
import QtQuick.Dialogs 1.2
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
ColumnLayout {
    id: imagesMatrix
    Layout.preferredWidth: mainAppColumn.width
    Layout.maximumHeight: mainAppColumn.height - informationDockRectangle.height
    Layout.fillHeight: true
    spacing: 0

    RowLayout {
        id: modelLabelsForMatrixRow
        Layout.preferredWidth: parent.width
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
        Layout.fillWidth: true
        Repeater {
            id: imageHeaderLabels
            model: imageColsNum;
            delegate: {
                this.delegate = Qt.createComponent(qsTr("image_matrix_row.qml"));
            }
        }
    }
}