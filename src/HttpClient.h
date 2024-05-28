#ifndef HTTPCLIENT_H
#define HTTPCLIENT_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>

class HttpClient : public QObject
{
    Q_OBJECT
public:
    explicit HttpClient(QObject *parent = nullptr);
    Q_INVOKABLE void makeGetRequest(const QString &url);
    Q_INVOKABLE void makePostRequest(const QString &url, const QVariantMap &data); // Обновляем метод

signals:
    void requestFinished(const QString &response);

private slots:
    void onFinished(QNetworkReply *reply);

private:
    QNetworkAccessManager *networkManager;
};

#endif // HTTPCLIENT_H
