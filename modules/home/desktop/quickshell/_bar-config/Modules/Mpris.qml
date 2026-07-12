import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Mpris
import Quickshell.Wayland
import Quickshell.Widgets
import qs.Widgets
import qs.Utilities

BarModuleRectangle {
        id: root

        property var player: {
                const players = Mpris.players.values
                return players.find(p => p.isPlaying) 
        }

        property string trackTitle: player?.trackTitle || "Unknown Title"
        property string artist: player?.trackAlbumArtist || player?.trackArtist || "Unknown Artist"

        // only show if player is not stopped
        // format: <artist> - <title>
        property string finalText: player?.playbackState !== MprisPlaybackState.Stopped ? artist + " - " + trackTitle : "..."

        property string icon: ""

        WrapperMouseArea {
                RowLayout {
                        spacing: 4
                        BarIconText {
                                text: icon
                        }

                        // text with scrolling
                        Item {
                                id: textContainer

                                implicitWidth: Math.min(210, text1.implicitWidth) // width of text is at most 210, then scrolling begins
                                implicitHeight: text1.implicitHeight
                                clip: true

                                property int gap: 30 // gap between current and next string
                                property bool needsScroll: text1.implicitWidth > textContainer.width // only need to scroll if string is longer than implicit width

                                // store two text items in row for infinite scrolling
                                // (need second item to appear from right after end of first)
                                RowLayout {
                                        id: scrollingTextRow

                                        spacing: textContainer.gap
                                        x: 0

                                        BarText {
                                                id: text1
                                                text: finalText
                                        }
                                        BarText {
                                                id: text2
                                                text: finalText
                                                visible: textContainer.needsScroll
                                        }
                                }

                                onNeedsScrollChanged: resetScroll()
                                Component.onCompleted: resetScroll()

                                Connections {
                                        target: root
                                        // reset scroll to beginning when track changes
                                        function onFinalTextChanged() { textContainer.resetScroll() }
                                }

                                function resetScroll() {
                                        scrollAnim.stop()
                                        scrollingTextRow.x = 0
                                        if (needsScroll) {
                                                scrollAnim.start()
                                        }
                                }

                                // scroll through artist and title text continuously
                                NumberAnimation {
                                        id: scrollAnim
                                        target: scrollingTextRow
                                        property: "x"
                                        running: false

                                        loops: Animation.Infinite
                                        easing.type: Easing.Linear

                                        // scroll animation ends exactly at beginning of second text item
                                        // decreasing x = scrolling text to left
                                        from: 0
                                        to: -(text1.implicitWidth + textContainer.gap) 
                                        duration: Math.max(0, (text1.implicitWidth + textContainer.gap) * 40)
                                }
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
