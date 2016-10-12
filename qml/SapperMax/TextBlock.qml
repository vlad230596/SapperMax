import QtQuick 2.0

Rectangle {
    property alias text: thisText.text
    property alias title: thisTitle.text
    width: thisText.width + 20
    height: thisText.contentHeight + 16
    radius: 4
    border {width: 3; color: "#f56c02"}
    Rectangle {
        id: thisBlockTitle
        x: 19
        y: - (height / 2)
        width: thisTitle.contentWidth + 4
        height: thisTitle.contentHeight
        Text {
            id: thisTitle
            anchors.horizontalCenter: parent.horizontalCenter
            text: "О игре"
            font.bold: true
            font.family: "Calibri"
            font.pixelSize: 15
        }
    }
    Text {
        id: thisText
        anchors.top: thisBlockTitle.bottom
        anchors.topMargin: 2
        anchors.horizontalCenter: parent.horizontalCenter
        width: 310
        text: "Открыть все ячейки"
        wrapMode: Text.WordWrap
        font.family: "Calibri"
        font.pixelSize: 14
    }
}
