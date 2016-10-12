import QtQuick 2.0

Rectangle {
    property alias text: table_cell_text.text
    anchors.leftMargin: -border.width
    width: 60
    height: 20
    border {color: "#466cf7"; width:2;}
    Text {
        id: table_cell_text
        z: 1
        anchors.centerIn: parent
        font.pointSize: 10
        font.family: "Consolas"
    }
}
