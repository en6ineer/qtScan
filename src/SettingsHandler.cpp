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

// Метод для сериализации структуры Method
QDataStream &operator<<(QDataStream &out, const Method &method) {
    out << method.name << method.endpoint;
    return out;
}

// Метод для десериализации структуры Method
QDataStream &operator>>(QDataStream &in, Method &method) {
    in >> method.name >> method.endpoint;
    return in;
}

// Метод для сериализации структуры Database
QDataStream &operator<<(QDataStream &out, const Database &db) {
    out << db.name << db.url << db.login << db.password;
    return out;
}

// Метод для десериализации структуры Database
QDataStream &operator>>(QDataStream &in, Database &db) {
    in >> db.name >> db.url >> db.login >> db.password;
    return in;
}

// Метод для получения списка имен баз данных
QStringList SettingsHandler::databaseNames() const {
    return m_databaseNames;
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

// Метод для получения текущего метода
Method SettingsHandler::currentMethod() const {
    return m_currentMethod;
}

// Метод для установки текущего метода
void SettingsHandler::setCurrentMethod(const Method &method) {
    m_currentMethod = method;
    emit currentMethodChanged();
}


// Метод для установки текущей базы данных по имени
void SettingsHandler::setDatabase(const QString &name) {
    if (m_databases.contains(name)) {
        setCurrentDatabase(m_databases[name]);
        emit currentDatabaseChanged();
    }
}

// Метод для установки текущего метода по имени
void SettingsHandler::setMethod(const QString &name) {
    if (m_methods.contains(m_currentDatabase.name)) {
        const auto &methods = m_methods[m_currentDatabase.name];
        for (const auto &method : methods) {
            if (method.name == name) {
                setCurrentMethod(method);
                emit currentMethodChanged();
                break;
            }
        }
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

    saveDatabases();
    emit databasesChanged();

    if (name == m_currentDatabase.name) {
        setCurrentDatabase(m_databases[name]);
        emit currentDatabaseChanged();
    }
}

// Метод для добавления или редактирования метода
void SettingsHandler::editMethod(const QString &databaseName, const QString &methodName, const QString &endpoint) {
    if (m_databases.contains(databaseName)) {
        bool isNewMethod = true;
        auto &methods = m_methods[databaseName];

        for (auto &method : methods) {
            if (method.name == methodName) {
                method.endpoint = endpoint;
                isNewMethod = false;
                setCurrentMethod(method);
                break;
            }
        }

        if (isNewMethod) {
            Method method = {methodName, endpoint};
            methods.append(method);
            setCurrentMethod(method);
        }

        saveMethods();
        emit currentMethodChanged();
    }
}

// Метод для получения списка имен методов текущей базы данных
QStringList SettingsHandler::methodNames() const {
    QStringList methodNames;
    if (m_methods.contains(m_currentDatabase.name)) {
        for (const auto &method : m_methods[m_currentDatabase.name]) {
            methodNames.append(method.name);
        }
    }
    return methodNames;
}

// Метод для загрузки настроек из файлов
void SettingsHandler::loadSettings() {
    // Загрузка баз данных
    QString basesFilePath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/Bases.bin";
    QFile basesFile(basesFilePath);
    if (basesFile.open(QIODevice::ReadOnly)) {
        QDataStream in(&basesFile);
        in >> m_databases >> m_databaseNames >> m_currentDatabase;
        basesFile.close();
    }

    // Загрузка методов
    QString methodsFilePath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/Methods.bin";
    QFile methodsFile(methodsFilePath);
    if (methodsFile.open(QIODevice::ReadOnly)) {
        QDataStream in(&methodsFile);
        in >> m_methods >> m_currentMethod;
        methodsFile.close();
    }
}

// Метод для сохранения баз данных
void SettingsHandler::saveDatabases() {
    QString basesFilePath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/Bases.bin";
    QFile basesFile(basesFilePath);
    if (basesFile.open(QIODevice::WriteOnly)) {
        QDataStream out(&basesFile);
        out << m_databases << m_databaseNames << m_currentDatabase;
        basesFile.close();
    }
}

// Метод для сохранения методов
void SettingsHandler::saveMethods() {
    QString methodsFilePath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/Methods.bin";
    QFile methodsFile(methodsFilePath);
    if (methodsFile.open(QIODevice::WriteOnly)) {
        QDataStream out(&methodsFile);
        out << m_methods << m_currentMethod;
        methodsFile.close();
    }
}
