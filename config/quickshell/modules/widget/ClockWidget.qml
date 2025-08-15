// ClockWidget.qml
import QtQuick
import QtQuick.Layouts

import qs.components

Column {
    spacing: 5

    Text {
        text: Time.date
        horizontalAlignment: Text.AlignHCenter
        font.bold: true
        color: "#cdd6f4"
    }

    Text {
        text: Time.time
        horizontalAlignment: Text.AlignHCenter
        font.bold: true
        color: "#cdd6f4"
    }
}
