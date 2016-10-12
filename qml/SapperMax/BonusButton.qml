import QtQuick 2.0

MyButton {
    id: thisBonusButton
    property bool is_active: false  //when clicked
    property int price: 1   //price of this bonus
    enabled: ( !is_bonus_active && price <= thisApp.money) || is_active_mouse
    color:  is_active_mouse || is_active ? "#cdf966" : "white"
    text_color: enabled || is_active ? "black" : "grey"

    Text {
        text: price.toString()
        anchors.right: thisBonusButton.right
        anchors.rightMargin: 4
        anchors.bottom: thisBonusButton.bottom
        anchors.bottomMargin: 2
        font.family: "Consolas"
        font.pixelSize: 13
        color: parent.price <= thisApp.money ? "#58a25e" : "#e64040"
    }
    onSenderClicked:
    {
        is_active = true;
        thisApp.money -= price;
        thisApp.money_use += price;
    }
}
