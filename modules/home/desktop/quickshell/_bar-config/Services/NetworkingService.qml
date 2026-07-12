pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Networking

Singleton {
        id: root

        Process {
                id: ipv4Proc
                command: [ "sh", "-c", "ip -4 addr show " + connectedDevice.name + " | grep -oP '(?<=inet\\s)\\d+(\\.\\d+){3}'"]
                running: true

                stdout: SplitParser {
                        onRead: data => ipv4 = data
                }
        }

        property string ipv4


        // find connected device
        // prioritise wired devices first
        readonly property var connectedDevice: {
                const devices = Networking.devices.values
                return devices.find(d => d.connected && d.type === DeviceType.Wired) 
                || devices.find(d => d.connected && d.type === DeviceType.Wifi)
                || null
        }

        // return device type as a string
        readonly property string connectedDeviceType: {
                if (!connectedDevice) return "None"
                connectedDevice.type === DeviceType.Wired ? "Wired" : (
                        connectedDevice.type === DeviceType.Wifi ? "Wifi" : "None"
                )
        }

        // search networks of connected device to find currently connected network
        readonly property var connectedNetwork: {
                if (!connectedDevice) return null
                return connectedDevice.networks.values.find(n => n.connected)

        }

        // return network name as string
        readonly property string connectedNetworkName: {
                return connectedNetwork ? connectedNetwork.name : ""
        }

        readonly property real connectedWifiStrength: {
                if (connectedNetwork.device.type !== DeviceType.Wifi) {
                        return -1
                }
                return connectedNetwork.signalStrength
        }

        readonly property int connectedWiredSpeed: {
                if (connectedDevice.type !== DeviceType.Wired) {
                        return -1
                }
                return connectedDevice.linkSpeed
        }

        onConnectedNetworkChanged: {
                ipv4Proc.running = true
        }
}
