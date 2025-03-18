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
    Q_PROPERTY(bool keyLicense READ getKeyLicense NOTIFY keyLicenseChanged)


public:
    explicit SettingsHandler(QObject *parent = nullptr);


    void loadSettings();
    void saveDatabases();
    void appendLog(const QString &message);
    Database currentDatabase() const;
    Q_INVOKABLE int getCurrentIndex() const;
    void setCurrentDatabase(const Database &db);
    Q_INVOKABLE void removeBase(const QString &name);
    Q_INVOKABLE void setDatabase(const QString &name);
    Q_INVOKABLE void editDatabase(const QString &name, const QString &login, const QString &password, const QString &url);
    Q_INVOKABLE QStringList getDatabaseNames();
    Q_INVOKABLE QString getSettings();
    QString logMessages() const;
    // Методы для работы с лицензионным ключом
    Q_INVOKABLE bool getKeyLicense() const;
    Q_INVOKABLE bool setKeyLicense(const QString &license);

signals:
    void databasesChanged();
    void currentDatabaseChanged();
    void logMessagesChanged();
    void keyLicenseChanged();

private:
    QMap<QString, Database> m_databases;
    QStringList m_databaseNames;
    Database m_currentDatabase;
    QString m_logMessages;
    bool m_keyLicense;


};

#endif // SETTINGSHANDLER_H
