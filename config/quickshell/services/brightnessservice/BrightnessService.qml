pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    signal brightnessUpdated  // Renamed from brightnessChanged
    property real brightness: 0.5
    property bool ready: false

    function increaseBrightness(): void {
        setBrightness(brightness + 0.05);
    }

    function decreaseBrightness(): void {
        setBrightness(brightness - 0.05);
    }

    function setBrightness(value: real): void {
        value = Math.max(0.01, Math.min(1, value));
        const rounded = Math.round(value * 100);
        if (Math.round(brightness * 100) === rounded)
            return;

        brightness = value;
        setProc.command = ["brightnessctl", "s", `${rounded}%`, "--quiet"];
        setProc.running = true;
    }

    function initialize() {
        ready = false;
        initProc.command = ["sh", "-c", "echo \"$(brightnessctl g) $(brightnessctl m)\""];
        initProc.running = true;
    }

    Process {
        id: initProc

        stdout: SplitParser {
            onRead: data => {
                const [current, max] = data.trim().split(" ");
                root.brightness = parseInt(current) / parseInt(max);
                root.ready = true;
                root.brightnessUpdated();  // Use the renamed signal
            }
        }
    }

    Process {
        id: setProc

        onExited: function (exitCode, exitStatus) {
            if (exitCode === 0) {
                readTimer.restart();
            }
        }
    }

    Timer {
        id: readTimer
        interval: 100
        onTriggered: initialize()
    }

    Timer {
        id: brightnessMonitor
        interval: 500  // Check every 500ms
        running: true
        repeat: true
        onTriggered: {
            // Only re-read if we're not currently setting brightness
            if (!setProc.running) {
                initialize();
            }
        }
    }
    Component.onCompleted: initialize()
}
