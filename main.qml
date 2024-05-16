import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    visible: true
    width: 400
    height: 300
    title: "Мое приложение"

    // Определяем StackView
    StackView {
        id: mainStackView
        anchors.fill: parent // StackView занимает всю доступную область окна

        // Главная страница
        initialItem: Page {
            id: mainPage

            ToolBar {
                id: mainToolbar
                contentHeight: backButton.implicitHeight

                Label {
                    text: "Главная страница"
                    horizontalAlignment: Text.AlignHCenter
                    anchors.centerIn: parent
                }

                Button {
                    id: backButton
                    text: "Назад"
                    width: 100
                    height: 40
                    visible: mainStackView.depth > 1 // Показать кнопку только при наличии страниц для возврата
                    onClicked: mainStackView.pop() // Возвращаемся на предыдущую страницу
                }
            }

            Column {
                anchors.fill: parent
                spacing: 20
                Button {
                    text: "Открыть Рабочий стол"
                    width: 400
                    height: 200
                    onClicked: mainStackView.push(desktopPage)
                }
            }
        }

        // Страница Рабочего стола
        Component {
            id: desktopPage

            Page {
                ToolBar {
                    id: desktopToolbar
                    contentHeight: backButton.implicitHeight

                    Label {
                        text: "Рабочий стол"
                        horizontalAlignment: Text.AlignHCenter
                        anchors.centerIn: parent
                    }

                    Button {
                        id: backButton
                        text: "Назад"
                        onClicked: mainStackView.pop() // Возвращаемся на предыдущую страницу
                    }
                }

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
        }
    }
}
