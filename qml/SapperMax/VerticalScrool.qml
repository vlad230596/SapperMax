import QtQuick 2.0

Rectangle {
    id: scrool
    property bool is_active: false
    property alias position: pointer.y
    property int way: mouse_field.maximum - mouse_field.minimum
    property alias pointer_y: pointer.y
    signal scrooling    // when need change position
    height: parent.height
    width: 12
    color: "#ddddcb"
    border {color: "#4896fb"; width: 2;}
        MouseArea {
            anchors.fill: parent
            onClicked: mouse_field.set_y(mouse.y);
        }

        Rectangle {
            id: pointer
            height: table_statistics.height / (table_statistics.height + table_statistics.all_height ) * parent.height//40//parent.height / table_statistics.all_height
            width: parent.width - border.width * 2
            x: border.width
            y: border.width
            color: is_active ? "#4896fb" : "grey"
            //border {color: "#c02cd3"; width: 1;}
                MouseArea {
                    id: mouse_field
                    property int start_position: 0
                    property int minimum: parent.border.width
                    property int maximum: scrool.height - parent.height - parent.border.width - 1
                    enabled: true
                    anchors.fill: parent
                    onPressed: {scrool.is_active = true;start_position = mouse.y;}
                    onReleased:  scrool.is_active = false;
                    onPositionChanged: set_y(pointer.y + mouse.y - start_position);
                    function set_y(value)
                    {
                        if(value < minimum)
                            pointer.y = minimum;
                        else
                            if(value > maximum)
                                pointer.y = maximum;
                            else
                                pointer.y = value;
                    }
            }
        }
       function set_pointer_y(value)
       {
           mouse_field.set_y(value);
       }
       Component.onCompleted:
       {
           pointer.onYChanged.connect(scrooling);
       }
}
