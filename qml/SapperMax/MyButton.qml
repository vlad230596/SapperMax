import QtQuick 2.0

Rectangle {
    id: thisMyButton
    property alias title: thisButtonText.text
    property alias text_color: thisButtonText.color
    property alias enabled: mouseLayout.enabled
    property alias is_active_mouse: mouseLayout.is_active_hover
    signal senderClicked
    anchors.left: playGrid.right
    anchors.leftMargin: 15
    height: 25
    width: 100
    border.width: 2
    color:  is_active_mouse ? "#cdf966" : "white"
    Text {
        id: thisButtonText
        color: enabled ? "black" : "#f76d6d"
        font.pointSize: 11
        font.family: "Calibri"
        anchors.centerIn: parent
    }
    MouseArea {
        id: mouseLayout
        property bool is_active_hover: false
        anchors.fill: parent
        hoverEnabled: true
        onEntered: is_active_hover = true;
        onExited: is_active_hover = false;
    }

    Component.onCompleted:
    {
        mouseLayout.clicked.connect(senderClicked);
    }
}
