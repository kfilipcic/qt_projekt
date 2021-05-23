import QtQuick 2.15;
import QtQuick.Window 2.15
import QtQuick.Dialogs 1.2
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

RowLayout {
    property int currentBrowseIndex;
    Layout.fillWidth: true
    Layout.preferredWidth: parent.width
    Text {
        objectName: qsTr('imageNumberText');
    }
    TextField {
        objectName: qsTr('imagePathTextField')
        Layout.fillWidth: true
        onEditingFinished: {
            imageFilenamesArray[currentBrowseIndex] = this.text;
            browseIndexClicked = currentBrowseIndex;
            imagePathTextField = this;
        }
    }
    Button {
        objectName: qsTr('browseImageButton')
        text: qsTr('Browse...')
    }
}
