#include "HttpClient.h"
#include <QJsonArray>
#include <QByteArray>
#include <QJsonObject>
#include <QJsonDocument>
#include <QNetworkRequest>
#include <QSslConfiguration>
#include <QSslError>
#include <QSslSocket>
#include "SettingsHandler.h"


HttpClient::HttpClient(SettingsHandler *settingsHandler, BarcodesData *barcodesData, QObject *parent)
    : QObject(parent), settingsHandler(settingsHandler), barcodesData(barcodesData)
{
    networkManager = new QNetworkAccessManager(this);
    connect(networkManager, &QNetworkAccessManager::finished, this, &HttpClient::onFinished);
}

void HttpClient::makePostRequest()
{
    // Получаем настройки из свойств объекта SettingsHandler
    QString url = settingsHandler->currentDatabase().url;
    QString login = settingsHandler->currentDatabase().login;
    QString pass = settingsHandler->currentDatabase().password;

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

    // Создаем QSslConfiguration для игнорирования ошибок сертификата
    QSslConfiguration sslConfig = QSslConfiguration::defaultConfiguration();
    sslConfig.setPeerVerifyMode(QSslSocket::VerifyNone);
    sslConfig.setProtocol(QSsl::TlsV1_2);

    request.setSslConfiguration(sslConfig);

    QNetworkReply *reply = networkManager->post(request, jsonData);

    // Подключаем обработчик ошибок SSL
    connect(reply, &QNetworkReply::sslErrors, this, [this, reply](const QList<QSslError> &errors) {
        ignoreSslErrors(reply, errors);
    });
}

void HttpClient::ignoreSslErrors(QNetworkReply *reply, const QList<QSslError> &errors)
{
    // Игнорируем все ошибки SSL
    qDebug() << "Ignoring SSL errors:";
    for (const QSslError &error : errors) {
        qDebug() << error.errorString();
    }
    reply->ignoreSslErrors(errors);
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
