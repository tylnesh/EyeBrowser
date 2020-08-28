#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtWebEngine>
#include "linkvalidator.hpp"


int main(int argc, char *argv[])
{

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QCoreApplication::setAttribute(Qt::AA_ShareOpenGLContexts);


    QGuiApplication app(argc, argv);
    QGuiApplication::setApplicationName("EyeBrowser");


    QtWebEngine::initialize();


    qmlRegisterSingletonType<LinkValidator>("com.tylnesh.linkvalidator", 1, 0, "LinkValidator",
                             [](QQmlEngine *engine, QJSEngine *scriptEngine) -> QObject * {
        Q_UNUSED(engine)
        Q_UNUSED(scriptEngine)
        LinkValidator *lv = new LinkValidator();

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
