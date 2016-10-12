import QtQuick 2.0

Rectangle {
    property string text: " "
    radius: 5
    border.width: 2
    border.color: "black"
    opacity: 0.75
    width: 120
    height: 50
    color: is_win ? "#6ef748" : "#f75d46"
    Text {
        anchors.centerIn: parent
        text: parent.text
        font.pointSize: 14
        font.family: "Calibri"
        color: "black"
    }
}
