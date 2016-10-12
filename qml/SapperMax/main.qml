import QtQuick 2.0
import QtQuick.Window 2.0

import "qrc:/source/Logic.js" as Logic

Window {
    id: thisApp
    property bool is_running: false
    property bool is_win: false
    property bool is_start: false
    property bool is_over: false
    property int seconds: 0 //seconds after first click
    property int currentIndex: 1 //current inset open
    property bool is_bonus_active: bonusCol.is_active || bonusRow.is_active || bonusSquare.is_active || bonusCell.is_active
    property bool is_exclusive: false
    property int money: 10  //money in collection
    property int money_use: 0   //money which user use
    property int current_row: 0
    property int current_col: 0
    visible: true   //for window element
    width: playGrid.x + playGrid.width + 140 + 20
    height: playGrid.y + playGrid.height + 40


    onCurrentIndexChanged:
    {
        switch(currentIndex)
        {
        case 1:
            playGrid.play_mine = count_bomb.value;
            playGrid.count_x = spin_x.value;
            playGrid.count_y = spin_y.value;
            if( playGrid.created_y != playGrid.count_y || playGrid.creted_x != playGrid.count_x)
                Logic.new_field();  //if field property have changes
            Logic.new_game();
            thisApp.setHeight(playGrid.y + playGrid.height + 40);
            if( playGrid.x + playGrid.width + 160 > 305)
                thisApp.setWidth(playGrid.x + playGrid.width + 160);
            else
                thisApp.setWidth(305);
            break;
        case 2: case 3:
            thisApp.setHeight(260);
            thisApp.setWidth(430);
            break;
        case 4:
            thisApp.setHeight(290);
            thisApp.setWidth(470);
            break;
        }
    }

    Inset {
        x: 10
        title: "Игра"
        indexInset: 1
        BodyInset {
            Grids {
                id: playGrid
                y: 40
            }

            Rectangle {
                //property int row:  if(mouseInGrid.mouseY>0)Math.floor((mouseInGrid.mouseY-1)/19); else Math.floor((mouseInGrid.mouseY)/19);
                y: current_row*19 + 21 + 19
                width: playGrid.width
                height: 18
                opacity: 0.4
                color: "red"
                visible: bonusRow.is_active
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.log("Bonus row: " + current_row);
                        bonusRow.is_active = false;
                        thisApp.is_running = true;
                        Logic.setBonusRow(current_row);
                       // bonusRow.is_active_mouse = false;
                    }
                }
            }
            Rectangle {
                //property int col: if(mouseInGrid.mouseX>0)Math.floor((mouseInGrid.mouseX-1)/19); else Math.floor((mouseInGrid.mouseX)/19);
                width: 18
                height: playGrid.height
                y: playGrid.y
                x: current_col*19
                color: "red"
                opacity: 0.4
                visible: bonusCol.is_active
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.log("Bonus col: " + current_col);
                        bonusCol.is_active = false;
                        thisApp.is_running = true;
                        Logic.setBonusCol(current_col);
                    }
                }
            }
            Rectangle {
                x: current_col*19
                y: current_row*19  + 21 + 19
                height: 18
                width: 18
                color: "red"
                opacity: 0.4
                visible: bonusCell.is_active
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.log("Bonus cell: " + current_row + " " + current_col);
                        bonusCell.is_active = false;
                        thisApp.is_running = true;
                        Logic.setBonusCell(current_row, current_col);
                    }
                }
            }
            Rectangle {
                property int row:
                    if( current_row == 0 )
                        1;
                    else
                        if(current_row == playGrid.count_y - 1)
                            playGrid.count_y - 2;
                        else
                            current_row;
                property int col:
                    if( current_col == 0 )
                        1;
                    else
                        if(current_col == playGrid.count_x - 1)
                            playGrid.count_x - 2;
                        else
                            current_col;
                x: col*19 - 19
                y: row*19 + 21
                height: 18*3+2
                width: 18*3+2
                color: "red"
                opacity: 0.4
                visible: bonusSquare.is_active
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.log("Bonus square: " + parent.row + " " + parent.col);
                        bonusSquare.is_active = false;
                        thisApp.is_running = true;
                        Logic.setBonusSquare(parent.row, parent.col);
                    }
                }
            }
            Rectangle {
                x:  current_col !=0 ? current_col*19 - 19 - 1 : current_col*19
                y: current_row != 0 ? current_row*19 + 21 - 1 : current_row*19 + 21 + 19
                height: ( !(current_row==0 || current_row == playGrid.count_y - 1)  )? 18*3+2 + 2 : 18*2+1 + 1
                width: ( !(current_col==0 || current_col == playGrid.count_x - 1) ) ? 18*3+2 + 2: 18*2+1 + 1
                //color: "orange"
                //opacity: 0.4
                color: "transparent"
                border {width:2; color: "#e64040"}
                visible: show_box_arround_cell.running
                }

            Rectangle {
                id: money_label
                anchors.horizontalCenter: new_game_button.horizontalCenter
                anchors.top: playGrid.top
                height: money_label_text.contentHeight + 5
                width: money_label_text.contentWidth + 16
                border {width: 2; color: "#ff9a0d"}
                radius: 4
                Text {
                    anchors.centerIn: parent
                    id: money_label_text
                    text: "$ " + money.toString()
                    font.pointSize: 11
                    font.family: "Consolas"
                }
                z: 100
            }
            MyButton {
                title: "Новая игра"
                id: new_game_button
                anchors.top: money_label.bottom
                anchors.topMargin:
                    if(playGrid.count_y < 9)
                        (playGrid.height + 3 + bomb_label.height - 25 * 5 - money_label.height) / 5;
                    else
                        if(playGrid.count_y < 12)
                            (playGrid.height  - 25 * 5 - money_label.height) / 5;
                        else
                            10;
                border.color: "#05b8ff"
                onSenderClicked: Logic.new_game();
                z: 100
            }
            BonusButton {
                id: bonusCell
                title: "Ячейка"
                border.color: "#e64040"
                price: 1
                anchors.top: new_game_button.bottom
                anchors.topMargin: new_game_button.anchors.topMargin
            }
            BonusButton {
                id: bonusCol
                title: "Столбец"
                border.color: "#f546d8"
                price: playGrid.count_y
                anchors.top: bonusCell.bottom
                anchors.topMargin: new_game_button.anchors.topMargin
            }
            BonusButton {
                id: bonusRow
                title: "Строка"
                border.color: "#7fcf1e"
                price: playGrid.count_x
                anchors.top: bonusCol.bottom
                anchors.topMargin: new_game_button.anchors.topMargin
            }
            BonusButton {
                id: bonusSquare
                title: "Квадрат"
                border.color: "#c2c02d"
                price: 9
                anchors.top: bonusRow.bottom
                anchors.topMargin: new_game_button.anchors.topMargin
            }

            Rectangle {
                id: bomb_label
                height: bomb_label_text.contentHeight + 5
                width: bomb_label_text.contentWidth + 16
                color: playGrid.play_mine - playGrid.users_mine < 0 ? "#f76d6d" : "white"
                radius: 4
                border.width: 2
                border.color: "#05b8ff"
                anchors.top: playGrid.bottom
                anchors.topMargin: 3
                Text {
                    id: bomb_label_text
                    anchors.centerIn: parent
                    text: playGrid.play_mine - playGrid.users_mine
                    font.pointSize: 11
                    font.family: "Consolas"
                }
            }

            Rectangle {
                x: playGrid.x + playGrid.width  - width
                anchors.top: playGrid.bottom
                anchors.topMargin: 3
                height: format_time_text.contentHeight + 5
                width: format_time_text.contentWidth + 16
                border {width: 2; color: "#05b8ff";}
                radius: 4
                Text {
                    anchors.centerIn: parent
                    id: format_time_text
                    text: Logic.format_time(thisApp.seconds)
                    font.pointSize: 11
                    font.family: "Consolas"
                }
            }
            Rectangle {
                id: shadow
                height: playGrid.height
                width: thisApp.width - 20
                anchors.top: playGrid.top
                visible: false
                opacity: 0
                //color: "red"
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    onClicked: Logic.new_game();

                }
                Behavior on opacity {
                    NumberAnimation {
                        duration: 200
                    }
                }

                states: State {
                        name: "active"
                        when: is_over//!is_running && is_start
                        PropertyChanges {
                            target: shadow
                            visible: true
                            opacity: 0.5
                        }
                    }
            }
            ResText {
                id: resultBox
                visible: is_over
                text: (is_win && !is_exclusive) ? ( "Победа" ) : (is_exclusive) ? ("Профи!") : ( "Поражение" )
                anchors.centerIn: playGrid
            }
        }
    }
    Inset {
        x_title: 64
        title: "Настройки"
        indexInset: 2
        BodyInset {
            Split {
                title: "Высота"
                id: spin_y
                y: 50
                x: 60
                width: 180
                height: 17
                min_value: 7
                max_value: 20
                value: playGrid.count_y
            }
            Split {
                title: "Ширина"
                id: spin_x
                y: 90
                x: 60
                width: 180
                height: 17
                min_value: 7
                max_value: 30
                value: playGrid.count_x
            }
            Split {
                title: "Бомбы"
                id: count_bomb
                property int start_value:
                    if(spin_x.value * spin_y.value < 100)
                        Math.ceil(spin_x.value *spin_y.value / 10);
                    else
                        if(spin_x.value * spin_y.value < 256)
                            Math.ceil ((5 * spin_x.value * spin_y.value - 240 ) / 26);
                        else
                            Math.ceil( (15 * spin_x.value * spin_y.value - 1600 ) / 56 );
                    // it's math formula for 3 line: 100 -> 10; 256 -> 40; 480 -> 100
                y: 130
                x: 60
                width: 180
                height: 17
                min_value: Math.ceil ( start_value / 2 ) //no user's changes property
                max_value: start_value * 2  //no user's changes property
                value: start_value  //changes property
                onMax_valueChanged://when field's property are changing
                {
                    if(value * 2 != max_value)
                        value = start_value;
                }
            }
            ButtonDifficult {
                id: difficult_easy
                difficult: 1
                anchors.left: parent.left
                anchors.leftMargin: 42
            }
            ButtonDifficult {
                id: difficult_medium
                difficult: 2
                anchors.left: difficult_easy.right
            }
            ButtonDifficult {
                id: difficult_hard
                difficult: 3
                anchors.left: difficult_medium.right
            }

        }
    }
    Inset {
        x_title: 149
        title: "Статистика"
        indexInset: 3
        BodyInset {

            Rectangle {
                 id: table_statistics
                 property int all_children: table_statistics.children.length
                 property int all_height: 0
                 property real koff: all_height/my_scrool.way
                 anchors.top: title_table.bottom
                 //anchors.topMargin: -2
                 height: 20*9 + 2
                 width: 426
                 //border {color: "lightBlue"; width: 2}
                 clip: true
                 MouseArea {
                     anchors.fill: parent
                     acceptedButtons: Qt.NoButton
                     onWheel:
                     {
                         if(wheel.angleDelta.y > 0)
                            my_scrool.set_pointer_y(my_scrool.pointer_y - 10);
                         else
                            my_scrool.set_pointer_y(my_scrool.pointer_y + 10);
                    }
                 }



            }
            TableRow {
                id: title_table
                y: 50
                width: 426
                height: 18
                index: "Место"
                date: "Дата"
                time_use:  "Время"
                money_use: "Деньги"
                property: "Поле"

            }
            VerticalScrool {
                id: my_scrool
                height: table_statistics.height + title_table.height
                anchors.top: title_table.top
                anchors.right: title_table.right
                anchors.rightMargin: 14
                visible: table_statistics.all_height > 0
                onScrooling: Logic.update_table();
            }
        }
    }
    Inset {
        x_title: 235
        title: "О игре"
        indexInset: 4
        BodyInset {
            TextBlock {
                id: taskText
                y: 40
                x: 10
                border.color: "#e64040"//red
                title: "Цель игры"
                text: "Открыть все ячейки, которые не содержат мин"
            }
            TextBlock {
                id: rulesText
                anchors.left: taskText.left
                anchors.top: taskText.bottom
                anchors.topMargin: 10
                border.color: "#f56c02"//orange
                title: "Правила"
                text: "• При первом клике невозможно попасть в мину \n• Вскрытие ячейки с миной – проигрыш \n• Цифра в ячейке – количество мин в соседних\n   восьми ячейках\n• Пустые ячейки вскрываются автоматически"
            }
            TextBlock {
                id: bonusText
                anchors.left: rulesText.left
                anchors.top: rulesText.bottom
                anchors.topMargin: 10
                border.color: "#05b8ff"//light blue
                title: "Бонусы"
                text: "Каждая победная партия приносит бонусы <b>$</b>, которые можно потратить на упрощение игры: открытие ячейки, столбца, строки или квадрата 3х3"
            }
            AnimatedImage {
                id: hintLeft
                anchors.left: taskText.right
                anchors.top: taskText.top
                anchors.leftMargin: 10
                source: "qrc:/images/LetfClick.gif"
            }
            AnimatedImage {
                id: hintRight
                anchors.left: hintLeft.left
                anchors.top: hintLeft.bottom
                anchors.topMargin: 8
                source: "qrc:/images/RightClick.gif"
            }
            AnimatedImage {
                id: hintRightBorder
                anchors.left: hintRight.left
                anchors.top: hintRight.bottom
                anchors.topMargin: 8
                source: "qrc:/images/RightClickBorder.gif"
            }

            Text {
                anchors.top: bonusText.bottom
                anchors.topMargin: 5
                anchors.horizontalCenter: bonusText.horizontalCenter
                font.family: "Consolas"
                text: "2014 Мохначёв Владислав vlad230596@mail.ru"
                font.pixelSize: 12
            }
        }
    }
    Timer { //for game's time
        running: is_running
        repeat: true
        interval: 1000
        onTriggered:
        {
            thisApp.seconds++;
        }
    }
    Timer { //for start creating item
        running: true
        triggeredOnStart: true
        interval: 1000*60*60*24///day
        onTriggered:
        {
            console.log("starting");
            playGrid.a = Logic.create_field(playGrid.play_mine, playGrid.count_y, playGrid.count_x);  //map of mine and count mine around cell
            playGrid.b = Logic.create_visible();    //map for clicked cell
            Logic.create_component();   //create field
            stop();
        }
    }
    Timer { // for visible help box arround cell
        id: show_box_arround_cell
        interval: 500
        onTriggered:
        {
            stop();
        }
    }
    onIs_overChanged:
    {
        if(is_over)
        {
            Logic.show_field();
            if(is_win)
            {
                money += count_bomb.value;
                Logic.add_new_line(playGrid.count_y, playGrid.count_x, playGrid.play_mine, seconds, thisApp.money_use); //statistics
                if(playGrid.count_y == 20 && playGrid.count_x == 30 && playGrid.play_mine == 263 && money_use <= 50)
                {
                    money += 1000;
                    is_exclusive = true;
                }
            }
        }
    }
}
