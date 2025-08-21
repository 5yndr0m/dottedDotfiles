import QtQuick
import Quickshell
import Quickshell.Wayland

import qs.components

Item {
    id: baseItem

    PanelWindow {
        id: basePanel

        implicitWidth: 300
        implicitHeight: 100
        // implicitWidth: screen.width
        // implicitHeight: screen.height
        // color: visible ? overlayColor : "transparent"
        color: "transparent"
        // visible: false
        WlrLayershell.exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Bottom
        anchors.top: true
        anchors.left: true
        anchors.right: true
        anchors.bottom: true
        margins.left: 40

        Rectangle {
            id: main
            color: "#1e1e2e"
            // anchors.bottom: basePanel.bottom
            // anchors.left: basePanel.left
            // anchors.top: basePanel.top
            anchors.verticalCenter: parent.verticalCenter
            implicitWidth: 200
            implicitHeight: 100
            bottomRightRadius: 32
            topRightRadius: 32
        }

        Corner {
            id: topLeftCorner
            position: "bottomleft"
            size: 1.5
            fillColor: "#1e1e2e"
            anchors.top: main.bottom
            anchors.leftMargin: 20
            offsetX: -45
            offsetY: 0
        }

        Corner {
            id: bottomLeftCorner
            position: "topleft"
            size: 1.5
            fillColor: "#1e1e2e"
            anchors.bottom: main.top
            anchors.bottomMargin: -60
            offsetY: 0
            offsetX: -45
        }
    }
}
