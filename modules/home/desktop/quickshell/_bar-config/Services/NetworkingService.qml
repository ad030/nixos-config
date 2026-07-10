pragma Singleton

import Quickshell
import Quickshell.Networking

Singleton {
        id: root

        readonly property var connectedDevice: {
                const devices = Networking.devices.values
                return devices.find(d => d.type === DeviceType.Wired && d.connected)
                ?? devices.find(d => d.type === DeviceType.Wifi && d.connected)
                ?? null
        }

        readonly property string connectionType: {
                if (!connectedDevice) return "None"
                return connectedDevice.type === DeviceType.Wired ? "Wired" : "Wifi"
        }

        readonly property string connectionName: {
                if (!connectedDevice) return ""
                const net = connectedDevice.networks.values.find(n => n.connected)
                return net ? net.name : ""
        }
}
