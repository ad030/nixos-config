pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

Singleton {
        id: root

        property var workspaces: []
        property var windows: []
        property var outputs: []

        Component.onCompleted: {
                if (Quickshell.env("NIRI_SOCKET")) {
                        eventStream.connected = true
                        commandSocket.connected = true
                }
        }

        // onWorkspacesChanged: {
        //         console.log(workspaces)
        // }


        function sendSocketCommand(socket: Socket, command: var): void {
                if (socket.connected) {
                        socket.write(JSON.stringify(command) + "\n");
                        socket.flush();
                }
        }

        function focusWorkspace(id: int): void {
                sendSocketCommand(commandSocket, {
                        "Action": {
                                "FocusWorkspace": {
                                        "reference": { "Index": id }
                                }
                        }
                })
        }

        Socket {
                id: eventStream
                path: Quickshell.env("NIRI_SOCKET") || ""
                connected: false

                onConnectedChanged: {
                        if (connected) 
                                sendSocketCommand(eventStream, "EventStream")
                }

                parser: SplitParser {
                        splitMarker: "\n"
                        onRead: (data) => {
                                if (!data.trim()) return

                                try {
                                        const event = JSON.parse(data)

                                        if (event.WorkspacesChanged) {
                                                sendSocketCommand(commandSocket, "Workspaces")
                                        }
                                        else if (event.WorkspaceActivated) {
                                                sendSocketCommand(commandSocket, "Workspaces")
                                        }
                                } catch (e) {
                                        console.warn("Niri socket parse error", e)
                                }
                        }
                }
        }

        Socket {
                id: commandSocket
                path: Quickshell.env("NIRI_SOCKET") || ""
                connected: false

                parser: SplitParser {
                        onRead: (line) => {
                                if (!line.trim()) return
                                try {
                                        const data = JSON.parse(line)
                                        if (data?.Ok) {
                                                const res = data.Ok
                                                if (res.Workspaces) {
                                                        workspaces = res.Workspaces.sort((a, b) => a.idx - b.idx)
                                                } else if (res.Windows) {
                                                        windows = res.Windows
                                                } else if (res.Outputs) {
                                                        outputs = res.Outputs
                                                }
                                        }
                                } catch (e) {
                                        console.warn("Niri socket parse error:", e)
                                }
                        }
                }
        }

}
