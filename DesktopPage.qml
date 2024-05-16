import QtQuick 2.15
import QtQuick.Controls 2.15

Page {
    id: desktopPage

    // Заголовок страницы
    ToolBar {
        id: desktopToolbar
        contentHeight: toolButton.implicitHeight

        Label {
            text: "Рабочий стол"
            horizontalAlignment: Text.AlignHCenter
            anchors.centerIn: parent
        }
    }

    // Содержимое страницы
    Column {
        anchors.fill: parent
        spacing: 20
        Text {
            text: "Это ваш рабочий стол"
            font.bold: true
            font.pixelSize: 24
            anchors.centerIn: parent
        }
    }
}
