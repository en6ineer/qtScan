#include "HttpClient.h"
#include <QJsonArray>
#include <QByteArray>
#include <QJsonObject>
#include <QJsonDocument>
#include <QNetworkRequest>
#include "SettingsHandler.h"

HttpClient::HttpClient(SettingsHandler *settingsHandler, BarcodesData *barcodesData, QObject *parent) : QObject(parent)
{
    networkManager = new QNetworkAccessManager(this);
    connect(networkManager, &QNetworkAccessManager::finished, this, &HttpClient::onFinished);

    // Сохранение ссылок на объекты SettingsHandler и BarcodesData
    this->settingsHandler = settingsHandler;
    this->barcodesData = barcodesData;
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

void HttpClient::makePostRequest()
{
    // Получаем настройки из свойств объекта SettingsHandler
    QString url = settingsHandler->url();
    QString login = settingsHandler->login();
    QString pass = settingsHandler->password();

    QNetworkRequest request;
    request.setUrl(QUrl(url));
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    // Преобразование логина и пароля в Base64
    QString authorizationHeader = "Basic " + toBase64(login, pass);

    // Установка заголовка авторизации
    request.setRawHeader("Authorization", authorizationHeader.toUtf8());

    // Преобразуем BarcodesData в QJsonObject
    QJsonArray jsonArray; // Изменили на QJsonArray для хранения нескольких объектов
    for (int row = 0; row < barcodesData->rowCount(); ++row) {
        QJsonObject jsonObject;
        QString barcode = barcodesData->get(row, 0).toString();
        int quantity = barcodesData->get(row, 1).toInt();
        QString comment = barcodesData->get(row, 2).toString(); // Получаем значение комментария

        jsonObject["barcode"] = barcode;  // Добавляем штрихкод в объект JSON
        jsonObject["quantity"] = quantity; // Добавляем количество в объект JSON
        jsonObject["comment"] = comment; // Добавляем комментарий в объект JSON

        jsonArray.append(jsonObject); // Добавляем объект JSON в массив
    }

    QJsonDocument jsonDoc(jsonArray); // Создаем документ JSON из массива
    QByteArray jsonData = jsonDoc.toJson(); // Преобразуем документ в QByteArray

    networkManager->post(request, jsonData); // Отправляем POST запрос с данными JSON
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
