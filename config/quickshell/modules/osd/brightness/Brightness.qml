import QtQuick
import Quickshell
import qs.components
import qs.services.brightnessservice

Scope {
    id: root

    property bool shouldShowOsd: false

    // Component.onCompleted: {
    //     console.log("BrightnessService available:", typeof BrightnessService);
    //     console.log("Initial brightness:", BrightnessService.brightness);
    // }

    // Listen for brightness changes from the service
    Connections {
        target: BrightnessService
        function onBrightnessChanged() {  // Use the automatic property signal
            // console.log("Brightness changed - showing OSD");
            root.shouldShowOsd = true;
            hideTimer.restart();
        }
    }

    Timer {
        id: hideTimer
        interval: 2000
        onTriggered: {
            // console.log("Hiding OSD");
            root.shouldShowOsd = false;
        }
    }

    LazyLoader {
        active: root.shouldShowOsd
        // onActiveChanged: {
        //     console.log("LazyLoader active changed:", active);
        // }

        PanelWindow {
            anchors.left: true
            anchors.right: true
            anchors.bottom: true
            color: "transparent"
            exclusionMode: ExclusionMode.Ignore
            implicitHeight: 50
            implicitWidth: 800

            Rectangle {
                id: container
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#1e1e2e"
                implicitHeight: 50
                implicitWidth: 500
                topLeftRadius: Math.max(0, width / 2, 16)
                topRightRadius: Math.max(0, width / 2, 16)

                Row {
                    anchors.centerIn: parent
                    spacing: 15

                    MIcon {
                        iconName: {
                            if (BrightnessService.brightness > 0.66)
                                return "brightness_high";
                            if (BrightnessService.brightness > 0.33)
                                return "brightness_medium";
                            return "brightness_low";
                        }
                        iconSize: 24
                        iconColor: "#cdd6f4"
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Rectangle {
                        width: 300
                        height: 8
                        radius: 4
                        color: "#45475a"
                        anchors.verticalCenter: parent.verticalCenter

                        Rectangle {
                            width: parent.width * BrightnessService.brightness
                            height: parent.height
                            radius: parent.radius
                            color: "#f9e2af"

                            Behavior on width {
                                NumberAnimation {
                                    duration: 150
                                }
                            }
                        }
                    }

                    Text {
                        text: Math.round(BrightnessService.brightness * 100) + "%"
                        font.pixelSize: 16
                        color: "#cdd6f4"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }

            Corner {
                id: bottomLeftCorner
                position: "topright"
                size: 1.6
                fillColor: "#1e1e2e"
                offsetX: 45
                offsetY: 10
                anchors.top: parent.top
                anchors.right: container.left
                anchors.rightMargin: -48
                anchors.topMargin: 18
            }

            Corner {
                id: bottomRightCorner
                position: "topleft"
                size: 1.6
                fillColor: "#1e1e2e"
                offsetX: 45
                offsetY: 10
                anchors.top: parent.top
                anchors.left: container.right
                anchors.leftMargin: -48
                anchors.topMargin: 18
            }
        }
    }
}
