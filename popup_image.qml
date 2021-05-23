import QtQuick 2.0
import QtQuick.Controls 2.5

Popup {
    id: imagePopup
    width: {
        if (window.width < window.height) Math.round(window.width / 1.5)
        else Math.round(window.height / 1.5)
    }
    height: {
        if (window.height < window.width) Math.round(window.height / 1.5)
        else Math.round(window.width / 1.5)
    }
    modal: true
    focus: true
    background: BorderImage {
        id: popupImage
        source: matrixImage.source
        width: imagePopup.width; height: imagePopup.height
    }
    x: {
        if (matrixImage != null) {
            var x_popup = Math.round(matrixImage.x + (matrixImage.width / 2) - (width / 2));
            x_popup;
        }
    }
    y: {
        if (matrixImage != null) {
            var y_popup = Math.round(matrixImage.y + (matrixImage.height / 2) - (height / 2));
            y_popup;
        }
    }
}