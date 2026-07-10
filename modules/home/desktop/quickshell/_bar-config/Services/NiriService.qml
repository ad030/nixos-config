pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {

        Socket {
                id: niriSocket
                path: Quickshell.env("NIRI_SOCKET") ?? ""
                connected: path.length > 0
        }

}
