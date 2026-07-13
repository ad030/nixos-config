import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import qs.Widgets

BarModuleRectangle {
        id: root

        // implicitHeight: undefined // don't want default height of 40

        property var player // player to play/pause/skip

        // power menu items and actions to do when clicked
        property var items: [
                {
                        icon: "",
                        action: () => { 
                                if (player?.canGoPrevious) { player.previous() }
                        }
                },
                {
                        icon: player?.isPlaying ? "" : "",
                        action: () => {
                                if (player?.canPlay) { player.togglePlaying() } 
                        }
                },
                {
                        icon: "",
                        action: () => { 
                                if (player?.canGoNext) { player.next() } 
                        }
                },
                { 
                        // add gap in menu
                        icon: " ",
                        action: { }
                },
                {
                        icon: "",
                        action: () => {
                                if (player?.canControl) { player.stop() }
                        }
                },
        ]

        RowLayout {
                spacing: 4

                Repeater {
                        model: root.items
                        WrapperMouseArea {
                                required property var modelData

                                BarIconText {
                                        text: modelData.icon
                                }
                                onClicked: mouse => modelData.action(mouse)
                        }
                }
        }
}
