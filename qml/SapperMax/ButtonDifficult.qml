import QtQuick 2.0
MyButton {
    id: thisButton
    property int difficult: 1   //3 levels supports: 1 - easy, 2 - medium, 3 - hard
    property string name_image:
        if(difficult == 1)
            "Easy";
        else
            if(difficult == 2)
                "Medium";
            else
                "Hard";
    property string mode: ""
    anchors.top: count_bomb.bottom
    anchors.topMargin: 10
    anchors.leftMargin: 10
    width: 65
    height: 65
    radius: 4
    border {width: 2; color: "#048ff1"}
    Image {
        anchors.centerIn: parent
        source: "qrc:/images/" + name_image + mode + ".png";
        sourceSize {width: parent.width-4; height: parent.height-4;}
    }

    onSenderClicked:
    {
        switch(difficult)
        {
        case 1:
            spin_x.value = 10;
            spin_y.value = 10;
            break;
        case 2:
            spin_x.value = 16;
            spin_y.value = 16;
            break;
        case 3:
            spin_x.value = 30;
            spin_y.value = 16;
            break;
        }
    }
    states: [
        State {
            name: "chosen"
            when: is_active_mouse
            PropertyChanges {
                target: thisButton
                mode: "_chosen"
            }
        },
        State {
            name: "selected"
            when: ( ( (spin_x.value == 10 && spin_y.value == 10 && difficult == 1 ) || (spin_x.value == 16 && spin_y.value == 16 && difficult == 2 ) || (spin_x.value == 30 && spin_y.value == 16 && difficult == 3 ) ) && count_bomb.value == count_bomb.start_value )
            PropertyChanges {
                target: thisButton
                mode: "_selected"
             }
        }

    ]
}
