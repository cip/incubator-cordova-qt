import QtQuick 1.1
import com.nokia.symbian 1.1
import QtWebKit 1.0
import "cordova_wrapper.js" as CordovaWrapper



PageStackWindow {
    id: appWindow
    initialPage: mainPage
    showToolBar: false
    showStatusBar: true
    Page {
        id: mainPage

        Flickable {
            id: webFlickable

            anchors.fill: parent

            contentHeight: webView.height
            contentWidth: webView.width

            boundsBehavior: "StopAtBounds"
            clip: true

            WebView {

                id: webView
                preferredWidth: mainPage.width
                preferredHeight: mainPage.height

                url: cordova.mainUrl
                settings.javascriptEnabled: true
                settings.localStorageDatabaseEnabled: true
                settings.offlineStorageDatabaseEnabled: true
                settings.localContentCanAccessRemoteUrls: true
                javaScriptWindowObjects: [QtObject{
                        WebView.windowObjectName: "qmlWrapper"

                        function callPluginFunction(pluginName, functionName, parameters) {
                            parameters = eval("("+parameters+")")
                            CordovaWrapper.execMethodOld(pluginName, functionName, parameters)
                        }
                    },
                    QtObject {
                        //Provide console log to javascript functionality
                        // (Appearantly else at least on symbian console log
                        //  produces not output)
                        // Note that in cordova-qt there is a console plugin
                        // with the same objective, but implementing
                        // it here does not require adding js/plugin
                        WebView.windowObjectName: "console"
                        function log(msg) {
                            console.log("[JSLOG] "+msg);
                        }
                    }
                ]

                onLoadFinished: cordova.loadFinished(true)
                onLoadFailed: cordova.loadFinished(false)

                Connections {
                    target: cordova
                    onJavaScriptExecNeeded: {
                        console.log("onJavaScriptExecNeeded: " + js)
                        webView.evaluateJavaScript(js)
                    }

                    onPluginWantsToBeAdded: {
                        console.log("onPluginWantsToBeAdded: " + pluginName)
                        CordovaWrapper.addPlugin(pluginName, pluginObject)
                    }
                }
            }
        }

    }

}
