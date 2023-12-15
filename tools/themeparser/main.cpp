#include <QGuiApplication>

#include "themeparser.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv); // QColor etc.
    const QStringList args = app.arguments();
    qWarning() << "XXXXXXXXXXXXXXXXXXXXXXXXXXXX Args = " << args;
    Victron::VenusOS::ThemeParser parser;
    return 0;
}
