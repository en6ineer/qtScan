#include "SettingsHandler.h"
#include <QFile>
#include <QDataStream>
#include <QStandardPaths>

// Конструктор класса SettingsHandler, инициализирует объект и загружает настройки
SettingsHandler::SettingsHandler(QObject *parent)
    : QObject(parent)
{
    loadSettings(); // Вызов метода для установки начальных значений свойств
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
    emit currentDatabaseChanged(); // Сигнал о том, что текущая база данных изменена
}

// Метод для получения текущего метода
Method SettingsHandler::currentMethod() const {
    return m_currentMethod;
}

// Метод для установки текущего метода
void SettingsHandler::setCurrentMethod(const Method &method) {
    m_currentMethod = method;
    emit currentMethodChanged(); // Сигнал о том, что текущий метод изменен
}

// Метод для добавления новой базы данных
void SettingsHandler::addDatabase(const QString &name, const QString &login, const QString &password, const QString &url) {
    Database db = {name, url, login, password}; // Создание новой базы данных
    m_databases[name] = db; // Добавление базы данных в QMap
    m_databaseNames.append(name); // Добавление имени базы данных в список имен
    saveSettings(); // Сохранение настроек
    emit databasesChanged(); // Сигнал о том, что список баз данных изменен
}

// Метод для редактирования существующей базы данных
void SettingsHandler::editDatabase(const QString &name, const QString &login, const QString &password, const QString &url) {
    if (m_databases.contains(name)) { // Проверка, существует ли база данных с таким именем
        m_databases[name].login = login; // Обновление логина
        m_databases[name].password = password; // Обновление пароля
        m_databases[name].url = url; // Обновление URL
        saveSettings(); // Сохранение настроек
        emit databasesChanged(); // Сигнал о том, что список баз данных изменен
        if (name == m_currentDatabase.name) {
            emit currentDatabaseChanged(); // Сигнал о том, что текущая база данных изменена
        }
    }
}

// Метод для добавления нового метода в базу данных
void SettingsHandler::addMethod(const QString &databaseName, const QString &methodName, const QString &endpoint) {
    if (m_databases.contains(databaseName)) { // Проверка, существует ли база данных с таким именем
        Method method = {methodName, endpoint}; // Создание нового метода
        m_methods[databaseName].append(method); // Добавление метода в QMap методов
        saveSettings(); // Сохранение настроек
        if (databaseName == m_currentDatabase.name) {
            emit currentMethodChanged();; // Сигнал о том, что текущая база данных изменена
        }
    }
}

// Метод для редактирования существующего метода в базе данных
void SettingsHandler::editMethod(const QString &databaseName, const QString &methodName, const QString &newEndpoint) {
    if (m_databases.contains(databaseName) && m_methods.contains(databaseName)) { // Проверка, существует ли база данных и методы с таким именем
        for (auto &method : m_methods[databaseName]) { // Проход по всем методам базы данных
            if (method.name == methodName) { // Проверка, совпадает ли имя метода
                method.endpoint = newEndpoint; // Обновление конечной точки метода
                saveSettings(); // Сохранение настроек
                if (databaseName == m_currentDatabase.name) {
                    emit currentDatabaseChanged(); // Сигнал о том, что текущая база данных изменена
                }
                break;
            }
        }
    }
}

// Метод для получения списка имен методов текущей базы данных
QStringList SettingsHandler::methodNames() const {
    QStringList methodNames;
    if (m_methods.contains(m_currentDatabase.name)) {
        for (const auto &method : m_methods[m_currentDatabase.name]) { // Проход по всем методам текущей базы данных
            methodNames.append(method.name); // Добавление имени метода в список
        }
    }
    return methodNames;
}

// Метод для загрузки настроек из файлов
void SettingsHandler::loadSettings() {
    // Загрузка баз данных
    QString basesFilePath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/Bases.bin"; // Определение пути к файлу баз данных
    QFile basesFile(basesFilePath);
    if (basesFile.open(QIODevice::ReadOnly)) { // Открытие файла в режиме чтения
        QDataStream in(&basesFile);
        in >> m_databases >> m_databaseNames >> m_currentDatabase; // Чтение данных из файла
        basesFile.close();
    }

    // Загрузка методов
    QString methodsFilePath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/Methods.bin"; // Определение пути к файлу методов
    QFile methodsFile(methodsFilePath);
    if (methodsFile.open(QIODevice::ReadOnly)) { // Открытие файла в режиме чтения
        QDataStream in(&methodsFile);
        in >> m_methods >> m_currentMethod; // Чтение данных из файла
        methodsFile.close();
    }
}

// Метод для сохранения настроек в файлы
void SettingsHandler::saveSettings() {
    // Сохранение баз данных
    QString basesFilePath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/Bases.bin"; // Определение пути к файлу баз данных
    QFile basesFile(basesFilePath);
    if (basesFile.open(QIODevice::WriteOnly)) { // Открытие файла в режиме записи
        QDataStream out(&basesFile);
        out << m_databases << m_databaseNames << m_currentDatabase; // Запись данных в файл
        basesFile.close();
    }

    // Сохранение методов
    QString methodsFilePath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/Methods.bin"; // Определение пути к файлу методов
    QFile methodsFile(methodsFilePath);
    if (methodsFile.open(QIODevice::WriteOnly)) { // Открытие файла в режиме записи
        QDataStream out(&methodsFile);
        out << m_methods << m_currentMethod; // Запись данных в файл
        methodsFile.close();
    }
}
