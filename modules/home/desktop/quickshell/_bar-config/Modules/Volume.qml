import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Pipewire
import qs
import qs.Widgets

BarModuleRectangle {
        WrapperMouseArea {

                readonly property var sink: Pipewire.defaultAudioSink;
                readonly property var audio: sink?.audio;

                readonly property var icon: audio ?  
                (
                        audio.muted ? "" : 
                        (
                                audio.volume > 0.3 ? "" : 
                                audio.volume > 0 ? "" : ""
                        )
                ) : "";

                PwObjectTracker {
                        objects: sink ? [ sink ] : [];
                }

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
