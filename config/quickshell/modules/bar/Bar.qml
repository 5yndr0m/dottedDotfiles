// Bar.qml
import Quickshell
import QtQuick
import QtQuick.Layouts

import qs.components
import qs.modules.widget

Scope {
    // no more time object

    Variants {
        model: Quickshell.screens

        PanelWindow {
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

                // Top center - workspaces
                WorkspaceWidget {
                    Layout.alignment: Qt.AlignHCenter
                }

                // Spacer to push clock to bottom
                Item {
                    Layout.fillHeight: true
                }

                // Bottom center - clock
                ClockWidget {
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
    }
}
