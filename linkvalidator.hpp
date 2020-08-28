#ifndef LINKVALIDATOR_H
#define LINKVALIDATOR_H

#include <QObject>

class LinkValidator
{
    Q_OBJECT
public:
    explicit LinkValidator(QObject *parent = nullptr);
    Q_INVOKABLE QString validateLink(QString linkOrSearch);
};

#endif // LINKVALIDATOR_H
