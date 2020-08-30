import QtQuick 2.0
import QtQuick 2.12
import QtQuick.Window 2.12
import QtWebEngine 1.8
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import com.eyebrowser.linkvalidator 1.0

Item {

    property string siteName: webView.title;

    signal newTab();


    LinkValidator {
        id: validator
    }

    Rectangle {
        id: buttoncontainer
        width: parent.width
        height: 32

        RowLayout {
            Button {
                id: backButton
                text: "<-"
                onClicked: webView.goBack()
            }
            Button {
                id: frontButton
                text: "->"
                onClicked: webView.goFront()
            }

            Button {
                id: addTabButton
                text: "+"
                onClicked: newTab();
                //onClicked:tabBar.addItem()
            }
            TextEdit {
                id: urlOrSearch
                width: parent.width - backButton.width - frontButton.width
                text: "https://lordsof.tech"

                activeFocusOnPress: true

                selectByKeyboard: true
                selectByMouse: true
                selectedTextColor: "#23B9CE"

                onFocusChanged: selectAll()

                Keys.onEnterPressed: webView.url = text
                Keys.onReturnPressed: {

                    webView.url = validator.validateLink(text)
                    webView.forceActiveFocus()
                }
            }
        }
    }
    WebEngineView {
        id: webView
        width: parent.width
        height: parent.height - buttoncontainer.height
        anchors.top: buttoncontainer.bottom
        onUrlChanged: urlOrSearch.text = webView.url

    }
}
