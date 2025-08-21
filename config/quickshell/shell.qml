//@ pragma UseQApplication
// shell.qml
import Quickshell
import QtQuick

import "./modules/bar"
import "./modules/notification"
import "./modules/osd/brightness"
import "./modules/osd/volume"

ShellRoot {
    id: root

    Bar {
        id: bar
    }

    Notification {
        id: notification
    }

    // osd
    Brightness {
        id: brightness
    }

    // osd
    Volume {
        id: volume
    }
}
