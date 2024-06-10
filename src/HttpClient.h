#ifndef HTTPCLIENT_H
#define HTTPCLIENT_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include "BarcodesData.h"  // Добавляем включение заголовочного файла BarcodesData

class HttpClient : public QObject
{
    Q_OBJECT
public:
    explicit HttpClient(QObject *parent = nullptr);
    Q_INVOKABLE void makeGetRequest(const QString &url);
    Q_INVOKABLE void makePostRequest(const QString &url, const QString &login, const QString &pass, const BarcodesData &barcodesData); // Обновляем метод

signals:
    void requestFinished(const QString &response);

private slots:
    void onFinished(QNetworkReply *reply);

private:
    QNetworkAccessManager *networkManager;
    QString toBase64(const QString &login, const QString &pass);  // Добавляем метод для преобразования в Base64
};

#endif // HTTPCLIENT_H
