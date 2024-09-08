import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.qmlmodels 1.0

ApplicationWindow {
    visible: true
    title: "1Sklad"


    // Диалоговое окно подтверждения закрытия
       Dialog {
           id: exitDialog
           title: "Подтверждение выхода"
           modal: true
           standardButtons: DialogButtonBox.Yes | DialogButtonBox.No
           visible: false

           onAccepted: {
                       Qt.quit();
                   }

           // onRejected: {
           //     exitDialog.visible = false;
           // }


           contentItem: Column {
               spacing: 10
               Text {
                   text: "Вы уверены, что хотите закрыть приложение?\nСписок штрихкодов будет очищен."
                   wrapMode: Text.Wrap
               }
           }
       }



    StackView {
        id: stackView
        anchors.fill: parent
        anchors.bottom: navigationBar.top
        initialItem: secondPage //mainpage


        Component {
            id: secondPage
            Page {


                TextField {
                    id: field
                    y: 5
                    anchors.horizontalCenter:  parent.horizontalCenter
                    placeholderText: "Поле ввода:"
                    height: parent.height * 0.08
                    width: parent.width
                    font.pixelSize: 28
                    // Отключение экранной клавиатуры не работает
                    inputMethodHints: Qt.ImhNoPredictiveText | Qt.ImhHiddenText
                     // text: "08595026432130" //for debug
                    onFocusChanged: {
                       if (focus) {
                           Qt.inputMethod.hide();
                       }
                   }

                   Keys.onPressed: {
                       if ((event.key === 0 || event.key === 16777220) && field.text != "") {
                           barcodesData.addRow(field.text)
                           field.text = ""
                           event.accepted = true
                       }
                   }
                }


                ComboBox {
                    id: listBases2
                    y: field.height + 25
                    width: parent.width
                    implicitContentWidthPolicy: ComboBox.ContentItemImplicitWidth
                    model: settingsHandler.databaseNames
                    onCurrentTextChanged: {
                        settingsHandler.setDatabase(listBases2.currentText)
                    }

                     Component.onCompleted: {
                        listBases2.currentIndex = settingsHandler.getCurrentIndex();
                     }


                }

                Rectangle {
                        width: parent.width
                        height: parent.height * 0.6 //0.7
                        color: "transparent"
                        border.color: "black"
                        border.width: 2
                        anchors.centerIn: parent
                        anchors.topMargin: 200


                        // Горизонтальный заголовок
                        Row {
                            width: parent.width
                            height: 40
                            anchors.top: parent.top
                            //spacing: 5

                            Rectangle {
                                width: parent.width * 0.5
                                height: parent.height
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
                                width: parent.width * 0.5
                                height: parent.height
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

                        // Основная часть с таблицей и вертикальным заголовком
                        Rectangle {
                            width: parent.width
                            height: parent.height - 60
                            anchors.top: parent.top
                            anchors.topMargin: 60



                            // Вертикальный заголовок
                            VerticalHeaderView {
                                id: verticalHeader
                                anchors.top: tableView.top
                                anchors.bottom: tableView.bottom
                                anchors.left: parent.left
                                anchors.leftMargin: 10
                                syncView: tableView

                                delegate: Rectangle {
                                    width: 50  // Ширина вертикального заголовка
                                    height: 50
                                    implicitHeight: 50
                                    implicitWidth: 50
                                    border.color: "black"
                                    border.width: 1
                                    color: "lightgray"

                                    Text {
                                        anchors.centerIn: parent
                                        text: model.row + 1
                                    }
                                }
                            }

                            // Основная таблица
                            TableView {
                                id: tableView
                                anchors.fill: parent
                                anchors.leftMargin: 75
                                model: barcodesData
                                rowSpacing: 10
                                columnSpacing: 20

                                delegate: Rectangle {
                                    implicitHeight: 50
                                    implicitWidth: parent.width * 0.5
                                    border.color: "black"
                                    border.width: 1

                                    Text {
                                        anchors.centerIn: parent
                                        text: {
                                            wrapMode: Text.Wrap
                                            if (column === 0) {
                                                return model.barcode
                                            } else if (column === 1) {
                                                return model.quantity
                                            }else if (column === 2) {
                                                return model.comment
                                            }
                                        }
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        onDoubleClicked: {
                                            editRowIndex = model.row
                                            editBarcode = model.barcode
                                            editQuantity = model.quantity
                                            editComment = model.comment
                                            editDialog.open()
                                        }
                                    }
                                }

                                property var columnWidths: [parent.width * 0.5, parent.width * 0.25]  // Устанавливаем начальную ширину колонок

                                columnWidthProvider: function(column) {
                                    return columnWidths[column]
                                }
                            }//tableview
                        }



                    }//rectangle


                property string editBarcode: ""
                property string editComment: ""
                property int editQuantity: 0
                property int editRowIndex: -1


                Dialog {
                    id: editDialog
                    x: parent.width / 2 - width / 2 // центр по горизонтали
                    y: 30
                    // Тут наверное лучше сделать закреп выше центра, чтобы клавиатура не перекрывала.
                    title: "Редактировать строку"

                    Column {
                        width: parent.width
                        spacing: 10
                        Label {
                            text: "Штрихкод"
                        }
                        TextField {
                            width: parent.width
                            id: barcodeField
                            text: editBarcode
                        }
                        Label {
                            text: "Количество"
                        }
                        TextField {
                            width: parent.width
                            id: quantityField
                            text: editQuantity.toString()
                            validator: IntValidator { bottom: 0 }
                        }

                        Label {
                            text: "Комментарий"
                        }
                        TextField {
                            width: parent.width
                            id: commentField
                            text: editComment
                        }

                        // Custom buttons panel
                        Row {
                            width: parent.width
                            spacing: 10
                            Button {
                                text: "Удалить"
                                onClicked: {
                                    barcodesData.removeRow(editRowIndex)
                                    editDialog.close()
                                }
                            }

                            Button {
                                text: "Отмена"
                                onClicked: {
                                    editDialog.close()
                                }
                            }

                            Button {
                                text: "ОК"
                                onClicked: {
                                    if (editRowIndex >= 0) {
                                        barcodesData.set(editRowIndex, barcodeField.text, parseInt(quantityField.text), commentField.text)
                                        editRowIndex = -1
                                        editBarcode = ""
                                        editQuantity = 0
                                        editComment = ""
                                    }
                                    editDialog.close()
                                }
                            }

                        }
                    }
                }


                // Button {
                //     text: "Добавить штрихкод"
                //     scale: 2//3 //build
                //     anchors.horizontalCenter: parent.horizontalCenter
                //     anchors.bottom: parent.bottom
                //     anchors.bottomMargin: parent.height * 0.1
                //     onClicked: {
                //       barcodesData.addRow(field.text)
                //         field.text = "7613326027588"
                //     }
                // }

                Button {
                    text: "Отправить в 1С"
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: parent.height * 0.1
                    onClicked: {
                        if(listBases2.currentIndex == -1){
                        showMessage("Не выбран документ!")
                        //тут же бахнем проверку на ключ лицензии.
                        }else if(barcodesData.rowCount() !== 0)
                        {
                          httpClient.makePostRequest();
                        }else{
                            showMessage("Список штрихкодов пуст!")
                        }
                    }
                }


                // Компонент для временного сообщения
                   Popup {
                       id: messagePopup
                       width: parent.width
                       height: 50
                       y: parent.height - height - 20
                       x: parent.width * 0.5 - (width * 0.5)
                       visible: false
                       focus: true
                       closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
                       onClosed: visible = false

                       Rectangle {
                           anchors.fill: parent
                           color: "lightgray"
                           border.color: "black"
                           radius: 10

                           Text {
                               id: messageText
                               anchors.centerIn: parent
                               text: ""
                               font.pixelSize: 24
                               color: "black"
                           }
                       }
                   }

                   // Функция для отображения сообщения
                   function showMessage(text) {
                       messageText.text = text;
                       messagePopup.open();
                       Qt.createQmlObject('import QtQuick 2.0; Timer { interval: 3000; running: true; repeat: false; onTriggered: messagePopup.close(); }', messagePopup);
                   }

                   Connections {
                           target: httpClient
                           onRequestFinished: {
                               showMessage(response)
                           }
                       }

                   Component.onCompleted: {
                                   field.forceActiveFocus()
                               }


            }//page
        }//component

        Component {
            id: thirdPage
            Page {

                // Компонент для временного сообщения
                   Popup {
                       id: messagePopup
                       width: parent.width * 0.5
                       height: 50
                       y: parent.height - height - 20
                       x: parent.width * 0.5 - (width * 0.5)
                       visible: false
                       focus: true
                       closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
                       onClosed: visible = false

                       Rectangle {
                           anchors.fill: parent
                           color: "lightgray"
                           border.color: "black"
                           radius: 10

                           Text {
                               id: messageText
                               anchors.centerIn: parent
                               text: ""
                               font.pixelSize: 20
                               color: "black"
                           }
                       }
                   }

                   // Функция для отображения сообщения
                   function showMessage(text) {
                       messageText.text = text;
                       messagePopup.open();
                       Qt.createQmlObject('import QtQuick 2.0; Timer { interval: 3000; running: true; repeat: false; onTriggered: messagePopup.close(); }', messagePopup);
                   }




                   Dialog {
                       id: editBase
                       x: parent.width / 2 - width / 2
                       y: 20
                       // Тут наверное лучше сделать закреп выше центра, чтобы клавиатура не перекрывала.
                       title: "Редактирование базы"

                       onOpened: {
                           var savedSettings = settingsHandler.getSettings();
                                   if(savedSettings === ""){
                                       showMessage("Не обнаружены настройки!")
                                   }else{
                                       var settingsList = savedSettings.split("\n");
                                       baseName.text = settingsList[0];
                                       login.text = settingsList[1];
                                       pass.text = settingsList[2];
                                       rootUrl.text = settingsList[3];
                                   }
                         }


                       Column {
                           width: parent.width
                           spacing: 10

                           Label {
                               text: "Название:"
                           }

                           TextField {
                               width: parent.width
                               id: baseName
                               //text: "Склад"
                           }

                           Label {
                               text: "Корневой URL:"
                           }

                           TextField {
                               width: parent.width
                               id: rootUrl
                               // text: "http://192.168.1.136/bolnica/hs/tsd/prihod"
                           }

                           Label {
                               text: "Логин:"
                           }

                           TextField {
                               width: parent.width
                               id: login
                               // text: "bot"
                           }

                           Label {
                               text: "Пароль:"
                           }

                           TextField {
                               width: parent.width
                               id: pass
                               // text: "0000" //"12345"
                               echoMode: TextInput.Password
                           }


                           Row {
                               width: parent.width
                               spacing: 10

                               Button {
                                   text: "Удалить"
                                   onClicked: {
                                       settingsHandler.removeBase(baseName.text)
                                       listBases.currentIndex = -1
                                       editBase.close()
                                   }
                               }

                               Button {
                                   text: "Отмена"
                                   onClicked: {
                                       editBase.close()
                                   }
                               }

                               Button {
                                   text: "ОК"
                                   onClicked: {
                                       //if (true) { //Если поля заполнены тогда добавляем/изменяем метод
                                       settingsHandler.editDatabase(baseName.text, login.text, pass.text, rootUrl.text)
                                       //}
                                       // listBases.currentIndex = -1 //settingsHandler.getCurrentIndex()
                                       editBase.close()
                                   }
                               }

                           }//Row
                       }//Column
                   }//DialogBase





                    ColumnLayout {
                           anchors.fill: parent
                           anchors.margins: 20
                           anchors.leftMargin: 20
                           anchors.topMargin: 20
                            width: parent.width
                            spacing: 2

                              Label {
                                  text: "Список документов:"
                                  font.pixelSize: 26
                              }


                              ComboBox {
                                  id: listBases
                                  width: 300
                                  implicitContentWidthPolicy: ComboBox.ContentItemImplicitWidth
                                  model: settingsHandler.databaseNames
                                  onCurrentTextChanged: {
                                      settingsHandler.setDatabase(listBases.currentText)
                                  }

                                  Component.onCompleted: {
                                     listBases.currentIndex = settingsHandler.getCurrentIndex();
                                  }
                              }


                              Button {
                                  text: "Редактировать"
                                  onClicked: {
                                     editBase.open()
                                  }
                              }



                           Button {
                               text: "Очистить список"
                               Layout.alignment: Qt.AlignHCenter
                               onClicked: {
                                   confirmClearDialog.open()
                               }
                           }


                           ScrollView {
                                       Layout.fillWidth: true
                                       Layout.fillHeight: true
                                       TextArea {
                                           id: textArea
                                           readOnly: true
                                           visible: false
                                           placeholderText: "Вывод информации"
                                           wrapMode: TextEdit.Wrap
                                       }
                                   }




                    }//ColumnLayout

                           Dialog {
                               anchors.centerIn: parent
                               id: confirmClearDialog
                               title: "Подтверждение"
                               standardButtons: Dialog.Yes | Dialog.No
                               Column {
                                       width: parent.width - 10
                                       spacing: 10
                                       Text {
                                           width: parent.width
                                           text: "Вы уверены, что хотите очистить список штрихкодов?"
                                           wrapMode: Text.Wrap
                                           // Если нужно задать максимальную ширину текста, можно использовать width:
                                           // width: myDialog.width * 0.9
                                       }
                                   }

                                   onAccepted: {
                                       barcodesData.clear()
                                   }
                           }

            }//page
        }
    }//StackView



    // Компонент для временного сообщения
       Popup {
           id: messagePopup
           width: parent.width * 0.8
           height: 50
           y: parent.height - height - 20
           x: parent.width * 0.5 - (width * 0.5)
           visible: false
           focus: true
           closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
           onClosed: visible = false

           Rectangle {
               anchors.fill: parent
               color: "lightgray"
               border.color: "black"
               radius: 10

               Text {
                   id: messageText
                   anchors.centerIn: parent
                   text: ""
                   font.pixelSize: 26 //20
                   color: "black"
               }
           }
       }

       // Функция для отображения сообщения
       function showMessage(text) {
           messageText.text = text;
           messagePopup.open();
           Qt.createQmlObject('import QtQuick 2.0; Timer { interval: 3000; running: true; repeat: false; onTriggered: messagePopup.close(); }', messagePopup);
       }



    Rectangle {
        id: navigationBar
        color: "lightgray"
        width: parent.width
        height: parent.height * 0.08
        anchors.bottom: parent.bottom

        RowLayout {
            anchors.fill: parent
            anchors.margins: 5

            Button {
                id: but2
                text: "Документ"
                Layout.fillWidth: true
                onClicked: stackView.replace(secondPage)
                font.pixelSize: 24//48//24
                Layout.preferredWidth: parent.width * 0.45
                Layout.preferredHeight: parent.height * 0.90
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
                font.pixelSize: 24//48//24
                Layout.preferredWidth: parent.width * 0.45//30
                Layout.preferredHeight: parent.height * 0.90//10
                background: Rectangle {
                                color: but3.pressed ? "lightblue" : "lightgray"
                                border.color: "black"
                                border.width: 1
                                radius: 0
                            }
            }
        }//RowLayout
    }//Rectangle
}//ApplicationWindow
