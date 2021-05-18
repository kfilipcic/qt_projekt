import QtQuick 2.15
import QtQuick.Layouts 1.3

ColumnLayout {
    Text {
        id: modelHeaderText
        text: qsTr("Model " + (index+1))
    }
}
