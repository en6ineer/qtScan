#ifndef SETTINGSHANDLER_H
#define SETTINGSHANDLER_H

#include <QObject>
#include <QSettings>
#include <QMap>
#include <QString>
#include <QStringList>

// Структура для хранения данных базы данных
struct Database {
    QString name;
    QString url;
    QString login;
    QString password;
};

class SettingsHandler : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString logMessages READ logMessages NOTIFY logMessagesChanged)
    Q_PROPERTY(QStringList databaseNames READ getDatabaseNames NOTIFY databasesChanged)
    Q_PROPERTY(Database currentDatabase READ currentDatabase WRITE setCurrentDatabase NOTIFY currentDatabaseChanged)

public:
    explicit SettingsHandler(QObject *parent = nullptr);


    void loadSettings();
    void saveDatabases();
    void appendLog(const QString &message);


    Database currentDatabase() const;
    void setCurrentDatabase(const Database &db);

    Q_INVOKABLE void setDatabase(const QString &name);
    Q_INVOKABLE void editDatabase(const QString &name, const QString &login, const QString &password, const QString &url);
    Q_INVOKABLE QStringList getDatabaseNames(); //QStringList
    Q_INVOKABLE QString getPath() const;
    Q_INVOKABLE void foo();
    QString logMessages() const;

signals:
    void databasesChanged();
    void currentDatabaseChanged();
    void logMessagesChanged();

private:
    QMap<QString, Database> m_databases;
    QStringList m_databaseNames;
    Database m_currentDatabase;
    QString m_logMessages;


};

#endif // SETTINGSHANDLER_H
