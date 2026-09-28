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

        readonly property var battery: UPower.displayDevice;

        readonly property var icon: battery.isCharging === UPowerDeviceState.Charging ? "charger" : ( 
                battery.percentage > 0.95 ? "battery_android_frame_full" : 
                battery.percentage > 0.80 ? "battery_android_frame_6" : 
                battery.percentage > 0.70 ? "battery_android_frame_5" : 
                battery.percentage > 0.55 ? "battery_android_frame_4" : 
                battery.percentage > 0.40 ? "battery_android_frame_3" : 
                battery.percentage > 0.25 ? "battery_android_frame_2" : 
                battery.percentage > 0.10 ? "battery_android_frame_1" : "battery_android_alert"
        );

        implicitWidth: root.implicitHeight

        visible: battery.isLaptopBattery;

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
                grabFocus: true;

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
