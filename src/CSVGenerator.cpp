#include "CSVGenerator.h"
#include <QFile>
#include <QTextStream>
#include <QStandardPaths>

CSVGenerator::CSVGenerator(QObject *parent) : QObject(parent) {}

QString CSVGenerator::generateCSV(BarcodesData *barcodesData) {
    // Получаем путь до папки загрузок
    QString downloadsPath = QStandardPaths::writableLocation(QStandardPaths::DownloadLocation);
    if (downloadsPath.isEmpty()) {
        return "Не удалось получить путь до папки загрузок.";
    }

    QString filePath = downloadsPath + "/barcodes.csv";
    QFile file(filePath);

    // Открываем файл для записи
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        return "Не удалось открыть файл для записи.";
    }

    QTextStream out(&file);

    // Записываем штрихкоды в файл
    for (int i = 0; i < barcodesData->rowCount(); ++i) {
        QString barcode = barcodesData->get(i, 0).toString();  // 0 - это колонка штрихкода
        out << barcode << "\n";
    }

    file.close();
    return "Файл успешно создан: " + filePath;
}
