import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Dialogs 1.2
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtQml.Models 2.3

Rectangle {
    id: informationDockRectangle
    Layout.alignment: Qt.AlignBottom
    //Layout.preferredHeight: resultsPageColumnLayout.height * 0.3
    //Layout.maximumHeight: resultsPageColumnLayout.height * 0.3
    //Layout.fillHeight: true
    //anchors.fill: parent
    color: "#e1e1e2"
    RowLayout {
        id: dockInfoRowLayout
        //Layout.fillHeight: true
        //Layout.fillWidth: true
        property string sourceImagePath: qsTr("N/A");
        property string usedModelForImagePath: qsTr("N/A");
        property string sourceImageWidth: qsTr("N/A");
        property string sourceImageHeight: qsTr("N/A");
        property string predictedClassForImage: qsTr("N/A");
        property string predictedClassProbabilityForImage: qsTr("N/A");

        //visible: false

        Repeater {
            model: 2
            Layout.fillHeight: true
            Layout.fillWidth: true
            delegate: ColumnLayout {
                id: dockInfoColumnLayout
                Layout.minimumHeight: informationDockRectangle.Layout.minimumHeight
                Layout.fillHeight: true
                Layout.fillWidth: true
                Text {
                    id: dockInfoText1
                    text: {
                        informationDockRectangle.Layout.minimumHeight = this.paintedHeight * 4;
                        if (!index) qsTr("• Source IMG path: " + dockInfoRowLayout.sourceImagePath.replace('file:///', ''));
                        else if (index) qsTr("• Predicted class: " + dockInfoRowLayout.predictedClassForImage);
                    }
                }
                Text {
                    text: {
                        if (!index) qsTr("• Source IMG dimensions: " + dockInfoRowLayout.sourceImageWidth + "x" + dockInfoRowLayout.sourceImageHeight);
                        else qsTr("• Prediction probabilty: " + dockInfoRowLayout.predictedClassProbabilityForImage);
                    }
                }
                Text {
                    text: {
                        if (!index) qsTr("• Model used: " + dockInfoRowLayout.usedModelForImagePath.replace('file:///', ''));
                    }
                }
            }
        }
    }
}