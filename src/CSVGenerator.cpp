#include "CSVGenerator.h"
#include <QFile>
#include <QTextStream>
#include <QStandardPaths>
#include "MessageHistory.h"

CSVGenerator::CSVGenerator(MessageHistory * messageHistory, QObject *parent) : QObject(parent), messageHistory(messageHistory) {}

QString CSVGenerator::generateCSV(BarcodesData *barcodesData) {
    // Получаем путь до папки загрузок
    QString downloadsPath = QStandardPaths::writableLocation(QStandardPaths::DownloadLocation);
    if (downloadsPath.isEmpty()) {
        return "Не удалось получить путь до папки загрузок.";
    }

    QString filePath = "/storage/emulated/0/Download/Штрихкоды.csv"; //downloadsPath + "/barcodes.csv";
    QFile file(filePath);

    // Открываем файл для записи
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {

        messageHistory->addMessage("Ошибка при создании файла: " + filePath);
        emit messageHistory->messagesUpdated();
        return "Не удалось открыть файл для записи.";
    }

    QTextStream out(&file);

    // Записываем штрихкоды в файл
    for (int i = 0; i < barcodesData->rowCount(); ++i) {
        QString barcode = barcodesData->get(i, 0).toString();  // 0 - это колонка штрихкода
        out << barcode << "\n";
    }

    file.close();
    messageHistory->addMessage("Файл успешно создан: " + filePath);
    emit messageHistory->messagesUpdated();
    return "Файл успешно создан";
}
