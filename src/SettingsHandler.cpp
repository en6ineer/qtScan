#include "SettingsHandler.h"
#include <QFile>
#include <QDataStream>
#include <QStandardPaths>

// Конструктор класса SettingsHandler, инициализирует объект и загружает настройки
SettingsHandler::SettingsHandler(QObject *parent)
    : QObject(parent)
{
    loadSettings();
}

// Метод для получения списка имен баз данных
QStringList SettingsHandler::getDatabaseNames() const {
    return m_databaseNames;
}

// Метод для получения списка имен баз данных
QString SettingsHandler::getPath() const {
     QString filePath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/settings.bin";
    return filePath;
}

// Метод для получения текущей базы данных
Database SettingsHandler::currentDatabase() const {
    return m_currentDatabase;
}

// Метод для установки текущей базы данных
void SettingsHandler::setCurrentDatabase(const Database &db) {
    m_currentDatabase = db;
    emit currentDatabaseChanged();
}

// Метод для установки текущей базы данных по имени
void SettingsHandler::setDatabase(const QString &name) {
    if (m_databases.contains(name)) {
        setCurrentDatabase(m_databases[name]);
        emit currentDatabaseChanged();
    }
}

// Метод для добавления или редактирования базы данных
void SettingsHandler::editDatabase(const QString &name, const QString &login, const QString &password, const QString &url) {
    bool isNewDatabase = !m_databases.contains(name);

    if (isNewDatabase) {
        Database db = {name, url, login, password};
        m_databases[name] = db;
        m_databaseNames.append(name);
    } else {
        Database &db = m_databases[name];
        db.url = url;
        db.login = login;
        db.password = password;
    }

    if (name != m_currentDatabase.name) {
        setCurrentDatabase(m_databases[name]);
        emit currentDatabaseChanged();
    }

    saveDatabases();
    emit databasesChanged();
}

// Метод для загрузки настроек из файлов
void SettingsHandler::loadSettings() {
    // Загрузка баз данных
    QString filePath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/settings.bin";
    QFile basesFile(filePath);
    if (basesFile.open(QIODevice::ReadOnly)) {
        QDataStream in(&basesFile);

        // Загрузка списка имен баз данных
        int dbCount;
        in >> dbCount;
        m_databaseNames.clear();
        for (int i = 0; i < dbCount; ++i) {
            QString dbName;
            in >> dbName;
            m_databaseNames.append(dbName);

            Database db;
            in >> db.name >> db.url >> db.login >> db.password;
            m_databases.insert(dbName, db);
        }

        // Загрузка текущей базы данных
        in >> m_currentDatabase.name >> m_currentDatabase.url >> m_currentDatabase.login >> m_currentDatabase.password;

        basesFile.close();
        emit databasesChanged();
    }
}

// Метод для сохранения баз данных
void SettingsHandler::saveDatabases() {
    QString filePath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/settings.bin";
    QFile basesFile(filePath);
    if (basesFile.open(QIODevice::WriteOnly)) {
        QDataStream out(&basesFile);

        // Сохранение списка имен баз данных
        out << m_databaseNames.size();
        for (const QString &dbName : m_databaseNames) {
            out << dbName;
            const Database &db = m_databases[dbName];
            out << db.name << db.url << db.login << db.password;
        }

        // Сохранение текущей базы данных
        out << m_currentDatabase.name << m_currentDatabase.url << m_currentDatabase.login << m_currentDatabase.password;

        basesFile.close();
    }
}
