import Quickshell
import QtQuick.Layouts
import qs.widgets

Scope {
        Variants {
                model: Quickshell.screens

                PanelWindow {
                        id: barRoot;

                        required property var modelData
                        screen: modelData

                        margins {
                                right: 2; 
                                bottom: 2; 
                                top: 2; 
                                left: 2;
                        }

                        color: "transparent"

                        anchors {
                                top: true
                                left: true
                                right: true
                        }

                        implicitHeight: 42
                        // implicitHeight: 40

                        // left modules
                        RowLayout {
                                anchors.left: parent.left
                                spacing: 4;
                        }

                        // centre modules
                        RowLayout {
                                anchors.centerIn: parent
                                spacing: 4;
                        }
                        
                        // right modules
                        RowLayout {
                                anchors.right: parent.right
                                spacing: 4;

                                VolumeWidget {}
                                // NetworkingWidget {}
                                BatteryWidget {}
                                ClockWidget {}
                                PowerOffWidget {
                                        inhibitorTarget: barRoot
                                }
                        }

                }
        }
}
