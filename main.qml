import QtQuick 2.12
import QtQuick.Window 2.12
import QtWebEngine 1.8
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")
    Rectangle{
        id: buttoncontainer
        width: parent.width
        height: 32
    RowLayout{
        Button{
            id:backButton
            text: "<-"
            onClicked: webView.goBack()
        }
        Button{
            id:frontButton
            text: "->"
            onClicked: webView.goFront()
        }
        TextEdit{
            id:urlOrSearch
            width:parent.width-backButton.width-frontButton.width
            text: "https://lordsof.tech"
        }

    }
    }
    WebEngineView{
        id:webView
       width:parent.width
       height:parent.height-buttoncontainer.height
       anchors.top:buttoncontainer.bottom
        url: urlOrSearch.text
    }
}
