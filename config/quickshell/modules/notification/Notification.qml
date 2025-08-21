import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications
import Quickshell.Hyprland

import qs.services.notificationservice
import qs.components

Item {
    id: rootItem

    PanelWindow {
        id: root

        // Use Hyprland's focused monitor to determine the screen
        screen: {
            if (Hyprland.focusedMonitor) {
                // Find the corresponding Quickshell screen
                for (let i = 0; i < Quickshell.screens.length; i++) {
                    let quickshellScreen = Quickshell.screens[i];
                    if (quickshellScreen.name === Hyprland.focusedMonitor.name) {
                        return quickshellScreen;
                    }
                }
            }
            // Fallback to primary screen
            return Quickshell.screens[0];
        }

        property ListModel notificationModel: NotificationService.notificationModel
        property var removingNotifications: ({})

        color: "transparent"
        visible: NotificationService.notificationModel.count > 0

        anchors.top: true
        anchors.right: true
        margins.top: 0
        margins.right: 0

        implicitWidth: 360
        implicitHeight: Math.min(notificationStack.implicitHeight, (NotificationService.maxVisible * 120)) + 60

        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.exclusionMode: ExclusionMode.Ignore

        Component.onCompleted: {
            NotificationService.animateAndRemove.connect(function (notification, index) {
                if (notificationStack.children && notificationStack.children[index]) {
                    let delegate = notificationStack.children[index];
                    if (delegate && delegate.animateOut) {
                        delegate.animateOut();
                    }
                }
            });
        }

        Rectangle {
            id: base

            color: "#1e1e2e"
            width: 323
            height: notificationStack.height + 15

            anchors.top: parent.top
            anchors.right: parent.right

            bottomLeftRadius: 20

            Column {
                id: notificationStack
                anchors.top: parent.top
                anchors.right: parent.right
                spacing: 8
                width: 301
                anchors.rightMargin: 11
                anchors.topMargin: 5
                anchors.bottomMargin: 5
                visible: true

                Repeater {
                    model: root.notificationModel

                    delegate: Rectangle {
                        id: each
                        width: 301
                        height: Math.max(80, contentColumn.implicitHeight + (12 * 2))
                        clip: true
                        radius: 20
                        border.color: "#b4befe"
                        border.width: 3
                        color: "#1e1e2e"

                        property real scaleValue: 0.8
                        property real opacityValue: 0.0
                        property bool isRemoving: false

                        scale: scaleValue
                        opacity: opacityValue

                        Component.onCompleted: {
                            scaleValue = 1.0;
                            opacityValue = 1.0;
                        }

                        function animateOut() {
                            isRemoving = true;
                            scaleValue = 0.8;
                            opacityValue = 0.0;
                        }

                        Timer {
                            id: removalTimer
                            interval: 500
                            repeat: false
                            onTriggered: {
                                try {
                                    NotificationService.forceRemoveNotification(model.rawNotification);
                                } catch (e) {
                                    console.error("NotificationDisplay: Error in forceRemoveNotification:", e);
                                }
                            }
                        }

                        onIsRemovingChanged: {
                            if (isRemoving) {
                                removalTimer.start();
                            }
                        }

                        Behavior on scale {
                            NumberAnimation {
                                duration: 500
                                easing.type: Easing.OutExpo
                            }
                        }

                        Behavior on opacity {
                            NumberAnimation {
                                duration: 300
                                easing.type: Easing.OutQuad
                            }
                        }

                        Column {
                            id: contentColumn
                            anchors.fill: parent
                            anchors.margins: 12
                            spacing: 8

                            RowLayout {
                                spacing: 8

                                Text {
                                    text: (model.appName || model.desktopEntry) || "Unknown App"
                                    color: "#b4befe"
                                    font.pointSize: 9
                                }

                                Rectangle {
                                    width: 6
                                    height: 6
                                    radius: 8
                                    color: (model.urgency === NotificationUrgency.Critical) ? "#f38ba8" : (model.urgency === NotificationUrgency.Low) ? "#cdd6f4" : "#cba6f7"
                                    Layout.alignment: Qt.AlignVCenter
                                }

                                Item {
                                    Layout.fillWidth: true
                                }

                                Text {
                                    text: NotificationService.formatTimestamp(model.timestamp)
                                    color: "#cdd6f4"
                                    font.pointSize: 8
                                }
                            }

                            Text {
                                text: model.summary || "No summary"
                                font.pointSize: 13
                                font.weight: 700
                                color: "#cdd6f4"
                                wrapMode: Text.Wrap
                                width: 300
                                maximumLineCount: 3
                                elide: Text.ElideRight
                            }

                            Text {
                                text: model.body || ""
                                font.pointSize: 8
                                color: "#cdd6f4"
                                wrapMode: Text.Wrap
                                width: 300
                                maximumLineCount: 5
                                elide: Text.ElideRight
                            }
                        }

                        Text {
                            id: closeButton

                            property string iconName: "close"
                            property int iconSize: 20
                            property color iconColor: "#cdd6f4"

                            text: iconName
                            font.family: "Material Symbols Rounded"
                            font.pixelSize: iconSize
                            color: iconColor
                            font.weight: Font.Normal
                            renderType: Text.NativeRendering
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter

                            anchors.top: parent.top
                            anchors.right: parent.right
                            anchors.margins: 10

                            // Component.onCompleted: {
                            //     console.log("NotificationDisplay: Close button created for notification:", model.summary || "no summary");
                            // }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    // console.log("NotificationDisplay: Close button clicked for notification:", model.summary || "no summary");
                                    try {
                                        each.animateOut();
                                        // console.log("NotificationDisplay: animateOut called successfully");
                                    } catch (e) {
                                        console.error("NotificationDisplay: Error calling animateOut:", e);
                                    }
                                }
                            }

                            opacity: closeButtonHover.containsMouse ? 0.7 : 1.0

                            HoverHandler {
                                id: closeButtonHover
                                onHoveredChanged:
                                // console.log("NotificationDisplay: Close button hover changed:", hovered);
                                {}
                            }

                            Behavior on opacity {
                                NumberAnimation {
                                    duration: 150
                                }
                            }
                        }
                    }
                }
            }
        }

        Corner {
            id: topLeftCorner
            position: "bottomright"
            size: 1.5
            fillColor: "#1e1e2e"
            anchors.top: base.top
            anchors.left: parent.left
            anchors.leftMargin: -68
            offsetY: 0
        }

        Corner {
            id: bottomRightCorner
            position: "bottomright"
            size: 1.5
            fillColor: "#1e1e2e"
            anchors.top: base.bottom
            anchors.right: parent.right
            anchors.rightMargin: -45
            offsetY: 0
        }
    }
}
