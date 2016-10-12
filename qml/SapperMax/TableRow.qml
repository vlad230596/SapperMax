import QtQuick 2.0

Item {
    id: thisRow
    x: 10
    property alias index: index_row.text
    property alias date: data_date.text
    property alias property: data_property.text
    property alias time_use: data_time_use.text
    property alias money_use: data_money_use.text
    property int seconds_use: 0 //for sorting
    property real start_y: 0    //for scrooling
    property bool is_active: false  //last result
    height: 20
    TableCell {
        id: index_row
        width: 50
        text: "1"
        color:
            if(is_active)
                "#f3be4b";//orange
            else
                index%2 ? "#7EC0EE" : "white";
    }

    TableCell {
        id: data_time_use
        anchors.left: index_row.right
        text: "02:31"
        color: index_row.color
    }
    TableCell {
        id: data_property
        property int difficult:
            if (thisRow.property == "10x10(10)")
                1;
            else
                if (thisRow.property == "16x16(40)")
                    2;
                else
                    if (thisRow.property == "16x30(100)")
                        3;
                    else 0;
        width: 90
        anchors.left: data_time_use.right
        text: "16*16(40)"
        color: index_row.color
        Rectangle {
            width: data_property.difficult * 16
            height: 17
            color: "transparent"
            anchors.centerIn: parent
            Repeater {
                model: data_property.difficult
                Image {
                    anchors.verticalCenter: parent.verticalCenter
                    source: "qrc:/images/Star.png"
                    sourceSize {width: 15; height: 15;}
                    x: index * 16
                    z: 0
                    opacity: 0.5
                }
            }
        }


    }
    TableCell {
        id: data_money_use
        anchors.left: data_property.right
        text: "31 $"
        color: index_row.color
    }
    TableCell {
        id: data_date
        anchors.left: data_money_use.right
        width: 150
        color: index_row.color
        text: "11.08.2014 | 02:31"
    }
}
