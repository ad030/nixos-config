import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.UPower
import qs
import qs.Widgets
import qs.Utilities

BarModuleRectangle {
        id: root

        implicitWidth: root.implicitHeight

        visible: battery.isLaptopBattery;

        readonly property var battery: UPower.displayDevice;

        readonly property var icon: battery.isCharging === UPowerDeviceState.Charging ? "" : ( 
                battery.percentage > 0.8 ? "" : 
                battery.percentage > 0.6 ? "" : 
                battery.percentage > 0.4 ? "" :
                battery.percentage > 0.2 ? "" : ""
        );

        WrapperMouseArea {
                BarIconText {
                        text: icon;
                }

                anchors.fill: root
                resizeChild: false

                // hoverEnabled: true
                // onEntered: {
                //         PopupSingleton.open(popup)
                // }
                // onExited: {
                //         PopupSingleton.close(popup)
                // }

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

                anchor.item: root
                anchor.edges: Edges.Bottom
                anchor.gravity: Edges.Bottom
                anchor.margins.bottom: -4

                implicitHeight: Math.ceil(contents.implicitHeight)
                implicitWidth: Math.ceil(contents.implicitWidth)

                BarModuleRectangle {
                        id: contents
                        BarText {
                                text: Math.round(battery.percentage * 100) + "%"; 
                        }
                }
        }
}
