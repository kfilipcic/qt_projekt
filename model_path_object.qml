import QtQuick 2.15;
import QtQuick.Window 2.15
import QtQuick.Dialogs 1.2
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

RowLayout {
    Layout.fillWidth: true
    Layout.preferredWidth: parent.width
    Text {
        objectName: qsTr('modelNumberText');
    }
    TextField {
        objectName: qsTr('modelPathTextField')
        Layout.fillWidth: true
    }
    Button {
        objectName: qsTr('browseModelButton')
        text: qsTr('Browse...')
    }
}
