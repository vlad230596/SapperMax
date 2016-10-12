import QtQuick 2.0
import "qrc:/source/Logic.js" as Logic

Rectangle {
    property var a //map of mine and count mine around cell
    property var b //map for clicked cell
    property int count_y: 10    //rows
    property int count_x: 15   //columns
    property int created_y: count_y //count of created rows
    property int created_x: count_x //count of created cols
    property int users_mine: 0  //user's clicks in cell with, probably, mine
    property int play_mine: 20  //real count mine
    property int clicks: 0      //count of open cell

    height: count_y*(18+1) - 1
    width: count_x*(18+1) - 1

//   Repeater {

//        model: parent.count_x * parent.count_y
//        Cell {
////            size: 18
//            rights: index%(count_x);
//            downs:  Math.floor(index/count_x);
//            numb: playGrid.ind_a(downs, rights);
//            is_visible: playGrid.ind_b(downs, rights);
//            x: rights*(18+1)
//            y: downs*(18+1)
//        }
//    }
    onClicksChanged:
    {
        if(count_x * count_y - clicks == play_mine)
        {   //player win, when he open all cells(except mine's cell)
            is_win = true;
            is_running = false;
            is_over = true;
        }
    }

    function ind_a(row, col)
    {
        return a[row*30 + col];
    }
    function ind_b(row, col)
    {
        return b[row*30 + col];
    }
}

