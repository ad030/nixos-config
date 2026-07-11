import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Widgets
import qs
import qs.Widgets

BarModuleRectangle {
        id: root

        implicitWidth: root.implicitHeight;

        leftMargin: 0;
        rightMargin: 0;
        topMargin: 0;
        bottomMargin: 0;

        resizeChild: true;

        // target status bar as window for idle inhibitor
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

                implicitWidth: menuWrapper.implicitWidth
                implicitHeight: menuWrapper.implicitHeight

                anchor.window: root;
                anchor.item: root;
                anchor.edges: Edges.Bottom   
                anchor.gravity: Edges.Bottom
                // anchor.margins.bottom: -4; // increase gap between button and menu

                color: Theme.background;

                Process {
                        id: p
                }

                WrapperRectangle {
                        id: menuWrapper
                        anchors.fill: parent;
                        color: Theme.background;
                        border.color: Theme.foreground;
                        border.width: 1;

                        leftMargin: 12;
                        rightMargin: 12;
                        topMargin: 6;
                        bottomMargin: 6;

                        ColumnLayout {
                                spacing: 2

                                WrapperMouseArea {
                                        BarText {
                                                text: inhibitor.enabled ? "Disable idle inhibitor" : "Enable idle inhibitor";
                                        }

                                        onDoubleClicked: mouse => {
                                                inhibitor.enabled = !inhibitor.enabled;
                                        };
                                }
                                WrapperMouseArea {
                                        BarText {
                                                text: "Lock screen";
                                        }

                                        onDoubleClicked: mouse => {
                                                p.exec ([ "hyprlock" ]);
                                        };
                                }
                                WrapperMouseArea {
                                        BarText {
                                                text: "Log out";
                                        }

                                        onDoubleClicked: mouse => {
                                                p.exec ([ 
                                                        "niri", 
                                                        "msg", 
                                                        "action", 
                                                        "quit" 
                                                ]);
                                        };
                                }
                                WrapperMouseArea {
                                        BarText {
                                                text: "Reboot";
                                        }

                                        onDoubleClicked: mouse => {
                                                p.exec ([ 
                                                        "reboot"
                                                ]);
                                        };
                                }
                                WrapperMouseArea {
                                        BarText {
                                                text: "Shut down";
                                        }

                                        onDoubleClicked: mouse => {
                                                p.exec ([ 
                                                        "shutdown",
                                                        "0"
                                                ]);
                                        };
                                }
                        }
                }

        }

        IdleInhibitor {
                id: inhibitor;
                window: inhibitorTarget;
                enabled: false;
        }
}
