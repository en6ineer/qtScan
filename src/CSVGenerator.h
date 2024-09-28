#ifndef CSVGENERATOR_H
#define CSVGENERATOR_H

#include <QObject>
#include <QString>
#include "BarcodesData.h"

class CSVGenerator : public QObject {
    Q_OBJECT

public:
    explicit CSVGenerator(QObject *parent = nullptr);

    // Метод для создания CSV-файла с баркодами из BarcodesData
    Q_INVOKABLE QString generateCSV(BarcodesData *barcodesData);
};

#endif // CSVGENERATOR_H
