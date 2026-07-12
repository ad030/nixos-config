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

                hoverEnabled: true

                onEntered: { 
                        PopupSingleton.open(popup)
                }

                onExited: { 
                        PopupSingleton.close(popup)
                }
        }

        PopupWindow {
                id: popup
                visible: false

                anchor.item: root
                anchor.edges: Edges.Bottom
                anchor.gravity: Edges.Bottom
                anchor.margins.bottom: -4

                implicitHeight: popupChild.implicitHeight
                implicitWidth: popupChild.implicitWidth

                BarModuleRectangle {
                        id: popupChild
                        BarText {
                                text: Qt.formatDateTime(clock.date, "dddd, MMMM M t")
                        }
                }
        }
}
