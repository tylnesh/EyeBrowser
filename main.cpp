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

    QQmlApplicationEngine engine;
    qmlRegisterType<LinkValidator>("com.eyebrowser.linkvalidator",1,0,"LinkValidator");



    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
