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

QString SettingsHandler::logMessages() const {
    return m_logMessages;
}

void SettingsHandler::appendLog(const QString &message) {
    m_logMessages += message + "\n";
    emit logMessagesChanged();
}

// Метод для получения списка имен баз данных
QStringList SettingsHandler::getDatabaseNames()  {

    return m_databaseNames;
}

void SettingsHandler::foo(){
    loadSettings();
    saveDatabases();
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
        appendLog("Database set: " + name);
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
    appendLog("Database edited: " + name);
}


void SettingsHandler::saveDatabases() {
    QString filePath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/settings.txt";
    appendLog("Путь сохранения: " + filePath);
    QFile basesFile(filePath);
    if (basesFile.open(QIODevice::WriteOnly)) {
        QTextStream out(&basesFile);

        for (const QString &dbName : m_databaseNames) {
            appendLog("Я в цикле сохранения");
            const Database &db = m_databases[dbName];
            out << db.name << Qt::endl;
            out << db.url << Qt::endl;
            out << db.login << Qt::endl;
            out << db.password << Qt::endl;
            appendLog("Сохранены данные базы: " + db.name);
        }

        out << m_currentDatabase.name << Qt::endl;
        out << m_currentDatabase.url << Qt::endl;
        out << m_currentDatabase.login << Qt::endl;
        out << m_currentDatabase.password << Qt::endl;

        basesFile.close();
        appendLog("Настройки сохранены\n");
    }
}



void SettingsHandler::loadSettings() {
    QString filePath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/settings.txt";
    appendLog("Путь загрузки: " + filePath);
    QFile basesFile(filePath);
    if (basesFile.open(QIODevice::ReadOnly)) {
        appendLog("Файл существует!");
        QTextStream in(&basesFile);

        m_databaseNames.clear();
        while (!in.atEnd()) {
            appendLog("Зашел в цикл!");
            QString dbName = in.readLine();
            if (dbName.isEmpty()) {
                appendLog("файл пуст!!");
                break;
            }

            Database db;
            db.name = dbName;
            db.url = in.readLine();
            db.login = in.readLine();
            db.password = in.readLine();

            m_databaseNames.append(db.name);
            m_databases.insert(db.name, db);
            appendLog("Загружена база данных: " + db.name);
        }

        m_currentDatabase.name = in.readLine();
        m_currentDatabase.url = in.readLine();
        m_currentDatabase.login = in.readLine();
        m_currentDatabase.password = in.readLine();

        basesFile.close();
        emit databasesChanged();
        appendLog("Настройки загружены\n");
    }
}
