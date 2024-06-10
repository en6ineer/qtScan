#ifndef SETTINGSHANDLER_H
#define SETTINGSHANDLER_H

#include <QObject>
#include <QSettings>

class SettingsHandler : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString url READ url WRITE setUrl NOTIFY urlChanged)
    Q_PROPERTY(QString login READ login WRITE setLogin NOTIFY loginChanged)
    Q_PROPERTY(QString password READ password WRITE setPassword NOTIFY passwordChanged)
    Q_PROPERTY(QString licenseKey READ licenseKey WRITE setLicenseKey NOTIFY licenseKeyChanged)

public:
    explicit SettingsHandler(QObject *parent = nullptr)
        : QObject(parent)
    {
        setupSettings(); // Вызов метода для установки начальных значений свойств
    }

    QString url() const { return m_url; }
    QString login() const { return m_login; }
    QString password() const { return m_password; }
    QString licenseKey() const { return m_licenseKey; }

public slots:
    void setUrl(const QString &url) { m_url = url; emit urlChanged(); }
    void setLogin(const QString &login) { m_login = login; emit loginChanged(); }
    void setPassword(const QString &password) { m_password = password; emit passwordChanged(); }
    void setLicenseKey(const QString &licenseKey) { m_licenseKey = licenseKey; emit licenseKeyChanged(); }
    Q_INVOKABLE void saveSettings(const QString &url, const QString &login, const QString &password, const QString &licenseKey);
    Q_INVOKABLE QString loadSettings();
    void setupSettings();
signals:
    void urlChanged();
    void loginChanged();
    void passwordChanged();
    void licenseKeyChanged();

private:
    QString m_url;
    QString m_login;
    QString m_password;
    QString m_licenseKey;
};

#endif // SETTINGSHANDLER_H
