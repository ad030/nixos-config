import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import qs
import qs.Widgets

BarModuleRectangle {
        readonly property str icon: ""

        property int value

        Process {
                id: p
        }

        Process {
                id: brightness
        }

        WrapperMouseArea {
                RowLayout {
                        spacing: 4

                        BarIconText {
                                text: icon;
                        }

                        BarText {
                                text: audio ? (
                                        audio.muted ? "Muted" : 
                                        Math.round(audio.volume * 100) + "%"
                                ) : "--%"; 
                        }
                }

                onWheel: wheel => {
                        if (!audio) return;
                        const step = 0.04;
                        if (wheel.angleDelta.y > 0) 
                        p.exec(["brightnessctl", "set", "+4%"]);
                        else if (wheel.angleDelta.y < 0) 
                        p.exec(["brightnessctl", "set", "4%-"]);
                };

                onClicked: mouse => {
                        if (!audio) return;
                        if (mouse.button === Qt.LeftButton) 
                        audio.muted = !audio.muted;
                };
        }
}
