import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Networking
import qs

WrapperRectangle {
        color: Theme.background;
        border.color: Theme.foreground;
        border.width: 1;
        margin: 4;

        readonly property var wifiIcon: "";
        readonly property var wiredIcon: "";
        readonly property var errorIcon: "";

        /** 
         * Wifi device and networks
         */
        readonly property var wifiDevice: Networking
        .devices
        .values
        .find(d => d.type === DeviceType.WiFi);

        readonly property var wifiNetwork: {
                if (!wifiDevice) return null;
                return wifiDevice.networks.values.find(n => n.connected);
        }

        /**
         * Wired device and networks
         */
        readonly property var wiredDevice: Networking
        .devices
        .values
        .find(d => d.type === DeviceType.Wired);

        readonly property bool isWiredConnected: {
                if (!wiredDevice) return false;
                return wiredDevice.connected;
        };

        implicitHeight: 40;

        WrapperMouseArea {
                leftMargin: 10;
                rightMargin: 10;
                topMargin: 4;
                bottomMargin: 4;

                RowLayout {
                        spacing: 2

                        Text {
                                text: isWiredConnected ? wiredIcon : (wifiNetwork ? wifiIcon : errorIcon);
                                color: Theme.foreground;
                                font.family: Theme.iconFontFamily;
                                font.pixelSize: Theme.fontSize;
                                font.weight: Font.Black;
                        }

                        Text {
                                text: wifiNetwork ? "connected" : ""; 

                                color: Theme.foreground;
                                font.family: Theme.fontFamily;
                                font.pixelSize: Theme.fontSize;
                        }
                }
        }
}
