// ClockWidget.qml
import QtQuick

import qs.components

Column {
    id: root
    property string currentTime: Time.time

    Text {
        text: root.currentTime
        horizontalAlignment: Text.AlignHCenter
        font.bold: true
        font.family: "Jetbrains Mono"
        font.pixelSize: 16
        color: "#cdd6f4"
    }
}
