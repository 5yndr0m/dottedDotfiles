// WorkspaceWidget.qml
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

ColumnLayout {
    spacing: 5

    Repeater {
        model: Hyprland.workspaces

        Rectangle {
            required property var modelData

            width: 20
            height: 20
            radius: 25

            color: modelData.focused ? "#b4befe" : "#cdd6f4"

            // Text {
            //     anchors.centerIn: parent
            //     text: modelData.id
            //     color: modelData.focused ? "white" : "black"
            //     font.pixelSize: 12
            // }

            MouseArea {
                anchors.fill: parent
                onClicked: modelData.activate()
            }
        }
    }
}
