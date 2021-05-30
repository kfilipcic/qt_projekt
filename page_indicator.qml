import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Dialogs 1.2
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtQml.Models 2.3

PageIndicator {
    id: pageIndicatorResultsPage
    Layout.fillWidth: false
    Layout.alignment: Qt.AlignHCenter
    count: swipeViewId.count
    currentIndex: swipeViewId.currentIndex
}