import QtQuick 2.12
import QtQuick.Window 2.12
import QtWebEngine 1.8
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import com.eyebrowser.linkvalidator 1.0

Window {
    visible: true
    width: 800
    height: 600
    title: qsTr("EyeBrowser")

    Component.onCompleted: {

    }

    Component {
        id: tabComponent

        WebViewItem {
            id: tabView
            onNewTab: {
                tabRepeater.model++
                console.log(tabRepeater.model)

                var newTabItem = tabComponent.createObject(null, {
                                                               "id": "tabName"
                                                           })
                stackLayout.children.push(newTabItem)
                //tabBar.addItem(newTabItem);
            }
        }
    }

    TabBar {
        id: tabBar
        width: parent.width

        Repeater {
            id: tabRepeater
            model: 0

            TabButton {
                text: "Tab n° " + index
                width: implicitWidth
                Button
                {
                    anchors.right: parent.right
                    text: "x"
                    onClicked: {}
                }
            }
        }
    }

    StackLayout {
        id: stackLayout
        anchors.top: tabBar.bottom
        width: parent.width
        height: parent.height - tabBar.height
        currentIndex: tabBar.currentIndex


            WebViewItem {
                id: firstTab
                onNewTab: {
                    tabRepeater.model++
                    console.log(tabRepeater.model)

                    var newTabItem = tabComponent.createObject(null, {
                                                                   "id": "tabName"
                                                               })
                    stackLayout.children.push(newTabItem)
                    //tabBar.addItem(newTabItem);
                }
            }

    }
}
