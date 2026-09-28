import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell.Services.Mpris
import qs.Widgets

BarModuleRectangle {
        id: root

        // implicitHeight: undefined // don't want default height of 40

        property var player // player to play/pause/skip

        // power menu items and actions to do when clicked
        property var items: [
                {
                        icon: "skip_previous",
                        action: () => { 
                                if (player?.canGoPrevious) { player.previous() }
                        }
                },
                {
                        icon: player?.isPlaying ? "pause" : "play_arrow",
                        action: () => {
                                if (player?.canTogglePlaying) { player.togglePlaying() } 
                        }
                },
                {
                        icon: "stop",
                        action: () => {
                                if (player?.canControl) { player.stop() }
                        }
                },
                {
                        icon: "skip_next",
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
                        icon: player?.loopState == MprisLoopState.Track ? "repeat_one_on" : 
                                (player?.loopState == MprisLoopState.Playlist ? "repeat_on" : "repeat"),
                        action: () => {
                                if (player && player.canControl && player.loopSupported) { 
                                        switch(player.loopState) {
                                                case MprisLoopState.None:
                                                        player.loopState = MprisLoopState.Playlist;
                                                        break;
                                                case MprisLoopState.Playlist:
                                                        player.loopState = MprisLoopState.Track;
                                                        break;
                                                case MprisLoopState.Track:
                                                        player.loopState = MprisLoopState.None;
                                                        break;
                                                default:
                                                        break;
                                        }
                                }
                        }
                },
                {
                        icon: player?.shuffle ? "shuffle_on" : "shuffle",
                        action: () => {
                                if (player && player.canControl && player.shuffleSupported) { 
                                        player.shuffle = !(player.shuffle)
                                }
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
