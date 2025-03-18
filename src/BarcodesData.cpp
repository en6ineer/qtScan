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
    return 3; // Колонки: barcode, quantity и comment
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
    case CommentRole:
        return item.comment;
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
    } else if (section == 2) {
        return "Комментарий";
    }

    return QVariant();
}

QHash<int, QByteArray> BarcodesData::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[BarcodeRole] = "barcode";
    roles[QuantityRole] = "quantity";
    roles[CommentRole] = "comment";
    return roles;
}

void BarcodesData::addRow(const QString &barcode)
{
    // Проверяем, существует ли строка с таким штрихкодом
    for (int i = 0; i < m_data.size(); ++i) {
        if (m_data[i].barcode == barcode) {
            // Если строка найдена, увеличиваем количество
            // m_data[i].quantity += 1; //, int quantity
            // // Уведомляем об изменении данных в строке
            // emit dataChanged(index(i, 0), index(i, 2), {QuantityRole});
            return;
        }
    }

    // Если штрихкод не найден, добавляем новую строку
    beginInsertRows(QModelIndex(), m_data.size(), m_data.size());
    m_data.append({barcode, 1, ""});
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
    if (row < 0 || row >= m_data.size() || column < 0 || column >= 3) {
        return QVariant();
    }

    const BarcodeItem &item = m_data.at(row);

    if (column == 0) {
        return item.barcode;
    } else if (column == 1) {
        return item.quantity;
    } else if (column == 2) {
        return item.comment;
    }

    return QVariant();
}

void BarcodesData::set(int row, const QVariant &barcode, const QVariant &quantity, const QVariant &comment)
{
    // Проверка на корректность номера строки и валидности значений
    if (row < 0 || row >= m_data.size()) {
        return;
    }

    BarcodeItem &item = m_data[row];

    // Обновление данных
    item.barcode = barcode.toString();
    item.quantity = quantity.toInt();
    item.comment = comment.toString();

    // Уведомляем об изменении данных в строке
    emit dataChanged(index(row, 0), index(row, 2), {BarcodeRole, QuantityRole, CommentRole});
}

void BarcodesData::clear()
{
    beginResetModel();
    m_data.clear();
    endResetModel();
}
