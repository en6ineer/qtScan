//My notes:
// Before build apk need replace fontsize in all elements

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.qmlmodels 1.0

ApplicationWindow {
    visible: true
    title: "1Sklad"

    // property var barcodesModel: TableModel {
    //         TableModelColumn { display: "barcode" }
    //         TableModelColumn { display: "quantity" }

    //         rows: [
    //             { "barcode": "1234567890123", "quantity": 1 },
    //             { "barcode": "9876543210987", "quantity": 200 }
    //         ]
    //     }
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
                //Необходимо сделать:
                //1) Таблицу содержащую штрихкод количество
                //2) Привязать значение таблицы к структуре которую потом передавать на сервер
                //3) Поле вводе для штрихкода
                //4) Событие для всей формы чтобы курсор всегда стоял на поле ввода
                //5) Событие для изменения количества в таблице, вызов диалога
                //6) Такой же диалог для изменения штрихкода в таблице
                //7) Кнопка отправить в 1С

                ColumnLayout {
                                   anchors.fill: parent
                                   spacing: 10

                                   // Заголовок таблицы
                                   RowLayout {
                                       Layout.fillWidth: true
                                       spacing: 1
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
                                   }

                                   // Таблица
                                   TableView {
                                       Layout.fillWidth: true
                                       Layout.fillHeight: true
                                       columnSpacing: 1
                                       rowSpacing: 1
                                       model: barcodesModel

                                       TableModelColumn { display: "Штрихкод" }
                                       TableModelColumn { display: "Количество" }

                                       delegate: Item {
                                           width: 400
                                           height: 40
                                           implicitHeight: 40
                                           implicitWidth: 400
                                           RowLayout {
                                               Rectangle {
                                                   width: 250
                                                   height: 40
                                                   border.color: "black"
                                                   border.width: 1
                                                   Text {
                                                       anchors.centerIn: parent
                                                       text: model.barcode
                                                   }
                                               }
                                               Rectangle {
                                                   width: 150
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
                                   }

                               }//columnlayout

                Button {
                    text: "Добавить штрихкод"
                    //Layout.alignment: Qt.AlignHCenter
                    anchors.centerIn: parent.Center
                    onClicked: {
                        barcodesModel.append({"barcode": "0000000000000", "quantity": 1})
                    }
                }

            }//page
        }//component

        Component {
            id: thirdPage
            Page {
                Label {
                   // id: responseText
                    text: "Настройки программы"
                    anchors.horizontalCenter:  parent.horizontalCenter
                    font.pixelSize: 32
                }
                //Необходимо сделать:
                //1) Поля url
                //2) Поля с логином паролем
                //3) Поле для лицензионного ключа
                //4) Проверку на этот ключ
                //5) Возможность записи системных настроек в бин файл на устройстве, и его чтение при запуске
                //6) Лог окно для отладки ошибок.

                Label {
                    scale: 2
                   id: responseText
                    text: "ответ"
                    anchors.horizontalCenter:  parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 32
                }
                       Button {
                           anchors.topMargin: parent.top + 30
                           anchors.horizontalCenter: parent.horizontalCenter
                                   text: "Make POST Request"
                                   scale: 1.5
                                   onClicked: {
                                       var data = {};
                                              for (var i = 0; i < barcodesModel.count; i++) {
                                                  var item = barcodesModel.get(i);
                                                  data[item.barcode] = item.quantity;
                                              }
                                       //httpClient.makeGetRequest("http://192.168.1.138//Bot/ru_RU/hs/bots/ping")
                                       httpClient.makePostRequest("http://192.168.1.136/Ihttp/ru_RU/hs/Request/docum", data)
                                   }
                               }

                // TextArea {
                //     id: responseText
                //     anchors.bottom: parent.bottom
                //     anchors.horizontalCenter: parent.horizontalCenter
                //     width: parent.width
                //     height: parent.height * 0.5
                //     scale: 1.5
                //     font.pixelSize: 40
                //     //readOnly: true
                //     text: "ababababdbsdbasd"
                // }

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
