#ifndef BARCODESDATA_H
#define BARCODESDATA_H

#include <QAbstractListModel>
#include <QVector>

// Структура для хранения данных одной строки таблицы
struct BarcodeItem {
    QString barcode;
    int quantity;
};

// Модель данных для хранения и управления списком штрихкодов
class BarcodesData : public QAbstractListModel
{
    Q_OBJECT
public:
    explicit BarcodesData(QObject *parent = nullptr);

    // Количество строк в модели
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    // Данные для определенной строки и роли
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    // Имена ролей для данных
    QHash<int, QByteArray> roleNames() const override;

    // Метод для добавления строки
    Q_INVOKABLE void addRow(const QString &barcode, int quantity);

    // Метод для удаления строки по индексу
    Q_INVOKABLE void removeRow(int index);

    // Метод для очистки всех данных
    Q_INVOKABLE void clear();

private:
    QVector<BarcodeItem> m_data;  // Вектор для хранения данных всех строк
};

#endif // BARCODESDATA_H
