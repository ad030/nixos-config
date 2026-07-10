import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.UPower
import qs
import qs.Widgets

BarModuleRectangle {

        visible: battery.isLaptopBattery;

        readonly property var battery: UPower.displayDevice;

        readonly property var icon: battery.isCharging === UPowerDeviceState.Charging ? "" : ( 
                battery.percentage > 0.8 ? "" : 
                battery.percentage > 0.6 ? "" : 
                battery.percentage > 0.4 ? "" :
                battery.percentage > 0.2 ? "" : ""
        );

        RowLayout {
                spacing: 2

                BarIconText {
                        text: icon;
                }

                BarText {
                        text: Math.round(battery.percentage * 100) + "%"; 
                }
        }
}
