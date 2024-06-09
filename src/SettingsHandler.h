#ifndef SETTINGSHANDLER_H
#define SETTINGSHANDLER_H

#include <QObject>

class SettingsHandler : public QObject
{
    Q_OBJECT
public:
    explicit SettingsHandler(QObject *parent = nullptr);

    Q_INVOKABLE void saveSettings(const QString &url, const QString &login, const QString &password, const QString &licenseKey);
    Q_INVOKABLE QString loadSettings(); // Новый метод для чтения настроек

signals:

public slots:
};

#endif // SETTINGSHANDLER_H
