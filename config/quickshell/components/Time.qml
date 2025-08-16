// Time.qml
pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: root
    readonly property string time: {
        Qt.formatDateTime(clock.date, " hh\n mm");
    }
    readonly property string date: {
        Qt.formatDateTime(clock.date, " d\n ddd");
    }

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
}
