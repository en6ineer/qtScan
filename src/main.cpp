#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "app_environment.h"
#include "import_qml_components_plugins.h"
#include "import_qml_plugins.h"
#include "HttpClient.h"
#include "BarcodesData.h"
#include "SettingsHandler.h"

int main(int argc, char *argv[])
{
    set_qt_environment();

    QGuiApplication app(argc, argv);

    // Регистрация SettingsHandler
    qmlRegisterType<SettingsHandler>("com.myapp.settings", 1, 0, "SettingsHandler");

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

    // Создание экземпляра HttpClient
    HttpClient httpClient;
    engine.rootContext()->setContextProperty("httpClient", &httpClient);

    // Создание экземпляра модели данных BarcodesData
    BarcodesData barcodesData;
    engine.rootContext()->setContextProperty("barcodesData", &barcodesData);

    // Создание экземпляра SettingsHandler
    SettingsHandler settingsHandler;
    engine.rootContext()->setContextProperty("settingsHandler", &settingsHandler);

    engine.addImportPath(QCoreApplication::applicationDirPath() + "/qml");
    engine.addImportPath(":/");

    engine.load(url);

    if (engine.rootObjects().isEmpty()) {
        return -1;
    }

    return app.exec();
}
