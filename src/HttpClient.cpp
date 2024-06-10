#include "HttpClient.h"
#include <QJsonArray>
#include <QByteArray>
#include <QJsonObject>
#include <QJsonDocument>
#include <QNetworkRequest>

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
    QString authorizationHeader = "Basic Ym90OjEyMzQ1"; //это для теста
    // Установка заголовка авторизации
    request.setRawHeader("Authorization", authorizationHeader.toUtf8());
    networkManager->get(request);
}

void HttpClient::makePostRequest(const QString &url, const QString &login, const QString &pass, const BarcodesData &barcodesData)
{
    QNetworkRequest request;
    request.setUrl(QUrl(url));
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    // Преобразование логина и пароля в Base64
    QString authorizationHeader = "Basic " + toBase64(login, pass);

    // Установка заголовка авторизации
    request.setRawHeader("Authorization", authorizationHeader.toUtf8());

    // Преобразуем BarcodesData в QJsonObject
    QJsonObject jsonObject;
    for (int row = 0; row < barcodesData.rowCount(); ++row) {
        QString barcode = barcodesData.get(row, 0).toString();
        int quantity = barcodesData.get(row, 1).toInt();
        jsonObject.insert(barcode, quantity);
    }

    QJsonDocument jsonDoc(jsonObject);
    QByteArray jsonData = jsonDoc.toJson();

    networkManager->post(request, jsonData);
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

QString HttpClient::toBase64(const QString &login, const QString &pass)
{
    QString credentials = login + ":" + pass;
    QByteArray data = credentials.toUtf8();
    return data.toBase64();
}
