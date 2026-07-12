import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs
import qs.Widgets
import qs.Utilities

BarModuleRectangle {
        WrapperMouseArea {
                RowLayout {
                        // spacing: 4
                        // BarIconText {
                        //         text: ""
                        // }
                        BarText {
                                text: Qt.formatDateTime(clock.date, "yyyy-MM-dd hh:mm")
                        }
                }

                SystemClock {
                        id: clock
                        precision: SystemClock.Minutes
                }

                hoverEnabled: true
                onEntered: { }
        }
}
