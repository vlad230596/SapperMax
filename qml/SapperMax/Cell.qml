import QtQuick 2.0
import "qrc:/source/Logic.js" as Logic

Rectangle {
    id: thisCell
    property int size: 18   //Pixel size of block
    property int numb:0     //Count bomb around a cell
    property bool is_visible: false //Show cell
    property int rights: 0  //X
    property int downs: 0   //Y
    state: "default"
    width: size
    height: size
    color: "#97bff7"
    border {width: 1; color: "#5c5b5b"}//important for next version ( new viev with "orange" or "white")
    radius: 2

    MouseArea {
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        anchors.fill: parent
        hoverEnabled: true
        onEntered:
        {
            thisApp.current_row = downs;
            thisApp.current_col = rights;
        }
        onClicked: {
            if( !thisApp.is_start )
                Logic.unset_mine(downs, rights);
            thisApp.is_start = true;
            thisApp.is_running = true;
            if (mouse.button == Qt.RightButton)
            {
                if(!is_visible)
                {
                    if ( parent.state == "default" )    //player has made choice
                    {
                        parent.state = "bomb";
                        playGrid.users_mine++;
                    }
                    else    //player change self choice of situated bomb
                    {
                        parent.state = "default";
                        playGrid.users_mine--;
                    }
                }
                else
                     show_box_arround_cell.start();
            }
            else
                if (mouse.button == Qt.LeftButton && ( parent.state == "bomb" || parent.state == "right_bomb" ))
                    return;//wrong click
            if (mouse.button == Qt.LeftButton)
            {
                if (numb != 9)
                    Logic.find_empty_cell(thisCell.downs, thisCell.rights, playGrid.count_y, playGrid.count_x);
                else//player has died
                {
                    thisApp.is_running = false;
                    thisApp.is_win = false;
                    thisApp.is_over = true;
                }
            }
        }
    }
    Text {
        id: cellText
        font.family: "Consolas"
        anchors.centerIn: parent
        text: numb
        font.bold: true
        font.pixelSize: size-Math.floor(size/18)
        visible:  is_visible && numb != 0 && numb != 9
        color:        switch(numb)
                       {
                       case 1: "#4896fb";//blue
                           break;
                       case 2: "#58a25e";//green
                           break;
                       case 3:"#c368f7";//magneta
                           break;
                       case 4: "#7a5127";//brown
                           break;
                       case 5: "#ec6834";//orange
                           break;
                       case 6: "#ee7f59";//red
                           break;
                       case 7: "#e65398";//pink
                           break;
                       case 8: "#fd799a";//yellow
                           break;
                       default: "black";
                       }
    }

    transitions: Transition {
        ColorAnimation { duration: 50 }
    }


    onIs_visibleChanged: {
        if(is_visible)
            if(numb != 9)
            {
                if(state == "bomb")
                {
                    playGrid.users_mine--;
                    if(thisApp.is_over)
                        state = "wrong_bomb";
                    else
                        state = "empty";
                }
                else
                    state = "empty";
            }
            else
            {
                if(state != "bomb" && state != "right_bomb")
                    playGrid.users_mine++;
                state = "right_bomb";
            }
    }

    states: [
        State {
            name: "empty"
            //when: is_visible && numb != 9
            PropertyChanges {
                target: thisCell
                color: "#eeeeee" //grey
            }
        },
        State {
            name: "right_bomb"
            //when: is_visible && numb == 9
            PropertyChanges {
                target: thisCell
                color: "#e00000" //dark red
                }
        },
        State {
            name: "bomb"
            PropertyChanges {
                target: thisCell
                color: "#f76d6d" //light red
            }
        },
        State {
            name: "wrong_bomb"
            PropertyChanges {
                target: thisCell
                color: "black"
            }
            PropertyChanges {
                target: cellText
                color: "white"
            }
        }

    ]
}
