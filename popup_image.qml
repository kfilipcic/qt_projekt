import QtQuick 2.0
import QtQuick.Controls 2.5

Popup {
    id: imagePopup
    width: {
        //console.log("popup WIDTH!");
        if (window.width < window.height) Math.round(window.width / 1.5)
        else Math.round(window.height / 1.5)
    }
    height: {
        //console.log("popup HEIGHT!");
        if (window.height < window.width) Math.round(window.height / 1.5)
        else Math.round(window.width / 1.5)
    }
    modal: true
    focus: true
    background: BorderImage {
        id: popupImage
        source: matrixImage.source
        width: imagePopup.width; height: imagePopup.height
        //border.left: 5; border.top: 5
        //border.right: 5; border.bottom: 5
    }
    x: {
        //console.log("X imagePopup!");
        if (matrixImage != null) {
            //console.log("racuna nes X, " + matrixImage.width);
            var x_popup = Math.round(matrixImage.x + (matrixImage.width / 2) - (width / 2));
            x_popup;
        }
    }
    y: {
        //console.log("Y imagePopup!");
        if (matrixImage != null) {
            //console.log("racuna nes Y, " + matrixImage.height);
            var y_popup = Math.round(matrixImage.y + (matrixImage.height / 2) - (height / 2));
            y_popup;
        }
    }
}
