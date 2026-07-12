import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import qs.Widgets
import qs.Utilities

BarModuleRectangle {
        id: root

        implicitWidth: root.implicitHeight;

        leftMargin: 0;
        rightMargin: 0;
        topMargin: 0;
        bottomMargin: 0;

        resizeChild: true;

        // target status bar popupwindow as window for idle inhibitor
        property var inhibitorTarget


        WrapperMouseArea {
                Image {
                        source: "../nixos.svg"
                        fillMode: Image.PreserveAspectFit
                        sourceSize.width: 1024
                        sourceSize.height: 1024
                }

                anchors.fill: parent
                resizeChild: true // needed for the svg icon to not be huge

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

                visible: false;
                grabFocus: true;

                // needed so the menu isn't tiny
                implicitWidth: menu.implicitWidth
                implicitHeight: menu.implicitHeight

                anchor.item: root;
                anchor.edges: Edges.Bottom | Edges.Right
                anchor.gravity: Edges.Bottom | Edges.Left
                anchor.margins.bottom: -4; // increase gap between button and menu

                PowerMenu {
                        id: menu
                        inhibitor: inhibitor
                }
        }


        IdleInhibitor {
                id: inhibitor;
                window: inhibitorTarget;
                enabled: false;
        }
}
