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

        readonly property string wifiIcon: "";
        readonly property string wiredIcon: "";
        readonly property string errorIcon: "";

        property real wifiStrength: NetworkingService?.connectedWifiStrength
        property int wiredSpeed: NetworkingService?.connectedWiredSpeed 

        WrapperMouseArea {
                BarIconText {
                        text: NetworkingService.connectedDevice?.type === DeviceType.Wired ? wiredIcon : (
                                NetworkingService.connectedDevice?.type === DeviceType.Wifi ? wifiIcon : 
                                errorIcon
                        );
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
                };
        }

        PopupWindow {
                id: popup

                visible: false

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
