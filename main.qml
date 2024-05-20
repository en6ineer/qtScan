import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    visible: true
    title: "1Sklad"

    // StackView для управления страницами
    StackView {
        id: stackView
        anchors.fill: parent
        anchors.bottom: navigationBar.top
        initialItem: mainPage

        Component {
            id: mainPage
            Page {
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
                            echoMode: TextInput.Password
                        }


                        Button {
                            id: authButton
                            text: "Авторизация"
                            font.pixelSize: 48
                            Layout.alignment: Qt.AlignHCenter
                            Layout.preferredWidth: parent.width * 0.8
                            Layout.preferredHeight: parent.height * 0.1
                            //visible: true
                        }

                }
            }
        }

        Component {
            id: secondPage
            Page {
                Label {
                    text: "Вторая"
                    anchors.centerIn: parent
                    font.pixelSize: 32
                }
            }
        }

        Component {
            id: thirdPage
            Page {
                Label {
                    text: "Третья"
                    anchors.centerIn: parent
                    font.pixelSize: 32
                }
            }
        }
    }


    Rectangle {
        id: navigationBar
        color: "lightgray"
        width: parent.width
        height: parent.height * 0.07
        anchors.bottom: parent.bottom

        RowLayout {
            anchors.fill: parent
            anchors.margins: 5

            Button {
                id: but1
                text: "Главная"
                Layout.fillWidth: true
                onClicked: stackView.replace(mainPage)
                font.pixelSize: 48
                Layout.preferredWidth: parent.width * 0.30
                Layout.preferredHeight: 120
                background: Rectangle {
                                color: but1.pressed ? "lightblue" : "lightgray"
                                border.color: "black"
                                border.width: 1
                                radius: 0
                            }
            }

            Button {
                id: but2
                text: "Вторая"
                Layout.fillWidth: true
                onClicked: stackView.replace(secondPage)
                font.pixelSize: 48
                Layout.preferredWidth: parent.width * 0.30
                Layout.preferredHeight: 120
                background: Rectangle {
                                color: but2.pressed ? "lightblue" : "lightgray"
                                border.color: "black"
                                border.width: 1
                                radius: 0
                            }
            }

            Button {
                id: but3
                text: "Настройки"
                Layout.fillWidth: true
                onClicked: stackView.replace(thirdPage)
                font.pixelSize: 48
                Layout.preferredWidth: parent.width * 0.30
                Layout.preferredHeight: 120
                background: Rectangle {
                                color: but3.pressed ? "lightblue" : "lightgray"
                                border.color: "black"
                                border.width: 1
                                radius: 0
                            }
            }
        }
    }
}

