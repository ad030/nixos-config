import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Mpris
import Quickshell.Wayland
import Quickshell.Widgets
import qs.Widgets

BarModuleRectangle {
        id: root

        property var player: {
                const players = Mpris.players.values
                return players.find(p => p.playing) || players[0] || null
        }

        property string trackTitle: player?.trackTitle || "Unknown Title"
        property string artist: player?.trackAlbumArtist || player?.trackArtist || "Unknown Artist"

        property string finalText: player?.playbackState !== MprisPlaybackState.Stopped ? artist + " - " + trackTitle : "..."

        // property string icon: player?.playbackState !== MprisPlaybackState.Stopped ? (player.isPlaying ? "" : "") : ""
        property string icon: ""


        WrapperMouseArea {
                RowLayout {
                        spacing: 4
                        BarIconText {
                                text: icon
                        }
                        BarText {
                                text: finalText
                        }
                }

                onClicked: {
                        if (popup.visible) {
                                PopupSingleton.close(popup)
                        } else {
                                PopupSingleton.open(popup)
                        }
                }
        }

        PopupWindow {
                id: popup

                visible: false
                grabFocus: true

                implicitWidth: menu.implicitWidth
                implicitHeight: menu.implicitHeight

                anchor.item: root

                anchor.edges: Edges.Bottom
                anchor.gravity: Edges.Bottom
                anchor.margins.bottom: -4

                MprisMenu {
                        id: menu
                        player: root.player
                }
        }
}
