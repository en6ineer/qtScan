import QtQuick 2.15
import QtQuick.Controls 2.15

Page {
    id: mainPage

    // Заголовок страницы
    ToolBar {
        id: mainToolbar
        contentHeight: toolButton.implicitHeight

        Label {
            text: "Главная страница"
            horizontalAlignment: Text.AlignHCenter
            anchors.centerIn: parent
        }
    }

    // Содержимое страницы
    Column {
        anchors.fill: parent
        spacing: 20
        Button {
            text: "Открыть Рабочий стол"
            onClicked: {
                mainStackView.push("qrc:/DesktopPage.qml")
            }
        }
    }
}
