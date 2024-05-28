#include "HttpClient.h"
#include <QJsonArray>
HttpClient::HttpClient(QObject *parent) : QObject(parent)
{
    networkManager = new QNetworkAccessManager(this);
    connect(networkManager, &QNetworkAccessManager::finished, this, &HttpClient::onFinished);
}

void HttpClient::makeGetRequest(const QString &url)
{
    QNetworkRequest request;
    request.setUrl(QUrl(url));
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    // Захардкоженное значение Base64 для строки "логин:пароль"
    QString authorizationHeader = "Basic Ym90OjEyMzQ1";
    // Установка заголовка авторизации
    request.setRawHeader("Authorization", authorizationHeader.toUtf8());
    networkManager->get(request);
}

void HttpClient::makePostRequest(const QString &url, const QVariantMap &data)
{
    QNetworkRequest request;
    request.setUrl(QUrl(url));
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    // Захардкоженное значение Base64 для строки "логин:пароль"
    QString authorizationHeader = "Basic Ym90OjEyMzQ1";

    // Установка заголовка авторизации
    request.setRawHeader("Authorization", authorizationHeader.toUtf8());

    // Преобразуем QVariantMap в QJsonObject
    QJsonObject jsonObject = QJsonObject::fromVariantMap(data);

    // Выводим значения QJsonObject в консоль
    qDebug() << "JSON Object:";
    for (const QString &key : jsonObject.keys()) {
        qDebug() << key << ": " << jsonObject.value(key).toString();
    }

    QJsonDocument jsonDoc(jsonObject);  // Используем QJsonObject вместо QJsonArray
    QByteArray jsonData = jsonDoc.toJson();

    networkManager->post(request, jsonData);  // Передаем запрос и данные
}

void HttpClient::onFinished(QNetworkReply *reply)
{
    if (reply->error() == QNetworkReply::NoError) {
        QByteArray response_data = reply->readAll();
        emit requestFinished(QString(response_data));
    } else {
        emit requestFinished("Error: " + reply->errorString());
    }
    reply->deleteLater();
}
