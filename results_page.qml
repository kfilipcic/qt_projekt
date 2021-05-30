import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Dialogs 1.2
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtQml.Models 2.3

Page {
    id: resultsPage
    property alias resultsPageObjectModelProp: objectModelRepeater.model
    //anchors.fill: parent
    width: parent.width
    height: parent.height
    /*
    Component.onCompleted: {
        console.log("resultsPage onCompleted");
        window.show();
        //resultsPageObjectModel.children[0].forceLayout();
    }
    */
    ColumnLayout {
        id: resultsPageColumnLayout
        width: parent.width
        height: parent.height
        anchors.fill: parent
        MenuBar {
            id: topMenuResultsPage
            Layout.alignment: Qt.AlignTop
            Layout.fillWidth: true
            Menu {
                title: qsTr("&File")
                FileDialog {
                    id: exportAllImagesFileDialogResultsPage
                    folder: shortcuts.home
                    selectFolder: true
                    onAccepted: {
                        pyMainApp.exportAllImages(this.fileUrl);
                    }
                }

                Action { 
                    text: qsTr("&Export images      ");
                    onTriggered: {
                        exportAllImagesFileDialog.open()
                    }
                }
                Action { text: qsTr("&Exit     "); onTriggered: Qt.quit() }
            }
        }
        Repeater {
            Layout.fillHeight: true
            Layout.fillWidth: true
            id: objectModelRepeater
            model: ObjectModel {
                id: resultsPageObjectModel
            }
        }
    }
}