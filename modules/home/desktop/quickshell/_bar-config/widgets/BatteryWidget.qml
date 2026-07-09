import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.UPower
import qs

WrapperRectangle {

        visible: battery.isLaptopBattery;

        color: Theme.background;
        border.color: Theme.foreground;
        border.width: 1;
        margin: 4;

        implicitHeight: 42;

        readonly property var battery: UPower.displayDevice;

        readonly property var icon: battery.isCharging === UPowerDeviceState.Charging ? "" : ( 
                battery.percentage > 0.8 ? "" : 
                battery.percentage > 0.6 ? "" : 
                battery.percentage > 0.4 ? "" :
                battery.percentage > 0.2 ? "" : ""
        );

        WrapperItem {
                leftMargin: 10;
                rightMargin: 10;
                topMargin: 4;
                bottomMargin: 4;

                RowLayout {
                        spacing: 2

                        Text {
                                text: icon;

                                color: Theme.foreground;
                                font.family: Theme.iconFontFamily;
                                font.pixelSize: Theme.fontSize;
                                font.weight: Font.Black;
                        }

                        Text {
                                text: Math.round(battery.percentage * 100) + "%"; 

                                color: Theme.foreground;
                                font.family: Theme.fontFamily;
                                font.pixelSize: Theme.fontSize;
                        }
                }
        }
}
