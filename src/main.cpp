#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "app_environment.h"
#include "import_qml_components_plugins.h"
#include "import_qml_plugins.h"
#include "HttpClient.h"
#include "BarcodesData.h"
#include "SettingsHandler.h"
#include "CSVGenerator.h"

int main(int argc, char *argv[])
{
    set_qt_environment();

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    const QUrl url(u"qrc:/qt/qml/Main/main.qml"_qs);
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);

    // AndroidBackHandler androidBackHandler;
    // engine.rootContext()->setContextProperty("androidBackHandler", &androidBackHandler);

    qmlRegisterType<HttpClient>("App", 1, 0, "HttpClient");
    qmlRegisterType<BarcodesData>("App", 1, 0, "BarcodesData");
    qmlRegisterType<SettingsHandler>("App", 1, 0, "SettingsHandler");


    // Создание экземпляра CSVGenerator
    CSVGenerator csvGenerator;
    engine.rootContext()->setContextProperty("csvGenerator", &csvGenerator);


    // Создание экземпляра SettingsHandler
    SettingsHandler settingsHandler;
    engine.rootContext()->setContextProperty("settingsHandler", &settingsHandler);

    // Создание экземпляра модели данных BarcodesData
    BarcodesData barcodesData;
    engine.rootContext()->setContextProperty("barcodesData", &barcodesData);

    // Создание экземпляра HttpClient с передачей ссылок на SettingsHandler и BarcodesData
    HttpClient httpClient(&settingsHandler, &barcodesData);
    engine.rootContext()->setContextProperty("httpClient", &httpClient);


    engine.addImportPath(QCoreApplication::applicationDirPath() + "/qml");
    engine.addImportPath(":/");

    engine.load(url);

    if (engine.rootObjects().isEmpty()) {
        return -1;
    }

    return app.exec();
}
