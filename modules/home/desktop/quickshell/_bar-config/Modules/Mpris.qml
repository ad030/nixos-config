import Quickshell.Services.Mpris
import qs.Widgets

BarModuleRectangle {

        property var player: {
                const players = Mpris.players.values
                return player.find(p => p.isPlaying) 
        }

        property string trackTitle: player.trackTitle || "Unknown Title"
        property string artist: player.trackAlbumArtist || player.trackArtist || "Unknown Artist"

        property string finalText: player ? artist + " - " + trackTitle : "..."

        property string icon: player ? (player.isPlaying "" : "") : ""

        WrapperMouseArea {
                RowLayout {
                        spacing: 2
                        BarIconText {
                                text: icon
                        }
                        BarText {
                                text: finalText
                        }
                }

                onClicked {
                }
        }
}
