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
                        id: resolutionTextField
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
                            onClicked: {
                                      // resolutionTextField.text = "Ширина экрана: " + Screen.desktopAvailableWidth
                                    resolutionTextField.text =  "Высота экрана: " + Screen.desktopAvailableHeight
                                   }
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
                ListView {
                    width: parent.width
                    height: parent.height
                    model: ListModel {
                        ListElement {
                            barcode: "123456789"
                            quantity: 10
                        }
                        ListElement {
                            barcode: "987654321"
                            quantity: 5
                        }
                    }

                    delegate: RowLayout {
                        spacing: 10
                        Text {
                            text: model.barcode
                            font.pixelSize: 24
                        }
                        Text {
                            text: model.quantity
                            font.pixelSize: 24
                        }
                    }
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

// import QtQuick 2.15
// import QtQuick.Controls 2.15
// import QtQuick.Layouts 1.15

// ApplicationWindow {
//     visible: true
//     // width: 400
//     // height: 600
//     title: "1Sklad"

//     // Объявление свойств для хранения данных
//     property string loginText: ""
//     property string passwordText: ""
//     property var barcodes: []

//     // StackView для управления страницами
//     StackView {
//         id: stackView
//         anchors.fill: parent
//         initialItem: mainPageLoader.item

//         Loader {
//             id: mainPageLoader
//             sourceComponent: mainPage
//         }

//         Loader {
//             id: secondPageLoader
//             sourceComponent: secondPage
//         }

//         Loader {
//             id: thirdPageLoader
//             sourceComponent: thirdPage
//         }
//     }

//     Component {
//         id: mainPage
//         Page {
//             ColumnLayout {
//                 anchors.fill: parent
//                 anchors.horizontalCenter: parent.horizontalCenter
//                 anchors.verticalCenter: parent.verticalCenter
//                 spacing: 10

//                 Text {
//                     text: "Главная страница"
//                     font.bold: true
//                     font.pixelSize: 48
//                     Layout.alignment: Qt.AlignHCenter
//                 }

//                 // Элементы ввода
//                 TextField {
//                     placeholderText: "Логин"
//                     text: loginText
//                     onTextChanged: loginText = text
//                     Layout.alignment: Qt.AlignHCenter
//                     Layout.preferredWidth: parent.width * 0.8
//                     Layout.preferredHeight: 60
//                     font.pixelSize: 40
//                 }

//                 TextField {
//                     placeholderText: "Пароль"
//                     text: passwordText
//                     onTextChanged: passwordText = text
//                     Layout.alignment: Qt.AlignHCenter
//                     Layout.preferredWidth: parent.width * 0.8
//                     Layout.preferredHeight: 60
//                     font.pixelSize: 40
//                     echoMode: TextInput.Password // Скрываем вводимый текст
//                 }

//                 Button {
//                     id: authButton
//                     text: "Авторизация"
//                     font.pixelSize: 48
//                     Layout.alignment: Qt.AlignHCenter
//                     Layout.preferredWidth: parent.width * 0.8
//                     Layout.preferredHeight: parent.height * 0.1
//                     visible: true
//                     onClicked: {
//                         console.log("Авторизация нажата")
//                         stackView.push(secondPageLoader.item)
//                     }
//                     Component.onCompleted: {
//                         console.log("Кнопка авторизации инициализирована")
//                     }
//                 }
//             }
//         }
//     }

//     Component {
//         id: secondPage
//         Page {
//             ColumnLayout {
//                 anchors.fill: parent
//                 anchors.horizontalCenter: parent.horizontalCenter
//                 anchors.verticalCenter: parent.verticalCenter
//                 spacing: 10

//                 Text {
//                     text: "Вторая страница"
//                     font.bold: true
//                     font.pixelSize: 48
//                     Layout.alignment: Qt.AlignHCenter
//                 }

//                 // Список штрихкодов и количеств
//                 ListView {
//                     width: parent.width * 0.9
//                     height: parent.height * 0.7
//                     model: barcodes
//                     delegate: RowLayout {
//                         spacing: 10
//                         Text { text: modelData.barcode }
//                         Text { text: modelData.quantity }
//                     }
//                 }

//                 Button {
//                     text: "Добавить штрихкод"
//                     onClicked: {
//                         barcodes.push({ barcode: "123456789", quantity: 1 })
//                     }
//                 }
//             }
//         }
//     }

//     Component {
//         id: thirdPage
//         Page {
//             ColumnLayout {
//                 anchors.fill: parent
//                 anchors.horizontalCenter: parent.horizontalCenter
//                 anchors.verticalCenter: parent.verticalCenter
//                 spacing: 10

//                 Text {
//                     text: "Третья страница"
//                     font.bold: true
//                     font.pixelSize: 48
//                     Layout.alignment: Qt.AlignHCenter
//                 }

//                 TextField {
//                     placeholderText: "URL 1"
//                     Layout.alignment: Qt.AlignHCenter
//                     Layout.preferredWidth: parent.width * 0.8
//                     Layout.preferredHeight: 60
//                     font.pixelSize: 40
//                 }

//                 TextField {
//                     placeholderText: "URL 2"
//                     Layout.alignment: Qt.AlignHCenter
//                     Layout.preferredWidth: parent.width * 0.8
//                     Layout.preferredHeight: 60
//                     font.pixelSize: 40
//                 }
//             }
//         }
//     }

//     // Навигационная панель с кнопками
//     Rectangle {
//         id: navigationBar
//         color: "lightgray"
//         width: parent.width
//         height: parent.height * 0.07
//         anchors.bottom: parent.bottom

//         RowLayout {
//             anchors.fill: parent
//             anchors.margins: 5

//             Button {
//                 id: but1
//                 text: "Главная"
//                 Layout.fillWidth: true
//                 onClicked: stackView.replace(mainPageLoader.item)
//                 font.pixelSize: 48
//                 Layout.preferredWidth: parent.width * 0.30
//                 Layout.preferredHeight: 120
//                 background: Rectangle {
//                     color: but1.pressed ? "lightblue" : "lightgray"
//                     border.color: "black"
//                     border.width: 1
//                     radius: 0 // Убираем скругление углов
//                 }
//             }

//             Button {
//                 id: but2
//                 text: "Вторая"
//                 Layout.fillWidth: true
//                 onClicked: stackView.replace(secondPageLoader.item)
//                 font.pixelSize: 48
//                 Layout.preferredWidth: parent.width * 0.30
//                 Layout.preferredHeight: 120
//                 background: Rectangle {
//                     color: but2.pressed ? "lightblue" : "lightgray"
//                     border.color: "black"
//                     border.width: 1
//                     radius: 0 // Убираем скругление углов
//                 }
//             }

//             Button {
//                 id: but3
//                 text: "Настройки"
//                 Layout.fillWidth: true
//                 onClicked: stackView.replace(thirdPageLoader.item)
//                 font.pixelSize: 48
//                 Layout.preferredWidth: parent.width * 0.30
//                 Layout.preferredHeight: 120
//                 background: Rectangle {
//                     color: but3.pressed ? "lightblue" : "lightgray"
//                     border.color: "black"
//                     border.width: 1
//                     radius: 0 // Убираем скругление углов
//                 }
//             }
//         }
//     }
// }


