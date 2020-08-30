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

    TabBar{
    id: tabBar
    width: parent.width

    TabButton {
            text: firstTab.siteName
            width: implicitWidth
        }

    }


    StackLayout {
        id: stackLayout
        anchors.top: tabBar.bottom
        width: parent.width
        height: parent.height - tabBar.height
        currentIndex: tabBar.currentIndex

        WebViewItem{
            id:firstTab
            onNewTab: tabBar.addItem(WebViewItem)
        }



    }

}
