//My notes:
// Before build apk need replace fontsize in all elements

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.qmlmodels 1.0

ApplicationWindow {
    visible: true
    title: "1Sklad"

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
        }//component first page

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
                //4) Событие для всей формы чтобы курсор всегда стоял на поле ввода
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

                    //События по добавлению штрихкода:
                    onTextChanged: {
                     workTable.text = field.text
                    }

                      onEditingFinished: {
                      field.placeholderText = "После"
                      }

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
                            height: parent.height - 60  // Учитываем высоту горизонтального заголовка
                            anchors.top: parent.top
                            anchors.topMargin: 60  // Отступ сверху для горизонтального заголовка



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
                                anchors.leftMargin: 80  // Учитываем ширину вертикального заголовка
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
                                            if (column === 0) {
                                                return model.barcode
                                            } else if (column === 1) {
                                                return model.quantity
                                            }
                                        }
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        onDoubleClicked: {
                                            editRowIndex = model.row
                                            editBarcode = model.barcode
                                            editQuantity = model.quantity
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
                property int editQuantity: 0
                property int editRowIndex: -1


                Dialog {
                    id: editDialog
                    anchors.centerIn: parent
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
                            text: "Работает как мне надо"
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
                                        barcodesData.set(editRowIndex, barcodeField.text, parseInt(quantityField.text))
                                        editRowIndex = -1
                                        editBarcode = ""
                                        editQuantity = 0
                                        stackView.push(secondPage)
                                    }
                                    editDialog.close()
                                }
                            }

                        }
                    }
                }



                Button {
                    text: "Добавить штрихкод"
                    scale: 2//3 //build
                   // anchors.centerIn: parent
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: parent.height * 0.1
                    onClicked: {
                      barcodesData.addRow(field.text)
                    }
                }

                Button {
                    text: "Отправить в 1С"
                    scale: 2//3 //build
                   // anchors.centerIn: parent
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: parent.height * 0.1
                    onClicked: {
                             httpClient.makePostRequest();

                    }
                }


                // Здесь на странице надо будет сделать событие установки курсора в поле ввода

            }//page
        }//component

        Component {
            id: thirdPage
            Page {


                // Компонент для временного сообщения
                   Popup {
                       id: messagePopup
                       width: parent.width * 0.8
                       height: 50
                       y: parent.height - height - 20
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
                               text: "bot"
                           }

                           TextField {
                               id: passwordField
                               placeholderText: "Пароль"
                               echoMode: TextInput.Password
                               Layout.fillWidth: true
                               text: "12345"
                           }

                           TextField {
                               id: licenseKeyField
                               placeholderText: "Лицензионный ключ"
                               Layout.fillWidth: true
                           }



                           Button {
                               text: "Сохранить настройки"
                               Layout.alignment: Qt.AlignHCenter
                               onClicked: {
                                   settingsHandler.saveSettings(urlField.text, loginField.text, passwordField.text, licenseKeyField.text)
                                    showMessage("Настройки сохранены");
                                   // Загрузка и отображение сохраненных настроек
                                   var savedSettings = settingsHandler.loadSettings();
                                   //responseText.text = savedSettings;

                                   var settingsList = savedSettings.split("\n");
                                   barcodesData.clear(); // Очищаем текущие данные
                                   barcodesData.addRow(settingsList[0]);
                                   barcodesData.addRow(settingsList[1]);
                                   barcodesData.addRow(settingsList[2]);
                                   barcodesData.addRow(settingsList[3]);
                               }
                           }





                           Button {
                               text: "Очистить список"
                               Layout.alignment: Qt.AlignHCenter
                               onClicked: {
                                   confirmClearDialog.open()
                               }
                           }

                           Dialog {
                               id: confirmClearDialog
                               title: "Подтверждение"
                               standardButtons: Dialog.Yes | Dialog.No
                               Column {
                                       width: parent.width
                                       spacing: 10
                                       Text {
                                          // anchors.horizontalCenter: parent.C
                                           text: "Вы уверены, что хотите очистить список штрихкодов?"
                                       }
                                   }

                                   onAccepted: {
                                       barcodesData.clear()
                                   }
                           }

                           TextArea {
                               id: responseText
                               Layout.fillWidth: true
                               Layout.fillHeight: true
                               readOnly: true
                               placeholderText: "Ответ сервера будет здесь"
                               wrapMode: TextEdit.Wrap
                           }
                       }//ColumnLayout

                       Connections {
                           target: httpClient
                           function onRequestFinished(response) {
                               responseText.text = response;
                           }
                       }

            }//page
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


            //Кажется первая страница будет не нужна, надо будет убрать её из проекта
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
