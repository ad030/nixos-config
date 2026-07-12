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

        readonly property string wifiIcon: "";
        readonly property string wiredIcon: "";
        readonly property string errorIcon: "";

        property real wifiStrength: NetworkingService.connectedWifiStrength
        property int wiredSpeed: NetworkingService.connectedWiredSpeed 


        WrapperMouseArea {
                BarIconText {
                        text: NetworkingService.connectedDevice.type === DeviceType.Wired ? wiredIcon : (
                                NetworkingService.connectedDevice.type === DeviceType.Wired ? wifiIcon : errorIcon
                        );
                }

                anchors.fill: root
                resizeChild: false

                onClicked: {
                        if (popup.visible) {
                                PopupSingleton.close(popup)
                        } else {
                                PopupSingleton.open(popup)
                        }

                }
        }

        PopupWindow {
                id: popup

                visible: false
                grabFocus: true

                implicitWidth: contents.implicitWidth
                implicitHeight: contents.implicitHeight

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
                                        text: NetworkingService.connectedNetwork.name
                                }
                                BarText {
                                        text: NetworkingService.ipv4
                                }
                                BarText {
                                        visible: NetworkingService.connectedNetwork != null
                                        text: NetworkingService.connectedDeviceType === "Wired" ? wiredSpeed + "Mb/s" : 
                                        (NetworkingService.connectedDeviceType === "Wifi" ? Math.round(wifiStrength * 100) + "%"
                                        : "" )
                                }
                        }
                }
        }
}
