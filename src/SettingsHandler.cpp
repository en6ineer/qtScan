#include "SettingsHandler.h"
#include <QFile>
#include <QDataStream>
#include <QStandardPaths>

void SettingsHandler::setupSettings()
{
    // Определение пути к файлу настроек
    QString filePath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/settings.bin";
    QFile file(filePath);
    if (file.open(QIODevice::ReadOnly)) {
        QDataStream in(&file);
        in >> m_url >> m_login >> m_password >> m_licenseKey; // Чтение настроек из файла
        file.close();
    }
}


void SettingsHandler::saveSettings(const QString &url, const QString &login, const QString &password, const QString &licenseKey)
{
    // Определение пути к файлу настроек
    QString filePath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/settings.bin";
    QFile file(filePath);
    if (file.open(QIODevice::WriteOnly)) {
        QDataStream out(&file);
        out << url << login << password << licenseKey; // Сохранение настроек в бинарный файл
        file.close();
    }
}

QString SettingsHandler::loadSettings()
{
    // Определение пути к файлу настроек
    QString filePath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/settings.bin";
    QFile file(filePath);
    if (file.open(QIODevice::ReadOnly)) {
        QDataStream in(&file);
        QString url, login, password, licenseKey;
        in >> url >> login >> password >> licenseKey; // Чтение настроек из файла
        file.close();
        return QString("%1\n%2\n%3\n%4").arg(url, login, password, licenseKey); // Формирование строки с настройками
    }
    return QString();
}
