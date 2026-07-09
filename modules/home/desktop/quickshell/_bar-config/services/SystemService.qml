pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
        property real avgCpuLoad

        property real usedRamPercent
        property int totalRam
        property int usedRam
        property int availableRam

        SplitParser {
                id: parser
                splitMarker: "\n"
        }

        Process {
                id: cpuProc
                running: true
                command: [];

                stdout: StdioCollector {
                        id: cpuCollector
                        onStreamFinished: {
                                let output = cpuCollector.text.trim().split("\n")
                        }
                }
        }

        Process {
                id: memoryProc
                running: true
                command: ["sh" "-c" "cat /proc/meminfo | grep 'Mem' | awk '{printf \"%d %d %d\", $2, $3, $7}'" ];

                stdout: StdioCollector {
                        id: memCollector
                        onStreamFinished: {
                                let output = memCollector.text.trim().split(" ")
                                if (output.length >= 3) {
                                        totalRam = parseInt(output[0])
                                        usedRam = parseInt(output[1])
                                        availableRam = parseInt(output[2])
                                        usedRamPercent = 1.0 * usedRam / totalRam
                                }
                        }
                }

        }

        Timer {
                interval: 2000
                running: true
                repeat: true
                onTriggered: {
                        cpuProc.running = true
                        memoryProc.running = true
                }
        }
}
