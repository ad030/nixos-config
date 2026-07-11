import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import Quickshell.Widgets
import qs.Widgets

BarModuleRectangle {
        id: root

        implicitHeight: undefined // don't want default height of 40

        property var inhibitor // IdleInhibitor to enable/disable

        // power menu items and actions to do when clicked
        property var items: [
                {
                        text: inhibitor.enabled ? "Disable idle inhibitor" : "Enable idle inhibitor" ,
                        action: () => inhibitor.enabled = !inhibitor.enabled
                },
                {
                        text: "Lock screen",
                        action: () => { p.exec([ "hyprlock" ]) }
                },
                {
                        text: "Log out",
                        action: () => { p.exec([ "niri", "msg", "action", "quit" ]) }
                },
                {
                        text: "Reboot",
                        action: () => { p.exec([ "reboot" ]) }
                },
                {
                        text: "Shut down",
                        action: () => { p.exec([ "shutdown", "0" ]) }
                },
        ]

        Process {
                id: p
        }


        ColumnLayout {
                spacing: 2

                Repeater {
                        model: root.items
                        WrapperMouseArea {
                                required property var modelData

                                BarText {
                                        text: modelData.text
                                }
                                onDoubleClicked: mouse => modelData.action(mouse)
                        }
                }
        }
}
