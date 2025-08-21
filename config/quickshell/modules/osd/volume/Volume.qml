import QtQuick
import Quickshell
import Quickshell.Services.Pipewire
import qs.components

Scope {
    id: root

    property bool shouldShowOsd: false

    // Audio node binding - required for volume controls to work
    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    // Listen for audio changes at the root level
    Connections {
        target: Pipewire.defaultAudioSink?.audio ?? null

        function onVolumeChanged() {
            root.shouldShowOsd = true;
            hideTimer.restart();
        }

        function onMutedChanged() {
            root.shouldShowOsd = true;
            hideTimer.restart();
        }
    }

    // Auto-hide timer
    Timer {
        id: hideTimer
        interval: 2000
        onTriggered: root.shouldShowOsd = false
    }

    // LazyLoader creates/destroys the window as needed
    LazyLoader {
        active: root.shouldShowOsd

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

                    // Volume icon with direct property binding
                    MIcon {
                        iconName: {
                            if (Pipewire.defaultAudioSink?.audio.muted)
                                return "volume_off";
                            let volume = Pipewire.defaultAudioSink?.audio.volume || 0;
                            if (volume > 0.66)
                                return "volume_up";
                            if (volume > 0.33)
                                return "volume_down";
                            return "volume_mute";
                        }
                        iconSize: 24
                        iconColor: "#cdd6f4"
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    // Volume bar
                    Rectangle {
                        width: 300
                        height: 8
                        radius: 4
                        color: "#45475a"
                        anchors.verticalCenter: parent.verticalCenter

                        Rectangle {
                            property real volume: Pipewire.defaultAudioSink?.audio.volume || 0
                            property bool muted: Pipewire.defaultAudioSink?.audio.muted || false

                            width: parent.width * volume
                            height: parent.height
                            radius: parent.radius
                            color: muted ? "#f38ba8" : "#a6e3a1"

                            Behavior on width {
                                NumberAnimation {
                                    duration: 150
                                }
                            }
                            Behavior on color {
                                ColorAnimation {
                                    duration: 150
                                }
                            }
                        }
                    }

                    // Volume percentage
                    Text {
                        text: Math.round((Pipewire.defaultAudioSink?.audio.volume || 0) * 100) + "%"
                        font.pixelSize: 16
                        color: "#cdd6f4"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }

            // Your corner decorations
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
