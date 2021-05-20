import QtQuick 2.15
import QtQuick.Layouts 1.3

GridLayout {
    //Layout.preferredWidth: parent.width
    //Layout.preferredWidth: imageLabelsForMatrixColumn.height
    //Layout.preferredHeight: imageLabelsForMatrixColumn.height
    Layout.preferredWidth: imageMatrixRow.height
    Layout.preferredHeight: imageMatrixRow.height
    //Layout.alignment: Qt.AlignHCenter
    columns: 1
    Image {
        id: matrixImage
        //source: 'heatmap_images/pasko.jpg'
        source: imageFilenamesArray[imageMatrixRow.currentImageIndex]
        //source: imageFilenamesArray[0]
        //Layout.preferredWidth: parent.width / modelInputsCounter
        Layout.preferredWidth: parent.width
        Layout.preferredHeight: parent.height
        Component.onCompleted: {
            //console.log(parent.columnImagesPathBrowse.children[parent.index].children[1]);
            //console.log(Object.keys(modelHeaderLabels.children[0]));
            //console.log(Object.keys(imageHeaderLabels));
            //console.log(imageHeaderLabels);
            //console.log(imageFilenamesArray);
        }
    }
}


/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:0.5;height:480;width:640}
}
##^##*/
