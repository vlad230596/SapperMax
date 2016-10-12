import QtQuick 2.0

Rectangle {
    property int value:6
    property int min_value: 0
    property int max_value: 10
    property real step: width/(max_value-min_value)
    property string title: ""
    id: thisSplit
    width: 200
    height: 14
    color: "#ddddcb"
    radius: 3
    x: height+10
    y: 25
    border {width: 2; color: "#4896fb" }
    Text {
        y: -15
        anchors.horizontalCenter: parent.horizontalCenter
        text: title
        font.family: "Consolas"
    }

    Rectangle {
        x: parent.border.width
        width: (value-min_value)*step-parent.border.width*2
        height: parent.height-parent.border.width*2
        anchors.verticalCenter: parent.verticalCenter
        color: "#00B2EE"
    }
    MouseArea {
        anchors.fill: parent
        onClicked:
        {
            value = Math.floor((mouse.x+step/2)/step) + min_value;
        }
        onWheel:
        {
            if (wheel.angleDelta.y > 0)
                add();
            else
                sub();
        }
    }

    Rectangle {
        id: pointer
        property real changed_position: 0
        anchors.verticalCenter: parent.verticalCenter
        color: "#CD6839"
        height: parent.height-parent.border.width*2
        width: 4
        opacity: 0.8
        x: (value-min_value)*step +
           (value!=min_value ? -width/2 : thisSplit.border.width) +
           (value==max_value ? -width/2 - thisSplit.border.width : 0)
        MouseArea {
            anchors.fill: parent
            onPositionChanged:
            {
                pointer.changed_position = mouse.x;
                while( Math.abs(pointer.changed_position) > step / 2)
                {
                    if(pointer.changed_position > 0)
                    {
                        add();
                        pointer.changed_position -= step;
                    }
                    else
                    {
                        sub();
                        pointer.changed_position += step;
                    }
                }

            }
        }
    }
    Text {
        text: parent.min_value.toString();
        x: parent.border.width + 1
        anchors.verticalCenter: parent.verticalCenter
        font.family: "Consolas"
        opacity: 0.4
    }
    Text {
        text: parent.value.toString();
        anchors.centerIn: parent
        font.family: "Consolas"
    }
    Text {
        text: parent.max_value.toString();
        x: parent.width - width - parent.border.width - 2
        anchors.verticalCenter: parent.verticalCenter
        font.family: "Consolas"
        opacity: 0.4
    }
    Rectangle {
        color: "#c1dd83"
        anchors.verticalCenter: parent.verticalCenter
        width: parent.height
        height: parent.height
        x: thisSplit.width + 5
        radius: 5
        Text {
            anchors.centerIn: parent
            text: "+"
            font.family: "Consolas"
            font.pointSize: 11
        }
        MouseArea {
            anchors.fill: parent
            onClicked: add();
        }
    }

    Rectangle {
        x: -parent.height-5
        width: parent.height
        height: parent.height
        color: "#c1dd83"
        radius: 5
        anchors.verticalCenter: parent.verticalCenter
        Text {
            text: "-"
            font.family: "Consolas"
            anchors.centerIn: parent
            font.pointSize: 11
        }
        MouseArea {
            anchors.fill: parent
            onClicked: sub();
        }
    }
    function add()
    {
        if(value<max_value)
            value++;
    }
    function sub()
    {
        if(value>min_value)
            value--;
    }
}
