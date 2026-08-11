import QtQuick
import QtQuick.Window
import Apertar 1.0

Window {
    id: root
    visible: !hdmiExternalOnly
    color: "#000000"
    flags: Qt.FramelessWindowHint
    visibility: Window.FullScreen

    width: displayConfigBridge ? displayConfigBridge.uiWidth : 720
    height: displayConfigBridge ? displayConfigBridge.uiHeight : 720

    property string currentPage: "camera"
    property bool settingsOpen: false
    property string selectedClipPath: ""
    property string selectedClipName: ""
    property int selectedClipFrames: 0
    property int selectedClipIndex: -1
    property bool autoPowerOffWarningOpen: false
    property int autoPowerOffCountdown: 10
    property bool powerButtonShutdownOpen: false
    property bool powerButtonShutdownTriggered: false
    property real powerButtonShutdownHoldProgress: 0.0
    property bool powerButtonShutdownTouchPressed: false
    property string powerButtonShutdownErrorText: ""
    readonly property bool powerButtonShutdownHoldActive: powerButtonBridge.pressed || powerButtonShutdownTouchPressed
    readonly property bool browserLayerVisible: currentPage === "browser" || currentPage === "player"
    readonly property string uiOrientation: settingsBridge ? settingsBridge.uiOrientation : "Landscape"
    readonly property string displayLayout: displayConfigBridge ? displayConfigBridge.uiLayout : "square"
    readonly property bool landscapeCompactLayout: displayLayout === "landscape_compact"
    readonly property bool standardLandscapeLayout: displayLayout === "landscape"
                                                   || displayLayout === "landscape_large"
    readonly property bool regularLandscapeLayout: displayLayout === "landscape_medium"
                                                   || standardLandscapeLayout
    readonly property bool compactLandscapeLayout: landscapeCompactLayout || regularLandscapeLayout
    readonly property bool displayWindowed: displayConfigBridge ? displayConfigBridge.windowed : false
    readonly property int displayUiWidth: displayConfigBridge ? displayConfigBridge.uiWidth : 720
    readonly property int displayUiHeight: displayConfigBridge ? displayConfigBridge.uiHeight : 720
    readonly property real displayControlsOpacity: settingsBridge
                                                   ? settingsBridge.cameraControlsOpacity
                                                   : (displayConfigBridge ? displayConfigBridge.controlsOpacity : 1.0)
    readonly property string displayControlsMode: settingsBridge
                                                 ? settingsBridge.cameraControlsMode
                                                 : "Light"
    readonly property int settingsUiRotationDegrees: uiOrientation === "Left Side" ? 90
                                                       : (uiOrientation === "Right Side" ? -90
                                                                                    : (uiOrientation === "Upside Down" ? 180 : 0))
    readonly property int displayUiRotationDegrees: displayConfigBridge ? displayConfigBridge.uiRotationDegrees : 0
    readonly property int effectiveUiRotationDegrees: settingsUiRotationDegrees + displayUiRotationDegrees
    readonly property bool displayRotationUsesConfiguredSize: displayWindowed || displayUiRotationDegrees !== 0

    function cancelAutoPowerOffWarning() {
        autoPowerOffWarningOpen = false
        autoPowerOffCountdown = 10
        autoPowerOffCountdownTimer.stop()
    }

    function closePowerButtonShutdownPopup() {
        powerButtonShutdownTimer.stop()
        powerButtonHoldFill.stop()
        powerButtonHoldReset.stop()
        powerButtonShutdownOpen = false
        powerButtonShutdownTriggered = false
        powerButtonShutdownTouchPressed = false
        powerButtonShutdownHoldProgress = 0.0
        powerButtonShutdownErrorText = ""
    }

    function openPowerButtonShutdownPopup() {
        if (autoPowerOffWarningOpen)
            cancelAutoPowerOffWarning()
        powerButtonShutdownOpen = true
        powerButtonShutdownTriggered = false
        powerButtonShutdownErrorText = ""
    }

    function beginPowerButtonShutdownHold() {
        if (powerButtonShutdownTriggered)
            return
        if (!powerButtonShutdownOpen)
            openPowerButtonShutdownPopup()

        powerButtonHoldReset.stop()
        powerButtonHoldFill.stop()
        powerButtonShutdownHoldProgress = 0.0
        powerButtonHoldFill.restart()
        powerButtonShutdownTimer.restart()
    }

    function cancelPowerButtonShutdownHold() {
        powerButtonShutdownTimer.stop()
        powerButtonHoldFill.stop()
        if (powerButtonShutdownTriggered)
            return

        if (powerButtonShutdownHoldProgress > 0.0)
            powerButtonHoldReset.restart()
        else
            powerButtonShutdownHoldProgress = 0.0
    }

    function confirmPowerButtonShutdown() {
        if (powerButtonShutdownTriggered)
            return

        powerButtonShutdownTriggered = true
        powerButtonShutdownTimer.stop()
        powerButtonHoldFill.stop()
        powerButtonShutdownHoldProgress = 1.0
        powerButtonShutdownErrorText = ""

        if (!systemActionBridge.shutdownCamera()) {
            powerButtonShutdownTriggered = false
            powerButtonShutdownErrorText = systemActionBridge.lastError.length > 0
                                          ? systemActionBridge.lastError
                                          : "Could not shut down the system."
            powerButtonHoldReset.restart()
        }
    }

    function updateBackgroundAudioMonitoring() {
        if (currentPage === "camera")
            audioMeterBridge.resumeMonitoring()
        else
            audioMeterBridge.suspendMonitoring()
    }

    function startAutoPowerOffWarning() {
        autoPowerOffCountdown = 10
        autoPowerOffWarningOpen = true
        autoPowerOffCountdownTimer.restart()
    }

    Component.onCompleted: {
        sleepManager.sleepMode = settingsBridge.sleepMode
        clipModel.stillMode = settingsBridge.photoModeEnabled
        apertarPreviewBridge.connectToCore()
        root.updateBackgroundAudioMonitoring()
    }

    onCurrentPageChanged: root.updateBackgroundAudioMonitoring()

    Connections {
        target: settingsBridge

        function onSleepModeChanged() {
            sleepManager.sleepMode = settingsBridge.sleepMode
            if (settingsBridge.sleepMode === "Off")
                root.cancelAutoPowerOffWarning()
        }

        function onPhotoModeEnabledChanged() {
            clipModel.stillMode = settingsBridge.photoModeEnabled
        }
    }

    Connections {
        target: sleepManager

        function onSleepTriggered() {
            if (settingsBridge.sleepMode === "Off")
                return

            if (cameraPage.recording) {
                sleepManager.restartIdleTimerNow()
                return
            }

            root.startAutoPowerOffWarning()
        }

        function onActivityDetected() {
            if (root.autoPowerOffWarningOpen)
                root.cancelAutoPowerOffWarning()
        }
    }

    Connections {
        target: powerButtonBridge

        function onButtonPressed() {
            root.openPowerButtonShutdownPopup()
            root.beginPowerButtonShutdownHold()
        }

        function onButtonReleased() {
            root.cancelPowerButtonShutdownHold()
        }
    }

    Timer {
        id: autoPowerOffCountdownTimer
        interval: 1000
        repeat: true
        running: false
        onTriggered: {
            if (!root.autoPowerOffWarningOpen) {
                stop()
                return
            }

            if (cameraPage.recording) {
                root.cancelAutoPowerOffWarning()
                sleepManager.restartIdleTimerNow()
                return
            }

            root.autoPowerOffCountdown -= 1
            if (root.autoPowerOffCountdown <= 0) {
                stop()
                root.autoPowerOffWarningOpen = false
                systemActionBridge.shutdownCamera()
            }
        }
    }

    Timer {
        id: powerButtonShutdownTimer
        interval: 3000
        repeat: false
        running: false
        onTriggered: root.confirmPowerButtonShutdown()
    }

    NumberAnimation {
        id: powerButtonHoldFill
        target: root
        property: "powerButtonShutdownHoldProgress"
        from: 0.0
        to: 1.0
        duration: powerButtonShutdownTimer.interval
        easing.type: Easing.Linear
    }

    NumberAnimation {
        id: powerButtonHoldReset
        target: root
        property: "powerButtonShutdownHoldProgress"
        to: 0.0
        duration: 140
        easing.type: Easing.OutCubic
    }

    function selectClip(path, name, frameCount, index) {
        selectedClipPath = path
        selectedClipName = name
        selectedClipFrames = frameCount
        selectedClipIndex = index
        playbackController.loadClip(path)
        currentPage = "player"
    }

    function selectClipAt(index) {
        if (index < 0 || index >= clipModel.count)
            return

        var clipPath = clipModel.pathAt(index)
        if (!clipPath || clipPath.length === 0)
            return

        selectClip(clipPath, clipModel.nameAt(index), clipModel.frameCountAt(index), index)
    }

    function hasPreviousClip() {
        return selectedClipIndex > 0
    }

    function hasNextClip() {
        return selectedClipIndex >= 0 && selectedClipIndex < clipModel.count - 1
    }

    function removeSelectedClip() {
        if (!selectedClipPath || selectedClipPath.length === 0)
            return

        var removedIndex = selectedClipIndex
        var removed = clipModel.removeClip(selectedClipPath)
        if (!removed)
            return

        playbackController.stop()

        if (clipModel.count <= 0) {
            selectedClipPath = ""
            selectedClipName = ""
            selectedClipFrames = 0
            selectedClipIndex = -1
            currentPage = "browser"
            return
        }

        var nextIndex = Math.max(0, Math.min(removedIndex, clipModel.count - 1))
        selectClipAt(nextIndex)
    }

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

    Item {
        id: uiScene
        width: root.displayRotationUsesConfiguredSize ? root.displayUiWidth : parent.width
        height: root.displayRotationUsesConfiguredSize ? root.displayUiHeight : parent.height
        anchors.centerIn: parent
        clip: true

        transform: Rotation {
            origin.x: uiScene.width / 2
            origin.y: uiScene.height / 2
            angle: root.effectiveUiRotationDegrees
        }

    Rectangle {
        anchors.fill: parent
        color: "transparent"
        border.width: root.displayWindowed ? 1 : 0
        border.color: "#44ffffff"
        z: 7000
    }

    CameraPage {
        id: cameraPage
        anchors.fill: parent
        bridge: apertarPreviewBridge
        controlBridge: apertarControlBridge
        settingsState: settingsBridge
        displayLayout: root.displayLayout
        controlsOpacity: root.displayControlsOpacity
        controlsMode: root.displayControlsMode
        sceneRotationDegrees: root.displayUiRotationDegrees
        onOpenSettingsRequested: root.settingsOpen = true
        onOpenClipBrowserRequested: {
            root.settingsOpen = false
            root.currentPage = "browser"
        }
        onRecordingChanged: {
            if (cameraPage.recording && root.autoPowerOffWarningOpen) {
                root.cancelAutoPowerOffWarning()
                sleepManager.restartIdleTimerNow()
            }
        }
    }

    Rectangle {
        id: settingsScrim
        anchors.fill: parent
        color: "#cc000000"
        opacity: root.currentPage === "camera" && root.settingsOpen ? 1.0 : 0.0
        visible: opacity > 0.0
        z: 1000

        Behavior on opacity {
            NumberAnimation {
                duration: 520
                easing.type: Easing.OutCubic
            }
        }
    }

    SettingsPage {
        id: settingsPage
        anchors.fill: parent
        z: 1001
        settingsState: settingsBridge
        displayLayout: root.displayLayout

        visible: root.currentPage === "camera" && (opacity > 0.0 || root.settingsOpen)
        opacity: root.currentPage === "camera" && root.settingsOpen ? 1.0 : 0.0
        y: root.currentPage === "camera" && root.settingsOpen ? 0 : 36
        scale: root.currentPage === "camera" && root.settingsOpen ? 1.0 : 0.985

        onBackRequested: root.settingsOpen = false

        Behavior on opacity {
            NumberAnimation {
                duration: 500
                easing.type: Easing.OutCubic
            }
        }

        Behavior on y {
            NumberAnimation {
                duration: 620
                easing.type: Easing.OutCubic
            }
        }

        Behavior on scale {
            NumberAnimation {
                duration: 620
                easing.type: Easing.OutCubic
            }
        }
    }

    ClipBrowserPage {
        id: clipBrowserPage
        anchors.fill: parent
        z: 900
        visible: opacity > 0.0 || root.browserLayerVisible
        opacity: root.browserLayerVisible ? 1.0 : 0.0
        y: root.browserLayerVisible ? 0 : 36
        scale: root.browserLayerVisible ? 1.0 : 0.985
        enabled: root.currentPage === "browser"
        settingsState: settingsBridge
        stillMode: settingsBridge.photoModeEnabled
        selectedClipPath: root.selectedClipPath
        displayLayout: root.displayLayout

        onBackRequested: root.currentPage = "camera"
        onClipOpened: function(clipPath, clipName, frameCount, clipIndex) {
            root.selectClip(clipPath, clipName, frameCount, clipIndex)
        }

        Behavior on opacity {
            NumberAnimation {
                duration: 500
                easing.type: Easing.OutCubic
            }
        }

        Behavior on y {
            NumberAnimation {
                duration: 620
                easing.type: Easing.OutCubic
            }
        }

        Behavior on scale {
            NumberAnimation {
                duration: 620
                easing.type: Easing.OutCubic
            }
        }
    }

    ClipPlayerPage {
        id: clipPlayerPage
        anchors.fill: parent
        z: 901
        visible: opacity > 0.0 || root.currentPage === "player"
        opacity: root.currentPage === "player" ? 1.0 : 0.0
        y: root.currentPage === "player" ? 0 : 36
        scale: root.currentPage === "player" ? 1.0 : 0.985
        enabled: root.currentPage === "player"
        selectedClipName: root.selectedClipName
        selectedClipIndex: root.selectedClipIndex
        hasPreviousClip: root.hasPreviousClip()
        hasNextClip: root.hasNextClip()
        displayLayout: root.displayLayout

        onBackRequested: root.currentPage = "browser"
        onPreviousClipRequested: root.selectClipAt(root.selectedClipIndex - 1)
        onNextClipRequested: root.selectClipAt(root.selectedClipIndex + 1)
        onDeleteRequested: root.removeSelectedClip()

        Behavior on opacity {
            NumberAnimation {
                duration: 500
                easing.type: Easing.OutCubic
            }
        }

        Behavior on y {
            NumberAnimation {
                duration: 620
                easing.type: Easing.OutCubic
            }
        }

        Behavior on scale {
            NumberAnimation {
                duration: 620
                easing.type: Easing.OutCubic
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "#cc000000"
        visible: root.autoPowerOffWarningOpen
        opacity: root.autoPowerOffWarningOpen ? 1.0 : 0.0
        z: 6000

        Behavior on opacity {
            NumberAnimation {
                duration: 180
                easing.type: Easing.OutCubic
            }
        }
    }

    Rectangle {
        id: autoPowerOffWarningCard
        readonly property int popupMargin: root.standardLandscapeLayout ? 26 : (root.compactLandscapeLayout ? 15 : 24)
        readonly property int bottomButtonGap: root.standardLandscapeLayout ? 24 : (root.compactLandscapeLayout ? 15 : 24)
        width: root.standardLandscapeLayout ? 500 : (root.compactLandscapeLayout ? 340 : 430)
        height: root.standardLandscapeLayout
                ? (autoPowerOffWarningColumn.implicitHeight + popupMargin + bottomButtonGap)
                : (root.compactLandscapeLayout ? (autoPowerOffWarningColumn.implicitHeight + 30) : 196)
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -10
        radius: root.standardLandscapeLayout ? 30 : (root.compactLandscapeLayout ? 20 : 26)
        color: "#151515"
        border.width: 1
        border.color: "#1affffff"
        visible: root.autoPowerOffWarningOpen
        opacity: root.autoPowerOffWarningOpen ? 1.0 : 0.0
        scale: root.autoPowerOffWarningOpen ? 1.0 : 0.96
        z: 6001

        Behavior on opacity {
            NumberAnimation {
                duration: 220
                easing.type: Easing.OutCubic
            }
        }

        Behavior on scale {
            NumberAnimation {
                duration: 240
                easing.type: Easing.OutCubic
            }
        }

        Column {
            id: autoPowerOffWarningColumn
            anchors.fill: parent
            anchors.leftMargin: autoPowerOffWarningCard.popupMargin
            anchors.rightMargin: autoPowerOffWarningCard.popupMargin
            anchors.topMargin: autoPowerOffWarningCard.popupMargin
            anchors.bottomMargin: autoPowerOffWarningCard.bottomButtonGap
            spacing: root.standardLandscapeLayout ? 14 : (root.compactLandscapeLayout ? 8 : 14)

            Text {
                text: "Auto Power Off"
                color: "white"
                font.family: interBold.font.family
                font.pixelSize: root.standardLandscapeLayout ? 30 : (root.compactLandscapeLayout ? 20 : 28)
                renderType: Text.NativeRendering
            }

            Text {
                text: "The camera will shut down in " + root.autoPowerOffCountdown + " seconds due to inactivity."
                color: "#8f9096"
                font.family: interRegular.font.family
                font.pixelSize: root.standardLandscapeLayout ? 16 : (root.compactLandscapeLayout ? 12 : 17)
                wrapMode: Text.WordWrap
                width: parent.width
                renderType: Text.NativeRendering
            }

            Rectangle {
                width: parent.width
                height: root.standardLandscapeLayout ? 60 : (root.compactLandscapeLayout ? 44 : 54)
                radius: root.standardLandscapeLayout ? 20 : (root.compactLandscapeLayout ? 14 : 18)
                color: stayAwakeArea.containsPress ? "#20ffffff" : "#14ffffff"
                border.width: 1
                border.color: "#1affffff"
                scale: stayAwakeArea.containsPress ? 0.985 : 1.0

                Behavior on scale {
                    NumberAnimation {
                        duration: 140
                        easing.type: Easing.OutCubic
                    }
                }

                Text {
                    anchors.centerIn: parent
                    text: "Stay Awake"
                    color: "white"
                    font.family: interMedium.font.family
                    font.pixelSize: root.standardLandscapeLayout ? 18 : (root.compactLandscapeLayout ? 13 : 18)
                    renderType: Text.NativeRendering
                }

                MouseArea {
                    id: stayAwakeArea
                    anchors.fill: parent
                    onClicked: {
                        root.cancelAutoPowerOffWarning()
                        sleepManager.restartIdleTimerNow()
                    }
                }
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "#cc000000"
        visible: root.powerButtonShutdownOpen
        opacity: root.powerButtonShutdownOpen ? 1.0 : 0.0
        z: 6100

        Behavior on opacity {
            NumberAnimation {
                duration: 180
                easing.type: Easing.OutCubic
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: root.closePowerButtonShutdownPopup()
        }
    }

    Rectangle {
        id: powerButtonShutdownCard
        readonly property int popupMargin: root.standardLandscapeLayout ? 26 : (root.compactLandscapeLayout ? 16 : 24)
        readonly property int bottomButtonGap: root.standardLandscapeLayout ? 24 : (root.compactLandscapeLayout ? 10 : 30)
        width: root.standardLandscapeLayout ? 500 : (root.compactLandscapeLayout ? 340 : 440)
        height: root.standardLandscapeLayout
                ? (powerButtonShutdownColumn.implicitHeight + popupMargin + bottomButtonGap)
                : (root.compactLandscapeLayout
                   ? (root.powerButtonShutdownErrorText.length > 0 ? 238 : 212)
                   : 272)
        anchors.centerIn: parent
        anchors.verticalCenterOffset: root.compactLandscapeLayout ? -8 : -10
        radius: root.standardLandscapeLayout ? 30 : (root.compactLandscapeLayout ? 22 : 26)
        color: "#151515"
        border.width: 1
        border.color: "#1affffff"
        visible: root.powerButtonShutdownOpen
        opacity: root.powerButtonShutdownOpen ? 1.0 : 0.0
        scale: root.powerButtonShutdownOpen ? 1.0 : 0.96
        z: 6101

        Behavior on opacity {
            NumberAnimation {
                duration: 220
                easing.type: Easing.OutCubic
            }
        }

        Behavior on scale {
            NumberAnimation {
                duration: 240
                easing.type: Easing.OutCubic
            }
        }

        MouseArea {
            anchors.fill: parent
        }

        Column {
            id: powerButtonShutdownColumn
            anchors.fill: parent
            anchors.leftMargin: powerButtonShutdownCard.popupMargin
            anchors.rightMargin: powerButtonShutdownCard.popupMargin
            anchors.topMargin: powerButtonShutdownCard.popupMargin
            anchors.bottomMargin: powerButtonShutdownCard.bottomButtonGap
            spacing: root.standardLandscapeLayout ? 14 : (root.compactLandscapeLayout ? 8 : 14)

            Text {
                text: "Shutdown System?"
                color: "white"
                font.family: gothamBold.font.family
                font.pixelSize: root.standardLandscapeLayout ? 30 : (root.compactLandscapeLayout ? 20 : 26)
                renderType: Text.NativeRendering
            }

            Text {
                text: root.powerButtonShutdownTriggered
                      ? "Shutting down..."
                      : "Hold the physical power button or press and hold below for 3 seconds to confirm shutdown."
                color: "#8f9096"
                font.family: interRegular.font.family
                font.pixelSize: root.standardLandscapeLayout ? 16 : (root.compactLandscapeLayout ? 12 : 17)
                wrapMode: Text.WordWrap
                width: parent.width
                renderType: Text.NativeRendering
            }

            Item {
                width: 1
                height: root.standardLandscapeLayout ? 4 : (root.compactLandscapeLayout ? 9 : 0)
            }

            Rectangle {
                width: parent.width
                height: root.standardLandscapeLayout ? 64 : (root.compactLandscapeLayout ? 42 : 62)
                radius: root.standardLandscapeLayout ? 21 : (root.compactLandscapeLayout ? 15 : 18)
                clip: true
                color: root.powerButtonShutdownHoldActive ? "#a32828" : "#171717"
                border.width: 1
                border.color: "#ba4a4a"
                opacity: root.powerButtonShutdownTriggered ? 0.85 : 1.0

                Rectangle {
                    x: 1
                    y: 1
                    width: (parent.width - 2) * root.powerButtonShutdownHoldProgress
                    height: parent.height - 2
                    radius: parent.radius - 1
                    color: "#c84242"
                    opacity: 0.6
                }

                Text {
                    anchors.centerIn: parent
                    text: root.powerButtonShutdownTriggered
                          ? "Shutting Down..."
                          : (root.powerButtonShutdownHoldActive ? "Keep Holding..." : "Hold to Shut Down")
                    color: "#ffd6d6"
                    font.family: interMedium.font.family
                    font.pixelSize: root.standardLandscapeLayout ? 18 : (root.compactLandscapeLayout ? 13 : 17)
                    renderType: Text.NativeRendering
                }

                MouseArea {
                    anchors.fill: parent
                    enabled: !root.powerButtonShutdownTriggered
                    onPressed: {
                        root.powerButtonShutdownTouchPressed = true
                        root.beginPowerButtonShutdownHold()
                    }
                    onReleased: {
                        root.powerButtonShutdownTouchPressed = false
                        root.cancelPowerButtonShutdownHold()
                    }
                    onCanceled: {
                        root.powerButtonShutdownTouchPressed = false
                        root.cancelPowerButtonShutdownHold()
                    }
                }
            }

            Text {
                visible: root.powerButtonShutdownErrorText.length > 0
                text: root.powerButtonShutdownErrorText
                color: "#ff9b9b"
                font.family: interRegular.font.family
                font.pixelSize: root.standardLandscapeLayout ? 14 : (root.compactLandscapeLayout ? 11 : 14)
                wrapMode: Text.WordWrap
                width: parent.width
                renderType: Text.NativeRendering
            }

            Rectangle {
                width: parent.width
                height: root.standardLandscapeLayout ? 60 : (root.compactLandscapeLayout ? 42 : 54)
                radius: root.standardLandscapeLayout ? 20 : (root.compactLandscapeLayout ? 15 : 18)
                color: cancelPowerButtonArea.containsPress ? "#20ffffff" : "#14ffffff"
                border.width: 1
                border.color: "#1affffff"
                scale: cancelPowerButtonArea.containsPress ? 0.985 : 1.0
                enabled: !root.powerButtonShutdownTriggered
                opacity: enabled ? 1.0 : 0.45

                Behavior on scale {
                    NumberAnimation {
                        duration: 140
                        easing.type: Easing.OutCubic
                    }
                }

                Text {
                    anchors.centerIn: parent
                    text: "Cancel"
                    color: "white"
                    font.family: interMedium.font.family
                    font.pixelSize: root.standardLandscapeLayout ? 18 : (root.compactLandscapeLayout ? 13 : 18)
                    renderType: Text.NativeRendering
                }

                MouseArea {
                    id: cancelPowerButtonArea
                    anchors.fill: parent
                    enabled: !root.powerButtonShutdownTriggered
                    onClicked: root.closePowerButtonShutdownPopup()
                }
            }
        }
    }

    }
}
