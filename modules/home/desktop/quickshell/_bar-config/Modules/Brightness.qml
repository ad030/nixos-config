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

        property int value

        WrapperMouseArea {
                BarIconText {
                        text: icon;
                }

                hoverEnabled: true
                onWheel: wheel => {
                        const step = 4
                        if (wheel.angleDelta.y > 0) 
                        BrightnessService.increasePercent(step)
                        else if (wheel.angleDelta.y < 0) 
                        BrightnessService.decreasePercent(step)

                };

                onEntered: {
                        PopupSingleton.open(popup)
                }
                onExited: {
                        PopupSingleton.close(popup)
                }
        }

        PopupWindow {
                id: popup
                visible: false

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
