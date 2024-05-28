//My notes:
// Before build apk need replace fontsize in all elements

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    visible: true
    title: "1Sklad"

    property var barcodesModel: ListModel {
            ListElement { barcode: "1234567890123"; quantity: 1 }
            ListElement { barcode: "9876543210987"; quantity: 200 }
        }

    StackView {
        id: stackView
        anchors.fill: parent
        anchors.bottom: navigationBar.top
        initialItem: mainPage

        Component {
            id: mainPage
            Page {

                Label {
                    id: labelMainPage
                    text: "Главная страница"
                    font.bold: true
                    font.pixelSize: 48//36
                    anchors.horizontalCenter: parent.horizontalCenter
                }


                ColumnLayout {
                    anchors.fill: parent
                    //anchors.verticalCenter: parent.verticalCenter
                    anchors.top: parent.top // Привязка к верхней границе окна
                    anchors.horizontalCenter: parent.horizontalCenter // Выравнивание по горизонта
                    spacing: 10

                    // Элементы ввода
                    TextField {
                        placeholderText: "Логин"
                        Layout.alignment: Qt.AlignHCenter
                        Layout.preferredWidth: parent.width * 0.8
                        Layout.preferredHeight: 60
                        font.pixelSize: 40//36
                    }

                    TextField {
                        id: passField
                        placeholderText: "Пароль"
                        Layout.alignment: Qt.AlignHCenter
                        Layout.preferredWidth: parent.width * 0.8
                        Layout.preferredHeight: 60
                        font.pixelSize: 40//36
                        echoMode: TextInput.Password
                    }


                    Button {
                        id: authButton
                        text: "Авторизация"
                        font.pixelSize: 48//36
                        Layout.alignment: Qt.AlignHCenter
                        //Layout.topMargin: passField.bottom
                        Layout.preferredWidth: parent.width * 0.6
                        Layout.preferredHeight: parent.height * 0.1
                    }
                }//columnLayout
            }
        }

        Component {
            id: secondPage
            Page {
                Label {
                    text: "Рабочий стол"
                    anchors.horizontalCenter:  parent.horizontalCenter
                    font.pixelSize: 32
                }




                    ColumnLayout {
                        anchors.fill: parent
                        anchors.top: parent.top // Привязка к верхней границе окна
                        anchors.horizontalCenter: parent.horizontalCenter // Выравнивание по горизонта
                        spacing: 5
                        // Заголовки колонок
                        GridLayout {
                            Layout.topMargin: 100
                            Layout.fillWidth: true
                            columns: 2
                            Rectangle {
                                Layout.fillWidth: true
                                height: 40
                                color: "lightgray"
                                border.color: "black"
                                border.width: 1
                                Text {
                                    anchors.centerIn: parent
                                    text: "Штрихкод"
                                    font.bold: true
                                }
                            }
                            Rectangle {
                                Layout.fillWidth: true
                                height: 40
                                color: "lightgray"
                                border.color: "black"
                                border.width: 1
                                Text {
                                    anchors.centerIn: parent
                                    text: "Количество"
                                    font.bold: true
                                }
                            }
                        }//GridLayout

                        // Таблица
                        ListView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            model: barcodesModel
                            delegate: RowLayout {
                                spacing: 10 // Пространство между колонками
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                Layout.alignment: Qt.AlignRight // Выравниваем по правому краю
                                Rectangle {
                                    Layout.fillWidth: true
                                    height: 40
                                    border.color: "black"
                                    border.width: 1
                                    Text {
                                        //anchors.centerIn: parent
                                        text: model.barcode
                                    }
                                }

                                Rectangle {
                                    Layout.alignment: Qt.AlignRight // Выравниваем по правому краю
                                    Layout.preferredWidth: 100  // Устанавливаем фиксированную ширину для колонки "Количество"
                                    height: 40
                                    border.color: "black"
                                    border.width: 1
                                    Text {
                                        anchors.centerIn: parent
                                        text: model.quantity
                                    }
                                }
                            }
                        }



                        }//ColumnLayout
                    Button {
                        text: "Добавить штрихкод"
                        //Layout.alignment: Qt.AlignHCenter
                        scale: 2
                        anchors.centerIn: parent
                        onClicked: {
                            barcodesModel.append({"barcode": "0000000000000", "quantity": 1})
                        }
                    }

                // ListView {
                //     width: parent.width
                //     height: parent.height
                //     model: ListModel {
                //         ListElement {
                //             barcode: "123456789"
                //             quantity: 10
                //         }
                //         ListElement {
                //             barcode: "987654321"
                //             quantity: 5
                //         }
                //     }

                //     delegate: RowLayout {
                //         spacing: 10
                //         Text {
                //             text: model.barcode
                //             font.pixelSize: 24
                //         }
                //         Text {
                //             text: model.quantity
                //             font.pixelSize: 24
                //         }
                //     }
                // }//ListView

            }
        }

        Component {
            id: thirdPage
            Page {
                Label {
                    id: responseText
                    text: "Настройки программы"
                    anchors.horizontalCenter:  parent.horizontalCenter
                    font.pixelSize: 32
                }


                Column {
                       anchors.fill: parent
                       // TextArea {
                       //     id: responseText
                       //     width: parent.width * 0.5
                       //     height: parent.height * 0.5
                       //     readOnly: true
                       //     text: "ababababdbsdbasd"
                       // }
                       Button {
                                   text: "Make POST Request"
                                   scale: 1.5
                                   onClicked: {
                                       var data = {};
                                              for (var i = 0; i < barcodesModel.count; i++) {
                                                  var item = barcodesModel.get(i);
                                                  data[item.barcode] = item.quantity;
                                              }
                                       //httpClient.makeGetRequest("http://192.168.1.138//Bot/ru_RU/hs/bots/ping")
                                       httpClient.makePostRequest("http://192.168.1.138//Bot/ru_RU/hs/bots/test", data)
                                   }
                               }
                   }

                Connections {
                       target: httpClient
                       function onRequestFinished(response) {
                           responseText.text = response;
                       }
                   }

            }
        }
    }


    Rectangle {
        id: navigationBar
        color: "lightgray"
        width: parent.width
        height: parent.height * 0.05
        anchors.bottom: parent.bottom

        RowLayout {
            anchors.fill: parent
            anchors.margins: 5

            Button {
                id: but1
                text: "Главная"
                Layout.fillWidth: true
                onClicked: stackView.replace(mainPage)
                font.pixelSize: 48//24
                Layout.preferredWidth: parent.width * 0.30
                Layout.preferredHeight: parent.width * 0.10
                background: Rectangle {
                                color: but1.pressed ? "lightblue" : "lightgray"
                                border.color: "black"
                                border.width: 1
                                radius: 0
                            }
            }

            Button {
                id: but2
                text: "Документ"
                Layout.fillWidth: true
                onClicked: stackView.replace(secondPage)
                font.pixelSize: 48//24
                Layout.preferredWidth: parent.width * 0.30
                Layout.preferredHeight: parent.width * 0.10
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
                font.pixelSize: 48//24
                Layout.preferredWidth: parent.width * 0.30
                Layout.preferredHeight: parent.width * 0.10
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



// import QtQuick 2.15
// import QtQuick.Controls 2.15
// import QtQuick.Layouts 1.15

// ApplicationWindow {
//     visible: true
//     width: 400
//     height: 600
//     title: "Штрихкоды и Количество"

//     property var barcodesModel: ListModel {
//         ListElement { barcode: "1234567890123"; quantity: 1 }
//         ListElement { barcode: "9876543210987"; quantity: 2 }
//     }

//     ColumnLayout {
//         anchors.fill: parent
//         spacing: 10

//         // Заголовки колонок
//         GridLayout {
//             Layout.fillWidth: true
//             columns: 2
//             Rectangle {
//                 Layout.fillWidth: true
//                 height: 40
//                 color: "lightgray"
//                 border.color: "black"
//                 border.width: 1
//                 Text {
//                     anchors.centerIn: parent
//                     text: "Штрихкод"
//                     font.bold: true
//                 }
//             }
//             Rectangle {
//                 Layout.fillWidth: true
//                 height: 40
//                 color: "lightgray"
//                 border.color: "black"
//                 border.width: 1
//                 Text {
//                     anchors.centerIn: parent
//                     text: "Количество"
//                     font.bold: true
//                 }
//             }
//         }

//         // Таблица
//         ListView {
//             Layout.fillWidth: true
//             Layout.fillHeight: true
//             model: barcodesModel
//             delegate: RowLayout {
//                 Rectangle {
//                     Layout.fillWidth: true
//                     height: 40
//                     border.color: "black"
//                     border.width: 1
//                     Text {
//                         anchors.centerIn: parent
//                         text: model.barcode
//                     }
//                 }
//                 Rectangle {
//                     Layout.fillWidth: true
//                     height: 40
//                     border.color: "black"
//                     border.width: 1
//                     Text {
//                         anchors.centerIn: parent
//                         text: model.quantity
//                     }
//                 }
//             }
//         }

//         Button {
//             text: "Добавить штрихкод"
//             Layout.alignment: Qt.AlignHCenter
//             onClicked: {
//                 barcodesModel.append({"barcode": "0000000000000", "quantity": 1})
//             }
//         }
//     }
// }
