import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs
import qs.Widgets
import qs.Utilities

BarModuleRectangle {
        id: root

        SystemClock {
                id: clock
                precision: SystemClock.Minutes
        }

        WrapperMouseArea {
                BarText {
                        text: Qt.formatDateTime(clock.date, "yyyy-MM-dd hh:mm")
                }

                anchors.fill: parent
                resizeChild: false

                // hoverEnabled: true
                //
                // onEntered: { 
                //         PopupSingleton.open(popup)
                // }
                //
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
                grabFocus: true

                anchor.item: root
                anchor.edges: Edges.Bottom
                anchor.gravity: Edges.Bottom
                anchor.margins.bottom: -4

                implicitHeight: Math.ceil(contents.implicitHeight)
                implicitWidth: Math.ceil(contents.implicitWidth)

                BarModuleRectangle {
                        id: contents
                        BarText {
                                text: Qt.formatDateTime(clock.date, "dddd, MMMM d t")
                        }
                }
        }
}
