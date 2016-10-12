//creating new field of  count_y*count_x cells
function create_component()
{
    playGrid.created_y = playGrid.count_y;
    playGrid.created_x = playGrid.count_x;
    var n = playGrid.count_x*playGrid.count_y;
    var element;
    for(var index=0; index < n ; index++)
    {
        var component = Qt.createComponent("Cell.qml");
        element = component.createObject(playGrid);
        element.rights = index%(playGrid.count_x);
        element.downs =  Math.floor(index/playGrid.count_x);
        element.numb = playGrid.ind_a(element.downs, element.rights);
        element.is_visible = playGrid.ind_b(element.downs, element.rights);
        element.x = element.rights*(18+1);
        element.y = element.downs*(18+1);
    }
}

//reseting games value
function new_game()
{
    set_zero(playGrid.a, playGrid.count_y, playGrid.count_x);
    set_mine(playGrid.a, playGrid.play_mine);
    set_number( playGrid.a, playGrid.count_y, playGrid.count_x);
    set_zero(playGrid.b, playGrid.count_y, playGrid.count_x);
    update_a();
    update_b();
    set_state();
    playGrid.users_mine = 0;
    playGrid.clicks = 0;
    thisApp.is_running = false;
    thisApp.is_win = false;
    thisApp.is_start = false;
    thisApp.is_over = false;
    thisApp.seconds = 0;
    thisApp.is_exclusive = false;
    thisApp.money_use = 0;
}

//destruction last field
function clean_field()
{
    for(var i=0; i < playGrid.children.length;i++)
    {
        if(playGrid.children[i])
            playGrid.children[i].destroy();
    }
}

//creating new Matrix with numbers
function create_field ( mines, rows, cols )
{
    console.log("creating matrix");
    var A = new Array(20 * 30);
    set_zero(A, 20, 30);
    set_mine(A, mines);
    set_number( A, rows, cols);
    return A;
}

//creating Matrix for property is_visible
function create_visible ()
{
    var A = new Array(20 * 30);
    set_zero(A, 20, 30);
    return A;
}

//destroy last field and create new field
function new_field()
{
    clean_field();
    create_component();
}

//set starting state for cells
function set_state()
{
    for(var i=0; i < playGrid.children.length;i++)
    {
        if(playGrid.children[i])
            playGrid.children[i].state = "default";
    }
}

//updating property is_visible for cells
function update_b()
{
    for(var i=0;i<playGrid.children.length;i++)
    {
        var element =  playGrid.children[i];
        element.is_visible = playGrid.ind_b(element.downs, element.rights);
    }
}

//updating property numb for cells
function update_a()
{
    for(var i=0;i < playGrid.children.length;i++)
    {
        var element =  playGrid.children[i];
        element.numb = playGrid.ind_a(element.downs, element.rights);
    }
}

//setting zero for Matrix
function set_zero ( A, rows, cols)
{
    for( var i = 0; i < rows; i++)
        for( var j = 0; j < cols; j++)
            A[i * 30 + j] = 0;
}

//setting mines into field
function set_mine ( A , mines )
{
    set_zero (A, playGrid.count_y , playGrid.count_x);
    var x, y;
    var minesSetted=0;
    while(minesSetted < mines)
    {
        x = get_random_int(0, playGrid.count_x);
        y = get_random_int(0, playGrid.count_y);
        if(A[y * 30 + x] != 9)
        {
            minesSetted++;
            A[y * 30 + x] = 9;
        }
    }
}

//resetting one mines if it was first click
function unset_mine( row, col )
{
    var flag_setted = false;
    if(playGrid.ind_a(row, col) == 9)
    {
        console.log("happy first click in bomb")
        playGrid.a[row * 30 + col] = 0;
        while( !flag_setted )
        {
            var x = get_random_int(0, playGrid.count_x);
            var y = get_random_int(0, playGrid.count_y);
            if(playGrid.ind_a(y,x) != 9 && y != row && x!= col)
            {
                flag_setted = true;
                playGrid.a[y * 30 + x] = 9;
            }
        }
        set_number(playGrid.a, playGrid.count_y, playGrid. count_x);
        update_a();
    }
}

//setting number into Matrix: 0 - empty; (1-8) - count mines arround; 9 - mine
function set_number( A , rows, cols )
{
    var i,j;
    var temp;
    for(i=0; i<rows; i++)
        for(j=0; j<cols; j++)
            if(A[i * 30 + j] != 9)
            {
                temp = 0;
                if ( i > 0 && j < cols-1 && A[ (i-1) * 30 + j+1] == 9) temp++;//right top
                if ( j < cols-1 && A[i * 30 + j+1] == 9) temp++;//right center
                if ( j < cols-1 && i < rows-1 && A[ (i+1) *30 + j+1] == 9) temp++;//right bottom
                if ( i < rows-1 && A [ (i+1) * 30  + j] == 9) temp++;//center bottom
                if ( i > 0 && A[ (i-1) * 30 + j] == 9) temp++;//center top
                if ( i > 0 && j > 0 && A[ (i-1) * 30 + j-1] == 9) temp++;//left top
                if ( j > 0 && A[ i * 30 + j-1] == 9) temp++;//left center
                if ( i < rows-1 && j > 0 &&  A[ (i+1) * 30 + j-1] == 9) temp++;//left bottom
                A[i * 30 + j] = temp;
            }
}

