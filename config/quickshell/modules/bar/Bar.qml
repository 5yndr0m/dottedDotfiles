// Bar.qml
import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Wayland

import qs.components
import qs.modules.widget
import qs.modules.bar.components

Scope {

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: rootbar
            required property var modelData
            screen: modelData

            anchors {
                top: true
                left: true
                bottom: true
            }

            implicitWidth: 40

            color: "#1e1e2e"

            ColumnLayout {
                anchors.fill: parent
                anchors.topMargin: 5
                anchors.bottomMargin: 5

                WorkspaceWidget {
                    Layout.alignment: Qt.AlignHCenter
                }

                Item {
                    Layout.fillHeight: true
                }

                ClockWidget {
                    Layout.alignment: Qt.AlignHCenter
                }
            }
            ActiveWindow {
                screen: rootbar.modelData
            }

            PanelWindow {
                id: topLeftPanel
                anchors.top: true
                anchors.left: true

                color: "transparent"
                screen: rootbar.modelData
                margins.left: 36
                WlrLayershell.exclusionMode: ExclusionMode.Ignore
                visible: true
                WlrLayershell.layer: WlrLayer.Bottom
                aboveWindows: false
                implicitHeight: 24

                Corner {
                    id: topLeftCorner
                    position: "bottomleft"
                    size: 1.3
                    fillColor: "#1e1e2e"
                    offsetX: -35
                    offsetY: 10
                    anchors.top: parent.top
                }
            }

            PanelWindow {
                id: topRightPanel
                anchors.top: true
                anchors.right: true
                color: "transparent"
                screen: rootbar.modelData
                WlrLayershell.exclusionMode: ExclusionMode.Ignore
                visible: true
                WlrLayershell.layer: WlrLayer.Bottom
                aboveWindows: false

                implicitHeight: 24

                Corner {
                    id: topRightCorner
                    position: "bottomright"
                    size: 1.3
                    fillColor: "#1e1e2e"
                    offsetX: 39
                    offsetY: 10
                    anchors.top: parent.top
                }
            }

            PanelWindow {
                id: bottomLeftPanel
                anchors.bottom: true
                anchors.left: true
                color: "transparent"
                screen: rootbar.modelData
                margins.left: 40
                WlrLayershell.exclusionMode: ExclusionMode.Ignore
                visible: true
                WlrLayershell.layer: WlrLayer.Bottom
                aboveWindows: false

                implicitHeight: 24

                Corner {
                    id: bottomLeftCorner
                    position: "topleft"
                    size: 1.3
                    fillColor: "#1e1e2e"
                    offsetX: -39
                    offsetY: -2
                    anchors.top: parent.top
                }
            }

            PanelWindow {
                id: bottomRightPanel
                anchors.bottom: true
                anchors.right: true
                color: "transparent"
                screen: rootbar.modelData
                WlrLayershell.exclusionMode: ExclusionMode.Ignore
                visible: true
                WlrLayershell.layer: WlrLayer.Bottom
                aboveWindows: false

                implicitHeight: 24

                Corner {
                    id: bottomRightCorner
                    position: "topright"
                    size: 1.3
                    fillColor: "#1e1e2e"
                    offsetX: 39
                    offsetY: -2
                    anchors.top: parent.top
                }
            }
        }
    }
}
