import QtQuick 2.0
import QtQuick 2.12
import QtQuick.Window 2.12
import QtWebEngine 1.8
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Dialogs 1.3
import com.eyebrowser.linkvalidator 1.0


Rectangle {
    property string siteName: webView.title
    property string siteURL


    signal newTab
    signal closeTab

    width: parent.width
    height: parent.height




    Component.onCompleted: {

        webView.url = urlOrSearch.text

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
                onClicked: webView.goForward()
            }

            Button {
                id: eyeButton
                text: "(‧)"
                onClicked: webView.startEyeTracking()
            }



            TextEdit {
                id: urlOrSearch
                width: parent.width - backButton.width - frontButton.width
                text: siteURL
                activeFocusOnPress: true

                selectByKeyboard: true
                selectByMouse: true
                selectedTextColor: "#23B9CE"

                onFocusChanged: selectAll()

                Keys.onEnterPressed: {

                    webView.url = validator.validateLink(text)
                    webView.forceActiveFocus()
                }

                Keys.onReturnPressed: {

                    webView.url = validator.validateLink(text)
                    webView.forceActiveFocus()
                }
            }
        }
    }


    WebEngineView {
        id: webView

        signal startEyeTracking

        width: parent.width
        height: parent.height - buttoncontainer.height
        anchors.top: buttoncontainer.bottom


        onNewViewRequested: {console.log("new view requested")}

        userScripts: [

        WebEngineScript{
            injectionPoint: WebEngineScript.DocumentCreation
            name: "Gaze"
            sourceUrl: "file:///home/tylnesh/GazeCloudAPI.js"
            worldId: WebEngineScript.MainWorld

        },

            WebEngineScript{
                injectionPoint: WebEngineScript.DocumentCreation
                name: "heatmap"
                sourceUrl: "file:///home/tylnesh/heatmapLive.js"
                worldId: WebEngineScript.MainWorld

            }
]

        settings.allowWindowActivationFromJavaScript: true
        settings.pluginsEnabled: true // needed for the adobe flash plugin to work



        onStartEyeTracking: {

            webView.runJavaScript("GazeCloudAPI.StartEyeTracking();");
            webView.runJavaScript("ShowHeatMap();")
            webView.runJavaScript("GazeCloudAPI.GazeData", result => { console.log(result)});
//           webView.runJavascript("
//                        GazeCloudAPI.OnResult = function (GazeData) { GazeData.state // 0: valid gaze data; -1 : face tracking lost, 1 : gaze data uncalibrated
//                        GazeData.docX // gaze x in document coordinates
//                        GazeData.docY // gaze y in document coordinates
//                        GazeData.time // timestamp
//    ");
//            webView.runJavaScript("GazeCloudAPI.StopEyeTracking();");

        }


        onUrlChanged: {

            urlOrSearch.text = webView.url



        }
        onFeaturePermissionRequested: {
           grantFeaturePermission(securityOrigin, feature, true);
        }

        property int spX: 0
        property int spY: 0

        property int scrollHeight: 0
        property int scrollWidth: 0


        onCertificateError: function(error) {
                            error.defer();
                            sslDialog.enqueue(error);
                        }


        MessageDialog {
               id: sslDialog

               property var certErrors: []
               icon: StandardIcon.Warning
               standardButtons: StandardButton.No | StandardButton.Yes
               title: "Server's certificate not trusted"
               text: "Do you wish to continue?"
               detailedText: "If you wish so, you may continue with an unverified certificate. " +
                             "Accepting an unverified certificate means " +
                             "you may not be connected with the host you tried to connect to.\n" +
                             "Do you wish to override the security check and continue?"
               onYes: {
                   certErrors.shift().ignoreCertificateError();
                   presentError();
               }
               onNo: reject()
               onRejected: reject()

               function reject(){
                   certErrors.shift().rejectCertificate();
                   presentError();
               }
               function enqueue(error){
                   certErrors.push(error);
                   presentError();
               }
               function presentError(){
                   visible = certErrors.length > 0
               }
           }

        onJavaScriptConsoleMessage: {
        console.log("js")
        }






//        onScrollPositionChanged: {

//           //TODO: Add a short delay between scroll events so that user doesn't scroll past the content too fast.
//            const delay = 500

//            var x = webView.scrollPosition.x
//            var y = webView.scrollPosition.y

//            const update = (xChange, yChange) => {
//              const newX = x + xChange;
//              const newY = y + yChange;


//              webView.runJavaScript("document.body.scrollHeight", result => { webView.scrollHeight = result});
//              webView.runJavaScript("document.body.scrollWidth", result => { webView.scrollWidth = result});

////                console.log("yChange: " + yChange);
////                console.log("newY: " + newY);
////                console.log("webView.scrollHeight: " + webView.scrollHeight);
////                console.log("Math.abs(webView.scrollHeight - newY) " + webView.scrollHeight);

//              if (xChange > 0 && Math.abs(webView.scrollWidth - newX) < xChange) newX = webView.scrollWidth
//              if (yChange > 0 && Math.abs(webView.scrollHeight - newY) < yChange) newY = webView.scrollHeight

//              if (xChange < 0 && Math.abs(webView.scrollWidth - newX) < xChange) newX = 0
//              if (yChange < 0 && Math.abs(webView.scrollHeight - newY) < yChange) newY = 0

//              const command = "window.setTimeout(window.scrollTo(" + newX + ", " + newY + "),"+ delay + ");"
//              webView.runJavaScript(command);
//              webView.spX = newX;
//              webView.spY = newY;


//            }

//            if (x > webView.spX) {
//                update(webview.width, 0)
//            } else if (x < webView.spX) {
//                update(-webView.width,0)
//            }

//            if (y > webView.spY) {
//                update(0, webView.height)
//            } else if (y < webView.spY) {
//                update(0, -webView.height)
//            }

//        }

         onGeometryChangeRequested: {
             window.x = geometry.x
             window.y = geometry.y
             window.width = geometry.width
             window.height = geometry.height
         }
    }
}
