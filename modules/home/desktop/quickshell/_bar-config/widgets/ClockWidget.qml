import QtQuick;
import Quickshell;
import Quickshell.Widgets;
import qs

WrapperRectangle {
        color: Theme.background;
        border.color: Theme.foreground;
        border.width: 1;
        margin: 4;

        implicitHeight: 42;

        WrapperMouseArea {
                leftMargin: 10;
                rightMargin: 10;
                topMargin: 4;
                bottomMargin: 4;

                Text {
                        color: Theme.foreground;
                        text: Qt.formatDateTime(clock.date, "yyyy-MM-dd hh:mm")

                        font.family: Theme.fontFamily;
                        font.pixelSize: Theme.fontSize;
                }

                SystemClock {
                        id: clock;
                        precision: SystemClock.Minutes;
                }

                hoverEnabled: true;
                onEntered: { }
        }
}
