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
    // property var barcodesModel: ListModel {
    //             ListElement { barcode: "1234567890123"; quantity: 1 }
    //             ListElement { barcode: "9876543210987"; quantity: 200 }
    //         }

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
                    font.pixelSize: 36//48
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
                        font.pixelSize: 36//40
                    }

                    TextField {
                        id: passField
                        placeholderText: "Пароль"
                        Layout.alignment: Qt.AlignHCenter
                        Layout.preferredWidth: parent.width * 0.8
                        Layout.preferredHeight: 60
                        font.pixelSize: 36//40
                        echoMode: TextInput.Password
                    }


                    Button {
                        id: authButton
                        text: "Авторизация"
                        font.pixelSize: 36//48
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
                    id: workTable
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
                //8) Проверить с изменением высоты квадрата если штрихкод сильно большой.


                TextField {

                    id: field
                    y: 30//200 // Размещение надо будет выбрать
                    anchors.horizontalCenter:  parent.horizontalCenter
                    placeholderText: "Поле ввода:"
                    height: parent.height * 0.1 //100 // И размер поля подредактировать под parent.height * 0.1
                    width: parent.width - 2
                    font.pixelSize: 36//40
                    text: "123129412421"

                    // Здесь просто событие дописываешь по завершению редактирования
                }



                Rectangle {
                        width: parent.width
                        height: parent.height * 0.7
                        color: "transparent"
                        border.color: "black"
                        border.width: 2
                        anchors.centerIn: parent
                        //anchors.topMargin: 10


                        //test

                        TableView {
                                   id: tableView
                                   anchors.fill: parent
                                   model: barcodesData  // Устанавливаем модель данных
                                   columnSpacing: 20
                                   rowSpacing: 10

                                   // Определяем заголовки колонок
                                   TableViewColumn {
                                       role: "barcode"
                                       title: "Штрихкод"
                                       width: parent.width * 0.5
                                   }

                                   TableViewColumn {
                                       role: "quantity"
                                       title: "Количество"
                                       width: 80
                                   }

                                   delegate: Rectangle {
                                       height: 50
                                       border.color: "black"
                                       border.width: 1
                                       color: model.row % 2 == 0 ? "lightgray" : "white"

                                       Row {
                                           spacing: 10
                                           Text {
                                               text: model.barcode
                                               width: tableView.columns[0].width
                                           }
                                           Text {
                                               text: model.quantity
                                               width: tableView.columns[1].width
                                           }
                                       }
                                   }

                                   // Добавление MouseArea для двойного клика
                                   MouseArea {
                                       anchors.fill: parent
                                       onDoubleClicked: {
                                           // Обработка двойного клика
                                           editBarcode = model.barcode
                                           editQuantity = model.quantity
                                           editRowIndex = tableView.selectionModel.currentIndex.row
                                           editDialog.open()
                                       }
                                   }
                               }

                        //test



                        // TableModel{
                        //      id: userTable
                        //      TableModelColumn { display: "barcode"}
                        //      TableModelColumn { display: "quantity" }

                        //      rows:[
                        //          {barcode: "1234567890123", quantity: 1},
                        //          {barcode: "9876543210987", quantity: 43},
                        //          {barcode: "ABCDE#12141241", quantity: 28}
                        //      ]
                        //  }


                        // // Горизонтальный заголовок
                        //         Row {
                        //             width: parent.width
                        //             height: 40
                        //             anchors.top: parent.top
                        //             spacing: 5

                        //             Rectangle {
                        //                 width: parent.width * 0.5
                        //                 height: parent.height
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
                        //                 width: parent.width * 0.5
                        //                 height: parent.height
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

                        // // Горизонтальный заголовок
                        //        HorizontalHeaderView {
                        //            id: horizontalHeader
                        //            anchors.left: tableView.left
                        //            anchors.right: tableView.right
                        //            anchors.top: parent.top
                        //            syncView: tableView
                        //            model: ["Штрихкод", "Количество"]
                        //            delegate: Rectangle {
                        //                width: tableView.columnWidths[index]
                        //                height: 40
                        //                implicitHeight: 40
                        //                 implicitWidth: parent.width * 0.5 //80
                        //                color: "lightgray"
                        //                border.color: "black"
                        //                border.width: 1

                        //                Text {
                        //                    anchors.centerIn: parent
                        //                    text: modelData
                        //                    font.bold: true
                        //                }
                        //            }
                        //        }

                               // // Вертикальный заголовок
                               // VerticalHeaderView {
                               //     id: verticalHeader
                               //     anchors.top: tableView.top
                               //     anchors.bottom: tableView.bottom
                               //     anchors.left: parent.left
                               //     anchors.leftMargin: 10
                               //     syncView: tableView
                               // }

                               // // Основная таблица
                               // TableView {
                               //     id: tableView
                               //     anchors.fill: parent
                               //     anchors.topMargin: 60  // Чтобы не перекрывать заголовок
                               //     model: userTable
                               //     rowSpacing: 10
                               //     columnSpacing: 20

                               //     selectionModel: ItemSelectionModel {}


                               //     delegate: Rectangle {
                               //         anchors.leftMargin: verticalHeader.right + 30

                               //         implicitHeight: 50
                               //         implicitWidth: parent.width * 0.5  //400 // От этого кажется зависит ширина колонок.
                               //         color: row == tableView.currentRow ? "lightgray" : "white"
                               //         border.color: "black"
                               //         border.width: 1

                               //         Text {
                               //             anchors.centerIn: parent
                               //             text: display
                               //         }
                               //     }

                               //      property var columnWidths: [parent.width * 0.5, parent.width * 0.25]  // Устанавливаем начальную ширину колонок

                               //     columnWidthProvider: function(column) {
                               //         // const implicitWidth = implicitColumnWidth(column)
                               //         // if (implicitWidth > columnWidths[column]) return implicitWidth
                               //         return columnWidths[column]
                               //     }



                               //     MouseArea {
                               //                        anchors.fill: parent
                               //                        onDoubleClicked: {
                               //                            // editBarcode = model.barcode
                               //                            // editQuantity = model.quantity
                               //                            // editRowIndex = row
                               //                            editDialog.open()
                               //                        }
                               //                    }

                               // }//tablview

                    }//rectangle


                //test
                Button {
                      text: "Добавить штрихкод"
                      anchors.bottom: parent.bottom
                      onClicked: {
                          barcodesData.addRow("Новый штрихкод", 1)
                      }
                  }

                  property string editBarcode: ""
                  property int editQuantity: 0
                  property int editRowIndex: -1

                  Dialog {
                      id: editDialog
                      title: "Редактировать строку"
                      standardButtons: Dialog.Ok | Dialog.Cancel

                      Column {
                          spacing: 10
                          Label {
                              text: "Штрихкод"
                          }
                          TextField {
                              id: barcodeField
                              text: editBarcode
                          }
                          Label {
                              text: "Количество"
                          }
                          TextField {
                              id: quantityField
                              text: editQuantity.toString()
                              validator: IntValidator { bottom: 0 }
                          }
                      }

                      onAccepted: {
                          if (editRowIndex >= 0) {
                              barcodesData.removeRow(editRowIndex)
                              barcodesData.addRow(barcodeField.text, parseInt(quantityField.text))
                          }
                      }
                  }

                  //test



                // property string editBarcode: ""
                //    property int editQuantity: 0
                //    property int editRowIndex: -1

                //    Dialog {
                //        id: editDialog
                //        anchors.centerIn: parent
                //        title: "Редактировать строку"
                //        standardButtons: Dialog.Ok | Dialog.Cancel

                //        Column {
                //            spacing: 10
                //            Label {
                //                text: "Штрихкод"
                //            }
                //            TextField {
                //                id: barcodeField
                //                text: editBarcode
                //            }
                //            Label {
                //                text: "Количество"
                //            }
                //            TextField {
                //                id: quantityField
                //                text: editQuantity.toString()
                //                validator: IntValidator { bottom: 0 }
                //            }
                //        }

                //        onAccepted: {
                //            if (editRowIndex >= 0) {
                //                userTable.set(editRowIndex, "barcode", barcodeField.text)
                //                userTable.set(editRowIndex, "quantity", parseInt(quantityField.text))
                //            }
                //        }
                //    }



                // Button {
                //     text: "Добавить штрихкод"
                //     scale: 2//3 //build
                //    // anchors.centerIn: parent
                //     anchors.horizontalCenter: parent.horizontalCenter
                //     anchors.bottom: parent.bottom
                //     anchors.bottomMargin: parent.height * 0.1
                //     onClicked: {
                //        addRow(field.text, 1)
                //     }
                // }

                // function addRow(barcode, quantity) {
                //         userTable.appendRow({
                //             barcode: barcode,
                //             quantity: quantity
                //         })
                //     }

                // Здесь на странице надо будет сделать событие установки курсора в поле ввода

            }//page
        }//component

        Component {
            id: thirdPage
            Page {

                ColumnLayout {
                           anchors.fill: parent
                           anchors.margins: 20

                           Label {
                               text: "Настройки программы"
                               font.pixelSize: 32
                               Layout.alignment: Qt.AlignHCenter
                           }

                           TextField {
                               id: urlField
                               placeholderText: "URL"
                               Layout.fillWidth: true
                               text: "http://192.168.1.136/Ihttp/ru_RU/hs/Request/docum"
                           }

                           TextField {
                               id: loginField
                               placeholderText: "Логин"
                               Layout.fillWidth: true
                               text: "Bot"
                           }

                           TextField {
                               id: passwordField
                               placeholderText: "Пароль"
                               echoMode: TextInput.Password
                               Layout.fillWidth: true
                               text: "1234"
                           }

                           TextField {
                               id: licenseKeyField
                               placeholderText: "Лицензионный ключ"
                               Layout.fillWidth: true
                           }

                           Button {
                               text: "Make POST Request"
                               Layout.alignment: Qt.AlignHCenter
                               // onClicked: {
                               //     httpClient.makePostRequest(urlField.text, data);
                               // }
                           }

                           TextArea {
                               id: responseText
                               Layout.fillWidth: true
                               Layout.fillHeight: true
                               readOnly: true
                               placeholderText: "Ответ сервера будет здесь"
                               wrapMode: TextEdit.Wrap
                           }
                       }

                       Connections {
                           target: httpClient
                           function onRequestFinished(response) {
                               responseText.text = response;
                           }
                       }




                // Label {
                //    // id: responseText
                //     text: "Настройки программы"
                //     anchors.horizontalCenter:  parent.horizontalCenter
                //     font.pixelSize: 32
                // }
                // //Необходимо сделать:
                // //1) Поля url
                // //2) Поля с логином паролем
                // //3) Поле для лицензионного ключа
                // //4) Проверку на этот ключ
                // //5) Возможность записи системных настроек в бин файл на устройстве, и его чтение при запуске
                // //6) Лог окно для отладки ошибок.

                // Label {
                //     scale: 2
                //    id: responseText
                //     text: "ответ"
                //     anchors.horizontalCenter:  parent.horizontalCenter
                //     anchors.verticalCenter: parent.verticalCenter
                //     font.pixelSize: 32
                // }
                //        Button {
                //            anchors.topMargin: parent.top + 30
                //            anchors.horizontalCenter: parent.horizontalCenter
                //                    text: "Make POST Request"
                //                    scale: 1.5
                //                    onClicked: {
                //                        // Переписать под userTable.rows
                //                        // Ещё лучше сделать чтобы строки сразу в фиксированной структуре хранились
                //                        // Типа вводишь одиннаковый штрихкод, его количество увеличивается на 1 штуку
                //                        var data = {};
                //                               for (var i = 0; i < barcodesModel.count; i++) {
                //                                   var item = barcodesModel.get(i);
                //                                   data[item.barcode] = item.quantity;
                //                               }
                //                        //httpClient.makeGetRequest("http://192.168.1.138//Bot/ru_RU/hs/bots/ping")
                //                        httpClient.makePostRequest("http://192.168.1.136/Ihttp/ru_RU/hs/Request/docum", data)
                //                    }
                //                }

                // // TextArea {
                // //     id: responseText
                // //     anchors.bottom: parent.bottom
                // //     anchors.horizontalCenter: parent.horizontalCenter
                // //     width: parent.width
                // //     height: parent.height * 0.5
                // //     scale: 1.5
                // //     font.pixelSize: 40
                // //     //readOnly: true
                // //     text: "ababababdbsdbasd"
                // // }

                // Connections {
                //        target: httpClient
                //        function onRequestFinished(response) {
                //            responseText.text = response;
                //        }
                //    }

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
                font.pixelSize: 10//48//24
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
                font.pixelSize: 10//48//24
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
                font.pixelSize: 10//48//24
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
