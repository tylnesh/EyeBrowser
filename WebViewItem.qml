import QtQuick 2.0
import QtQuick 2.12
import QtQuick.Window 2.12
import QtWebEngine 1.8
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import com.eyebrowser.linkvalidator 1.0

Rectangle {
    property string siteName: webView.title
    signal newTab
    signal closeTab

    Component.onCompleted: webView.url = urlOrSearch.text

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
        }
    }

    WebEngineView {
        id: webView
        width: parent.width
        height: parent.height - buttoncontainer.height
        anchors.top: buttoncontainer.bottom


        settings.pluginsEnabled: true // needed for the adobe flash plugin to work

        onUrlChanged: urlOrSearch.text = webView.url

        property int spX: 0
        property int spY: 0

        property int scrollHeight: 0
        property int scrollWidth: 0

        onScrollPositionChanged: {

            //TODO: Add a short delay between scroll events so that user doesn't scroll past the content too fast.

            var x = webView.scrollPosition.x
            var y = webView.scrollPosition.y

            const update = (xChange, yChange) => {
              const newX = x + xChange;
              const newY = y + yChange;

              webView.runJavaScript("document.body.scrollHeight", result => { webView.scrollHeight = result});
              webView.runJavaScript("document.body.scrollWidth", result => { webView.scrollWidth = result});

              if (xChange > 0 && Math.abs(webView.scrollWidth - newX) < xChange) newX = webView.scrollWidth
              if (yChange > 0 && Math.abs(webView.scrollHeight - newY) < yChange) newY = webView.scrollHeight

              if (xChange < 0 && Math.abs(webView.scrollWidth - newX) < xChange) newX = 0
              if (yChange < 0 && Math.abs(webView.scrollHeight - newY) < yChange) newY = 0

              const command = "window.scrollTo(" + newX + ", " + newY + ");"
              webView.runJavaScript(command);
              webView.spX = newX;
              webView.spY = newY;
            }

            if (x > webView.spX) {
                update(webview.width, 0)
            } else if (x < webView.spX) {
                update(-webView.width,0)
            }

            if (y > webView.spY) {
                update(0, webView.height)
            } else if (y < webView.spY) {
                update(0, -webView.height)
            }

        }

         onGeometryChangeRequested: {
             window.x = geometry.x
             window.y = geometry.y
             window.width = geometry.width
             window.height = geometry.height
         }
    }
}
