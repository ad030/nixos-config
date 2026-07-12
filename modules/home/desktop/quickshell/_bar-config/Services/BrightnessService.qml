pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
        id: root

        property string device: ""
        property bool hasBacklightDevice: false
        property int maxBrightness: 1
        property int currentBrightness: 0

        Process {
                id: listDevices
                command: ["sh", "-c", "ls /sys/class/backlight 2>/dev/null"]
                running: true

                stdout: SplitParser {
                        onRead: (data) => {
                                const devices = data.trim().filter(d => d.length > 0)
                                if (devices.length > 0) {
                                        root.device = devices[0]
                                        root.hasBacklightDevice = true
                                } else {
                                        root.hasBacklightDevice = false
                                }
                        }
                }
        }

        Process {
                id: ctl
        }

        FileView {
                id: maxFile
                path: root.hasBacklightDevice ? "/sys/class/backlight/" + root.device + "/max_brightness" : ""

                onLoaded: root.maxBrightness = parseInt(text())
        }

        FileView {
                id: currentFile
                path: root.hasBacklightDevice ? "/sys/class/backlight/" + root.device + "/brightness" : ""

                watchChanges: true
                onFileChanged: this.reload()
                onLoaded: root.currentBrightness = parseInt(text())
        }

        // set brightness to a specific percentage of max
        function setPercent(p: int): void {
                if (!hasBacklightDevice) return
                ctl.exec(["brightnessctl", "set", p + "%" ])
        }

        function increasePercent(p: int): void {
                if (!hasBacklightDevice) return
                ctl.exec(["brightnessctl", "set", "+" + p + "%" ])
        }

        function decreasePercent(p: int): void {
                if (!hasBacklightDevice) return
                ctl.exec(["brightnessctl", "set", p + "%-" ])
        }
}
