import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs
import qs.Widgets
import qs.Services

BarModuleRectangle {
        required property ShellScreen screen

        RowLayout {
                spacing: 1

                Repeater {
                        model: NiriService.workspaces.filter(ws => ws.output === screen.name)

                        delegate: WrapperRectangle {        
                                required property var modelData

                                color: modelData.is_focused ? Theme.dark4 : Theme.background

                                WrapperMouseArea {
                                        leftMargin: 10;
                                        rightMargin: 10;
                                        topMargin: 2;
                                        bottomMargin: 2;

                                        BarText {
                                                text: modelData.idx
                                        }

                                        onClicked: {
                                                NiriService.focusWorkspace(modelData.idx)
                                        }
                                }
                        }
                }
        }
}
