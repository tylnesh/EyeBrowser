import QtQuick 2.12
import QtQuick.Window 2.12
import QtWebEngine 1.8
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import com.eyebrowser.linkvalidator 1.0

Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")



    LinkValidator {
    id: validator
    }


    TabBar{
    id: tabBar
    width: parent.width

    TabButton {
            text: "First"
            width: implicitWidth
        }
        TabButton {
            text: "Second"
            width: implicitWidth
        }
        TabButton {
            text: "Third"
            width: implicitWidth
        }
    }


    StackLayout {
        anchors.top: tabBar.bottom
        width: parent.width
        height: parent.height - tabBar.height
        currentIndex: tabBar.currentIndex
        Item {
            id: homeTab
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

                Button {
                    id: addTabButton
                    text: "+"
                    //onClicked:tabBar.addItem()
                }
                TextEdit{
                    id:urlOrSearch
                    width:parent.width-backButton.width-frontButton.width
                    text: "https://lordsof.tech"

                    activeFocusOnPress: true

                    selectByKeyboard: true
                    selectByMouse: true
                    selectedTextColor: "#23B9CE"


                    onFocusChanged: selectAll()

                    Keys.onEnterPressed: webView.url = text
                    Keys.onReturnPressed: {

                        webView.url = validator.validateLink(text)
                        webView.forceActiveFocus();

                    }
                }
            }
          }
            WebEngineView {
                id:webView
               width:parent.width
               height:parent.height-buttoncontainer.height
               anchors.top:buttoncontainer.bottom
               onUrlChanged: urlOrSearch.text = webView.url
            }

        }
        Item {
            id: discoverTab
            Rectangle{
                anchors.fill: parent
                color: "yellow"
                    }
        }
        Item {
            id: activityTab
            Rectangle{
                anchors.fill: parent
                color: "red"
                    }
        }


    }

}