//opening empty cells after click
function find_empty_cell( x, y, rows, cols )
{
    if( x < 0 || x >= rows || y < 0 || y >= cols || playGrid.a[x * 30 + y] == 9 || playGrid.b[x * 30 + y] == true )
        return;
    playGrid.clicks += (!playGrid.b[x * 30 + y]) ? 1 : 0;
    playGrid.b[x * 30 + y] = true;
    playGrid.children[x * playGrid.count_x + y].is_visible = true;
    if(playGrid.a[x * 30 + y] == 0)
    {
        find_empty_cell(x-1, y-1, rows, cols);//left top
        find_empty_cell(x-1, y, rows, cols);//center top
        find_empty_cell(x-1, y+1, rows, cols);//right top
        find_empty_cell(x, y+1, rows, cols);//right center
        find_empty_cell(x, y-1, rows, cols);//left center
        find_empty_cell(x+1, y-1, rows, cols);//left botoom
        find_empty_cell(x+1, y, rows, cols);//center bottom
        find_empty_cell(x+1, y+1, rows, cols);//right bottom
    }
}

//opening bonus cell ( with mine or empty)
function open_bonus_cell( x, y )
{
    thisApp.is_start = true;
    if(playGrid.ind_a(x,y) != 9)
        find_empty_cell(x, y, playGrid.count_y, playGrid.count_x);
    else
    {
        playGrid.b[x * 30 + y] = true;
        playGrid.children[x * playGrid.count_x + y].is_visible = true;
    }
}

//opening bonus row
function setBonusRow(row)
{
    for(var i=0;i<playGrid.count_x;i++)
        open_bonus_cell(row,i);
}

//opening bonus col
function setBonusCol(col)
{
    for(var i=0;i<playGrid.count_y;i++)
        open_bonus_cell(i,col);
}

//opening bonus square
function setBonusSquare(row, col)
{
    for(var i=0;i<3;i++)
    {
        open_bonus_cell(row+i-1,col-1);
        open_bonus_cell(row+i-1,col);
        open_bonus_cell(row+i-1,col+1);
    }
}

//opening bonus cell
function setBonusCell(row, col)
{
    open_bonus_cell(row, col);
}

//show all cells of field
function show_field()
{
    set_true(playGrid.b, playGrid.count_y, playGrid.count_x);
    update_b();
}

//setting true for all elements in matrix
function set_true(A, rows, cols)
{
    for(var i=0; i < rows; i++)
        for(var j=0; j < cols; j++)
            A[i * 30 + j] = true;
}

//creating new statistcs line; add it; and sorting them (with help right position in window)
function add_new_line(rows, cols, mines, seconds, money)
{
    var element;
    var date = new Date();
    var component = Qt.createComponent("TableRow.qml");
    element = component.createObject(table_statistics);
    element.start_y = (table_statistics.children.length - 2) * (20 - 2);
    element.y = element.start_y;
    element.index = table_statistics.children.length - 1;
    element.date = to_2digit(date.getDate()) + "." + to_2digit(date.getMonth()) + "." + date.getFullYear() + " | " + to_2digit(date.getHours()) + ":" + to_2digit(date.getMinutes());//"10.10.2010 / 10:01";
    element.property = rows.toString() + "x" + cols.toString() + "(" + mines.toString() + ")";
    element.seconds_use = seconds;
    if(seconds < 60*60)
        element.time_use = Math.floor(seconds/60).toString() + ":" + to_2digit(seconds%60);
    else
        element.time_use = format_time(seconds);
    element.money_use = money.toString() + " $";
    if(element.index > 10)
        table_statistics.all_height += 18;
    var i;
    console.log("new line. seconds = " + seconds);
    var min_seconds = 100000;
    var min_index = 0;
    var min_start_y = -10;
    var min_y = 0;
    for(i=1; i < table_statistics.children.length; ++i)
    {
        table_statistics.children[i].is_active = false;
        if(element.seconds_use < table_statistics.children[i].seconds_use)
        {
            if(table_statistics.children[i].seconds_use < min_seconds)
            {
                min_seconds = table_statistics.children[i].seconds_use;
                min_index = table_statistics.children[i].index;
                min_start_y = table_statistics.children[i].start_y;
                min_y = table_statistics.children[i].y;
            }
            table_statistics.children[i].start_y += 18;
            table_statistics.children[i].y += 18;
            table_statistics.children[i].index++;
        }
    }
    if (min_index != 0)
    {
        element.start_y = min_start_y;
        element.index = min_index;
        element.y = min_y;
    }
    element.is_active = true;
}

//updating position info row in table for scrooling
function update_table()
{
    var i;
    for(i=1; i<table_statistics.children.length; ++i)
        table_statistics.children[i].y  =  table_statistics.children[i].start_y - (my_scrool.position - 1) * table_statistics.koff;

}

//returning random int value [min;max]
function get_random_int(min, max)
{
    return Math.floor( Math.random() * max ) + min;
}

//converting digit to string
function to_2digit(value)   //from 6 to 06
{
    if( value < 10 )
        return "0" + value;
    return value;
}

//converting seconds to time string
function format_time(sec) //from 1:1 to 01:01
{
    if(sec < 60 * 60)
        return to_2digit(Math.floor(sec/60)) + ":" + to_2digit(sec%60);
    else
        return Math.floor(sec/(60*60)).toString() + ":" + format_time(Math.floor(sec/60));
}
