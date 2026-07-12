import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Pipewire
import qs
import qs.Widgets
import qs.Utilities

BarModuleRectangle {
        id: root

        readonly property var sink: Pipewire.defaultAudioSink
        readonly property var audio: sink?.audio

        readonly property var icon: audio ?  
        (
                audio.muted ? "" : 
                (
                        audio.volume > 0.5 ? "" : 
                        audio.volume > 0 ? "" : ""
                )
        ) : ""

        PwObjectTracker {
                objects: sink ? [ sink ] : []
        }

        readonly property string volumePercent: Math.round(audio.volume * 100) + "%"


        WrapperMouseArea {
                BarIconText {
                        text: icon
                }

                anchors.fill: parent
                resizeChild: false

                hoverEnabled: true

                onWheel: wheel => {
                        if (!audio) return
                        const step = 0.04
                        if (wheel.angleDelta.y > 0) {
                                audio.volume = Math.min(1, audio.volume + step)
                        } else if (wheel.angleDelta.y < 0) {
                                audio.volume = Math.max(0, audio.volume - step)
                        }
                }

                onClicked: mouse => {
                        if (!audio) return
                        if (mouse.button === Qt.LeftButton) 
                        audio.muted = !audio.muted
                }

                onEntered: {
                        PopupSingleton.open(popup)
                }

                onExited: {
                        PopupSingleton.close(popup)
                }
        }

        PopupWindow {
                id: popup

                anchor.item: root

                visible: false

                implicitWidth: contents.implicitWidth
                implicitHeight: contents.implicitHeight

                anchor.edges: Edges.Bottom
                anchor.gravity: Edges.Bottom
                anchor.margins.bottom: -4

                BarModuleRectangle {
                        id: contents

                        BarText {
                                text: audio.muted ? volumePercent + " (Muted)" : volumePercent
                        }
                }
        }
}
