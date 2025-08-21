import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.modules.bar.segments

Item {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: barInstance
            required property var modelData
            screen: modelData
            implicitWidth: 40
            color: "#1e1e2e"

            anchors.top: true
            anchors.left: true
            anchors.bottom: true

            ScreenCorners {
                modelData: barInstance.screen
            }

            // Use a Column to stack segments vertically
            ColumnLayout {
                anchors.fill: parent // Fill the entire bar
                spacing: 0 // No space between segments
                anchors.topMargin: 20
                anchors.bottomMargin: 20

                Workspaces {
                    Layout.alignment: Qt.AlignHCenter
                }

                // Top Group: Status Items
                ActiveWindow {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 30
                    model: barInstance.modelData
                }

                // Middle Spacer: Pushes items to top and bottom
                Item {
                    Layout.fillHeight: true
                }

                // Bottom Group: System Tray & Controls
                // TrayMenu {
                //     Layout.fillWidth: true
                //     Layout.preferredHeight: 30
                // }

                ClockWidget {
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
    }
}
