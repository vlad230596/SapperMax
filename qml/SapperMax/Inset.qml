import QtQuick 2.0

Rectangle {
    id: thisInset
    property string title: ""
    property int indexInset: 0
    property int x_title: 0

    Rectangle {
        id: thisTitle
        width: text_info.contentWidth + 30
        height: 20
        y: 10
        x: x_title
        border.width: 1
        Text {
            id: text_info
            anchors.centerIn: parent
            text: title
            font.family: "Calibri"
            font.pointSize: 10
        }
        MouseArea {
            anchors.fill: parent
            onClicked: thisApp.currentIndex = indexInset
        }
    }
    states: [
        State {
            name: "selected"
            when: thisApp.currentIndex == indexInset
            PropertyChanges {
                target: thisTitle
                color: "#35a3f1"
                opacity: 0.8
            }
        }
    ]

}
