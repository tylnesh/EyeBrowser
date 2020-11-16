import QtQuick 2.0
import QtQuick 2.12
import QtQuick.Window 2.12
import QtWebEngine 1.8
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import com.eyebrowser.linkvalidator 1.0

Rectangle {
    property string siteName: webView.title;
    signal newTab();
    signal closeTab();




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
                onClicked: {
                    newTab();
                }
            }
            TextEdit {
                id: urlOrSearch
                width: parent.width - backButton.width - frontButton.width
                text: "https://helpx.adobe.com/flash-player.html"

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

            Button {
                id: closeTabButton
                text: "x"
                onClicked: {
                    closeTab();
                }
        }
    }
    }
    WebEngineView {

        id: webView
        width: parent.width
        settings.pluginsEnabled: true
        height: parent.height - buttoncontainer.height
        anchors.top: buttoncontainer.bottom
        onUrlChanged: urlOrSearch.text = webView.url

    }
}
