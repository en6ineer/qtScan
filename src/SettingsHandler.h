#ifndef SETTINGSHANDLER_H
#define SETTINGSHANDLER_H

#include <QObject>
#include <QSettings>
#include <QMap>
#include <QVector>
#include <QString>
#include <QStringList>

// Структура для хранения данных метода
struct Method {
    QString name;
    QString endpoint;
};

// Структура для хранения данных базы данных
struct Database {
    QString name;
    QString url;
    QString login;
    QString password;
};

// Перегрузка операторов для сериализации и десериализации
QDataStream &operator<<(QDataStream &out, const Method &method);
QDataStream &operator>>(QDataStream &in, Method &method);

QDataStream &operator<<(QDataStream &out, const Database &db);
QDataStream &operator>>(QDataStream &in, Database &db);

class SettingsHandler : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QStringList databaseNames READ databaseNames NOTIFY databasesChanged)
    Q_PROPERTY(Database currentDatabase READ currentDatabase WRITE setCurrentDatabase NOTIFY currentDatabaseChanged)
    Q_PROPERTY(Method currentMethod READ currentMethod WRITE setCurrentMethod NOTIFY currentMethodChanged)

public:
    explicit SettingsHandler(QObject *parent = nullptr);


    Database currentDatabase() const; // ?
    Method currentMethod() const; // ?
    void setCurrentDatabase(const Database &db);
    void setCurrentMethod(const Method &method);

    Q_INVOKABLE void setDatabase(const QString &name);
    Q_INVOKABLE void setMethod(const QString &name);
    Q_INVOKABLE void editDatabase(const QString &name, const QString &login, const QString &password, const QString &url);
    Q_INVOKABLE void editMethod(const QString &databaseName, const QString &methodName, const QString &endpoint);
    Q_INVOKABLE QStringList methodNames() const; // OK, это надо чтобы список в модель ComboBox загружать
    Q_INVOKABLE QStringList databaseNames() const; //
signals:
    void databasesChanged();
    void currentDatabaseChanged();
    void currentMethodChanged();

private:
    QMap<QString, Database> m_databases;
    QMap<QString, QVector<Method>> m_methods;
    QStringList m_databaseNames;
    Database m_currentDatabase;
    Method m_currentMethod;

    void loadSettings();
    void saveDatabases();
    void saveMethods();
};

#endif // SETTINGSHANDLER_H
