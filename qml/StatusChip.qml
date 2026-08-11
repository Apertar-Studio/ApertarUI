import QtQuick

Rectangle {
    id: root

    FontLoader { id: gothamThin;   source: "qrc:/qml/fonts/Gotham/Gotham-Thin.ttf" }
    FontLoader { id: gothamLight;  source: "qrc:/qml/fonts/Gotham/Gotham-Light.ttf" }
    FontLoader { id: gothamMedium; source: "qrc:/qml/fonts/Gotham/Gotham-Medium.ttf" }
    FontLoader { id: gothamBold;   source: "qrc:/qml/fonts/Gotham/Gotham-Bold.ttf" }
    FontLoader { id: gothamBlack;  source: "qrc:/qml/fonts/Gotham/Gotham-Black.ttf" }
    FontLoader { id: interThin;    source: "qrc:/qml/fonts/Inter/Inter-Thin.ttf" }
    FontLoader { id: interLight;   source: "qrc:/qml/fonts/Inter/Inter-Light.ttf" }
    FontLoader { id: interRegular; source: "qrc:/qml/fonts/Inter/Inter-Regular.ttf" }
    FontLoader { id: interMedium;  source: "qrc:/qml/fonts/Inter/Inter-Medium.ttf" }
    FontLoader { id: interBold;    source: "qrc:/qml/fonts/Inter/Inter-Bold.ttf" }
    FontLoader { id: interBlack;   source: "qrc:/qml/fonts/Inter/Inter-Black.ttf" }

    property bool recording: false
    property bool mediaMounted: true
    property real backgroundOpacity: 1.0
    property bool compact: false
    property bool largeCompact: false
    property bool extraLargeCompact: false
    property bool oversizedCompact: false
    property bool darkBackground: false
    property bool useControlBackground: false

    readonly property bool noMedia: !mediaMounted
    readonly property real chipScale: compact ? (oversizedCompact ? 1.38 : (extraLargeCompact ? 1.16 : (largeCompact ? 0.96 : 0.80))) : 1.0
    readonly property int dotContainerSize: compact ? (oversizedCompact ? 18 : (extraLargeCompact ? 15 : (largeCompact ? 12 : 10))) : 12
    readonly property int dotSize: compact ? (oversizedCompact ? 14 : (extraLargeCompact ? 12 : (largeCompact ? 10 : 8))) : 10
    readonly property color controlFill: darkBackground
                                         ? fadedColor(0x00, 0x00, 0x00, 0.329)
                                         : fadedColor(0xff, 0xff, 0xff, 0.141)
    readonly property color controlBorder: darkBackground
                                           ? fadedColor(0xff, 0xff, 0xff, 0.165)
                                           : fadedColor(0xff, 0xff, 0xff, 0.188)
    readonly property color stateFill: noMedia ? (compact ? (darkBackground
                                                             ? fadedColor(0x4a, 0x38, 0x00, 0.66)
                                                             : fadedColor(0x52, 0x3f, 0x00, 0.58))
                                                           : fadedColor(0x6b, 0x52, 0x00, 0.50))
                                                : (recording ? (compact ? (darkBackground
                                                                           ? fadedColor(0x8d, 0x0f, 0x0f, 0.66)
                                                                           : fadedColor(0xa0, 0x11, 0x11, 0.58))
                                                                         : fadedColor(0xb7, 0x12, 0x12, 0.50))
                                                             : fadedColor(0x00, 0x00, 0x00, compact ? (darkBackground ? 0.58 : 0.50) : 0.44))
    readonly property color stateBorder: noMedia ? fadedColor(0xff, 0xd5, 0x4a, compact ? (darkBackground ? 0.52 : 0.46) : 0.40)
                                                  : (recording ? fadedColor(0xff, 0x66, 0x66, compact ? (darkBackground ? 0.52 : 0.46) : 0.40)
                                                               : fadedColor(0xff, 0xff, 0xff, compact ? (darkBackground ? 0.18 : 0.12) : 0.04))
    readonly property color chipFill: compact && useControlBackground ? controlFill : stateFill
    readonly property color chipBorder: compact && useControlBackground ? controlBorder : stateBorder
    readonly property color dotFill: noMedia ? "#ffd54a"
                                              : (recording ? "#fb2c36" : "#00c951")
    readonly property string chipLabel: noMedia ? "NO MEDIA"
                                                : (recording ? "REC" : "READY")

    width: Math.round((noMedia ? 118 : 90) * chipScale)
    height: Math.round(30 * chipScale)
    radius: height / 2
    color: chipFill
    border.width: 1
    border.color: chipBorder
    layer.enabled: true
    layer.smooth: false

    Behavior on color {
        ColorAnimation { duration: 220 }
    }

    Behavior on border.color {
        ColorAnimation { duration: 220 }
    }

    Behavior on width {
        NumberAnimation {
            duration: 180
            easing.type: Easing.OutCubic
        }
    }

    function fadedColor(r, g, b, baseAlpha) {
        return Qt.rgba(r / 255.0,
                       g / 255.0,
                       b / 255.0,
                       Math.max(0.0, Math.min(1.0, baseAlpha * root.backgroundOpacity)))
    }

    Row {
        anchors.centerIn: parent
        spacing: root.compact ? 5 : 6

        Item {
            width: root.dotContainerSize
            height: root.dotContainerSize
            anchors.verticalCenter: parent.verticalCenter

            Rectangle {
                id: dotGlow
                anchors.centerIn: parent
                width: root.dotContainerSize
                height: root.dotContainerSize
                radius: width / 2
                color: root.dotFill
                opacity: root.recording && !root.noMedia ? 0.22 : 0.0
                visible: root.recording && !root.noMedia

                Behavior on opacity {
                    NumberAnimation {
                        duration: 140
                        easing.type: Easing.OutCubic
                    }
                }
            }

            Rectangle {
                id: dot
                anchors.centerIn: parent
                width: root.dotSize
                height: root.dotSize
                radius: width / 2
                color: root.dotFill

                Behavior on color {
                    ColorAnimation { duration: 180 }
                }
            }
        }

        Text {
            text: root.chipLabel
            color: "white"
            font.family: interBold.font.family
            font.weight: Font.Bold
            font.pixelSize: root.compact ? (root.oversizedCompact ? 18 : (root.extraLargeCompact ? 16 : (root.largeCompact ? 14 : 12))) : 14
            renderType: Text.NativeRendering
            anchors.verticalCenter: parent.verticalCenter

            Behavior on opacity {
                NumberAnimation { duration: 140 }
            }
        }
    }
}
