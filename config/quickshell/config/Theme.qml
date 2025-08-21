pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: theme

    readonly property string primary: "#b4befe"
    readonly property string secondary: "#cba6f7"
    readonly property string accent: "#f5c2e7"
    readonly property string background: "#1e1e2e"
    readonly property string surface: "#313244"
    readonly property string surfaceVariant: "#45475a"
    readonly property string onPrimary: "#11111b"
    readonly property string onSecondary: "#11111b"
    readonly property string onAccent: "#11111b"
    readonly property string onBackground: "#cdd6f4"
    readonly property string onSurface: "#cdd6f4"
    readonly property string onSurfaceVariant: "#bac2de"
    readonly property string text: "#cdd6f4"
    readonly property string textSecondary: "#bac2de"
    readonly property string textMuted: "#a6adc8"
    readonly property string textDisabled: "#6c7086"
    readonly property string border: "#585b70"
    readonly property string borderLight: "#6c7086"
    readonly property string success: "#a6e3a1"
    readonly property string warning: "#f9e2af"
    readonly property string error: "#f38ba8"
    readonly property string info: "#89b4fa"
    readonly property string highlight: "#b4befe"
    readonly property string selection: "#585b70"
    readonly property string hover: "#45475a"
    readonly property string focus: "#b4befe"
    readonly property string disabled: "#6c7086"
    readonly property string shadow: "#11111b"
    readonly property string overlay: "#1e1e2e"
    readonly property string card: "#313244"
    readonly property string cardHover: "#45475a"
    readonly property string button: "#b4befe"
    readonly property string buttonHover: "#cba6f7"
    readonly property string buttonPressed: "#a6adc8"
    readonly property string input: "#313244"
    readonly property string inputBorder: "#585b70"
    readonly property string inputFocus: "#b4befe"
    readonly property string scrollbar: "#45475a"
    readonly property string scrollbarThumb: "#6c7086"
    readonly property string tooltip: "#45475a"
    readonly property string tooltipText: "#cdd6f4"
    readonly property real opacity: 0.8
    readonly property bool enabled: true

    readonly property int barWidth: 40
    readonly property int barItemSpacing: 10
    readonly property int barItemPadding: 5

    readonly property string barFontFamily: "JetBrains Mono"
    readonly property int barFontSize: 10
}
