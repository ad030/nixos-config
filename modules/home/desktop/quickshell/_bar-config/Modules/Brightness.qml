import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import qs
import qs.Services
import qs.Utilities
import qs.Widgets

BarModuleRectangle {
        id: root

        visible: BrightnessService.hasBacklightDevice

        readonly property string icon: ""

        WrapperMouseArea {
                BarIconText {
                        text: icon;
                }

                anchors.fill: parent
                resizeChild: false

                onWheel: wheel => {
                        const step = 4
                        if (wheel.angleDelta.y > 0) {
                                BrightnessService.increasePercent(step)
                        } else if (wheel.angleDelta.y < 0) {
                                BrightnessService.decreasePercent(step)
                        }

                };

                // hoverEnabled: true
                // onEntered: {
                //         PopupSingleton.open(popup)
                // }
                // onExited: {
                //         PopupSingleton.close(popup)
                // }

                onClicked: mouse => {
                        if (popup.visible) {
                                PopupSingleton.close(popup)
                        } else {
                                PopupSingleton.open(popup)
                        }
                }

                // change button color on click
                // onPressed: {
                //         root.color = Theme.dark0
                // }
                // onReleased: {
                //         root.color = Theme.background
                // }
        }

        PopupWindow {
                id: popup

                visible: false
                grabFocus: true

                anchor.item: root
                anchor.edges: Edges.Bottom
                anchor.gravity: Edges.Bottom
                anchor.margins.bottom: -4

                implicitHeight: Math.ceil(contents.implicitHeight)
                implicitWidth: Math.ceil(contents.implicitWidth)

                BarModuleRectangle {
                        id: contents
                        BarText {
                                text: BrightnessService.hasBacklightDevice ? Math.round(BrightnessService.currentBrightnessPercent * 100) + "%" : "--%"
                        }
                }
        }
}
