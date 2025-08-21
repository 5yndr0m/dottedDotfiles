import Quickshell
import QtQuick
import Quickshell.Wayland
import qs.components

Item {
    id: baseItem
    required property var modelData

    // ONE window instead of FOUR
    PanelWindow {
        id: cornersWindow
        screen: baseItem.modelData
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore // Make it ignore inputs
        WlrLayershell.layer: WlrLayer.Bottom // Or Bottom, whichever works best
        anchors.top: true // Cover the whole screen
        anchors.right: true // Cover the whole screen
        anchors.bottom: true // Cover the whole screen
        anchors.left: true // Cover the whole screen

        // Top-Left Corner
        Corner {
            id: topLeftCorner
            position: "bottomleft"
            size: 1.3
            fillColor: "#1e1e2e"
            offsetX: 0
            offsetY: 0
            // Anchor it to the top-left of the *cornersWindow*
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.leftMargin: 1
        }

        // Top-Right Corner
        Corner {
            id: topRightCorner
            position: "bottomright"
            size: 1.3
            fillColor: "#1e1e2e"
            offsetX: 45
            offsetY: 10
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.rightMargin: -39
            anchors.topMargin: 0
        }

        // Bottom-Left Corner
        Corner {
            id: bottomLeftCorner
            position: "topleft"
            size: 1.3
            fillColor: "#1e1e2e"
            offsetX: 0
            offsetY: 0
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.leftMargin: 1
            anchors.bottomMargin: -52
        }

        // Bottom-Right Corner
        Corner {
            id: bottomRightCorner
            position: "topright"
            size: 1.3
            fillColor: "#1e1e2e"
            offsetX: -39
            offsetY: -2
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.bottomMargin: -54
            anchors.rightMargin: -39
        }
    }
}
