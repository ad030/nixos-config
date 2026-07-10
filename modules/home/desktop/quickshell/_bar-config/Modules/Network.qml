import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Networking
import qs
import qs.Widgets
import qs.Services

BarModuleRectangle {
        WrapperMouseArea {
                readonly property var wifiIcon: "";
                readonly property var wiredIcon: "";
                readonly property var errorIcon: "";

                RowLayout {
                        spacing: 4

                        BarIconText {
                                text: NetworkingService.connectionType === "Wired" ? wiredIcon : (
                                        NetworkingService.connectionType === "Wifi" ? wifiIcon : errorIcon
                                );
                        }

                        BarText {
                                text: NetworkingService.connectionName; 
                        }
                }
        }
}
