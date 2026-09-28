import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Networking
import Quickshell.Widgets
import qs
import qs.Widgets
import qs.Services
import qs.Utilities

BarModuleRectangle {
        id: root

        implicitWidth: root.implicitHeight

        readonly property string wifiIcon: wifiStrength ? (
                wifiStrength < 0.33 ? "wifi_1_bar" :
                wifiStrength < 0.66 ? "wifi_2_bar" : "wifi")
                : "wifi"
        readonly property string wiredIcon: "settings_ethernet"
        readonly property string errorIcon: "wifi_off"

        property real wifiStrength: NetworkingService?.connectedWifiStrength
        property int wiredSpeed: NetworkingService?.connectedWiredSpeed 

        WrapperMouseArea {
                BarIconText {
                        text: NetworkingService.connectedDevice ? (
                                NetworkingService.connectedDevice.type === DeviceType.Wired ? wiredIcon : 
                                NetworkingService.connectedDevice.type === DeviceType.Wifi ? wifiIcon : 
                                errorIcon
                        ) : errorIcon;
                }

                anchors.fill: root
                resizeChild: false

                // hoverEnabled: true
                //
                // onEntered: { 
                //         PopupSingleton.open(popup)
                // }
                //
                // onExited: { 
                //         PopupSingleton.close(popup)
                // }
                //

                onClicked: mouse => {
                        if (popup.visible) {
                                PopupSingleton.close(popup)
                        } else {
                                PopupSingleton.open(popup)
                        }
                }

                // change button color on click
                // onPressed: {
                //         root.color = Theme.dark0
                // }
                // onReleased: {
                //         root.color = Theme.background
                // }
        }

        PopupWindow {
                id: popup

                visible: false
                grabFocus: true

                implicitWidth: Math.ceil(contents.implicitWidth)
                implicitHeight: Math.ceil(contents.implicitHeight)

                anchor.item: root

                anchor.edges: Edges.Bottom
                anchor.gravity: Edges.Bottom
                anchor.margins.bottom: -4

                BarModuleRectangle {
                        id: contents

                        implicitHeight: undefined

                        ColumnLayout {
                                spacing: 2

                                BarText {
                                        text: NetworkingService.connectedNetwork ? NetworkingService.connectedNetwork.name : "Disconnected"
                                }
                                BarText {
                                        visible: NetworkingService.connectedDevice !== null && NetworkingService.connectedNetwork !== null
                                        text: this.visible ? 
                                        ( 
                                                NetworkingService.connectedDevice.type === DeviceType.Wired ? wiredSpeed + "Mb/s" : 
                                                NetworkingService.connectedDevice.type === DeviceType.Wifi ? Math.round(wifiStrength * 100) + "%" : ""
                                        ) : "" 
                                }
                                BarText {
                                        visible: NetworkingService.ipv4 !== null
                                        text: this.visible ? NetworkingService.ipv4 : ""
                                }
                        }
                }
        }
}
