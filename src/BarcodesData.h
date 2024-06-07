#ifndef BARCODESDATA_H
#define BARCODESDATA_H

#include <QAbstractTableModel>
#include <QString>
#include <QVector>

// Структура для хранения данных штрихкода и количества
struct BarcodeItem {
    QString barcode;
    int quantity;
};

class BarcodesData : public QAbstractTableModel
{
    Q_OBJECT

public:
    explicit BarcodesData(QObject *parent = nullptr);

    // Переопределение методов из QAbstractTableModel
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    int columnCount(const QModelIndex &parent = QModelIndex()) const override;
   Q_INVOKABLE QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QVariant headerData(int section, Qt::Orientation orientation, int role = Qt::DisplayRole) const override;
    // Методы для управления данными
   Q_INVOKABLE void addRow(const QString &barcode, int quantity);
   Q_INVOKABLE void removeRow(int row);
    Q_INVOKABLE  QVariant get(int row, int column) const;
   Q_INVOKABLE void set(int row, int column, const QVariant &value);
    QHash<int, QByteArray> roleNames() const override; // Метод для определения ролей данных

private:
    QVector<BarcodeItem> m_data;

    // Определение ролей
    enum BarcodeRoles {
        BarcodeRole = Qt::UserRole + 1,
        QuantityRole
    };

};

#endif // BARCODESDATA_H
