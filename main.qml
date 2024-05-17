import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    visible: true
   // width: 400
   // height: 300
    title: "Сканер"

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
                    font.pixelSize: 48
                    horizontalAlignment: Text.AlignHCenter
                    anchors.centerIn: parent
                }

                Button {
                    id: backButton
                    text: "Назад"
                    font.pixelSize: 48
                    //width: 100
                    //height: 40
                    visible: mainStackView.depth > 1 // Показать кнопку только при наличии страниц для возврата
                    onClicked: mainStackView.pop() // Возвращаемся на предыдущую страницу
                }
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                spacing: 10

                Text {
                    text: "Главная страница"
                    font.bold: true
                    font.pixelSize: 48
                    Layout.alignment: Qt.AlignHCenter
                }

                Column{
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 5 // Отступ между полями ввода

                    // Элементы ввода
                    TextField {
                        placeholderText: "Логин"
                        Layout.alignment: Qt.AlignHCenter
                        Layout.preferredWidth: parent.width * 0.8
                        Layout.preferredHeight: 60
                        font.pixelSize: 40
                    }

                    TextField {
                        placeholderText: "Пароль"
                        Layout.alignment: Qt.AlignHCenter
                        Layout.preferredWidth: parent.width * 0.8
                        Layout.preferredHeight: 60
                        font.pixelSize: 40
                        echoMode: TextInput.Password // Скрываем вводимый текст
                    }
                }


                Button {
                    text: "Авторизация"
                    font.pixelSize: 48
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: parent.width * 0.8
                    Layout.preferredHeight: parent.height * 0.1
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
                        font.pixelSize: 64
                        horizontalAlignment: Text.AlignHCenter
                        anchors.centerIn: parent
                    }

                    Button {
                        id: backButton
                        text: "Назад"
                        font.pixelSize: 48
                        onClicked: mainStackView.pop() // Возвращаемся на предыдущую страницу
                    }
                }

                ColumnLayout {
                    anchors.fill: parent
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 20

                    Text {
                        text: "Это ваш рабочий стол"
                        font.bold: true
                        font.pixelSize: 48
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
            }
        }
    }
}

