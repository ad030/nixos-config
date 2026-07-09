import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Pipewire
import qs

WrapperRectangle {
        color: Theme.background;
        border.color: Theme.foreground;
        border.width: 1;
        margin: 4;

        implicitHeight: 42;

        readonly property var sink: Pipewire.defaultAudioSink;
        readonly property var audio: sink?.audio;

        readonly property var icon: audio ?  
        (
                audio.muted ? "\uf6a9" : 
                (
                        audio.volume > 0.3 ? "" : 
                        audio.volume > 0 ? "" : ""
                )
        ) : "";

        PwObjectTracker {
                objects: sink ? [ sink ] : [];
        }

        WrapperMouseArea {
                leftMargin: 10;
                rightMargin: 10;
                topMargin: 4;
                bottomMargin: 4;

                RowLayout {
                        spacing: 2

                        Text {
                                text: icon;

                                color: Theme.foreground;
                                font.family: Theme.iconFontFamily;
                                font.pixelSize: Theme.fontSize;
                                font.weight: Font.Black;
                        }

                        Text {
                                text: audio ? (
                                        audio.muted ? "Muted" : 
                                        Math.round(audio.volume * 100) + "%"
                                ) : "--%"; 

                                color: Theme.foreground;
                                font.family: Theme.fontFamily;
                                font.pixelSize: Theme.fontSize;
                        }
                }

                onWheel: wheel => {
                        if (!audio) return;
                        const step = 0.04;
                        if (wheel.angleDelta.y > 0) 
                        audio.volume = Math.min(1, audio.volume + step);
                        else if (wheel.angleDelta.y < 0) 
                        audio.volume = Math.max(0, audio.volume - step);
                };

                onClicked: mouse => {
                        if (!audio) return;
                        if (mouse.button === Qt.LeftButton) 
                        audio.muted = !audio.muted;
                };
        }
}
