import QtQuick

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
}
