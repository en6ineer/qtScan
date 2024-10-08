#ifndef HTTPCLIENT_H
#define HTTPCLIENT_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QSslError>
#include <QSslConfiguration>
#include "BarcodesData.h"
#include "SettingsHandler.h"


class HttpClient : public QObject
{
    Q_OBJECT
public:
    explicit HttpClient(SettingsHandler *settingsHandler, BarcodesData *barcodesData,  QObject *parent = nullptr);
    Q_INVOKABLE void makePostRequest();

signals:
    void requestFinished(const QString &response);

private slots:
    void onFinished(QNetworkReply *reply);
    void ignoreSslErrors(QNetworkReply *reply, const QList<QSslError> &errors);

private:
    QNetworkAccessManager *networkManager;
    SettingsHandler *settingsHandler; // Ссылка на объект SettingsHandler
    BarcodesData *barcodesData;       // Ссылка на объект BarcodesData
    QString toBase64(const QString &login, const QString &pass);
};

#endif // HTTPCLIENT_H
