import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Widgets
import qs

WrapperRectangle {
        id: root

        color: Theme.background;
        border.color: Theme.foreground;
        border.width: 1;
        margin: 4;

        implicitHeight: 42;
        implicitWidth: 42;

        // target status bar as window for idle inhibitor
        property var inhibitorTarget;

        readonly property var icon: "";

        WrapperMouseArea {
                id: button

                margin: 0

                // Text {
                //         text: icon;
                //
                //         color: Theme.foreground;
                //         font.family: Theme.iconFontFamily;
                //         font.pixelSize: Theme.fontSize;
                //         font.weight: Font.Black;
                // }

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

                        leftMargin: 10;
                        rightMargin: 10;
                        topMargin: 4;
                        bottomMargin: 4;

                        ColumnLayout {
                                spacing: 2

                                WrapperMouseArea {
                                        Text {
                                                text: inhibitor.enabled ? "Disable idle inhibitor" : "Enable idle inhibitor";
                                                color: Theme.foreground;
                                                font.family: Theme.fontFamily;
                                                font.pixelSize: Theme.fontSize;
                                        }

                                        onDoubleClicked: mouse => {
                                                inhibitor.enabled = !inhibitor.enabled;
                                        };
                                }
                                WrapperMouseArea {
                                        Text {
                                                text: "Lock screen";
                                                color: Theme.foreground;
                                                font.family: Theme.fontFamily;
                                                font.pixelSize: Theme.fontSize;
                                        }

                                        onDoubleClicked: mouse => {
                                                p.exec ([ "hyprlock" ]);
                                        };
                                }
                                WrapperMouseArea {
                                        Text {
                                                text: "Log out";
                                                color: Theme.foreground;
                                                font.family: Theme.fontFamily;
                                                font.pixelSize: Theme.fontSize;
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
                                        Text {
                                                text: "Reboot";
                                                color: Theme.foreground;
                                                font.family: Theme.fontFamily;
                                                font.pixelSize: Theme.fontSize;
                                        }

                                        onDoubleClicked: mouse => {
                                                p.exec ([ 
                                                        "reboot"
                                                ]);
                                        };
                                }
                                WrapperMouseArea {
                                        Text {
                                                text: "Shut down";
                                                color: Theme.foreground;
                                                font.family: Theme.fontFamily;
                                                font.pixelSize: Theme.fontSize;
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
