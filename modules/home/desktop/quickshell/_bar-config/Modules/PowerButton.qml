import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Widgets
import qs.Widgets

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
                id: button

                Image {
                        source: "../nixos.svg"
                        fillMode: Image.PreserveAspectFit
                        sourceSize.width: 1024
                        sourceSize.height: 1024
                }

                onClicked: mouse => {
                        menu.visible = !menu.visible;
                };
        }

        PopupWindow {
                id: menu

                visible: false;
                grabFocus: true;

                // needed so the menu isn't tiny
                implicitWidth: powerMenu.implicitWidth
                implicitHeight: powerMenu.implicitHeight

                anchor.window: root;
                anchor.item: root;
                anchor.edges: Edges.Bottom | Edges.Right
                anchor.gravity: Edges.Bottom | Edges.Left
                anchor.margins.bottom: -4; // increase gap between button and menu

                PowerMenu {
                        id: powerMenu
                        anchors.fill: parent
                        inhibitor: inhibitor
                }
        }


        IdleInhibitor {
                id: inhibitor;
                window: inhibitorTarget;
                enabled: false;
        }
}
