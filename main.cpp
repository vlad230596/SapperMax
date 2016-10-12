#include <QtGui/QGuiApplication>
#include <QQmlEngine>
#include <QQmlComponent>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQmlEngine engine;
    QQmlComponent component(&engine,  QUrl( "qrc:/source/main.qml" ));
    component.create();
    return app.exec();
}

