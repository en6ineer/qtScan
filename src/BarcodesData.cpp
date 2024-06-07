#include "BarcodesData.h"

BarcodesData::BarcodesData(QObject *parent)
    : QAbstractTableModel(parent)
{
}

int BarcodesData::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return m_data.count();
}

int BarcodesData::columnCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return 2; // Колонки: barcode и quantity
}

QVariant BarcodesData::data(const QModelIndex &index, int role) const
{
    if (!index.isValid()) {
        return QVariant();
    }

    const BarcodeItem &item = m_data.at(index.row());

    switch (role) {
    case BarcodeRole:
        return item.barcode;
    case QuantityRole:
        return item.quantity;
    default:
        return QVariant();
    }
}

QVariant BarcodesData::headerData(int section, Qt::Orientation orientation, int role) const
{
    if (role != Qt::DisplayRole || orientation != Qt::Horizontal) {
        return QVariant();
    }

    if (section == 0) {
        return "Штрихкод";
    } else if (section == 1) {
        return "Количество";
    }

    return QVariant();
}

QHash<int, QByteArray> BarcodesData::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[BarcodeRole] = "barcode";
    roles[QuantityRole] = "quantity";
    return roles;
}

void BarcodesData::addRow(const QString &barcode, int quantity)
{
    beginInsertRows(QModelIndex(), m_data.size(), m_data.size());
    m_data.append({barcode, quantity});
    endInsertRows();
}

void BarcodesData::removeRow(int row)
{
    if (row < 0 || row >= m_data.size()) {
        return;
    }
    beginRemoveRows(QModelIndex(), row, row);
    m_data.removeAt(row);
    endRemoveRows();
}

QVariant BarcodesData::get(int row, int column) const
{
    if (row < 0 || row >= m_data.size() || column < 0 || column >= 2) {
        return QVariant();
    }

    const BarcodeItem &item = m_data.at(row);

    if (column == 0) {
        return item.barcode;
    } else if (column == 1) {
        return item.quantity;
    }

    return QVariant();
}

void BarcodesData::set(int row, int column, const QVariant &value)
{
    if (row < 0 || row >= m_data.size() || column < 0 || column >= 2) {
        return;
    }

    BarcodeItem &item = m_data[row];

    if (column == 0) {
        item.barcode = value.toString();
    } else if (column == 1) {
        item.quantity = value.toInt();
    }

    emit dataChanged(index(row, column), index(row, column), {Qt::DisplayRole});
}
