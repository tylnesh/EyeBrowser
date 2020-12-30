import QtQuick 2.12
import QtQuick.Window 2.12
import QtWebEngine 1.8
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQml.Models 2.12
import com.eyebrowser.linkvalidator 1.0

ApplicationWindow {
    visible: true
    width: 1920
    height: 1080
    title: qsTr("EyeBrowser")
    id:root




    WebViewItem{
    anchors.fill: parent
    siteURL: "https://edu.ukf.sk/"
    }
}



