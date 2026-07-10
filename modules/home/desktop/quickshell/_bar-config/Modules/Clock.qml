import QtQuick;
import Quickshell;
import Quickshell.Widgets;
import qs
import qs.Widgets

BarModuleRectangle {
        WrapperMouseArea {
                BarText {
                        text: Qt.formatDateTime(clock.date, "yyyy-MM-dd hh:mm")
                }

                SystemClock {
                        id: clock
                        precision: SystemClock.Minutes
                }

                hoverEnabled: true
                onEntered: { }
        }
}
