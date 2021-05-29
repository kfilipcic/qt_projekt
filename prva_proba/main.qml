import QtQuick 2.15
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

ApplicationWindow {
    id: root
    visible: true
    width: 1024
    height: 768

    //    DropArea {
    //        id: dropArea
    //        width: root.width
    //        height: root.height

    //        onDropped: {
    //            console.log('dropped files')
    //        }
    //    }

    Label {
        id: textLabel
        anchors.top: parent.top
        anchors.topMargin: 16
        anchors.left: parent.left
        anchors.leftMargin: 16
        text: 'TableView example'
        font.bold: true
    }


    TableView {
        id: idTableView
        clip: true
        anchors {
            top: textLabel.bottom; topMargin: 8
            left: parent.left; right: parent.right
            bottom: parent.bottom; bottomMargin: 8
        }

        model: tablemodel
        topMargin: header.implicitHeight
        delegate: Rectangle {
            id: displayRect
            color: "transparent"

            border.width: 1
            Text {
                id: modeltext
                text: displayText
                font.bold: true; font.pixelSize: 12
                anchors{bottom: parent.bottom; horizontalCenter: parent.horizontalCenter}
            }

            Image {
                id: modelimg
                source: displayImage
                width: 64; height: 64
                anchors{bottom: parent.bottom; horizontalCenter: parent.horizontalCenter}
                //anchors.centerIn: parent
                scale: 0.5
                //z: -1
            }

        }
    }
}
