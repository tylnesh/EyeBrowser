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

    Component.onCompleted: {

        webView.url = urlOrSearch.text
//        webView.runJavaScript('var s = document.createElement("script");
//    s.src = "/home/tylnesh/GazeCloudAPI.js";
//    document.body.appendChild(s);
//window.setTimeout(GazeCloudAPI.StartEyeTracking(), 200);
//')


    }

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
                //text: "https://api.gazerecorder.com/"


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
        onNewViewRequested: {console.log("new view requested")}

        WebEngineScript{
            //injectionPoint: WebEngineScript.DocumentReady
            name: "GazeCloudApi"
            //sourceUrl: "qrc:///GazeCloudAPI.js"
            //sourceUrl: "/home/tylnesh/hello.js"
            sourceCode: "window.alert('hello world');"


            worldId: WebEngineScript.MainWorld

        }

        settings.allowWindowActivationFromJavaScript: true

        settings.pluginsEnabled: true // needed for the adobe flash plugin to work

        onUrlChanged: urlOrSearch.text = webView.url

        onFeaturePermissionRequested: {
           grantFeaturePermission(securityOrigin, feature, true);
        }

        property int spX: 0
        property int spY: 0

        property int scrollHeight: 0
        property int scrollWidth: 0

        onScrollPositionChanged: {

            //TODO: Add a short delay between scroll events so that user doesn't scroll past the content too fast.
            const delay = 500

            var x = webView.scrollPosition.x
            var y = webView.scrollPosition.y

            const update = (xChange, yChange) => {
              const newX = x + xChange;
              const newY = y + yChange;

              webView.runJavaScript("document.body.scrollHeight", result => { webView.scrollHeight = result});
              webView.runJavaScript("document.body.scrollWidth", result => { webView.scrollWidth = result});

//                console.log("yChange: " + yChange);
//                console.log("newY: " + newY);
//                console.log("webView.scrollHeight: " + webView.scrollHeight);
//                console.log("Math.abs(webView.scrollHeight - newY) " + webView.scrollHeight);

              if (xChange > 0 && Math.abs(webView.scrollWidth - newX) < xChange) newX = webView.scrollWidth
              if (yChange > 0 && Math.abs(webView.scrollHeight - newY) < yChange) newY = webView.scrollHeight

              if (xChange < 0 && Math.abs(webView.scrollWidth - newX) < xChange) newX = 0
              if (yChange < 0 && Math.abs(webView.scrollHeight - newY) < yChange) newY = 0

              const command = "window.setTimeout(window.scrollTo(" + newX + ", " + newY + "),"+ delay + ");"
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
