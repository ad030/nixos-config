import Quickshell
import QtQuick.Layouts

Scope {
        Variants {
                model: Quickshell.screens

                PanelWindow {
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

                        implicitHeight: 40
                        // implicitHeight: 38

                        // left modules
                        RowLayout {
                                anchors.left: parent.left
                                spacing: 4;

                                ClockWidget {}
                                ClockWidget {}
                        }

                        // centre modules
                        RowLayout {
                                anchors.centerIn: parent
                                spacing: 4;

                                ClockWidget {}
                                ClockWidget {}
                        }
                        
                        // right modules
                        RowLayout {
                                anchors.right: parent.right
                                spacing: 4;

                                ClockWidget {}
                                ClockWidget {}
                        }

                }
        }
}
