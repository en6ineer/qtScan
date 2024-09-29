#ifndef CSVGENERATOR_H
#define CSVGENERATOR_H

#include <QObject>
#include <QString>
#include "BarcodesData.h"
#include "MessageHistory.h"

// Класс для генерации CSV-файлов
class CSVGenerator : public QObject {
    Q_OBJECT

public:
    // Конструктор, принимающий указатель на MessageHistory
    explicit CSVGenerator(MessageHistory *messageHistory, QObject *parent = nullptr);

    // Метод для создания CSV-файла с баркодами из BarcodesData
    Q_INVOKABLE QString generateCSV(BarcodesData *barcodesData);

private:
    MessageHistory *messageHistory;  // Указатель на объект MessageHistory
};

#endif // CSVGENERATOR_H
