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

    if (name != m_currentDatabase.name) {
        setCurrentDatabase(m_databases[name]);
        emit currentDatabaseChanged();
    }

    saveDatabases();
    emit databasesChanged();
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
        emit methodsChanged();
    }
}

// Метод для получения списка имен методов текущей базы данных
QStringList SettingsHandler::getMethodNames() const {
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

     // QFile::remove(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/Bases.bin");
     // QFile::remove(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/Methods.bin");

    // Загрузка баз данных
    QString basesFilePath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/Bases.bin";
    QFile basesFile(basesFilePath);
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

    // Загрузка методов
    QString methodsFilePath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/Methods.bin";
    QFile methodsFile(methodsFilePath);
    if (methodsFile.open(QIODevice::ReadOnly)) {
        QDataStream in(&methodsFile);

        int methodCount;
        in >> methodCount;
        m_methods.clear();
        for (int i = 0; i < methodCount; ++i) {
            QString dbName, methodName, endpoint;
            in >> dbName >> methodName >> endpoint;
            m_methods[dbName].append({ methodName, endpoint });
        }

        in >> m_currentMethod.name >> m_currentMethod.endpoint;

        methodsFile.close();
        emit methodsChanged();
    }
}

// Метод для сохранения баз данных
void SettingsHandler::saveDatabases() {
    QString basesFilePath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/Bases.bin";
    QFile basesFile(basesFilePath);
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

// Метод для сохранения методов
void SettingsHandler::saveMethods() {
    QString methodsFilePath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/Methods.bin";
    QFile methodsFile(methodsFilePath);
    if (methodsFile.open(QIODevice::WriteOnly)) {
        QDataStream out(&methodsFile);

        int methodCount = 0;
        for (auto it = m_methods.cbegin(); it != m_methods.cend(); ++it) {
            methodCount += it.value().size();
        }
        out << methodCount;

        for (auto it = m_methods.cbegin(); it != m_methods.cend(); ++it) {
            for (const Method &method : it.value()) {
                out << it.key() << method.name << method.endpoint;
            }
        }

        out << m_currentMethod.name << m_currentMethod.endpoint;

        methodsFile.close();
    }
}

