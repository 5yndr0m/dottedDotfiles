import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Widgets

import qs.components

Item {
    id: baseItem
    required property var model

    PanelWindow {
        id: basePanel
        anchors.top: true
        anchors.right: true
        color: "transparent"
        implicitWidth: 300
        implicitHeight: 100
        WlrLayershell.exclusionMode: ExclusionMode.Ignore
        screen: (typeof modelData !== 'undefined' ? modelData : null)

        Item {
            id: titleWrapper
            width: parent.width
            property int cornerHeight: 20
            property int fullHeight: mainContent.height + cornerHeight
            property bool shouldShow: false
            property bool finallyHidden: false

            Timer {
                id: visibilityTimer
                interval: 1200
                running: false
                onTriggered: {
                    titleWrapper.shouldShow = false;
                    hideTimer.restart();
                }
            }

            Timer {
                id: hideTimer
                interval: 350  // Slightly longer than animations
                running: false
                onTriggered: {
                    titleWrapper.finallyHidden = true;
                }
            }

            Connections {
                target: ToplevelManager
                function onActiveToplevelChanged() {
                    if (ToplevelManager.activeToplevel?.appId) {
                        titleWrapper.shouldShow = true;
                        titleWrapper.finallyHidden = false;
                        visibilityTimer.restart();
                    } else {
                        titleWrapper.shouldShow = false;
                        hideTimer.restart();
                        visibilityTimer.stop();
                    }
                }
            }

            // Fixed animation properties
            y: shouldShow ? 0 : -mainContent.height
            height: shouldShow ? fullHeight : 1
            opacity: shouldShow ? 1 : 0
            clip: true  // Enable clipping for smooth animations

            Behavior on height {
                NumberAnimation {
                    duration: 300
                    easing.type: Easing.OutQuad
                }
            }
            Behavior on y {
                NumberAnimation {
                    duration: 300
                    easing.type: Easing.OutQuad
                }
            }
            Behavior on opacity {
                NumberAnimation {
                    duration: 250
                }
            }

            Rectangle {
                id: mainContent
                implicitWidth: 200
                implicitHeight: 30
                color: "#1e1e2e"
                anchors.right: parent.right
                anchors.top: parent.top
                bottomLeftRadius: Math.max(0, width / 2)

                Text {
                    text: ToplevelManager.activeToplevel ? ToplevelManager.activeToplevel.title : "No active window"
                    color: "white"
                    anchors.centerIn: parent
                    elide: Text.ElideRight
                    width: parent.width - 20
                }
            }

            Corner {
                id: topLeftCorner
                position: "bottomright"
                size: 1.1
                fillColor: "#1e1e2e"
                offsetX: 45
                offsetY: 10
                anchors.top: parent.top
                anchors.right: mainContent.left
                anchors.rightMargin: -33
                anchors.topMargin: 0
            }

            Corner {
                id: bottomRightCorner
                position: "bottomright"
                size: 1.3
                fillColor: "#1e1e2e"
                offsetX: 45
                offsetY: 10
                anchors.top: mainContent.bottom
                anchors.right: parent.right
                anchors.rightMargin: -39
                anchors.topMargin: 0
            }
        }

        // Control panel visibility based on animation state
        visible: !titleWrapper.finallyHidden
    }
}
