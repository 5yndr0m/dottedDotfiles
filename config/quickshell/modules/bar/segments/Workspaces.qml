// WorkSpace.qml
import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

ColumnLayout {
    id: root
    spacing: 10

    implicitHeight: {
        let totalHeight = 0;
        for (let i = 0; i < repeater.count; i++) {
            let item = repeater.itemAt(i);
            if (item) {
                totalHeight += item.height;
            }
        }
        return totalHeight + (repeater.count - 1) * spacing;
    }

    Repeater {
        id: repeater
        model: Hyprland.workspaces

        Rectangle {
            id: oneSpace
            required property var modelData

            width: 15
            height: modelData.active ? 20 : 15
            radius: 5

            Layout.preferredHeight: height
            Layout.preferredWidth: width

            color: {
                if (modelData.focused)
                    return "#cba6f7";
                if (modelData.active)
                    return "#b4befe";
                if (modelData.urgent)
                    return "#f38ba8";  // Red for urgent
                if (modelData.hasFullscreen)
                    return "#fab387";  // Orange for fullscreen
                if (modelData.toplevels.length > 0) // no idea what this is
                    return "#a6adc8";
                return "#cdd6f4";
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: oneSpace.modelData.activate()
            }

            Behavior on color {
                ColorAnimation {
                    duration: 150
                    easing.type: Easing.OutCubic
                }
            }

            scale: mouseArea.containsMouse ? 1.2 : 1.0
            Behavior on scale {
                NumberAnimation {
                    duration: 100
                    easing.type: Easing.OutCubic
                }
            }
            onHeightChanged: root.implicitHeightChanged()
        }
    }
}
