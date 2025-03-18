import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.qmlmodels 1.0

ApplicationWindow {
    visible: true
    title: "1Sklad"

     property string feedback: ""
    // Определение базового размера для масштабирования
    property real baseWidth: 480
    property real baseHeight: 764
    property real scaleFactor: Math.min(width / baseWidth, height / baseHeight)
    //license:
    property bool licuha : settingsHandler.getKeyLicense();

    // Диалоговое окно подтверждения закрытия
    Dialog {
        id: exitDialog
        title: "Подтверждение выхода"
        modal: true
        standardButtons: DialogButtonBox.Yes | DialogButtonBox.No
        visible: false
        width: parent.width * 0.8
        height: parent.height * 0.2

        onAccepted: {
            Qt.quit();
        }

        contentItem: Column {
            spacing: 10 * scaleFactor
            Text {
                text: "Вы уверены, что хотите закрыть приложение?\nСписок штрихкодов будет очищен."
                wrapMode: Text.Wrap
                font.pixelSize: 16 * scaleFactor
            }
        }
    }

    StackView {
        id: stackView
        anchors.fill: parent
        anchors.bottom: navigationBar.top
        initialItem: secondPage

        Component {
            id: secondPage
            Page {
                TextField {
                    id: field
                    y: parent.height * 0.01
                    anchors.horizontalCenter: parent.horizontalCenter
                    placeholderText: "Поле ввода:"
                    height: parent.height * 0.08
                    width: parent.width * 0.9
                    font.pixelSize: 28 * scaleFactor
                    inputMethodHints: Qt.ImhNoPredictiveText | Qt.ImhHiddenText

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

                // Button {
                //     id: submitButton
                //     y: field.y * 2

                //     anchors.right: parent.right
                //      anchors.rightMargin: 25
                //     text: "->"
                //     height: field.height * 0.5
                //     width: field.width * 0.2
                //     font.pixelSize: 14 * scaleFactor
                //     onClicked: {
                //         if (field.text != "") {
                //             barcodesData.addRow(field.text)
                //             field.text = ""
                //         }
                //     }
                // }

                ComboBox {
                    id: listBases2
                    y: field.y + field.height + parent.height * 0.03
                    width: parent.width * 0.9
                    height: parent.height * 0.05
                    anchors.horizontalCenter: parent.horizontalCenter
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
                    width: parent.width * 0.95
                    height: parent.height * 0.6
                    color: "transparent"
                    border.color: "black"
                    border.width: 2 * scaleFactor
                    anchors.centerIn: parent
                    anchors.topMargin: parent.height * 0.25 + 5

                    // Горизонтальный заголовок
                    Row {
                        width: parent.width
                        height: parent.height * 0.1
                        anchors.top: parent.top

                        Rectangle {
                            width: parent.width * 0.5
                            height: parent.height
                            color: "lightgray"
                            border.color: "black"
                            border.width: 1 * scaleFactor

                            Text {
                                anchors.centerIn: parent
                                text: "Штрихкод"
                                font.bold: true
                                font.pixelSize: 16 * scaleFactor
                            }
                        }

                        Rectangle {
                            width: parent.width * 0.5
                            height: parent.height
                            color: "lightgray"
                            border.color: "black"
                            border.width: 1 * scaleFactor

                            Text {
                                anchors.centerIn: parent
                                text: "Количество"
                                font.bold: true
                                font.pixelSize: 16 * scaleFactor
                            }
                        }
                    }

                    // Основная часть с таблицей и вертикальным заголовком
                    Rectangle {
                        width: parent.width
                        height: parent.height * 0.9
                        anchors.top: parent.top
                        anchors.topMargin: parent.height * 0.1

                        // Вертикальный заголовок
                        VerticalHeaderView {
                            id: verticalHeader
                            anchors.top: tableView.top
                            anchors.bottom: tableView.bottom
                            anchors.left: parent.left
                            anchors.leftMargin: parent.width * 0.02
                            syncView: tableView

                            delegate: Rectangle {
                                width: parent.width * 0.15
                                height: 50 * scaleFactor
                                implicitHeight: 50 * scaleFactor
                                implicitWidth: parent.width * 0.15
                                border.color: "black"
                                border.width: 1 * scaleFactor
                                color: "lightgray"

                                Text {
                                    anchors.centerIn: parent
                                    text: model.row + 1
                                    font.pixelSize: 14 * scaleFactor
                                }
                            }
                        }

                        // Основная таблица
                        TableView {
                            id: tableView
                            anchors.fill: parent
                            anchors.leftMargin: parent.width * 0.18
                            model: barcodesData
                            rowSpacing: 10 * scaleFactor
                            columnSpacing: 20 * scaleFactor

                            delegate: Rectangle {
                                implicitHeight: 50 * scaleFactor
                                implicitWidth: parent.width * 0.5
                                border.color: "black"
                                border.width: 1 * scaleFactor

                                Text {
                                    anchors.fill: parent
                                    anchors.margins: 5 * scaleFactor
                                    text: {
                                        wrapMode: Text.Wrap
                                        if (column === 0) {
                                            return model.barcode
                                        } else if (column === 1) {
                                            return model.quantity
                                        } else if (column === 2) {
                                            return model.comment
                                        }
                                    }
                                    wrapMode: Text.Wrap  // Перенос текста на новую строку
                                    font.pixelSize: 14 * scaleFactor
                                    horizontalAlignment: Text.AlignLeft  // Выравнивание текста по левому краю
                                    verticalAlignment: Text.AlignVCenter  // Вертикальное выравнивание текста по центру
                                    elide: Text.ElideNone  // Отключение усечения текста с многоточием
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

                            property var columnWidths: [parent.width * 0.5, parent.width * 0.25]

                            columnWidthProvider: function(column) {
                                return columnWidths[column]
                            }
                        }
                    }
                }

                property string editBarcode: ""
                property string editComment: ""
                property int editQuantity: 0
                property int editRowIndex: -1

                Dialog {
                    id: editDialog
                    x: parent.width / 2 - width / 2
                    y: parent.height * 0.05
                    width: parent.width * 0.9
                    height: parent.height * 0.6
                    title: "Редактировать строку"

                    Column {
                        width: parent.width
                        spacing: 10 * scaleFactor
                        Label {
                            text: "Штрихкод"
                            font.pixelSize: 16 * scaleFactor
                        }
                        TextField {
                            width: parent.width
                            id: barcodeField
                            text: editBarcode
                            font.pixelSize: 14 * scaleFactor
                        }
                        Label {
                            text: "Количество"
                            font.pixelSize: 16 * scaleFactor
                        }
                        TextField {
                            width: parent.width
                            id: quantityField
                            text: editQuantity.toString()
                            validator: IntValidator { bottom: 0 }
                            font.pixelSize: 14 * scaleFactor
                        }

                        Label {
                            text: "Комментарий"
                            font.pixelSize: 16 * scaleFactor
                        }
                        TextField {
                            width: parent.width
                            id: commentField
                            text: editComment
                            font.pixelSize: 14 * scaleFactor
                        }

                        // Custom buttons panel
                        Row {
                            width: parent.width
                            spacing: 10 * scaleFactor
                            Button {
                                text: "Удалить"
                                onClicked: {
                                    barcodesData.removeRow(editRowIndex)
                                    editDialog.close()
                                }
                                font.pixelSize: 14 * scaleFactor
                            }

                            Button {
                                text: "Отмена"
                                onClicked: {
                                    editDialog.close()
                                }
                                font.pixelSize: 14 * scaleFactor
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
                                font.pixelSize: 14 * scaleFactor
                            }
                        }
                    }
                }

                RowLayout {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: parent.height * 0.1
                    width: parent.width * 0.8 // Ширина, чтобы разместить две кнопки по 40% каждая
                    height: parent.height * 0.06
                    spacing: 10 * scaleFactor // Расстояние между кнопками, масштабируемое

                    Button {
                        text: "Отправить в 1С"
                        Layout.fillWidth: true
                        height: parent.height
                        visible: licuha
                        font.pixelSize: 16 * scaleFactor
                        onClicked: {
                           // barcodesData.addRow("4870002732201")
                            // var result = license.insertValueToSheet()
                            // showMessage(result)

                            // if(listBases2.currentIndex == -1){
                            //     showMessage("Не выбран документ!")
                            // } else if(barcodesData.rowCount() !== 0) {
                            //     httpClient.makePostRequest();
                            // } else {
                            //     showMessage("Список штрихкодов пуст!")
                            // }
                        }
                    }

                    Button {
                        text: "Сохранить в файл"
                        Layout.fillWidth: true
                        height: parent.height
                        visible: licuha
                        font.pixelSize: 16 * scaleFactor
                        onClicked: {
                            //Delete before build:
                            // if (field.text != ""){
                            // barcodesData.addRow(field.text)
                            // field.text = ""
                            // }
                            //
                            // if(barcodesData.rowCount() !== 0) {
                            //     var result = csvGenerator.generateCSV(barcodesData)
                            //     showMessage(result)
                            // } else {
                            //     showMessage("Список штрихкодов пуст!")
                            // }


                        }
                    }
                }


                // Компонент для временного сообщения
                Popup {
                    id: messagePopup
                    width: parent.width * 0.9
                    height: parent.height * 0.08
                    y: parent.height - height - parent.height * 0.03
                    x: parent.width * 0.5 - (width * 0.5)
                    visible: false
                    focus: true
                    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
                    onClosed: visible = false

                    Rectangle {
                        anchors.fill: parent
                        color: "lightgray"
                        border.color: "black"
                        radius: 10 * scaleFactor

                        Text {
                            id: messageText
                            anchors.centerIn: parent
                            text: ""
                            font.pixelSize: 24 * scaleFactor
                            color: "black"
                        }
                    }
                }

                // Функция для отображения сообщения
                function showMessage(text) {
                    messageText.text = text;
                    messagePopup.open();//                                    3000
                    Qt.createQmlObject('import QtQuick 2.0; Timer { interval: 6000; running: true; repeat: false; onTriggered: messagePopup.close(); }', messagePopup);
                }

                Connections {
                    target: httpClient
                    onRequestFinished: {
                        showMessage(response)
                        feedback = feedback + response + "/n"

                    }
                }
            }
        }


        Component {
            id: thirdPage

            Page {
                // Компонент для временного сообщения
                Popup {
                    id: messagePopup
                    width: parent.width * 0.5
                    height: parent.height * 0.08
                    y: parent.height - height - parent.height * 0.03
                    x: parent.width * 0.5 - (width * 0.5)
                    visible: false
                    focus: true
                    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
                    onClosed: visible = false

                    Rectangle {
                        anchors.fill: parent
                        color: "lightgray"
                        border.color: "black"
                        radius: 10 * scaleFactor

                        Text {
                            id: messageText
                            anchors.centerIn: parent
                            text: ""
                            font.pixelSize: 20 * scaleFactor
                            color: "black"
                        }
                    }
                }

                // Функция для отображения сообщения
                function showMessage(text) {
                    messageText.text = text;
                    messagePopup.open();//                                    3000
                    Qt.createQmlObject('import QtQuick 2.0; Timer { interval: 6000; running: true; repeat: false; onTriggered: messagePopup.close(); }', messagePopup);
                }

                Dialog {
                    id: editBase
                    x: parent.width / 2 - width / 2
                    y: parent.height * 0.05
                    width: parent.width * 0.9
                    height: parent.height * 0.7
                    title: "Редактирование документа"

                    // Добавляем свойство для масштабирования шрифта
                    property real fontScaleFactor: scaleFactor * 1.0

                    onOpened: {
                        var savedSettings = settingsHandler.getSettings();
                        if(savedSettings === ""){
                            showMessage("Не обнаружены настройки!")
                        } else {
                            var settingsList = savedSettings.split("\n");
                            baseName.text = settingsList[0];
                            login.text = settingsList[1];
                            pass.text = settingsList[2];
                            rootUrl.text = settingsList[3];
                        }
                    }

                    Column {
                        width: parent.width
                        spacing: 10 * scaleFactor

                        Label {
                            text: "Название:"
                            font.pixelSize: 26 * scaleFactor
                        }
                        TextField {
                            width: parent.width * 0.9
                            height: 40 * scaleFactor
                            id: baseName
                            font.pixelSize: 26 * scaleFactor
                        }

                        Label {
                            text: "Корневой URL:"
                            font.pixelSize: 26 * scaleFactor
                        }
                        TextField {
                            width: parent.width * 0.9
                            height: 40 * scaleFactor
                            id: rootUrl
                            font.pixelSize: 26 * scaleFactor
                        }

                        Label {
                            text: "Логин:"
                            font.pixelSize: 26 * scaleFactor
                        }
                        TextField {
                            width: parent.width * 0.9
                            height: 40 * scaleFactor
                            id: login
                            font.pixelSize: 26 * scaleFactor
                        }

                        Label {
                            text: "Пароль:"
                            font.pixelSize: 26 * scaleFactor
                        }
                        TextField {
                            width: parent.width * 0.9
                            height: 40 * scaleFactor
                            id: pass
                            echoMode: TextInput.Password
                            font.pixelSize: 26 * scaleFactor
                        }

                        Row {
                            width: parent.width
                            spacing: 10 * scaleFactor
                            //layoutDirection: Qt.RightToLeft  // Кнопки будут справа налево

                            Button {
                                text: "ОК"
                                width: 100 * scaleFactor
                                height: 40 * scaleFactor
                                font.pixelSize: 26 * scaleFactor
                                onClicked: {
                                    settingsHandler.editDatabase(baseName.text, login.text, pass.text, rootUrl.text)
                                    editBase.close()
                                }
                            }

                            Button {
                                text: "Отмена"
                                width: 100 * scaleFactor
                                height: 40 * scaleFactor
                                font.pixelSize: 26 * scaleFactor
                                onClicked: {
                                    editBase.close()
                                }
                            }

                            Button {
                                text: "Удалить"
                                width: 100 * scaleFactor
                                height: 40 * scaleFactor
                                font.pixelSize: 26 * scaleFactor
                                onClicked: {
                                    settingsHandler.removeBase(baseName.text)
                                    listBases.currentIndex = -1
                                    editBase.close()
                                }
                            }
                        }
                    }
                }//Dialog



       //Here was scrollview
               // Item{

                    Label {
                        text: "Список документов:"
                        font.pixelSize: 26 * scaleFactor
                    }

                    ComboBox {
                        id: listBases
                        y: parent.height * 0.05
                        width: parent.width //* 0.8 * scaleFactor
                        height: parent.height * 0.05
                        implicitContentWidthPolicy: ComboBox.ContentItemImplicitWidth
                        model: settingsHandler.databaseNames
                        onCurrentTextChanged: {
                            settingsHandler.setDatabase(listBases.currentText)
                        }

                        Component.onCompleted: {
                            listBases.currentIndex = settingsHandler.getCurrentIndex();
                        }
                    }

                //}//Item

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.top: listBases.bottom
                        anchors.topMargin: listBases.y + parent.height * 0.08 * scaleFactor
                        anchors.margins: 20 * scaleFactor
                        width: parent.width
                        spacing: 10 * scaleFactor
                        id: firstcolumn

                        // Добавляем Row для кнопок в одну строку
                        RowLayout {
                            spacing: 10 * scaleFactor
                            Layout.fillWidth: true

                            Button {
                                text: "Редактировать"
                                id: editBut
                                Layout.preferredHeight: 40 * scaleFactor
                                Layout.preferredWidth: 140 * scaleFactor
                                font.pixelSize: 14 * scaleFactor
                                onClicked: {
                                    editBase.open()
                                }
                            }

                            Button {
                                text: "Очистить список"
                                Layout.preferredHeight: 40 * scaleFactor
                                Layout.preferredWidth: 140 * scaleFactor
                                font.pixelSize: 14 * scaleFactor
                                onClicked: {
                                    confirmClearDialog.open()
                                }
                            }
                        }

                        // Добавляем небольшой отступ перед следующей секцией
                        Item {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 20 * scaleFactor
                        }

                        // Лицензионная секция
                        Label {
                            text: "Ключ лицензии:"
                            font.pixelSize: 20 * scaleFactor
                            Layout.alignment: Qt.AlignLeft
                            visible: !licuha
                        }

                        TextField {
                            id: license
                            Layout.preferredWidth: parent.width * 0.9
                            Layout.preferredHeight: 40 * scaleFactor
                            font.pixelSize: 20 * scaleFactor
                            Layout.alignment: Qt.AlignLeft
                            visible: !licuha
                        }

                        Button {
                            text: "Получить лицензию"
                            Layout.preferredHeight: 40 * scaleFactor
                            Layout.preferredWidth: 180 * scaleFactor
                            font.pixelSize: 14 * scaleFactor
                            Layout.alignment: Qt.AlignLeft
                            visible: !licuha
                             onClicked: {
                               result = settingsHandler.setKeyLicense(license.text)
                                if(result){
                                    showMessage("Лицензия активирована!")
                                }else
                                {
                                    showMessage("Неверный ключ!")
                                }
                             }

                        }

                        // Добавляем растягивающийся элемент, чтобы все остальные элементы были сверху
                        Item {
                            Layout.fillHeight: true
                        }
                    }


                        Dialog {
                            anchors.centerIn: parent
                            id: confirmClearDialog
                            title: "Подтверждение"
                            standardButtons: Dialog.Yes | Dialog.No
                            Column {
                                width: parent.width * 0.9
                                spacing: 10 * scaleFactor
                                Text {
                                    width: parent.width
                                    text: "Вы уверены, что хотите очистить список штрихкодов?"
                                    wrapMode: Text.Wrap
                                }
                            }

                            onAccepted: {
                                barcodesData.clear()
                            }
                        }

            }//page
                 }//Component

             }//StackView

                        Popup {
                            id: messagePopup
                            width: parent.width * 0.9 //* scaleFactor
                            height: 50 * scaleFactor
                            y: parent.height - height - 20 * scaleFactor
                            x: parent.width * 0.5 - (width * 0.5) * scaleFactor
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
                                    font.pixelSize: 26 //* scaleFactor
                                    color: "black"
                                }
                            }
                        }

                        function showMessage(text) {
                            messageText.text = text;
                            messagePopup.open(); //                                   3000
                            Qt.createQmlObject('import QtQuick 2.0; Timer { interval: 6000; running: true; repeat: false; onTriggered: messagePopup.close(); }', messagePopup);
                        }

                        Rectangle {
                            id: navigationBar
                            color: "lightgray"
                            width: parent.width
                            height: parent.height * 0.08
                            anchors.bottom: parent.bottom

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 5 * scaleFactor

                                Button {
                                    id: but2
                                    text: "Документ"
                                    Layout.fillWidth: true
                                    onClicked: stackView.replace(secondPage)
                                    font.pixelSize: 24 * scaleFactor
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
                                    font.pixelSize: 24 * scaleFactor
                                    Layout.preferredWidth: parent.width * 0.45
                                    Layout.preferredHeight: parent.height * 0.90
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
