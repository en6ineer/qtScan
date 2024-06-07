#include "BarcodesData.h"

BarcodesData::BarcodesData(QObject *parent)
    : QAbstractListModel(parent)
{
}

int BarcodesData::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return m_data.count();  // Возвращаем количество строк в модели
}

QVariant BarcodesData::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() >= m_data.count())
        return QVariant();  // Проверяем на корректность индекса

    const BarcodeItem &item = m_data[index.row()];  // Получаем элемент по индексу

    switch (role) {
    case Qt::DisplayRole:
        return QString("%1: %2").arg(item.barcode).arg(item.quantity);  // Возвращаем строку для отображения
    case Qt::UserRole + 1:
        return item.barcode;  // Возвращаем штрихкод
    case Qt::UserRole + 2:
        return item.quantity;  // Возвращаем количество
    default:
        return QVariant();
    }
}

QHash<int, QByteArray> BarcodesData::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[Qt::UserRole + 1] = "barcode";
    roles[Qt::UserRole + 2] = "quantity";
    return roles;  // Возвращаем хэш с именами ролей
}

void BarcodesData::addRow(const QString &barcode, int quantity)
{
    beginInsertRows(QModelIndex(), m_data.count(), m_data.count());  // Уведомляем начало вставки строки
    m_data.append({barcode, quantity});  // Добавляем новый элемент
    endInsertRows();  // Уведомляем окончание вставки строки
}

void BarcodesData::removeRow(int index)
{
    if (index < 0 || index >= m_data.count())
        return;  // Проверяем на корректность индекса

    beginRemoveRows(QModelIndex(), index, index);  // Уведомляем начало удаления строки
    m_data.removeAt(index);  // Удаляем элемент по индексу
    endRemoveRows();  // Уведомляем окончание удаления строки
}

void BarcodesData::clear()
{
    beginResetModel();  // Уведомляем о сбросе модели
    m_data.clear();  // Очищаем все данные
    endResetModel();  // Уведомляем окончание сброса модели
}
