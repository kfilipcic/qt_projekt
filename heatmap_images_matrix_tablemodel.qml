import QtQuick 2.15;
import QtQuick.Window 2.15
import QtQuick.Dialogs 1.2
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

Page {
    id: resultsPage
    anchors.fill: parent

    TableView {
        id: idTableView
        rowSpacing: 10
        columnSpacing: 10
        model: tablemodel
        delegate: Image {
            id: matrixImage 
            source: displayImage
            fillMode: Image.PreserveAspectFit
            width: parent.width / parent.columnCount
            height: parent.height / parent.rowCount
            MouseArea {
                id: matrixImageMouseArea
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    if (mouse.button === Qt.RightButton) {
                        imageColIndex = idTableView.index.column();
                        imageRowIndex = idTableView.index.row();
                        contextMenu.popup();
                    }
                    else if (mouse.button === Qt.LeftButton) {
                        var imagePopupComponent = Qt.createComponent(qsTr("popup_image.qml"));
                        var imagePopupObject = imagePopupComponent.createObject(imagePopupItem);
                        imagePopupObject.open();

                        var imagePopupGlobalCoords = imagePopupItem.mapToItem(windowItem, imagePopupObject.x, imagePopupObject.y);

                        if (imagePopupGlobalCoords.x + imagePopupObject.width >= window.width) {
                            imagePopupObject.x -= (imagePopupGlobalCoords.x + imagePopupObject.width) - window.width;
                        }
                        else if (imagePopupGlobalCoords.x <= 0) {
                            imagePopupObject.x += imagePopupGlobalCoords.x;
                        }
                        if (imagePopupGlobalCoords.y + imagePopupObject.height >= window.height) {
                            imagePopupObject.y -= (imagePopupGlobalCoords.y + imagePopupObject.height) - window.height;
                        }
                        else if (imagePopupGlobalCoords.y <= 0) {
                            imagePopupObject.y += imagePopupGlobalCoords.y;
                        }
                    }
                }
                onHoveredChanged: {
                    // Save hovered image data so the dock component can show it
                    dockInfoRowLayout.sourceImagePath = imagePath;
                    dockInfoRowLayout.usedModelForImagePath = modelPath;
                    dockInfoRowLayout.predictedClassForImage = predictedClass;
                    dockInfoRowLayout.predictedClassProbabilityForImage = classProbability;

                    dockInfoRowLayout.sourceImageWidth = matrixImage.sourceSize.width;
                    dockInfoRowLayout.sourceImageHeight = matrixImage.sourceSize.height;

                    if (this.containsMouse) dockInfoRowLayout.visible = true;
                    else dockInfoRowLayout.visible = false;
                }
                Item {
                    id: imagePopupItem
                }
            }
        }
    }
    Rectangle {
        id: informationDockRectangle
        color: "#e1e1e2"
        RowLayout {
            id: dockInfoRowLayout
            Layout.fillHeight: true
            Layout.fillWidth: true
            property string sourceImagePath: qsTr("N/A");
            property string usedModelForImagePath: qsTr("N/A");
            property string sourceImageWidth: qsTr("N/A");
            property string sourceImageHeight: qsTr("N/A");
            property string predictedClassForImage: qsTr("N/A");
            property string predictedClassProbabilityForImage: qsTr("N/A");

            visible: false
    
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
}