import QtQuick;
import Quickshell;
import Quickshell.Widgets;

WrapperRectangle {
        color: Theme.background;
        border.color: "#ffffff";
        border.width: 1;
        margin: 4;

        WrapperItem {
                leftMargin: 11;
                rightMargin: 11;
                topMargin: 4;
                bottomMargin: 4;

                Text {
                        color: "#ffffff";
                        text: Qt.formatDateTime(clock.date, "yyyy-MM-dd hh:mm")

                        font.family: Theme.fontFamily;
                        font.pixelSize: Theme.fontSize;
                }

                SystemClock {
                        id: clock;
                        precision: SystemClock.Minutes;
                }
        }
}
