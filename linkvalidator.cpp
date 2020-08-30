#include "linkvalidator.hpp"
#include <QString>
#include <QDebug>

LinkValidator::LinkValidator(QObject *parent)
    : QObject(parent)
{

}


QString LinkValidator::validateLink(QString linkOrSearch) {

    //TODO add setting to pick and choose search engines
    //https://duckduckgo.com/?q=something+to+be+searched&ia=web
    //https://www.google.com/search?q=something+to+be+searched

    QString validatedLink;
    if (linkOrSearch.contains(" ")){
        linkOrSearch.replace(" ","+",Qt::CaseInsensitive);
        validatedLink = "https://duckduckgo.com/?q=" + linkOrSearch + "&ia=web";
        qDebug() << validatedLink;
        return validatedLink;
    }

    else if (!linkOrSearch.contains(".")){
        linkOrSearch.replace(" ","+",Qt::CaseInsensitive);
        validatedLink = "https://duckduckgo.com/?q=" + linkOrSearch + "&ia=web";
        qDebug() << validatedLink;
        return validatedLink;
    }

    else if (linkOrSearch.indexOf("https://") == 0 || linkOrSearch.indexOf("http://") == 0 ) {
        validatedLink = linkOrSearch;
        return validatedLink;
    }

    else {
        validatedLink = "https://" + linkOrSearch;

        return validatedLink;
    }

}
