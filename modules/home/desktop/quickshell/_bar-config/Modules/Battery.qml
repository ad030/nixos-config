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

                hoverEnabled: true
                onEntered: {
                        PopupSingleton.open(popup)
                }
                onExited: {
                        PopupSingleton.close(popup)
                }
        }

        PopupWindow {
                id: popup
                visible: false

                anchor.item: root
                anchor.edges: Edges.Bottom
                anchor.gravity: Edges.Bottom
                anchor.margins.bottom: -4

                implicitHeight: contents.implicitHeight
                implicitWidth: contents.implicitWidth

                BarModuleRectangle {
                        id: contents
                        BarText {
                                text: Math.round(battery.percentage * 100) + "%"; 
                        }
                }
        }
}
