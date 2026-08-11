import QtQuick
import Apertar 1.0

Item {
    id: root
	
	signal openSettingsRequested()
    signal openClipBrowserRequested()
	
	FontLoader { id: gothamThin;   source: "qrc:/qml/fonts/Gotham/Gotham-Thin.ttf" }
    FontLoader { id: gothamLight;  source: "qrc:/qml/fonts/Gotham/Gotham-Light.ttf" }
    FontLoader { id: gothamMedium; source: "qrc:/qml/fonts/Gotham/Gotham-Medium.ttf" }
    FontLoader { id: gothamBold;   source: "qrc:/qml/fonts/Gotham/Gotham-Bold.ttf" }
    FontLoader { id: gothamBlack;  source: "qrc:/qml/fonts/Gotham/Gotham-Black.ttf" }
	FontLoader { id: interThin;   source: "qrc:/qml/fonts/Inter/Inter-Thin.ttf" }
	FontLoader { id: interLight;   source: "qrc:/qml/fonts/Inter/Inter-Light.ttf" }
	FontLoader { id: interRegular;   source: "qrc:/qml/fonts/Inter/Inter-Regular.ttf" }
	FontLoader { id: interMedium;   source: "qrc:/qml/fonts/Inter/Inter-Medium.ttf" }
	FontLoader { id: interBold;   source: "qrc:/qml/fonts/Inter/Inter-Bold.ttf" }
	FontLoader { id: interBlack;   source: "qrc:/qml/fonts/Inter/Inter-Black.ttf" }



    property var bridge
    property var controlBridge
    property bool recording: false
    property bool recordWarningOpen: false
    property string recordWarningTitle: "No Media Mounted"
    property string recordWarningSubtitle: ""
    property string recordWarningDetailTitle: ""
    property string recordWarningDetailBody: ""
	
    property var settingsState
    property string displayLayout: "square"
    property real controlsOpacity: 1.0
    property string controlsMode: "Light"
    property int sceneRotationDegrees: 0
    readonly property bool landscapeLayout: displayLayout === "landscape_compact"
                                            || displayLayout === "landscape_medium"
                                            || displayLayout === "landscape"
                                            || displayLayout === "landscape_large"
    readonly property bool landscapeCompactLayout: displayLayout === "landscape_compact"
    readonly property bool mediumLandscapeLayout: displayLayout === "landscape_medium"
    readonly property bool largeLandscapeLayout: displayLayout === "landscape_large"
    readonly property bool standardLandscapeLayout: displayLayout === "landscape"
                                                   || largeLandscapeLayout
    readonly property bool regularLandscapeLayout: mediumLandscapeLayout
                                                   || standardLandscapeLayout
    readonly property bool compactLandscapeLayout: landscapeCompactLayout || regularLandscapeLayout
    readonly property bool portraitLayout: displayLayout === "portrait_compact"
                                           || displayLayout === "portrait"
                                           || displayLayout === "portrait_large"
    readonly property bool compactPortraitLayout: displayLayout === "portrait_compact"
    readonly property bool rectangularLayout: landscapeLayout || portraitLayout
    readonly property bool compactRectangularLayout: compactLandscapeLayout || compactPortraitLayout
    readonly property bool compactDarkControls: compactLandscapeLayout && controlsMode === "Dark"
    readonly property real effectiveControlsOpacity: Math.max(0.15, Math.min(1.0, controlsOpacity))
    function fadedControlColor(colorValue) {
        return root.withAlphaFactor(colorValue, root.effectiveControlsOpacity)
    }

    function compactControlColor(defaultColor, compactLightColor, compactDarkColor) {
        var color = defaultColor
        if (root.compactLandscapeLayout)
            color = root.compactDarkControls && typeof compactDarkColor !== "undefined"
                    ? compactDarkColor
                    : compactLightColor
        return root.fadedControlColor(color)
    }

    function withAlphaFactor(colorValue, factor) {
        var text = String(colorValue)
        if (text === "transparent")
            return "transparent"

        if (text.length > 0 && text[0] === "#") {
            var hex = text.slice(1)
            var alpha = 1.0
            var offset = 0

            if (hex.length === 8) {
                alpha = parseInt(hex.slice(0, 2), 16) / 255.0
                offset = 2
            } else if (hex.length !== 6) {
                return colorValue
            }

            var r = parseInt(hex.slice(offset, offset + 2), 16) / 255.0
            var g = parseInt(hex.slice(offset + 2, offset + 4), 16) / 255.0
            var b = parseInt(hex.slice(offset + 4, offset + 6), 16) / 255.0
            return Qt.rgba(r, g, b, Math.max(0.0, Math.min(1.0, alpha * factor)))
        }

        return colorValue
    }

    readonly property int previewTopOffset: rectangularLayout ? 0 : 157
    readonly property int previewVisibleHeight: rectangularLayout ? height : 405
    readonly property int topControlsSideMargin: rectangularLayout ? (largeLandscapeLayout ? 26 : (standardLandscapeLayout ? 20 : (compactLandscapeLayout ? 16 : (compactPortraitLayout ? 12 : 18)))) : 20
    readonly property int topControlsTopMargin: rectangularLayout ? (largeLandscapeLayout ? 24 : (standardLandscapeLayout ? 18 : (compactLandscapeLayout ? 14 : (compactPortraitLayout ? 14 : 18)))) : 20
    readonly property int topControlsSpacing: rectangularLayout ? (largeLandscapeLayout ? 18 : (standardLandscapeLayout ? 14 : (compactLandscapeLayout ? 10 : (compactPortraitLayout ? 8 : 10)))) : 12
    readonly property int topStatHeight: rectangularLayout ? (largeLandscapeLayout ? 100 : (standardLandscapeLayout ? 82 : (compactLandscapeLayout ? 64 : (compactPortraitLayout ? 72 : 80)))) : 86
    readonly property int topControlRadius: largeLandscapeLayout ? 28 : 22
    readonly property int topSettingsButtonSize: rectangularLayout ? (largeLandscapeLayout ? 92 : (standardLandscapeLayout ? 74 : (compactLandscapeLayout ? 56 : (compactPortraitLayout ? 62 : 70)))) : 76
    readonly property int topSettingsIconSize: largeLandscapeLayout ? 42 : (standardLandscapeLayout ? 34 : 28)
    readonly property int topValueFontSize: rectangularLayout ? (largeLandscapeLayout ? 37 : (standardLandscapeLayout ? 29 : (compactLandscapeLayout ? 19 : (compactPortraitLayout ? 21 : 23)))) : 25
    readonly property int topLabelFontSize: largeLandscapeLayout ? 16 : (standardLandscapeLayout ? 13 : (compactLandscapeLayout ? 11 : 13))
    readonly property int topArrowFontSize: largeLandscapeLayout ? 25 : (standardLandscapeLayout ? 20 : (compactLandscapeLayout ? 16 : 18))
    readonly property int topDropdownPopupMaxHeight: largeLandscapeLayout ? 500 : (standardLandscapeLayout ? 360 : (mediumLandscapeLayout ? 304 : (compactLandscapeLayout ? 220 : 340)))
    readonly property int topDropdownPopupMargin: largeLandscapeLayout ? 14 : (standardLandscapeLayout ? 10 : (mediumLandscapeLayout ? 8 : (compactLandscapeLayout ? 6 : 8)))
    readonly property int topDropdownPopupSpacing: largeLandscapeLayout ? 12 : (standardLandscapeLayout ? 8 : (mediumLandscapeLayout ? 6 : (compactLandscapeLayout ? 4 : 6)))
    readonly property int topDropdownPopupOptionHeight: largeLandscapeLayout ? 64 : (standardLandscapeLayout ? 46 : (mediumLandscapeLayout ? 38 : (compactLandscapeLayout ? 28 : 36)))
    readonly property int topDropdownPopupOptionRadius: largeLandscapeLayout ? 21 : (standardLandscapeLayout ? 16 : (mediumLandscapeLayout ? 13 : (compactLandscapeLayout ? 10 : 12)))
    readonly property int topDropdownPopupOptionFontSize: largeLandscapeLayout ? 44 : (standardLandscapeLayout ? 34 : (mediumLandscapeLayout ? 30 : (compactLandscapeLayout ? 22 : 34)))
    readonly property int topDropdownPopupRadius: largeLandscapeLayout ? 31 : (standardLandscapeLayout ? 22 : (mediumLandscapeLayout ? 18 : (compactLandscapeLayout ? 14 : 18)))
    readonly property int topDropdownPopupTopMargin: largeLandscapeLayout ? 14 : (standardLandscapeLayout ? 10 : (mediumLandscapeLayout ? 8 : (compactLandscapeLayout ? 6 : 8)))
    readonly property int bottomOverlayMargin: rectangularLayout ? (compactRectangularLayout ? 16 : 34) : 40
    readonly property int bottomControlsSpacing: largeLandscapeLayout ? 22 : (standardLandscapeLayout ? 18 : (mediumLandscapeLayout ? 14 : (compactLandscapeLayout ? 12 : 16)))
    readonly property int clipBrowserButtonSize: largeLandscapeLayout ? 88 : (standardLandscapeLayout ? 72 : (mediumLandscapeLayout ? 58 : (compactLandscapeLayout ? 52 : 64)))
    readonly property int clipBrowserIconSize: largeLandscapeLayout ? 34 : (standardLandscapeLayout ? 28 : (mediumLandscapeLayout ? 22 : (compactLandscapeLayout ? 20 : 24)))
    readonly property int recordButtonSize: largeLandscapeLayout ? 100 : (standardLandscapeLayout ? 82 : (mediumLandscapeLayout ? 64 : (compactLandscapeLayout ? 58 : 74)))
    readonly property int recordButtonCenterSize: largeLandscapeLayout ? 40 : (standardLandscapeLayout ? 32 : (mediumLandscapeLayout ? 24 : (compactLandscapeLayout ? 22 : 28)))
    readonly property int timecodeHeight: largeLandscapeLayout ? 66 : (standardLandscapeLayout ? 54 : (mediumLandscapeLayout ? 44 : (compactLandscapeLayout ? 40 : 52)))
    readonly property int timecodeRadius: largeLandscapeLayout ? 21 : (standardLandscapeLayout ? 17 : (mediumLandscapeLayout ? 14 : (compactLandscapeLayout ? 13 : 16)))
    readonly property int timecodeHorizontalPadding: largeLandscapeLayout ? 54 : (standardLandscapeLayout ? 44 : (mediumLandscapeLayout ? 30 : (compactLandscapeLayout ? 26 : 40)))
    readonly property int timecodeTextInset: largeLandscapeLayout ? 27 : (standardLandscapeLayout ? 22 : (mediumLandscapeLayout ? 15 : (compactLandscapeLayout ? 13 : 20)))
    readonly property int timecodeFontSize: largeLandscapeLayout ? 37 : (standardLandscapeLayout ? 30 : (mediumLandscapeLayout ? 24 : (compactLandscapeLayout ? 22 : 28)))
    readonly property int bottomControlsBaseMargin: compactLandscapeLayout ? 10 : bottomOverlayMargin
    readonly property int dateTimeChipHeight: largeLandscapeLayout ? 42 : (standardLandscapeLayout ? 34 : (mediumLandscapeLayout ? 28 : (compactLandscapeLayout ? 26 : 32)))
    readonly property int dateTimeChipRadius: largeLandscapeLayout ? 21 : (standardLandscapeLayout ? 17 : (mediumLandscapeLayout ? 14 : (compactLandscapeLayout ? 13 : 16)))
    readonly property int dateTimeChipHorizontalPadding: largeLandscapeLayout ? 34 : (standardLandscapeLayout ? 28 : (mediumLandscapeLayout ? 20 : (compactLandscapeLayout ? 18 : 22)))
    readonly property int dateTimeChipFontSize: largeLandscapeLayout ? 20 : (standardLandscapeLayout ? 16 : (mediumLandscapeLayout ? 13 : (compactLandscapeLayout ? 12 : 14)))
    readonly property string compactControlFill: "#24ffffff"
    readonly property string compactControlFillSoft: "#1cffffff"
    readonly property string compactControlFillActive: "#30ffffff"
    readonly property string compactControlBorder: "#30ffffff"
    readonly property string compactControlBorderActive: "#44ffffff"
    readonly property string compactDarkControlFill: "#54000000"
    readonly property string compactDarkControlFillSoft: "#44000000"
    readonly property string compactDarkControlFillActive: "#66000000"
    readonly property string compactDarkControlBorder: "#2affffff"
    readonly property string compactDarkControlBorderActive: "#3dffffff"
    readonly property int quickMenuPanelWidth: largeLandscapeLayout ? 240 : (standardLandscapeLayout ? 198 : (mediumLandscapeLayout ? 150 : (compactLandscapeLayout ? 128 : 172)))
    readonly property int quickMenuPanelHeight: largeLandscapeLayout ? 492 : (standardLandscapeLayout ? 408 : (mediumLandscapeLayout ? 308 : (compactLandscapeLayout ? 262 : 352)))
    readonly property int quickMenuPanelRadius: largeLandscapeLayout ? 34 : (standardLandscapeLayout ? 28 : (mediumLandscapeLayout ? 22 : (compactLandscapeLayout ? 20 : 26)))
    readonly property int quickMenuPanelMargin: largeLandscapeLayout ? 20 : (standardLandscapeLayout ? 16 : (mediumLandscapeLayout ? 12 : (compactLandscapeLayout ? 10 : 14)))
    readonly property int quickMenuPanelSpacing: largeLandscapeLayout ? 14 : (standardLandscapeLayout ? 11 : (mediumLandscapeLayout ? 8 : (compactLandscapeLayout ? 7 : 10)))
    readonly property int quickMenuTitleFontSize: largeLandscapeLayout ? 26 : (standardLandscapeLayout ? 21 : (mediumLandscapeLayout ? 16 : (compactLandscapeLayout ? 14 : 18)))
    readonly property int quickMenuResolutionHeight: largeLandscapeLayout ? 78 : (standardLandscapeLayout ? 64 : (mediumLandscapeLayout ? 48 : (compactLandscapeLayout ? 42 : 56)))
    readonly property int quickMenuResolutionRadius: largeLandscapeLayout ? 25 : (standardLandscapeLayout ? 21 : (mediumLandscapeLayout ? 16 : (compactLandscapeLayout ? 14 : 18)))
    readonly property int quickMenuResolutionLabelFontSize: largeLandscapeLayout ? 14 : (standardLandscapeLayout ? 12 : (mediumLandscapeLayout ? 10 : (compactLandscapeLayout ? 9 : 10)))
    readonly property int quickMenuResolutionValueFontSize: largeLandscapeLayout ? 23 : (standardLandscapeLayout ? 19 : (mediumLandscapeLayout ? 14 : (compactLandscapeLayout ? 12 : 15)))
    readonly property int quickMenuResolutionArrowFontSize: largeLandscapeLayout ? 27 : (standardLandscapeLayout ? 22 : (mediumLandscapeLayout ? 16 : (compactLandscapeLayout ? 14 : 18)))
    readonly property int quickMenuPopupMaxHeight: largeLandscapeLayout ? 286 : (standardLandscapeLayout ? 236 : (mediumLandscapeLayout ? 168 : (compactLandscapeLayout ? 142 : 196)))
    readonly property int quickMenuPopupOptionHeight: largeLandscapeLayout ? 54 : (standardLandscapeLayout ? 44 : (mediumLandscapeLayout ? 34 : (compactLandscapeLayout ? 30 : 38)))
    readonly property int quickMenuPopupOptionFontSize: largeLandscapeLayout ? 25 : (standardLandscapeLayout ? 21 : (mediumLandscapeLayout ? 16 : (compactLandscapeLayout ? 14 : 19)))
    readonly property int quickMenuButtonSize: largeLandscapeLayout ? 90 : (standardLandscapeLayout ? 74 : (mediumLandscapeLayout ? 56 : (compactLandscapeLayout ? 48 : 67)))
    readonly property int quickMenuButtonRadius: largeLandscapeLayout ? 28 : (standardLandscapeLayout ? 23 : (mediumLandscapeLayout ? 17 : (compactLandscapeLayout ? 15 : 20)))
    readonly property int quickMenuButtonSpacing: largeLandscapeLayout ? 14 : (standardLandscapeLayout ? 11 : (mediumLandscapeLayout ? 8 : (compactLandscapeLayout ? 6 : 10)))
    readonly property int quickMenuIconSize: largeLandscapeLayout ? 52 : (standardLandscapeLayout ? 43 : (mediumLandscapeLayout ? 32 : (compactLandscapeLayout ? 27 : 38)))
    readonly property int quickMenuArrowButtonWidth: largeLandscapeLayout ? 58 : (standardLandscapeLayout ? 46 : (mediumLandscapeLayout ? 35 : (compactLandscapeLayout ? 30 : 54)))
    readonly property int quickMenuArrowButtonHeight: largeLandscapeLayout ? 132 : (standardLandscapeLayout ? 106 : (mediumLandscapeLayout ? 80 : (compactLandscapeLayout ? 66 : 124)))
    readonly property int quickMenuArrowCanvasWidth: largeLandscapeLayout ? 24 : (standardLandscapeLayout ? 20 : (mediumLandscapeLayout ? 15 : (compactLandscapeLayout ? 12 : 20)))
    readonly property int quickMenuArrowCanvasHeight: largeLandscapeLayout ? 44 : (standardLandscapeLayout ? 36 : (mediumLandscapeLayout ? 27 : (compactLandscapeLayout ? 22 : 38)))
    readonly property real quickMenuArrowLineWidth: largeLandscapeLayout ? 4.4 : (standardLandscapeLayout ? 3.7 : (mediumLandscapeLayout ? 3.0 : (compactLandscapeLayout ? 2.4 : 4.0)))
    readonly property bool showCornerStats: compactLandscapeLayout || !compactRectangularLayout
    readonly property int bottomStatsSideMargin: largeLandscapeLayout ? 30 : (standardLandscapeLayout ? 24 : (compactLandscapeLayout ? 12 : 20))
    readonly property int bottomStatsWidth: largeLandscapeLayout ? 246 : (standardLandscapeLayout ? 198 : (mediumLandscapeLayout ? 152 : (compactLandscapeLayout ? 136 : 180)))
    readonly property int bottomStatsRightWidth: largeLandscapeLayout ? 242 : (standardLandscapeLayout ? 194 : (mediumLandscapeLayout ? 148 : (compactLandscapeLayout ? 132 : 178)))
    readonly property int bottomStatsSpacing: largeLandscapeLayout ? 8 : (standardLandscapeLayout ? 6 : (mediumLandscapeLayout ? 4 : (compactLandscapeLayout ? 3 : 18)))
    readonly property int bottomStatsIconSize: largeLandscapeLayout ? 21 : (standardLandscapeLayout ? 17 : (mediumLandscapeLayout ? 13 : (compactLandscapeLayout ? 11 : 18)))
    readonly property int bottomStatsRowSpacing: largeLandscapeLayout ? 10 : (standardLandscapeLayout ? 8 : (mediumLandscapeLayout ? 6 : (compactLandscapeLayout ? 5 : 8)))
    readonly property int bottomStatsTextSpacing: compactLandscapeLayout ? 0 : 1
    readonly property int bottomStatsLabelFontSize: largeLandscapeLayout ? 16 : (standardLandscapeLayout ? 13 : (mediumLandscapeLayout ? 10 : (compactLandscapeLayout ? 9 : 13)))
    readonly property int bottomStatsValueFontSize: largeLandscapeLayout ? 24 : (standardLandscapeLayout ? 20 : (mediumLandscapeLayout ? 15 : (compactLandscapeLayout ? 13 : 18)))
    readonly property int bottomStatsSubFontSize: largeLandscapeLayout ? 16 : (standardLandscapeLayout ? 13 : (mediumLandscapeLayout ? 10 : (compactLandscapeLayout ? 9 : 13)))
    readonly property int bottomStatsHeightWithSub: largeLandscapeLayout ? 70 : (standardLandscapeLayout ? 58 : (mediumLandscapeLayout ? 42 : (compactLandscapeLayout ? 38 : 56)))
    readonly property int bottomStatsHeightWithoutSub: largeLandscapeLayout ? 58 : (standardLandscapeLayout ? 48 : (mediumLandscapeLayout ? 36 : (compactLandscapeLayout ? 32 : 46)))
    readonly property int bottomStatsVerticalOffset: largeLandscapeLayout ? -20 : (standardLandscapeLayout ? -16 : (compactLandscapeLayout ? -12 : 0))
    readonly property int bottomStatsBottomMargin: standardLandscapeLayout ? (bottomOverlayMargin + 14)
                                                   : (root.rectangularLayout ? root.bottomOverlayMargin : 14)
    readonly property real falseColorLegendDisplayScale: largeLandscapeLayout ? 1.6 : (standardLandscapeLayout ? 1.12 : 1.0)
    readonly property real photoStatusChipScale: compactLandscapeLayout
                                                 ? (largeLandscapeLayout ? 1.38
                                                    : (standardLandscapeLayout ? 1.16
                                                       : (regularLandscapeLayout ? 0.96 : 0.80)))
                                                 : 1.0
    readonly property int photoStatusChipHeight: Math.round(30 * photoStatusChipScale)
    readonly property int photoStatusChipHorizontalPadding: Math.round(18 * photoStatusChipScale)
    readonly property int photoStatusChipDotSize: compactLandscapeLayout
                                                 ? (largeLandscapeLayout ? 14
                                                    : (standardLandscapeLayout ? 12
                                                       : (regularLandscapeLayout ? 10 : 8)))
                                                 : 10
    readonly property int photoStatusChipFontSize: compactLandscapeLayout
                                                  ? (largeLandscapeLayout ? 18
                                                     : (standardLandscapeLayout ? 16
                                                        : (regularLandscapeLayout ? 14 : 12)))
                                                  : 14
    readonly property string timecodeMode: settingsState ? settingsState.timecodeMode : "Free Run"
    readonly property bool photoModeEnabled: settingsState ? settingsState.photoModeEnabled : false
    readonly property string uiOrientation: settingsState ? settingsState.uiOrientation : "Landscape"
    readonly property int uiPreviewRotation: uiOrientation === "Left Side" ? -90
                                              : (uiOrientation === "Right Side" ? 90
                                                                           : (uiOrientation === "Upside Down" ? 180 : 0))
    readonly property string photoTimerSetting: settingsState ? settingsState.photoTimer : "Off"
    readonly property string photoBurstSetting: settingsState ? settingsState.photoBurst : "Single"
    readonly property string photoFormatSetting: settingsState ? settingsState.photoFormat : "DNG"
    readonly property bool dateTimeOverlayEnabled: settingsState ? settingsState.dateTimeOverlayEnabled : false
    readonly property bool smpteEnabled: settingsState ? settingsState.smpteEnabled : false
    readonly property bool falseColorLegendVisible: settingsState ? (settingsState.falseColorEnabled && !settingsState.smpteEnabled) : false
    readonly property bool recordAudioEnabled: settingsState ? settingsState.recordAudioEnabled : false
    readonly property bool audioMeterEnabled: settingsState ? settingsState.audioMeterEnabled : false
    readonly property bool audioInputAvailable: (typeof audioMeterBridge !== "undefined" && audioMeterBridge)
                                               ? audioMeterBridge.inputDeviceAvailable
                                               : false
    readonly property bool anamorphicDesqueezeEnabled: settingsState ? settingsState.anamorphicDesqueezeEnabled : false
    readonly property real anamorphicDesqueezeRatio: {
        if (!settingsState)
            return 1.33

        var label = settingsState.anamorphicRatio
        if (!label || label.length === 0)
            return 1.33

        var parsed = parseFloat(String(label).replace("x", ""))
        return (isNaN(parsed) || parsed < 1.0) ? 1.33 : parsed
    }
    readonly property int inputVolumeLevel: settingsState ? settingsState.inputVolume : 60
    readonly property int headphoneVolumeLevel: settingsState ? settingsState.headphoneVolume : 55
    readonly property bool showAudioMeter: root.recordAudioEnabled
                                           && root.audioMeterEnabled
                                           && !root.photoModeEnabled
                                           && root.audioInputAvailable
    readonly property bool vmountPowerPresent: powerBridge.sensorAvailable && powerBridge.busVoltageV > 3.0
    readonly property string powerOverlayValue: !powerBridge.sensorAvailable
                                               ? "INA219"
                                               : (!root.vmountPowerPresent
                                                  ? "External"
                                                  : (powerBridge.voltageText + " • " + powerBridge.batteryPercentText))
    readonly property string powerOverlaySubtext: !powerBridge.sensorAvailable
                                                 ? "Unavailable"
                                                 : (!root.vmountPowerPresent
                                                    ? "DC INPUT"
                                                    : ("VMOUNT • " + powerBridge.powerText))
    property bool photoCapturePulse: false
    property bool photoCaptureInProgress: false
    property int pendingPhotoShots: 0
    property int photoCountdownSecondsRemaining: 0
    property date currentDateTime: new Date()
    readonly property string dateTimeOverlayText: Qt.formatDateTime(root.currentDateTime, "dd MMM yyyy  HH:mm")

    property string fps: "24.000"
	
	onFpsChanged: {
	        mediaBridge.fps = parseFloat(fps)
	        root.updateMediaEstimate()
	        root.updateTimecodeDisplay()
	    }
		
	    Component.onCompleted: {
	        root.syncControlValuesFromBridge()
	        root.ensureValidResolutionSelection()
	        root.ensureValidFpsSelection()
	        mediaBridge.fps = parseFloat(fps)
	        root.updateMediaEstimate()
	        root.updateTimecodeDisplay()
	    }
	
    property string iso: "800"
    property string shutterAngle: "180°"
    property string shutterSpeed: "1/48"
    property string wb: "5600K"
    property string resolution: "1920x1080"
    property bool controlResolutionSynced: false
    readonly property string sensorNameLower: (typeof deviceInfoBridge !== "undefined"
                                               && deviceInfoBridge
                                               && deviceInfoBridge.sensorName)
                                              ? deviceInfoBridge.sensorName.toLowerCase()
                                              : ""
    readonly property bool imx585Detected: root.sensorNameLower.indexOf("imx585") !== -1
    readonly property bool imx577Detected: root.sensorNameLower.indexOf("imx577") !== -1
    readonly property bool imx477Detected: root.sensorNameLower.indexOf("imx477") !== -1
    readonly property var resolutionOptions: root.imx577Detected
                                             ? ["1332x990", "2028x1080", "2028x1520", "4056x2160", "4056x3040"]
                                             : (root.imx477Detected
                                                ? ["1332x990", "2028x1080", "2028x1520"]
                                                : ["1920x1080", "3840x2160"])
    readonly property string shutterDisplayValue: root.photoModeEnabled ? root.shutterSpeed : root.shutterAngle
    readonly property var shutterOptions: root.photoModeEnabled
                                         ? ["Auto", "1/24", "1/30", "1/40", "1/48", "1/50", "1/60", "1/80", "1/100", "1/125", "1/160", "1/200", "1/250", "1/320", "1/500", "1/1000"]
                                         : ["Auto", "11.25°", "15°", "22.5°", "30°", "37.5°", "45°", "60°", "72°", "75°", "90°", "108°", "120°", "144°", "150°", "172.8°", "180°", "216°", "270°", "324°", "360°"]
    readonly property var fpsOptions: root.availableFpsOptions()
    readonly property string formatDisplayValue: root.resolution
    readonly property string formatDisplaySubtext: "Uncompressed"
	
	//Zoom Property
	property real previewZoom: 1.0
    property real minPreviewZoom: 1.0
    property real maxPreviewZoom: 4.0
	
	//Pan Property
	property real previewPanX: 0.0
    property real previewPanY: 0.0

    property string openDropdown: ""
    property bool quickMenuOpen: false
    property bool quickMenuResolutionOpen: false
    readonly property int quickMenuButtonCount: 6
    readonly property real quickMenuSwipeEdgeWidth: 44

    onQuickMenuOpenChanged: {
        if (!quickMenuOpen)
            quickMenuResolutionOpen = false
    }

    function quickMenuSlotLabel(index) {
        if (index <= 5)
            return ""
        return "Q" + (index + 1)
    }

    function quickMenuSlotSubtitle(index) {
        if (index <= 5)
            return ""
        return "Soon"
    }

    function quickMenuSlotIconSource(index) {
        if (index === 0)
            return "qrc:/qml/icons/focuspeaking.png"
        if (index === 1)
            return "qrc:/qml/icons/zebra.png"
        if (index === 2)
            return "qrc:/qml/icons/false-color.png"
        if (index === 3)
            return "qrc:/qml/icons/guides.png"
        if (index === 4)
            return "qrc:/qml/icons/center-marker.png"
        if (index === 5)
            return "qrc:/qml/icons/grayscale.png"
        return ""
    }

    function quickMenuSlotActive(index) {
        if (!root.settingsState)
            return false
        if (index === 0)
            return root.settingsState.focusPeakingEnabled
        if (index === 1)
            return root.settingsState.zebraEnabled
        if (index === 2)
            return root.settingsState.falseColorEnabled
        if (index === 3)
            return root.settingsState.guidesEnabled
        if (index === 4)
            return root.settingsState.centerMarkerEnabled
        if (index === 5)
            return root.settingsState.grayscaleEnabled
        return false
    }

    function triggerQuickMenuSlot(index) {
        if (!root.settingsState)
            return

        if (index === 0)
            root.settingsState.focusPeakingEnabled = !root.settingsState.focusPeakingEnabled
        else if (index === 1)
            root.settingsState.zebraEnabled = !root.settingsState.zebraEnabled
        else if (index === 2)
            root.settingsState.falseColorEnabled = !root.settingsState.falseColorEnabled
        else if (index === 3)
            root.settingsState.guidesEnabled = !root.settingsState.guidesEnabled
        else if (index === 4)
            root.settingsState.centerMarkerEnabled = !root.settingsState.centerMarkerEnabled
        else if (index === 5)
            root.settingsState.grayscaleEnabled = !root.settingsState.grayscaleEnabled
    }

    function pad2(v) {
    return v < 10 ? "0" + v : "" + v
}

function currentFpsInt() {
    var parsed = parseFloat(root.fps)
    if (isNaN(parsed) || parsed <= 0)
        return 24
    return Math.round(parsed)
}

function currentFpsValue() {
    var parsed = parseFloat(root.fps)
    if (isNaN(parsed) || parsed <= 0)
        return 24.0
    return parsed
}

function formatFpsValue(value) {
    return Number(value).toFixed(3)
}

function maximumSelectableFps() {
    if (!root.fpsOptions || root.fpsOptions.length === 0)
        return 24.0
    var parsed = parseFloat(root.fpsOptions[root.fpsOptions.length - 1])
    return isNaN(parsed) || parsed <= 0 ? 24.0 : parsed
}

function maximumSupportedFpsForResolution(resolutionValue) {
    if (root.imx577Detected) {
        if (resolutionValue === "1332x990")
            return 101.68
        if (resolutionValue === "2028x1080" || resolutionValue === "1928x1090" || resolutionValue === "1920x1080")
            return 62.81
        if (resolutionValue === "2028x1520")
            return 45.19
        if (resolutionValue === "4056x2160" || resolutionValue === "3856x2180" || resolutionValue === "3840x2160")
            return 16.39
        if (resolutionValue === "4056x3040")
            return 11.72
    }

    if (root.imx477Detected) {
        if (resolutionValue === "1332x990")
            return 100.0
        if (resolutionValue === "2028x1080")
            return 60.0
        if (resolutionValue === "2028x1520")
            return 30.0
        if (resolutionValue === "1928x1090" || resolutionValue === "1920x1080")
            return 60.0
        if (resolutionValue === "3856x2180" || resolutionValue === "3840x2160")
            return 30.0
    }

    if (root.imx585Detected && (resolutionValue === "3856x2180" || resolutionValue === "3840x2160"))
        return 30.0

    return 60.0
}

function availableFpsOptions() {
    var presets = (root.imx477Detected || root.imx577Detected)
                  ? [24.000, 25.000, 30.000, 50.000, 60.000, 100.000]
                  : [24.000, 25.000, 30.000, 50.000, 60.000]
    var max = root.maximumSupportedFpsForResolution(root.resolution)
    var filtered = []
    for (var i = 0; i < presets.length; ++i) {
        if (presets[i] <= max + 0.0005)
            filtered.push(root.formatFpsValue(presets[i]))
    }
    return filtered.length > 0 ? filtered : [root.formatFpsValue(max)]
}

function estimatedFrameSizeMB() {
    var normalized = root.normalizedResolutionForCurrentSensor(root.resolution)

    if (root.imx477Detected) {
        if (normalized === "1332x990")
            return 2.0
        if (normalized === "2028x1080")
            return 3.3
        if (normalized === "2028x1520")
            return 4.6
    }

    if (root.imx577Detected) {
        if (normalized === "1332x990")
            return 2.0
        if (normalized === "2028x1080")
            return 3.3
        if (normalized === "2028x1520")
            return 4.6
        if (normalized === "4056x2160")
            return 13.2
        if (normalized === "4056x3040")
            return 18.5
    }

    if (root.imx585Detected) {
        if (normalized === "3856x2180" || normalized === "3840x2160")
            return 12.4
        if (normalized === "1928x1090" || normalized === "1920x1080")
            return 3.1
    }

    if (normalized === "1332x990")
        return 2.0
    if (normalized === "2028x1080")
        return 3.3
    if (normalized === "2028x1520")
        return 4.6
    if (normalized === "3856x2180" || normalized === "3840x2160")
        return 12.4
    if (normalized === "1928x1090" || normalized === "1920x1080")
        return 3.1

    return 5.3
}

function updateMediaEstimate() {
    if (typeof mediaBridge === "undefined" || !mediaBridge)
        return

    mediaBridge.frameSizeMB = root.estimatedFrameSizeMB()
}

function resolutionOptionsForCurrentSensor() {
    if (root.imx577Detected)
        return ["1332x990", "2028x1080", "2028x1520", "4056x2160", "4056x3040"]
    return root.imx477Detected
           ? ["1332x990", "2028x1080", "2028x1520"]
           : ["1920x1080", "3840x2160"]
}

function normalizedResolutionForCurrentSensor(resolutionValue) {
    var currentOptions = root.resolutionOptionsForCurrentSensor()

    if (root.imx577Detected) {
        if (resolutionValue === "1928x1090" || resolutionValue === "1920x1080")
            return "2028x1080"
        if (resolutionValue === "3856x2180" || resolutionValue === "3840x2160")
            return "4056x2160"
        if (currentOptions.indexOf(resolutionValue) !== -1)
            return resolutionValue
        return "2028x1080"
    }

    if (root.imx477Detected) {
        if (resolutionValue === "1928x1090" || resolutionValue === "1920x1080")
            return "2028x1080"
        if (resolutionValue === "3856x2180" || resolutionValue === "3840x2160")
            return "2028x1080"
        if (resolutionValue === "4056x2160")
            return "2028x1080"
        if (resolutionValue === "4056x3040")
            return "2028x1520"
        if (currentOptions.indexOf(resolutionValue) !== -1)
            return resolutionValue
        return "2028x1080"
    }

    if (root.imx585Detected) {
        if (resolutionValue === "1332x990" ||
                resolutionValue === "2028x1080" ||
                resolutionValue === "2028x1520")
            return "1920x1080"
        if (resolutionValue === "1928x1090" || resolutionValue === "1920x1080")
            return "1920x1080"
        if (resolutionValue === "3856x2180" || resolutionValue === "3840x2160")
            return "3840x2160"
        if (resolutionValue === "4056x2160" ||
                resolutionValue === "4056x3040")
            return "3840x2160"
        if (currentOptions.indexOf(resolutionValue) !== -1)
            return resolutionValue
        return "1920x1080"
    }

    return resolutionValue
}

function ensureValidResolutionSelection() {
    var normalized = root.normalizedResolutionForCurrentSensor(root.resolution)
    if (normalized === root.resolution)
        return

    if (!root.controlResolutionSynced) {
        root.resolution = normalized
    } else if (root.controlBridge) {
        root.controlBridge.applyResolution(normalized)
    } else {
        root.resolution = normalized
    }
}

function photoTimerDelayMs() {
    if (root.photoTimerSetting === "2s")
        return 2000
    if (root.photoTimerSetting === "5s")
        return 5000
    if (root.photoTimerSetting === "10s")
        return 10000
    if (root.photoTimerSetting === "15s")
        return 15000
    if (root.photoTimerSetting === "20s")
        return 20000
    if (root.photoTimerSetting === "25s")
        return 25000
    if (root.photoTimerSetting === "30s")
        return 30000
    return 0
}

function photoBurstCount() {
    if (root.photoBurstSetting === "3 Shots")
        return 3
    if (root.photoBurstSetting === "5 Shots")
        return 5
    if (root.photoBurstSetting === "10 Shots")
        return 10
    return 1
}

function photoBurstIntervalMs() {
    return Math.max(16, Math.round(1000 / root.currentFpsValue()))
}

function cancelPhotoSequence() {
    root.photoCaptureInProgress = false
    root.pendingPhotoShots = 0
    root.photoCountdownSecondsRemaining = 0
    photoDelayTimer.stop()
    photoCountdownTimer.stop()
    photoBurstTimer.stop()
}

function queueNextPhotoInSequence() {
    if (root.pendingPhotoShots <= 0) {
        root.photoCaptureInProgress = false
        photoBurstTimer.stop()
        return
    }

    var captureQueued = true
    if (root.controlBridge)
        captureQueued = root.controlBridge.capturePhoto(root.photoFormatSetting)
    if (!captureQueued) {
        root.cancelPhotoSequence()
        return
    }

    root.photoCapturePulse = false
    photoCapturePulseTimer.stop()
    root.photoCapturePulse = true
    photoCapturePulseTimer.start()
    photoCaptureFeedbackAnimation.restart()

    root.pendingPhotoShots -= 1
    if (root.pendingPhotoShots > 0) {
        photoBurstTimer.interval = root.photoBurstIntervalMs()
        photoBurstTimer.start()
    } else {
        root.photoCaptureInProgress = false
    }
}

function beginPhotoCaptureSequence() {
    if (root.photoCaptureInProgress)
        return

    root.photoCaptureInProgress = true
    root.pendingPhotoShots = root.photoBurstCount()

    var delayMs = root.photoTimerDelayMs()
    if (delayMs > 0) {
        root.photoCountdownSecondsRemaining = Math.max(1, Math.ceil(delayMs / 1000))
        photoDelayTimer.interval = delayMs
        photoDelayTimer.start()
        photoCountdownTimer.start()
        return
    }

    root.queueNextPhotoInSequence()
}

function clampPreviewPan(value) {
    return Math.max(-1.0, Math.min(1.0, value))
}

function resetPreviewTransform() {
    root.previewZoom = 1.0
    root.previewPanX = 0.0
    root.previewPanY = 0.0
}

function togglePreviewZoom() {
    if (root.previewZoom > 1.01) {
        root.resetPreviewTransform()
    } else {
        root.previewZoom = 2.0
        root.previewPanX = 0.0
        root.previewPanY = 0.0
    }
}

function ensureValidFpsSelection() {
    var current = root.currentFpsValue()
    var max = root.maximumSelectableFps()
    if (current <= max + 0.0005)
        return

    var clamped = root.formatFpsValue(max)
    if (root.controlBridge) {
        root.controlBridge.applyFps(clamped)
    } else {
        root.fps = clamped
    }
}

function syncControlValuesFromBridge() {
    if (!root.controlBridge)
        return

    if (root.controlBridge.fps && root.controlBridge.fps.length > 0)
        root.fps = root.controlBridge.fps

    if (root.controlBridge.iso && root.controlBridge.iso.length > 0)
        root.iso = root.controlBridge.iso

    if (root.controlBridge.shutterAngle && root.controlBridge.shutterAngle.length > 0)
        root.shutterAngle = root.controlBridge.shutterAngle

    if (root.controlBridge.shutterSpeed && root.controlBridge.shutterSpeed.length > 0)
        root.shutterSpeed = root.controlBridge.shutterSpeed

    if (root.controlBridge.whiteBalance && root.controlBridge.whiteBalance.length > 0)
        root.wb = root.controlBridge.whiteBalance

    if (root.controlBridge.resolution && root.controlBridge.resolution.length > 0) {
        root.controlResolutionSynced = true
        root.resolution = root.controlBridge.resolution
    }

    root.recording = root.controlBridge.recording
}

function requestRecordingState(recordingState) {
    if (root.controlBridge) {
        if (recordingState && typeof audioMeterBridge !== "undefined" && audioMeterBridge)
            audioMeterBridge.suspendMonitoring()

        const success = root.controlBridge.setRecording(recordingState)
        if (!success) {
            if (recordingState && typeof audioMeterBridge !== "undefined" && audioMeterBridge)
                audioMeterBridge.resumeMonitoring()

            var fallbackError = recordingState
                                ? "ApertarCore did not start recording."
                                : "ApertarCore did not stop recording."
            var errorText = (root.controlBridge.lastError && root.controlBridge.lastError.length > 0)
                            ? root.controlBridge.lastError
                            : fallbackError
            root.showRecordWarning(recordingState ? "Recording Failed" : "Stop Failed",
                                   errorText,
                                   recordingState ? "The camera is still in standby"
                                                  : "Recording is still active",
                                   recordingState
                                       ? "Check media and audio device settings, then try again."
                                       : "Please try stopping again in a moment.")
        }
    } else {
        root.recording = recordingState
    }
}

function showRecordWarning(title, subtitle, detailTitle, detailBody) {
    root.recordWarningTitle = title
    root.recordWarningSubtitle = subtitle
    root.recordWarningDetailTitle = detailTitle
    root.recordWarningDetailBody = detailBody
    root.recordWarningOpen = true
}

function showNoMediaWarning(forPhoto) {
    root.showRecordWarning("No Media Mounted",
                           forPhoto
                               ? ("Insert " + mediaBridge.mediaPromptLabel + " to capture a still.")
                               : ("Insert " + mediaBridge.mediaPromptLabel + " to start recording."),
                           forPhoto
                               ? "Still capture is unavailable"
                               : "Recording is unavailable",
                           forPhoto
                               ? "The camera will stay in still mode until media is detected."
                               : "The camera will stay in standby until media is detected.")
}

function formatTimecode(totalFrames) {
    var fpsInt = currentFpsInt()

    var hours = Math.floor(totalFrames / (fpsInt * 3600))
    var remainder = totalFrames % (fpsInt * 3600)

    var minutes = Math.floor(remainder / (fpsInt * 60))
    remainder = remainder % (fpsInt * 60)

    var seconds = Math.floor(remainder / fpsInt)
    var frames = remainder % fpsInt

    return pad2(hours) + ":" + pad2(minutes) + ":" + pad2(seconds) + ":" + pad2(frames)
}

function updateTimecodeDisplay() {
    if (root.timecodeMode === "Free Run") {
        var now = new Date()
        var fpsInt = currentFpsInt()
        var frame = Math.floor((now.getMilliseconds() / 1000) * fpsInt)
        if (frame >= fpsInt)
            frame = fpsInt - 1

        root.timecode = pad2(now.getHours())
                      + ":" + pad2(now.getMinutes())
                      + ":" + pad2(now.getSeconds())
                      + ":" + pad2(frame)
    } else {
        root.timecode = root.formatTimecode(root.timecodeFrames)
    }
}

function toggleTimecodeMode() {
    var nextMode = root.timecodeMode === "Free Run" ? "Rec Run" : "Free Run"
    if (root.settingsState)
        root.settingsState.timecodeMode = nextMode
    if (typeof apertarControlBridge !== "undefined" && apertarControlBridge)
        apertarControlBridge.applyTimecodeMode(nextMode)
}

function falseColorModeToInt(mode) {
    if (mode === "Exposure Based") return 0
    if (mode === "Skin Tone") return 1
    if (mode === "Highlight Priority") return 2
    if (mode === "Shadow Priority") return 3
    return 0
}

function intToFalseColorMode(mode) {
    if (mode === 0) return "Exposure Based"
    if (mode === 1) return "Skin Tone"
    if (mode === 2) return "Highlight Priority"
    if (mode === 3) return "Shadow Priority"
    return "Exposure Based"
}

property int timecodeFrames: 0
property string timecode: "00:00:00:00"

Timer {
    id: recordTimer
    interval: Math.max(1, Math.round(1000 / currentFpsInt()))
    running: root.timecodeMode === "Free Run"
    repeat: true
    onTriggered: {
        if (root.timecodeMode === "Free Run") {
            root.updateTimecodeDisplay()
        }
    }
}

Timer {
    interval: 1000
    running: root.dateTimeOverlayEnabled
    repeat: true
    triggeredOnStart: true
    onTriggered: root.currentDateTime = new Date()
}

onTimecodeModeChanged: {
    if (root.timecodeMode === "Rec Run" && !root.recording)
        root.timecodeFrames = 0
    root.updateTimecodeDisplay()
}

onPhotoModeEnabledChanged: {
    if (root.photoModeEnabled && root.recording) {
        root.requestRecordingState(false)
        root.updateTimecodeDisplay()
    }
    if (!root.photoModeEnabled)
        root.cancelPhotoSequence()
}

onResolutionChanged: {
    root.ensureValidResolutionSelection()
    root.ensureValidFpsSelection()
    root.updateMediaEstimate()
}
onImx585DetectedChanged: {
    root.ensureValidResolutionSelection()
    root.ensureValidFpsSelection()
    root.updateMediaEstimate()
}
onImx577DetectedChanged: {
    root.ensureValidResolutionSelection()
    root.ensureValidFpsSelection()
    root.updateMediaEstimate()
}
onImx477DetectedChanged: {
    root.ensureValidResolutionSelection()
    root.ensureValidFpsSelection()
    root.updateMediaEstimate()
}

Connections {
    target: mediaBridge

    function onMediaMountedChanged() {
        if (mediaBridge.mediaMounted)
            root.recordWarningOpen = false
    }
}

Connections {
    target: root.controlBridge

    function onFpsChanged() {
        if (root.controlBridge && root.controlBridge.fps.length > 0)
            root.fps = root.controlBridge.fps
    }

    function onIsoChanged() {
        if (root.controlBridge && root.controlBridge.iso.length > 0)
            root.iso = root.controlBridge.iso
    }

    function onShutterAngleChanged() {
        if (root.controlBridge && root.controlBridge.shutterAngle.length > 0)
            root.shutterAngle = root.controlBridge.shutterAngle
    }

    function onShutterSpeedChanged() {
        if (root.controlBridge && root.controlBridge.shutterSpeed.length > 0)
            root.shutterSpeed = root.controlBridge.shutterSpeed
    }

    function onWhiteBalanceChanged() {
        if (root.controlBridge && root.controlBridge.whiteBalance.length > 0)
            root.wb = root.controlBridge.whiteBalance
    }

    function onResolutionChanged() {
        if (root.controlBridge && root.controlBridge.resolution.length > 0) {
            root.controlResolutionSynced = true
            root.resolution = root.controlBridge.resolution
        }
    }

    function onRecordingChanged() {
        var wasRecording = root.recording
        root.recording = root.controlBridge ? root.controlBridge.recording : false
        if (root.timecodeMode === "Rec Run" && !wasRecording && root.recording)
            root.timecodeFrames = 0
        root.updateTimecodeDisplay()
    }
}

Connections {
    target: root.bridge

    function onFrameArrived() {
        if (root.timecodeMode === "Rec Run" && root.recording) {
            root.timecodeFrames += 1
            root.updateTimecodeDisplay()
        }
    }
}

Timer {
    id: photoCapturePulseTimer
    interval: 220
    repeat: false
    onTriggered: root.photoCapturePulse = false
}

Timer {
    id: photoDelayTimer
    interval: 0
    repeat: false
    onTriggered: {
        root.photoCountdownSecondsRemaining = 0
        photoCountdownTimer.stop()
        root.queueNextPhotoInSequence()
    }
}

Timer {
    id: photoCountdownTimer
    interval: 1000
    repeat: true
    onTriggered: {
        if (root.photoCountdownSecondsRemaining > 1) {
            root.photoCountdownSecondsRemaining -= 1
        } else {
            root.photoCountdownSecondsRemaining = 1
            stop()
        }
    }
}

Timer {
    id: photoBurstTimer
    interval: 0
    repeat: false
    onTriggered: root.queueNextPhotoInSequence()
}


    // =========================
    // PREVIEW AREA
    // =========================
	
    Item {
        id: previewContainer
        objectName: "previewContainer"
        anchors.horizontalCenter: parent.horizontalCenter
        y: root.previewTopOffset
        width: parent.width
        height: root.previewVisibleHeight

        CameraPreviewItem {
            id: preview
            objectName: "previewItem"
            anchors.fill: parent
            bridge: root.bridge
            zoom: root.previewZoom
            panX: root.previewPanX
            panY: root.previewPanY
            zebraEnabled: root.settingsState ? root.settingsState.zebraEnabled : false
            zebraThreshold: root.settingsState ? root.settingsState.zebraThreshold : 0.70
            focusPeakingEnabled: root.settingsState ? root.settingsState.focusPeakingEnabled : false
            focusPeakingThreshold: root.settingsState ? root.settingsState.focusPeakingThreshold : 0.04
            focusPeakingColor: root.settingsState ? root.settingsState.focusPeakingColor : "Red"
            grayscaleEnabled: root.settingsState ? root.settingsState.grayscaleEnabled : false
            smpteEnabled: root.smpteEnabled
            anamorphicDesqueezeEnabled: root.anamorphicDesqueezeEnabled
            anamorphicDesqueezeRatio: root.anamorphicDesqueezeRatio
            falseColorEnabled: root.settingsState ? root.settingsState.falseColorEnabled : false
            falseColorMode: root.settingsState ? root.settingsState.falseColorMode : 0
            displayRotation: root.uiPreviewRotation - root.sceneRotationDegrees
        }

        Rectangle {
            id: photoFlashOverlay
            anchors.fill: parent
            color: "white"
            opacity: 0.0
            visible: opacity > 0.01
            z: 27
        }

        Rectangle {
            id: photoCaptureFramePulse
            anchors.fill: parent
            anchors.margins: 10
            radius: 28
            color: "transparent"
            border.width: 2
            border.color: "white"
            opacity: 0.0
            scale: 0.992
            visible: opacity > 0.01
            z: 28
        }

        SequentialAnimation {
            id: photoCaptureFeedbackAnimation

            ScriptAction {
                script: {
                    photoFlashOverlay.opacity = 0.0
                    photoCaptureFramePulse.opacity = 0.0
                    photoCaptureFramePulse.scale = 0.992
                }
            }

            ParallelAnimation {
                NumberAnimation {
                    target: photoFlashOverlay
                    property: "opacity"
                    from: 0.58
                    to: 0.0
                    duration: 320
                    easing.type: Easing.OutCubic
                }

                SequentialAnimation {
                    NumberAnimation {
                        target: photoCaptureFramePulse
                        property: "opacity"
                        from: 0.88
                        to: 0.48
                        duration: 110
                        easing.type: Easing.OutCubic
                    }
                    NumberAnimation {
                        target: photoCaptureFramePulse
                        property: "opacity"
                        to: 0.0
                        duration: 360
                        easing.type: Easing.OutCubic
                    }
                }

                NumberAnimation {
                    target: photoCaptureFramePulse
                    property: "scale"
                    from: 0.992
                    to: 1.018
                    duration: 460
                    easing.type: Easing.OutCubic
                }
            }
        }

        Rectangle {
            visible: root.photoCountdownSecondsRemaining > 0
            anchors.centerIn: parent
            width: 132
            height: 132
            radius: 66
            color: "#9a000000"
            border.width: 2
            border.color: "#66ffffff"
            z: 30

            Column {
                anchors.centerIn: parent
                spacing: -4

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: root.photoCountdownSecondsRemaining
                    color: "white"
                    font.family: gothamBold.font.family
                    font.pixelSize: 56
                    renderType: Text.NativeRendering
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "SECONDS"
                    color: "#d9ffffff"
                    font.family: interBold.font.family
                    font.pixelSize: 12
                    font.capitalization: Font.AllUppercase
                    font.letterSpacing: 2.4
                    renderType: Text.NativeRendering
                }
            }
        }
		
        MultiPointTouchArea {
            id: previewTouchArea
            anchors.fill: parent
            minimumTouchPoints: 1
            maximumTouchPoints: 2
            mouseEnabled: false
            z: 25

            property int gestureMode: 0
            property real singleStartX: 0.0
            property real singleStartY: 0.0
            property real singleStartPanX: 0.0
            property real singleStartPanY: 0.0
            property bool singleMoved: false
            property bool blockedForQuickMenuSwipe: false
            property double singlePressTimestamp: 0
            property double lastTapTimestamp: 0
            property real lastTapX: 0.0
            property real lastTapY: 0.0
            property real pinchStartZoom: 1.0
            property real pinchStartDistance: 1.0

            touchPoints: [
                TouchPoint { id: previewTouchPoint1 },
                TouchPoint { id: previewTouchPoint2 }
            ]

            function activePointCount() {
                var count = 0
                if (previewTouchPoint1.pressed)
                    count += 1
                if (previewTouchPoint2.pressed)
                    count += 1
                return count
            }

            function activePrimaryPoint() {
                return previewTouchPoint1.pressed ? previewTouchPoint1 : previewTouchPoint2
            }

            function shouldReserveForQuickMenuSwipe(point) {
                return !!point
                        && quickMenuEdgeSwipeZone.visible
                        && point.x >= (previewTouchArea.width - root.quickMenuSwipeEdgeWidth)
            }

            function currentPinchDistance() {
                var dx = previewTouchPoint1.x - previewTouchPoint2.x
                var dy = previewTouchPoint1.y - previewTouchPoint2.y
                return Math.sqrt((dx * dx) + (dy * dy))
            }

            function beginSingleTouchGesture(markAsMoved) {
                var point = activePrimaryPoint()
                if (!point)
                    return

                gestureMode = 1
                singleStartX = point.x
                singleStartY = point.y
                singleStartPanX = root.previewPanX
                singleStartPanY = root.previewPanY
                singleMoved = markAsMoved
                singlePressTimestamp = Date.now()
            }

            function beginPinchGesture() {
                gestureMode = 2
                pinchStartZoom = root.previewZoom
                pinchStartDistance = Math.max(1.0, currentPinchDistance())
                singleMoved = true
            }

            function finishSingleTap(pointX, pointY) {
                var now = Date.now()
                var withinTapTime = (now - singlePressTimestamp) <= 350
                if (!withinTapTime || singleMoved)
                    return

                var dx = pointX - lastTapX
                var dy = pointY - lastTapY
                var distance = Math.sqrt((dx * dx) + (dy * dy))
                if (lastTapTimestamp > 0 &&
                        (now - lastTapTimestamp) <= 350 &&
                        distance <= 48) {
                    root.togglePreviewZoom()
                    lastTapTimestamp = 0
                    return
                }

                lastTapTimestamp = now
                lastTapX = pointX
                lastTapY = pointY
            }

            onPressed: {
                var count = activePointCount()
                if (count >= 2) {
                    blockedForQuickMenuSwipe = false
                    beginPinchGesture()
                } else if (count === 1) {
                    var point = activePrimaryPoint()
                    blockedForQuickMenuSwipe = shouldReserveForQuickMenuSwipe(point)
                    if (blockedForQuickMenuSwipe) {
                        gestureMode = 0
                        singleMoved = true
                        return
                    }
                    beginSingleTouchGesture(false)
                }
            }

            onUpdated: {
                if (blockedForQuickMenuSwipe)
                    return

                var count = activePointCount()
                if (count >= 2) {
                    if (gestureMode !== 2)
                        beginPinchGesture()

                    var scale = currentPinchDistance() / Math.max(1.0, pinchStartDistance)
                    root.previewZoom = Math.max(root.minPreviewZoom,
                                                Math.min(root.maxPreviewZoom, pinchStartZoom * scale))

                    if (root.previewZoom <= 1.01) {
                        root.previewPanX = 0.0
                        root.previewPanY = 0.0
                    }
                    return
                }

                if (count === 1) {
                    if (gestureMode === 2) {
                        beginSingleTouchGesture(true)
                        return
                    }

                    if (gestureMode !== 1)
                        beginSingleTouchGesture(false)

                    var point = activePrimaryPoint()
                    var dx = point.x - singleStartX
                    var dy = point.y - singleStartY
                    if (Math.abs(dx) > 12 || Math.abs(dy) > 12)
                        singleMoved = true

                    if (root.previewZoom > 1.01) {
                        var nx = dx / previewContainer.width
                        var ny = dy / previewContainer.height
                        root.previewPanX = root.clampPreviewPan(singleStartPanX - (nx * 2.0))
                        root.previewPanY = root.clampPreviewPan(singleStartPanY - (ny * 2.0))
                    }
                }
            }

            onReleased: {
                if (blockedForQuickMenuSwipe) {
                    if (activePointCount() === 0)
                        blockedForQuickMenuSwipe = false
                    gestureMode = 0
                    return
                }

                var count = activePointCount()
                if (count === 1) {
                    beginSingleTouchGesture(true)
                    return
                }

                if (count === 0) {
                    if (gestureMode === 1)
                        finishSingleTap(singleStartX, singleStartY)
                    gestureMode = 0
                }
            }

            onCanceled: {
                gestureMode = 0
                singleMoved = false
                blockedForQuickMenuSwipe = false
            }
        }

        DragHandler {
            id: previewDragHandler
            target: null
            acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
            minimumPointCount: 1
            maximumPointCount: 1
            grabPermissions: PointerHandler.CanTakeOverFromAnything | PointerHandler.ApprovesTakeOverByAnything
            enabled: root.previewZoom > 1.01

            property real startPanX: 0.0
            property real startPanY: 0.0

            onActiveChanged: {
                if (!active)
                    return

                startPanX = root.previewPanX
                startPanY = root.previewPanY
            }

            onActiveTranslationChanged: {
                if (!active)
                    return

                var nx = activeTranslation.x / previewContainer.width
                var ny = activeTranslation.y / previewContainer.height

                root.previewPanX = root.clampPreviewPan(startPanX - (nx * 2.0))
                root.previewPanY = root.clampPreviewPan(startPanY - (ny * 2.0))
            }
        }

        TapHandler {
            id: previewMouseTapHandler
            target: null
            acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
            gesturePolicy: TapHandler.ReleaseWithinBounds
            grabPermissions: PointerHandler.CanTakeOverFromAnything | PointerHandler.ApprovesTakeOverByAnything

            onDoubleTapped: function(eventPoint, button) {
                if (previewDragHandler.active)
                    return

                root.togglePreviewZoom()
            }
        }

    // =========================
    // GUIDES
    // =========================

        Item {
            id: guideOverlay
            anchors.fill: parent
            z: 10
            visible: !root.smpteEnabled

            readonly property real guideInset: 24
            readonly property real guideWidth: parent.width - (guideInset * 2)
            readonly property real guideHeight: parent.height - (guideInset * 2)
            readonly property bool guidesEnabled: root.settingsState ? root.settingsState.guidesEnabled : true
            readonly property string guideType: root.settingsState ? root.settingsState.guidesType : "Thirds"
            readonly property int guidesThickness: root.settingsState ? Math.max(1, root.settingsState.guidesThickness) : 1
            readonly property bool centerMarkerEnabled: root.settingsState ? root.settingsState.centerMarkerEnabled : true
            readonly property string centerMarkerType: root.settingsState ? root.settingsState.centerMarkerType : "Circle/Dot"
            readonly property int centerMarkerCircleSize: root.standardLandscapeLayout ? 72 : 56
            readonly property int centerMarkerDotSize: root.standardLandscapeLayout ? 10 : 8
            readonly property int centerMarkerCrosshairSize: root.standardLandscapeLayout ? 62 : 48
            readonly property real selectedAspectRatio: guideType === "16:9" ? (16.0 / 9.0)
                                                     : guideType === "2.39:1" ? 2.39
                                                     : guideType === "4:3" ? (4.0 / 3.0)
                                                     : guideType === "1:1" ? 1.0
                                                     : guideType === "Academy 1.37:1" ? 1.37
                                                     : guideType === "5:4" ? 1.25
                                                     : guideType === "9:16" ? (9.0 / 16.0)
                                                     : guideType === "14:9" ? (14.0 / 9.0)
                                                     : 0.0
            readonly property bool showThirds: guidesEnabled && guideType === "Thirds"
            readonly property bool showAspectFrame: guidesEnabled && selectedAspectRatio > 0.0
            readonly property real aspectGuideWidth: showAspectFrame
                                                    ? ((guideWidth / guideHeight) > selectedAspectRatio
                                                       ? guideHeight * selectedAspectRatio
                                                       : guideWidth)
                                                    : 0
            readonly property real aspectGuideHeight: showAspectFrame
                                                     ? ((guideWidth / guideHeight) > selectedAspectRatio
                                                        ? guideHeight
                                                        : guideWidth / selectedAspectRatio)
                                                     : 0

            Rectangle {
                x: guideOverlay.guideInset
                y: guideOverlay.guideInset
                width: guideOverlay.guideWidth
                height: guideOverlay.guideHeight
                radius: 22
                color: "transparent"
                border.width: guideOverlay.guidesThickness
                border.color: "#4dffffff"
                antialiasing: false
            }

            Rectangle {
                visible: guideOverlay.showThirds
                width: guideOverlay.guidesThickness
                color: "#4dffffff"
                x: Math.round(guideOverlay.guideInset + (guideOverlay.guideWidth / 3))
                y: guideOverlay.guideInset
                height: guideOverlay.guideHeight
                antialiasing: false
            }

            Rectangle {
                visible: guideOverlay.showThirds
                width: guideOverlay.guidesThickness
                color: "#4dffffff"
                x: Math.round(guideOverlay.guideInset + ((guideOverlay.guideWidth * 2) / 3))
                y: guideOverlay.guideInset
                height: guideOverlay.guideHeight
                antialiasing: false
            }

            Rectangle {
                visible: guideOverlay.showThirds
                height: guideOverlay.guidesThickness
                color: "#4dffffff"
                x: guideOverlay.guideInset
                y: Math.round(guideOverlay.guideInset + (guideOverlay.guideHeight / 3))
                width: guideOverlay.guideWidth
                antialiasing: false
            }

            Rectangle {
                visible: guideOverlay.showThirds
                height: guideOverlay.guidesThickness
                color: "#4dffffff"
                x: guideOverlay.guideInset
                y: Math.round(guideOverlay.guideInset + ((guideOverlay.guideHeight * 2) / 3))
                width: guideOverlay.guideWidth
                antialiasing: false
            }

            Rectangle {
                visible: guideOverlay.showAspectFrame
                width: guideOverlay.aspectGuideWidth
                height: guideOverlay.aspectGuideHeight
                x: Math.round((parent.width - width) / 2)
                y: Math.round((parent.height - height) / 2)
                color: "transparent"
                border.width: guideOverlay.guidesThickness
                border.color: "#4dffffff"
                antialiasing: false
            }

            Rectangle {
                visible: guideOverlay.centerMarkerEnabled && guideOverlay.centerMarkerType === "Circle/Dot"
                width: guideOverlay.centerMarkerCircleSize
                height: guideOverlay.centerMarkerCircleSize
                radius: width / 2
                color: "transparent"
                border.width: 1
                border.color: "#4dffffff"
                anchors.centerIn: parent
                antialiasing: false
            }

            Rectangle {
                visible: guideOverlay.centerMarkerEnabled && guideOverlay.centerMarkerType === "Circle/Dot"
                width: guideOverlay.centerMarkerDotSize
                height: guideOverlay.centerMarkerDotSize
                radius: width / 2
                color: "white"
                anchors.centerIn: parent
                antialiasing: false
            }

            Rectangle {
                visible: guideOverlay.centerMarkerEnabled && guideOverlay.centerMarkerType === "Crosshair"
                width: 1
                height: guideOverlay.centerMarkerCrosshairSize
                color: "#4dffffff"
                anchors.centerIn: parent
                antialiasing: false
            }

            Rectangle {
                visible: guideOverlay.centerMarkerEnabled && guideOverlay.centerMarkerType === "Crosshair"
                width: guideOverlay.centerMarkerCrosshairSize
                height: 1
                color: "#4dffffff"
                anchors.centerIn: parent
                antialiasing: false
            }
        }

        FalseColorLegend {
            id: falseColorLegend
            z: 16
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: root.largeLandscapeLayout ? 20 : 12
            transformOrigin: Item.Left
            mode: root.intToFalseColorMode(root.settingsState ? root.settingsState.falseColorMode : 0)
            backgroundColor: root.rectangularLayout
                             ? root.compactControlColor("#70000000", root.compactControlFill, root.compactDarkControlFill)
                             : "#9c000000"
            borderColor: root.rectangularLayout
                         ? root.compactControlColor("#0affffff", root.compactControlBorder, root.compactDarkControlBorder)
                         : "#16ffffff"
            opacity: root.falseColorLegendVisible ? 1.0 : 0.0
            scale: root.falseColorLegendDisplayScale * (root.falseColorLegendVisible ? 1.0 : 0.96)
        }

    // =========================
    // STATUS CHIP
	
    StatusChip {
        z: 20
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 16
        anchors.topMargin: root.rectangularLayout ? (root.topControlsTopMargin + root.topStatHeight + 16) : 16
        recording: root.recording
        mediaMounted: mediaBridge.mediaMounted
        backgroundOpacity: root.effectiveControlsOpacity
        compact: root.compactLandscapeLayout
        largeCompact: root.regularLandscapeLayout
        extraLargeCompact: root.standardLandscapeLayout
        oversizedCompact: root.largeLandscapeLayout
        darkBackground: root.compactDarkControls
        useControlBackground: root.compactLandscapeLayout
        }

        Column {
            z: 20
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 16
            anchors.topMargin: root.rectangularLayout ? (root.topControlsTopMargin + root.topStatHeight + 16) : 16
            spacing: 8
            visible: root.photoModeEnabled

            Rectangle {
                visible: root.photoModeEnabled && root.photoTimerSetting !== "Off"
                height: root.photoStatusChipHeight
                width: timerChipRow.implicitWidth + root.photoStatusChipHorizontalPadding
                radius: height / 2
                color: root.compactControlColor("#70000000", root.compactControlFill, root.compactDarkControlFill)
                border.width: 1
                border.color: root.compactControlColor("#0affffff", root.compactControlBorder, root.compactDarkControlBorder)

                Row {
                    id: timerChipRow
                    anchors.centerIn: parent
                    spacing: 6

                    Rectangle {
                        width: root.photoStatusChipDotSize
                        height: root.photoStatusChipDotSize
                        radius: width / 2
                        color: "#ffd54a"
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        text: "TIMER " + root.photoTimerSetting
                        color: "white"
                        font.family: interBold.font.family
                        font.weight: Font.Bold
                        font.pixelSize: root.photoStatusChipFontSize
                        renderType: Text.NativeRendering
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }

            Rectangle {
                visible: root.photoModeEnabled
                height: root.photoStatusChipHeight
                width: burstChipRow.implicitWidth + root.photoStatusChipHorizontalPadding
                radius: height / 2
                color: root.compactControlColor("#70000000", root.compactControlFill, root.compactDarkControlFill)
                border.width: 1
                border.color: root.compactControlColor("#0affffff", root.compactControlBorder, root.compactDarkControlBorder)

                Row {
                    id: burstChipRow
                    anchors.centerIn: parent
                    spacing: 6

                    Rectangle {
                        width: root.photoStatusChipDotSize
                        height: root.photoStatusChipDotSize
                        radius: width / 2
                        color: "#66d9ff"
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        text: root.photoBurstSetting === "Single"
                              ? "SINGLE"
                              : ("BURST " + root.photoBurstSetting.toUpperCase())
                        color: "white"
                        font.family: interBold.font.family
                        font.weight: Font.Bold
                        font.pixelSize: root.photoStatusChipFontSize
                        renderType: Text.NativeRendering
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
        }
    }

    // =========================
    // STATIC OVERLAY (cached)
    // =========================
	
    Item {
        id: staticOverlay
        anchors.fill: parent
		
		// =========================
        // Background
        // =========================
	

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: root.previewTopOffset
            color: "#000000"
            visible: !root.rectangularLayout
        }

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: root.rectangularLayout ? 0 : 158
            color: "#000000"
            visible: !root.rectangularLayout
        }


    // =========================
    // Top Menu
    // =========================
	

        Row {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.leftMargin: root.topControlsSideMargin
            anchors.rightMargin: root.topControlsSideMargin
            anchors.topMargin: root.topControlsTopMargin
            spacing: root.topControlsSpacing

            Repeater {
                model: 4

	                delegate: Rectangle {
	                    width: (parent.width - root.topSettingsButtonSize - (root.topControlsSpacing * 4)) / 4
	                    height: root.topStatHeight
	                    radius: root.topControlRadius
                    color: root.compactControlColor(index === 0 ? "#1affffff" : "#14ffffff",
                                                    index === 0 ? root.compactControlFillActive : root.compactControlFill,
                                                    index === 0 ? root.compactDarkControlFillActive : root.compactDarkControlFill)
                    border.width: 1
                    border.color: root.compactControlColor(index === 0 ? "#33ffffff" : "#1affffff",
                                                           index === 0 ? root.compactControlBorderActive : root.compactControlBorder,
                                                           index === 0 ? root.compactDarkControlBorderActive : root.compactDarkControlBorder)
                    readonly property bool dropdownOpen: (index === 0 && root.openDropdown === "fps")
                                                         || (index === 1 && root.openDropdown === "iso")
                                                         || (index === 2 && root.openDropdown === "shutter")
                                                         || (index === 3 && root.openDropdown === "wb")

                    Text {
    id: menuLabel
    anchors.left: parent.left
    anchors.top: parent.top
    anchors.leftMargin: 16
    anchors.topMargin: 12
    text: index === 0 ? "FPS"
         : index === 1 ? "ISO"
         : index === 2 ? "SHUTTER"
         : "WB"
    color: "#99ffffff"
    font.family: interLight.font.family
    font.pixelSize: root.topLabelFontSize
    font.letterSpacing: 2
    font.capitalization: Font.AllUppercase
    renderType: Text.NativeRendering
}

Text {
    anchors.right: parent.right
    anchors.rightMargin: 14
    anchors.baseline: menuLabel.baseline
    text: "⌄"
    color: "#ccffffff"
    font.family: interRegular.font.family
    font.pixelSize: root.topArrowFontSize
    rotation: parent.dropdownOpen ? 180 : 0
    renderType: Text.NativeRendering

    Behavior on rotation {
        NumberAnimation { duration: 170; easing.type: Easing.OutCubic }
    }
}
                }
            }

	            Rectangle {
	                width: root.topSettingsButtonSize
	                height: root.topSettingsButtonSize
	                radius: root.topControlRadius
                color: root.compactControlColor("#14ffffff", root.compactControlFill, root.compactDarkControlFill)
                border.width: 1
                border.color: root.compactControlColor("#1affffff", root.compactControlBorder, root.compactDarkControlBorder)

                Image {
                    anchors.centerIn: parent
                    width: root.topSettingsIconSize
                    height: root.topSettingsIconSize
                    source: "qrc:/qml/icons/settings.png"
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    mipmap: true
                }
            }
        }
    }

    // =========================
    // DYNAMIC OVERLAY
    // =========================
    Item {
        id: dynamicOverlay
        anchors.fill: parent
        z: 100

        MouseArea {
            anchors.fill: parent
            visible: root.openDropdown !== "" || root.quickMenuOpen
            enabled: visible
            onClicked: function(mouse) {
                if (root.quickMenuOpen) {
                    var panelPoint = quickMenuPanel.mapFromItem(dynamicOverlay, mouse.x, mouse.y)
                    if (panelPoint.x >= 0
                            && panelPoint.y >= 0
                            && panelPoint.x <= quickMenuPanel.width
                            && panelPoint.y <= quickMenuPanel.height) {
                        return
                    }
                }

                root.openDropdown = ""
                root.quickMenuResolutionOpen = false
                root.quickMenuOpen = false
            }
        }

        Row {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.leftMargin: root.topControlsSideMargin
            anchors.rightMargin: root.topControlsSideMargin
            anchors.topMargin: root.topControlsTopMargin
            spacing: root.topControlsSpacing

            TopDropdownStat {
                width: (parent.width - root.topSettingsButtonSize - (root.topControlsSpacing * 4)) / 4
                height: root.topStatHeight
                valueFontSize: root.topValueFontSize
                backgroundOpacity: root.effectiveControlsOpacity
                maxPopupHeight: root.topDropdownPopupMaxHeight
                popupMargin: root.topDropdownPopupMargin
                popupSpacing: root.topDropdownPopupSpacing
                popupOptionHeight: root.topDropdownPopupOptionHeight
                popupOptionRadius: root.topDropdownPopupOptionRadius
                popupOptionFontSize: root.topDropdownPopupOptionFontSize
                popupRadius: root.topDropdownPopupRadius
                popupTopMargin: root.topDropdownPopupTopMargin
                value: root.fps
                isOpen: root.openDropdown === "fps"
                options: root.fpsOptions
                onToggleRequested: {
                    root.quickMenuOpen = false
                    root.quickMenuResolutionOpen = false
                    root.openDropdown = root.openDropdown === "fps" ? "" : "fps"
                }
                onOptionSelected: function(v) {
                    if (root.controlBridge) {
                        root.controlBridge.applyFps(v)
                    } else {
                        root.fps = v
                    }
                    root.openDropdown = ""
                }
            }

            TopDropdownStat {
                width: (parent.width - root.topSettingsButtonSize - (root.topControlsSpacing * 4)) / 4
                height: root.topStatHeight
                valueFontSize: root.topValueFontSize
                backgroundOpacity: root.effectiveControlsOpacity
                maxPopupHeight: root.topDropdownPopupMaxHeight
                popupMargin: root.topDropdownPopupMargin
                popupSpacing: root.topDropdownPopupSpacing
                popupOptionHeight: root.topDropdownPopupOptionHeight
                popupOptionRadius: root.topDropdownPopupOptionRadius
                popupOptionFontSize: root.topDropdownPopupOptionFontSize
                popupRadius: root.topDropdownPopupRadius
                popupTopMargin: root.topDropdownPopupTopMargin
                value: root.iso
                isOpen: root.openDropdown === "iso"
                options: ["Auto", "100", "200", "400", "800", "1600", "3200", "6400"]
                onToggleRequested: {
                    root.quickMenuOpen = false
                    root.quickMenuResolutionOpen = false
                    root.openDropdown = root.openDropdown === "iso" ? "" : "iso"
                }
                onOptionSelected: function(v) {
                    if (root.controlBridge) {
                        root.controlBridge.applyIso(v)
                    } else {
                        root.iso = v
                    }
                    root.openDropdown = ""
                }
            }

            TopDropdownStat {
                width: (parent.width - root.topSettingsButtonSize - (root.topControlsSpacing * 4)) / 4
                height: root.topStatHeight
                valueFontSize: root.topValueFontSize
                backgroundOpacity: root.effectiveControlsOpacity
                maxPopupHeight: root.topDropdownPopupMaxHeight
                popupMargin: root.topDropdownPopupMargin
                popupSpacing: root.topDropdownPopupSpacing
                popupOptionHeight: root.topDropdownPopupOptionHeight
                popupOptionRadius: root.topDropdownPopupOptionRadius
                popupOptionFontSize: root.topDropdownPopupOptionFontSize
                popupRadius: root.topDropdownPopupRadius
                popupTopMargin: root.topDropdownPopupTopMargin
                value: root.shutterDisplayValue
                isOpen: root.openDropdown === "shutter"
                options: root.shutterOptions
                onToggleRequested: {
                    root.quickMenuOpen = false
                    root.quickMenuResolutionOpen = false
                    root.openDropdown = root.openDropdown === "shutter" ? "" : "shutter"
                }
                onOptionSelected: function(v) {
                    if (root.photoModeEnabled) {
                        if (root.controlBridge) {
                            root.controlBridge.applyShutterSpeed(v)
                        } else {
                            root.shutterSpeed = v
                        }
                    } else {
                        if (root.controlBridge) {
                            root.controlBridge.applyShutterAngle(v)
                        } else {
                            root.shutterAngle = v
                        }
                    }
                    root.openDropdown = ""
                }
            }

            TopDropdownStat {
                width: (parent.width - root.topSettingsButtonSize - (root.topControlsSpacing * 4)) / 4
                height: root.topStatHeight
                valueFontSize: root.topValueFontSize
                backgroundOpacity: root.effectiveControlsOpacity
                maxPopupHeight: root.topDropdownPopupMaxHeight
                popupMargin: root.topDropdownPopupMargin
                popupSpacing: root.topDropdownPopupSpacing
                popupOptionHeight: root.topDropdownPopupOptionHeight
                popupOptionRadius: root.topDropdownPopupOptionRadius
                popupOptionFontSize: root.topDropdownPopupOptionFontSize
                popupRadius: root.topDropdownPopupRadius
                popupTopMargin: root.topDropdownPopupTopMargin
                value: root.wb
                isOpen: root.openDropdown === "wb"
                options: ["2500K", "2800K", "3000K", "3200K", "3400K", "3600K", "4000K", "4500K", "4800K", "5000K", "5200K", "5400K", "5600K", "5800K", "6000K", "6500K", "7000K", "7500K", "8000K"]
                onToggleRequested: {
                    root.quickMenuOpen = false
                    root.quickMenuResolutionOpen = false
                    root.openDropdown = root.openDropdown === "wb" ? "" : "wb"
                }
                onOptionSelected: function(v) {
                    if (root.controlBridge) {
                        root.controlBridge.applyWhiteBalance(v)
                    } else {
                        root.wb = v
                    }
                    root.openDropdown = ""
                }
            }

	            Rectangle {
	                width: root.topSettingsButtonSize
	                height: root.topSettingsButtonSize
	                radius: root.topControlRadius
                color: "transparent"

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        root.quickMenuOpen = false
                        root.quickMenuResolutionOpen = false
                        root.openSettingsRequested()
                    }
                }
            }
        }

        Item {
            id: quickMenuEdgeSwipeZone
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            width: root.quickMenuSwipeEdgeWidth
            visible: !root.quickMenuOpen && root.openDropdown === ""
            z: 180

            Item {
                id: quickMenuOpenButton
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 1
                width: root.quickMenuArrowButtonWidth
                height: root.quickMenuArrowButtonHeight

                Canvas {
                    anchors.centerIn: parent
                    width: root.quickMenuArrowCanvasWidth
                    height: root.quickMenuArrowCanvasHeight

                    onPaint: {
                        var ctx = getContext("2d")
                        ctx.clearRect(0, 0, width, height)
                        ctx.strokeStyle = "white"
                        ctx.lineWidth = root.quickMenuArrowLineWidth
                        ctx.lineCap = "round"
                        ctx.lineJoin = "round"
                        ctx.beginPath()
                        ctx.moveTo(width * 0.75, height * 0.16)
                        ctx.lineTo(width * 0.25, height * 0.50)
                        ctx.lineTo(width * 0.75, height * 0.84)
                        ctx.stroke()
                    }
                }

                TapHandler {
                    acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad | PointerDevice.TouchScreen
                    gesturePolicy: TapHandler.DragThreshold
                    onTapped: {
                        root.openDropdown = ""
                        root.quickMenuResolutionOpen = false
                        root.quickMenuOpen = true
                    }
                }
            }

            DragHandler {
                id: quickMenuOpenSwipe
                target: null
                yAxis.enabled: false
                xAxis.enabled: true
                acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad | PointerDevice.TouchScreen
                grabPermissions: PointerHandler.CanTakeOverFromAnything | PointerHandler.ApprovesTakeOverByAnything

                property real swipeDeltaX: 0

                onActiveChanged: {
                    if (active) {
                        swipeDeltaX = 0
                        return
                    }

                    if (swipeDeltaX <= -42) {
                        root.openDropdown = ""
                        root.quickMenuResolutionOpen = false
                        root.quickMenuOpen = true
                    }
                }

                onActiveTranslationChanged: swipeDeltaX = activeTranslation.x
            }
        }

        Rectangle {
            id: quickMenuPanel
            width: root.quickMenuPanelWidth
            height: root.quickMenuPanelHeight
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: root.quickMenuOpen ? 14 : -(width + 20)
            anchors.topMargin: root.rectangularLayout ? Math.round((parent.height - height) / 2) : 184
            radius: root.quickMenuPanelRadius
            color: root.fadedControlColor("#151515")
            border.width: 1
            border.color: root.fadedControlColor("#1affffff")
            opacity: root.quickMenuOpen ? 1.0 : 0.0
            visible: opacity > 0.0
            z: 190

            Behavior on anchors.rightMargin {
                NumberAnimation { duration: 280; easing.type: Easing.OutCubic }
            }

            Behavior on opacity {
                NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
            }

            DragHandler {
                id: quickMenuCloseSwipe
                target: null
                yAxis.enabled: false
                xAxis.enabled: true
                acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad | PointerDevice.TouchScreen
                grabPermissions: PointerHandler.CanTakeOverFromAnything | PointerHandler.ApprovesTakeOverByAnything

                property real swipeDeltaX: 0

                onActiveChanged: {
                    if (active) {
                        swipeDeltaX = 0
                        return
                    }

                    if (swipeDeltaX >= 42) {
                        root.quickMenuResolutionOpen = false
                        root.quickMenuOpen = false
                    }
                }

                onActiveTranslationChanged: swipeDeltaX = activeTranslation.x
            }

            Column {
                anchors.fill: parent
                anchors.margins: root.quickMenuPanelMargin
                spacing: root.quickMenuPanelSpacing

                Text {
                    width: parent.width
                    text: "Quick Menu"
                    color: "white"
                    font.family: gothamBold.font.family
                    font.pixelSize: root.quickMenuTitleFontSize
                    horizontalAlignment: Text.AlignHCenter
                    renderType: Text.NativeRendering
                }

                Item {
                    id: quickResolutionControl
                    width: parent.width
                    height: root.quickMenuResolutionHeight
                    z: 10

                    Rectangle {
                        id: quickResolutionField
                        anchors.fill: parent
                        radius: root.quickMenuResolutionRadius
                        color: root.fadedControlColor(quickResolutionArea.containsPress ? "#1f2c36" : "#171717")
                        border.width: 1
                        border.color: root.fadedControlColor(root.quickMenuResolutionOpen ? "#3fd0ff" : "#1affffff")

                        Behavior on color {
                            ColorAnimation { duration: 140; easing.type: Easing.OutCubic }
                        }

                        Behavior on border.color {
                            ColorAnimation { duration: 180; easing.type: Easing.OutCubic }
                        }

                        Column {
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.leftMargin: root.compactLandscapeLayout ? 12 : 14
                            spacing: 2

                            Text {
                                text: "Resolution"
                                color: root.quickMenuResolutionOpen ? "#79ddff" : "#8f9096"
                                font.family: interMedium.font.family
                                font.pixelSize: root.quickMenuResolutionLabelFontSize
                                font.capitalization: Font.AllUppercase
                                font.letterSpacing: 2.1
                                renderType: Text.NativeRendering
                            }

                            Text {
                                text: root.resolution
                                color: "white"
                                font.family: interMedium.font.family
                                font.pixelSize: root.quickMenuResolutionValueFontSize
                                renderType: Text.NativeRendering
                            }
                        }

                        Text {
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.rightMargin: root.compactLandscapeLayout ? 12 : 14
                            text: root.quickMenuResolutionOpen ? "⌃" : "⌄"
                            color: "#ccffffff"
                            font.family: interRegular.font.family
                            font.pixelSize: root.quickMenuResolutionArrowFontSize
                            renderType: Text.NativeRendering
                        }

                        MouseArea {
                            id: quickResolutionArea
                            anchors.fill: parent
                            onClicked: {
                                root.openDropdown = ""
                                root.quickMenuResolutionOpen = !root.quickMenuResolutionOpen
                            }
                        }
                    }

                    Rectangle {
                        id: quickResolutionPopup
                        width: parent.width
                        anchors.top: quickResolutionField.bottom
                        anchors.topMargin: root.compactLandscapeLayout ? 6 : 8
                        radius: root.quickMenuResolutionRadius
                        color: root.fadedControlColor("#151515")
                        border.width: 1
                        border.color: root.fadedControlColor("#1affffff")
                        clip: true
                        opacity: root.quickMenuResolutionOpen ? 1.0 : 0.0
                        visible: opacity > 0.0
                        height: Math.min(quickResolutionFlick.contentHeight + 16, root.quickMenuPopupMaxHeight)

                        Behavior on opacity {
                            NumberAnimation { duration: 170; easing.type: Easing.OutCubic }
                        }

                        Flickable {
                            id: quickResolutionFlick
                            anchors.fill: parent
                            anchors.margins: 8
                            contentWidth: width
                            contentHeight: quickResolutionOptions.implicitHeight
                            clip: true
                            boundsBehavior: Flickable.StopAtBounds
                            flickableDirection: Flickable.VerticalFlick
                            interactive: root.quickMenuResolutionOpen

                            Column {
                                id: quickResolutionOptions
                                width: quickResolutionFlick.width
                                spacing: 6

                                Repeater {
                                    model: root.resolutionOptions

                            delegate: Rectangle {
                                required property string modelData

                                width: quickResolutionOptions.width
                                height: root.quickMenuPopupOptionHeight
                                radius: 12
                                        color: root.fadedControlColor(modelData === root.resolution ? "#22ffffff" : "transparent")

                                        Text {
                                            anchors.centerIn: parent
                                    text: modelData
                                    color: "white"
                                    font.family: interRegular.font.family
                                    font.pixelSize: root.quickMenuPopupOptionFontSize
                                            renderType: Text.NativeRendering
                                        }

                                        MouseArea {
                                            anchors.fill: parent
                                            onClicked: {
                                                if (root.controlBridge) {
                                                    root.controlBridge.applyResolution(modelData)
                                                } else {
                                                    root.resolution = modelData
                                                }
                                                root.quickMenuResolutionOpen = false
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                Grid {
                    width: implicitWidth
                    x: Math.round((parent.width - width) / 2)
                    columns: 2
                    columnSpacing: root.quickMenuButtonSpacing
                    rowSpacing: root.quickMenuButtonSpacing

                    Repeater {
                        model: root.quickMenuButtonCount

                        delegate: Rectangle {
                            width: root.quickMenuButtonSize
                             height: root.quickMenuButtonSize
                             radius: root.quickMenuButtonRadius
                             color: root.fadedControlColor(root.quickMenuSlotActive(index)
                                    ? (quickSlotArea.containsPress ? "#22323c" : "#1f2c36")
                                     : (root.compactLandscapeLayout
                                       ? (root.compactDarkControls
                                          ? (quickSlotArea.containsPress ? root.compactDarkControlFillActive : root.compactDarkControlFillSoft)
                                          : (quickSlotArea.containsPress ? root.compactControlFillActive : root.compactControlFillSoft))
                                       : (quickSlotArea.containsPress ? "#20ffffff" : "#14ffffff")))
                             border.width: 1
                             border.color: root.fadedControlColor(root.quickMenuSlotActive(index)
                                                                  ? "#3fd0ff"
                                                                  : (root.compactLandscapeLayout
                                                                     ? (root.compactDarkControls ? root.compactDarkControlBorder : root.compactControlBorder)
                                                                     : "#1affffff"))
                            scale: quickSlotArea.containsPress ? 0.985 : 1.0

                            Behavior on scale {
                                NumberAnimation { duration: 140; easing.type: Easing.OutCubic }
                            }

                            Behavior on color {
                                ColorAnimation { duration: 140; easing.type: Easing.OutCubic }
                            }

                            Behavior on border.color {
                                ColorAnimation { duration: 160; easing.type: Easing.OutCubic }
                            }

                            Column {
                                anchors.centerIn: parent
                                spacing: 4

                                Image {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    width: index <= 5 ? root.quickMenuIconSize : 24
                                    height: index <= 5 ? root.quickMenuIconSize : 24
                                    visible: root.quickMenuSlotIconSource(index).length > 0
                                    source: root.quickMenuSlotIconSource(index)
                                    fillMode: Image.PreserveAspectFit
                                    smooth: true
                                    mipmap: true
                                    opacity: 0.96
                                }

                                Text {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    text: root.quickMenuSlotLabel(index)
                                    visible: text.length > 0
                                    color: "white"
                                    font.family: interBold.font.family
                                    font.pixelSize: index === 0 ? 10 : 14
                                    font.capitalization: Font.MixedCase
                                    renderType: Text.NativeRendering
                                }

                                Text {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    text: root.quickMenuSlotSubtitle(index)
                                    visible: text.length > 0
                                    color: root.quickMenuSlotActive(index) ? "#79ddff" : "#8cffffff"
                                    font.family: interRegular.font.family
                                    font.pixelSize: 9
                                    font.capitalization: Font.AllUppercase
                                    font.letterSpacing: 1.6
                                    renderType: Text.NativeRendering
                                }
                            }

                            MouseArea {
                                id: quickSlotArea
                                anchors.fill: parent
                                onClicked: root.triggerQuickMenuSlot(index)
                            }
                        }
                    }
                }
            }
        }
		
    // =========================
    // BOTTOM STATS
    // =========================

        Column {
    anchors.left: parent.left
    anchors.bottom: root.compactLandscapeLayout ? undefined : parent.bottom
    anchors.verticalCenter: root.compactLandscapeLayout ? bottomControlsRow.verticalCenter : undefined
    anchors.verticalCenterOffset: root.bottomStatsVerticalOffset
    anchors.leftMargin: root.bottomStatsSideMargin
    anchors.bottomMargin: root.bottomStatsBottomMargin
    spacing: root.bottomStatsSpacing
    width: root.bottomStatsWidth
    visible: root.showCornerStats

    InfoLine {
        width: parent.width
        label: "FORMAT"
        value: root.formatDisplayValue
        sub: root.formatDisplaySubtext
        iconSource: "qrc:/qml/icons/camera.png"
        iconSize: root.bottomStatsIconSize
        rowSpacing: root.bottomStatsRowSpacing
        textSpacing: root.bottomStatsTextSpacing
        labelFontSize: root.bottomStatsLabelFontSize
        valueFontSize: root.bottomStatsValueFontSize
        subFontSize: root.bottomStatsSubFontSize
        heightWithSub: root.bottomStatsHeightWithSub
        heightWithoutSub: root.bottomStatsHeightWithoutSub
    }

    InfoLine {
    width: parent.width
    label: "MEDIA"
    value: root.photoModeEnabled ? mediaBridge.remainingStillsText : mediaBridge.remainingMinutesText
    sub: mediaBridge.mediaMounted ? mediaBridge.mediaTypeLabel : "Insert Media"
    iconSource: "qrc:/qml/icons/media.png"
    iconSize: root.bottomStatsIconSize
    rowSpacing: root.bottomStatsRowSpacing
    textSpacing: root.bottomStatsTextSpacing
    labelFontSize: root.bottomStatsLabelFontSize
    valueFontSize: root.bottomStatsValueFontSize
    subFontSize: root.bottomStatsSubFontSize
    heightWithSub: root.bottomStatsHeightWithSub
    heightWithoutSub: root.bottomStatsHeightWithoutSub
}

}

Column {
    anchors.right: parent.right
    anchors.bottom: root.compactLandscapeLayout ? undefined : parent.bottom
    anchors.verticalCenter: root.compactLandscapeLayout ? bottomControlsRow.verticalCenter : undefined
    anchors.verticalCenterOffset: root.bottomStatsVerticalOffset
    anchors.rightMargin: root.bottomStatsSideMargin
    anchors.bottomMargin: root.bottomStatsBottomMargin
    spacing: root.bottomStatsSpacing
    width: root.bottomStatsRightWidth
    visible: root.showCornerStats

    InfoLine {
    width: parent.width
    alignRight: true
    label: "CPU"
    value: statsBridge.cpuText
    sub: statsBridge.cpuPercent < 30 ? "Idle"
     : statsBridge.cpuPercent < 70 ? "Normal"
     : "High Load"
    iconSource: "qrc:/qml/icons/cpu.png"
    iconSize: root.bottomStatsIconSize
    rowSpacing: root.bottomStatsRowSpacing
    textSpacing: root.bottomStatsTextSpacing
    labelFontSize: root.bottomStatsLabelFontSize
    valueFontSize: root.bottomStatsValueFontSize
    subFontSize: root.bottomStatsSubFontSize
    heightWithSub: root.bottomStatsHeightWithSub
    heightWithoutSub: root.bottomStatsHeightWithoutSub
}

    InfoLine {
        width: parent.width
        alignRight: true
        label: "POWER"
        value: root.powerOverlayValue
        sub: root.powerOverlaySubtext
        iconSource: "qrc:/qml/icons/power.png"
        iconSize: root.bottomStatsIconSize
        rowSpacing: root.bottomStatsRowSpacing
        textSpacing: root.bottomStatsTextSpacing
        labelFontSize: root.bottomStatsLabelFontSize
        valueFontSize: root.bottomStatsValueFontSize
        subFontSize: root.bottomStatsSubFontSize
        heightWithSub: root.bottomStatsHeightWithSub
        heightWithoutSub: root.bottomStatsHeightWithoutSub
    }
}

    // =========================
    // TIMECODE
    // =========================


TextMetrics {
    id: timecodeMetrics
    font.family: interRegular.font.family
    font.pixelSize: root.timecodeFontSize
    text: "00:00:00:00"
}

        Row {
            id: bottomControlsRow
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: root.rectangularLayout
                                  ? ((root.photoModeEnabled && root.dateTimeOverlayEnabled && !root.compactLandscapeLayout)
                                     ? root.bottomControlsBaseMargin + 34
                                     : root.bottomControlsBaseMargin)
                                  : ((root.photoModeEnabled && root.dateTimeOverlayEnabled)
                                     ? 54
                                     : 40)
            anchors.verticalCenter: undefined
            spacing: root.bottomControlsSpacing
            height: Math.max(centerStack.visible ? centerStack.height : 0,
                             clipBrowserBtn.height,
                             recordBtn.height)

            ClipBrowserButton {
                id: clipBrowserBtn
                anchors.verticalCenter: parent.verticalCenter
                backgroundOpacity: root.effectiveControlsOpacity
                buttonSize: root.clipBrowserButtonSize
                iconSize: root.clipBrowserIconSize
                strongBackground: root.compactLandscapeLayout
                darkBackground: root.compactDarkControls
                enabled: !root.recording
                onClicked: {
                    root.quickMenuOpen = false
                    root.openClipBrowserRequested()
                }
            }

            Item {
                id: centerStack
                anchors.verticalCenter: parent.verticalCenter
                visible: !root.photoModeEnabled
                width: timecodeBox.width
                height: timecodeBox.height
                readonly property int dateTimeGap: 8

                AudioMeterOverlay {
                    id: audioMeterOverlay
                    width: root.standardLandscapeLayout ? Math.max(timecodeBox.width, 248) : timecodeBox.width
                    visible: root.showAudioMeter && !root.photoModeEnabled && !root.compactLandscapeLayout
                    anchors.horizontalCenter: timecodeBox.horizontalCenter
                    anchors.bottom: timecodeBox.top
                    anchors.bottomMargin: 10
                    large: root.standardLandscapeLayout
                    muted: root.inputVolumeLevel <= 0
                    inputLevel: (typeof audioMeterBridge !== "undefined" && audioMeterBridge)
                                ? audioMeterBridge.inputLevel
                                : 0
                }

                Rectangle {
                    id: timecodeBox
                    height: root.timecodeHeight
                    radius: root.timecodeRadius
                    color: root.compactControlColor(root.recording ? "#1aff4444" : "#14ffffff",
                                                    root.recording ? "#33ff4444" : root.compactControlFill,
                                                    root.recording ? "#6b230000" : root.compactDarkControlFill)
                    border.width: 1
                    border.color: root.compactControlColor(root.recording ? "#4dff4444" : "#1affffff",
                                                           root.recording ? "#4dff4444" : root.compactControlBorder,
                                                           root.recording ? "#66ff4444" : root.compactDarkControlBorder)
                    width: Math.ceil(timecodeMetrics.width) + root.timecodeHorizontalPadding
                    anchors.centerIn: parent

                    Text {
                        id: timecodeText
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: root.timecodeTextInset
                        width: parent.width - (root.timecodeTextInset * 2)
                        text: root.timecode
                        color: root.recording ? "#ff4d4d" : "white"
                        font.family: interRegular.font.family
                        font.pixelSize: root.timecodeFontSize
                        horizontalAlignment: Text.AlignLeft
                        renderType: Text.QtRendering

                        Behavior on color {
                            ColorAnimation {
                                duration: 260
                                easing.type: Easing.OutCubic
                            }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: root.toggleTimecodeMode()
                    }
                }
            }

            // =========================
            // RECORD BUTTON
            // =========================

            RecordButton {
                id: recordBtn
                anchors.verticalCenter: parent.verticalCenter
                recording: root.recording
                photoMode: root.photoModeEnabled
                photoCapturePulse: root.photoCapturePulse
                backgroundOpacity: root.effectiveControlsOpacity
                buttonSize: root.recordButtonSize
                centerSize: root.recordButtonCenterSize
                strongBackground: root.compactLandscapeLayout
                darkBackground: root.compactDarkControls

                onClicked: {
                    if (root.photoModeEnabled) {
                        if (!mediaBridge.mediaMounted) {
                            root.showNoMediaWarning(true)
                            return
                        }

                        root.beginPhotoCaptureSequence()
                        return
                    }

                    if (!root.recording) {
                        if (!mediaBridge.mediaMounted) {
                            root.showNoMediaWarning(false)
                            return
                        }
                        if (root.timecodeMode === "Rec Run") {
                            root.timecodeFrames = 0
                            root.updateTimecodeDisplay()
                        }
                        root.requestRecordingState(true)
                    } else {
                        root.requestRecordingState(false)
                        if (root.timecodeMode === "Free Run")
                            root.updateTimecodeDisplay()
                    }
                }
            }
        }

        AudioMeterOverlay {
            id: compactAudioMeterOverlay
            z: 21
            width: root.largeLandscapeLayout ? 230 : (root.standardLandscapeLayout ? 190 : (root.mediumLandscapeLayout ? 146 : 126))
            visible: root.showAudioMeter && !root.photoModeEnabled && root.compactLandscapeLayout
            anchors.horizontalCenter: parent.horizontalCenter
            y: root.dateTimeOverlayEnabled
               ? (bottomControlsRow.y
                  + ((bottomControlsRow.height - timecodeBox.height) / 2)
                  - height
                  - centerStack.dateTimeGap)
               : (bottomControlsRow.y
                  + ((bottomControlsRow.height - timecodeBox.height) / 2)
                  - height
                  - centerStack.dateTimeGap)
            muted: root.inputVolumeLevel <= 0
            inputLevel: (typeof audioMeterBridge !== "undefined" && audioMeterBridge)
                        ? audioMeterBridge.inputLevel
                        : 0
            compact: true
            largeCompact: root.regularLandscapeLayout
            extraLargeCompact: root.standardLandscapeLayout
            oversizedCompact: root.largeLandscapeLayout
            backgroundOpacity: root.effectiveControlsOpacity
            darkBackground: root.compactDarkControls
        }

        Rectangle {
            id: dateTimePageChip
            visible: root.dateTimeOverlayEnabled
            anchors.horizontalCenter: parent.horizontalCenter
            y: root.compactLandscapeLayout && !root.photoModeEnabled
               ? (root.showAudioMeter
                  ? (bottomControlsRow.y
                     + ((bottomControlsRow.height - timecodeBox.height) / 2)
                     - compactAudioMeterOverlay.height
                     - height
                     - centerStack.dateTimeGap
                     - 6
                     - (root.regularLandscapeLayout ? 2 : 0))
                   : (bottomControlsRow.y
                      + ((bottomControlsRow.height - timecodeBox.height) / 2)
                      - height
                      - centerStack.dateTimeGap
                      - (root.regularLandscapeLayout ? 3 : 0)))
               : root.photoModeEnabled
               ? (root.compactLandscapeLayout
                  ? (bottomControlsRow.y - height - centerStack.dateTimeGap)
                  : (bottomControlsRow.y + bottomControlsRow.height + 8))
               : (bottomControlsRow.y
                  + ((bottomControlsRow.height - timecodeBox.height) / 2)
                  + timecodeBox.height
                  + centerStack.dateTimeGap)
            height: root.dateTimeChipHeight
            width: dateTimeChipText.implicitWidth + root.dateTimeChipHorizontalPadding
            radius: root.dateTimeChipRadius
            color: root.compactControlColor("#14ffffff", root.compactControlFill, root.compactDarkControlFill)
            border.width: 1
            border.color: root.compactControlColor("#1affffff", root.compactControlBorder, root.compactDarkControlBorder)

            Text {
                id: dateTimeChipText
                anchors.centerIn: parent
                text: root.dateTimeOverlayText
                color: "white"
                font.family: interBold.font.family
                font.weight: Font.Bold
                font.pixelSize: root.dateTimeChipFontSize
                renderType: Text.NativeRendering

                Behavior on color {
                    ColorAnimation {
                        duration: 260
                        easing.type: Easing.OutCubic
                    }
                }
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "#cc000000"
        visible: root.recordWarningOpen
        opacity: root.recordWarningOpen ? 1.0 : 0.0
        z: 300

        Behavior on opacity {
            NumberAnimation {
                duration: 180
                easing.type: Easing.OutCubic
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: root.recordWarningOpen = false
        }
    }

    Rectangle {
        id: recordWarningCard
        readonly property int popupMargin: root.standardLandscapeLayout ? 26 : (root.compactLandscapeLayout ? 16 : 24)
        readonly property int bottomButtonGap: root.standardLandscapeLayout ? 24 : 0
        width: root.standardLandscapeLayout ? 500 : (root.compactLandscapeLayout ? 340 : 404)
        height: root.standardLandscapeLayout ? (recordWarningColumn.implicitHeight + popupMargin + bottomButtonGap) : (root.compactLandscapeLayout ? 210 : 286)
        anchors.centerIn: parent
        anchors.verticalCenterOffset: root.compactLandscapeLayout ? -8 : -18
        radius: root.standardLandscapeLayout ? 30 : (root.compactLandscapeLayout ? 22 : 28)
        color: "#111214"
        border.width: 1
        border.color: "#2a2d31"
        visible: root.recordWarningOpen
        opacity: root.recordWarningOpen ? 1.0 : 0.0
        scale: root.recordWarningOpen ? 1.0 : 0.96
        z: 301

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
            id: recordWarningColumn
            anchors.fill: parent
            anchors.leftMargin: recordWarningCard.popupMargin
            anchors.rightMargin: recordWarningCard.popupMargin
            anchors.topMargin: recordWarningCard.popupMargin
            anchors.bottomMargin: root.standardLandscapeLayout ? recordWarningCard.bottomButtonGap : recordWarningCard.popupMargin
            spacing: root.standardLandscapeLayout ? 16 : (root.compactLandscapeLayout ? 10 : 16)

            Row {
                spacing: root.standardLandscapeLayout ? 14 : (root.compactLandscapeLayout ? 8 : 12)

                Rectangle {
                    width: root.standardLandscapeLayout ? 52 : (root.compactLandscapeLayout ? 32 : 42)
                    height: root.standardLandscapeLayout ? 52 : (root.compactLandscapeLayout ? 32 : 42)
                    radius: width / 2
                    color: "#6b5200"
                    border.width: 1
                    border.color: "#d7b44a"

                    Text {
                        anchors.centerIn: parent
                        text: "!"
                        color: "white"
                        font.family: interBold.font.family
                        font.weight: Font.Bold
                        font.pixelSize: root.standardLandscapeLayout ? 27 : (root.compactLandscapeLayout ? 17 : 22)
                        renderType: Text.NativeRendering
                    }
                }

                Column {
                    spacing: root.standardLandscapeLayout ? 5 : (root.compactLandscapeLayout ? 3 : 4)

                    Text {
                        text: root.recordWarningTitle
                        color: "white"
                        font.family: interBold.font.family
                        font.weight: Font.Bold
                        font.pixelSize: root.standardLandscapeLayout ? 30 : (root.compactLandscapeLayout ? 20 : 25)
                        renderType: Text.NativeRendering
                    }

                    Text {
                        text: root.recordWarningSubtitle
                        color: "#8f9096"
                        font.family: interRegular.font.family
                        font.pixelSize: root.standardLandscapeLayout ? 16 : (root.compactLandscapeLayout ? 12 : 14)
                        width: root.standardLandscapeLayout ? 380 : (root.compactLandscapeLayout ? 248 : 280)
                        wrapMode: Text.WordWrap
                        renderType: Text.NativeRendering
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: root.standardLandscapeLayout ? 100 : (root.compactLandscapeLayout ? 62 : 84)
                radius: root.standardLandscapeLayout ? 22 : (root.compactLandscapeLayout ? 16 : 18)
                color: "#0d0e10"
                border.width: 1
                border.color: "#202227"

                Column {
                    anchors.fill: parent
                    anchors.margins: root.standardLandscapeLayout ? 18 : (root.compactLandscapeLayout ? 10 : 14)
                    spacing: root.standardLandscapeLayout ? 5 : (root.compactLandscapeLayout ? 2 : 4)

                    Text {
                        text: root.recordWarningDetailTitle
                        color: "white"
                        font.family: interBold.font.family
                        font.weight: Font.Bold
                        font.pixelSize: root.standardLandscapeLayout ? 19 : (root.compactLandscapeLayout ? 13 : 16)
                        renderType: Text.NativeRendering
                    }

                    Text {
                        text: root.recordWarningDetailBody
                        color: "#6f7076"
                        font.family: interRegular.font.family
                        font.pixelSize: root.standardLandscapeLayout ? 15 : (root.compactLandscapeLayout ? 11 : 13)
                        wrapMode: Text.WordWrap
                        width: parent.width
                        renderType: Text.NativeRendering
                    }
                }
            }

            Item {
                width: 1
                height: root.standardLandscapeLayout ? 2 : (root.compactLandscapeLayout ? 4 : 1)
            }

            Rectangle {
                width: root.standardLandscapeLayout ? 154 : (root.compactLandscapeLayout ? 112 : 132)
                height: root.standardLandscapeLayout ? 60 : (root.compactLandscapeLayout ? 40 : 52)
                radius: root.standardLandscapeLayout ? 20 : (root.compactLandscapeLayout ? 14 : 18)
                anchors.right: parent.right
                color: confirmWarningArea.containsPress ? "#242428" : "#18181b"
                border.width: 1
                border.color: "#2c2d31"
                scale: confirmWarningArea.containsPress ? 0.985 : 1.0

                Behavior on scale {
                    NumberAnimation {
                        duration: 140
                        easing.type: Easing.OutCubic
                    }
                }

                Text {
                    anchors.centerIn: parent
                    text: "OK"
                    color: "white"
                    font.family: interMedium.font.family
                    font.pixelSize: root.standardLandscapeLayout ? 18 : (root.compactLandscapeLayout ? 13 : 16)
                    renderType: Text.NativeRendering
                }

                MouseArea {
                    id: confirmWarningArea
                    anchors.fill: parent
                    onClicked: root.recordWarningOpen = false
                }
            }
        }
    }
}

