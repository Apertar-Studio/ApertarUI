import QtQuick
import QtQuick.Controls
import QtQml.Models

Item {
    id: root

    signal backRequested()

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

    property string selectedSection: "Monitoring"
    property var settingsState
    property string displayLayout: "square"
    readonly property bool landscapeCompactLayout: displayLayout === "landscape_compact"
    readonly property bool mediumLandscapeLayout: displayLayout === "landscape_medium"
    readonly property bool largeLandscapeLayout: displayLayout === "landscape_large"
    readonly property bool standardLandscapeLayout: displayLayout === "landscape"
    readonly property bool regularLandscapeLayout: mediumLandscapeLayout || standardLandscapeLayout
                                                     || largeLandscapeLayout
    readonly property bool compactLandscapeLayout: landscapeCompactLayout || regularLandscapeLayout
    readonly property int settingsSectionSpacing: largeLandscapeLayout ? 18 : (standardLandscapeLayout ? 12 : (compactLandscapeLayout ? 8 : 12))
    readonly property int settingsSectionTopSpacer: largeLandscapeLayout ? 10 : (standardLandscapeLayout ? 6 : (compactLandscapeLayout ? 4 : 10))
    readonly property int settingsEyebrowSize: largeLandscapeLayout ? 15 : (standardLandscapeLayout ? 11 : (compactLandscapeLayout ? 9 : 12))
    readonly property int settingsTitleSize: largeLandscapeLayout ? 42 : (standardLandscapeLayout ? 30 : (compactLandscapeLayout ? 22 : 28))
    readonly property int settingsHintSize: largeLandscapeLayout ? 18 : (standardLandscapeLayout ? 14 : (compactLandscapeLayout ? 11 : 13))
    readonly property real settingsEyebrowSpacing: largeLandscapeLayout ? 3.5 : (standardLandscapeLayout ? 2.8 : (compactLandscapeLayout ? 2.2 : 2.8))
    readonly property int compactSettingsBottomOverhang: largeLandscapeLayout ? 74 : (compactLandscapeLayout ? 44 : 0)
    readonly property int settingsScrollBottomPadding: largeLandscapeLayout ? 92 : (standardLandscapeLayout ? 58 : (compactLandscapeLayout ? 46 : 24))
    readonly property int settingsKeyboardPopupWidth: largeLandscapeLayout ? 1020 : (standardLandscapeLayout ? 780 : 592)
    readonly property int settingsKeyboardPopupHeight: largeLandscapeLayout ? 780 : (standardLandscapeLayout ? 596 : 448)
    readonly property int settingsKeyboardPopupMargin: largeLandscapeLayout ? 34 : (standardLandscapeLayout ? 24 : 19)
    readonly property int settingsKeyboardPopupSpacing: largeLandscapeLayout ? 16 : (standardLandscapeLayout ? 11 : 8)
    readonly property int settingsKeyboardRowSpacing: largeLandscapeLayout ? 12 : (standardLandscapeLayout ? 9 : 6)
    readonly property int settingsKeyboardKeyHeight: largeLandscapeLayout ? 78 : (standardLandscapeLayout ? 60 : 45)
    readonly property int settingsKeyboardButtonHeight: largeLandscapeLayout ? 82 : (standardLandscapeLayout ? 64 : 51)
    readonly property int settingsKeyboardTitleSize: largeLandscapeLayout ? 38 : (standardLandscapeLayout ? 28 : 23)
    readonly property int settingsKeyboardHintSize: largeLandscapeLayout ? 21 : (standardLandscapeLayout ? 16 : 13)
    readonly property int settingsKeyboardLabelSize: largeLandscapeLayout ? 17 : (standardLandscapeLayout ? 13 : 11)
    readonly property int settingsKeyboardFieldHeight: largeLandscapeLayout ? 88 : (standardLandscapeLayout ? 70 : 55)
    readonly property int settingsKeyboardFieldTextSize: largeLandscapeLayout ? 33 : (standardLandscapeLayout ? 25 : 21)
    readonly property int settingsKeyboardKeyTextSize: largeLandscapeLayout ? 24 : (standardLandscapeLayout ? 18 : 15)
    readonly property int settingsKeyboardSpaceTextSize: largeLandscapeLayout ? 22 : (standardLandscapeLayout ? 16 : 13)
    readonly property int settingsKeyboardButtonTextSize: largeLandscapeLayout ? 24 : (standardLandscapeLayout ? 18 : 15)
    readonly property int settingsSidebarWidth: largeLandscapeLayout ? 420 : (standardLandscapeLayout ? 260 : (mediumLandscapeLayout ? 220 : (compactLandscapeLayout ? 172 : 220)))
    readonly property int settingsSidebarGap: largeLandscapeLayout ? 28 : (standardLandscapeLayout ? 18 : (mediumLandscapeLayout ? 14 : (compactLandscapeLayout ? 12 : 20)))
    readonly property int settingsSidebarItemHeight: largeLandscapeLayout ? 88 : (standardLandscapeLayout ? 64 : (mediumLandscapeLayout ? 52 : (compactLandscapeLayout ? 40 : 56)))
    readonly property bool settingsSidebarItemCompact: landscapeCompactLayout
    readonly property bool settingsSidebarItemLarge: standardLandscapeLayout || largeLandscapeLayout
    readonly property int settingsSidebarHorizontalMargin: largeLandscapeLayout ? 16 : (standardLandscapeLayout ? 10 : (mediumLandscapeLayout ? 9 : (compactLandscapeLayout ? 7 : 12)))
    readonly property int settingsSidebarTopMargin: largeLandscapeLayout ? 14 : (standardLandscapeLayout ? 6 : (compactLandscapeLayout ? 6 : 12))
    readonly property int settingsSidebarBottomInset: largeLandscapeLayout ? 16 : (standardLandscapeLayout ? 10 : (mediumLandscapeLayout ? 8 : (compactLandscapeLayout ? 8 : 24)))
    readonly property int settingsSidebarSpacing: largeLandscapeLayout ? 8 : (standardLandscapeLayout ? 4 : (compactLandscapeLayout ? 4 : 8))
    readonly property int settingsContentTopOffset: largeLandscapeLayout ? 132 : (standardLandscapeLayout ? 76 : (mediumLandscapeLayout ? 62 : (landscapeCompactLayout ? 54 : 102)))

    property bool focusPeakingEnabled: true
    property string focusPeakingThreshold: "70%"
    property string focusPeakingColor: "Red"

    property bool falseColorEnabled: false
    property string falseColorMode: "Exposure"

    property bool greyscaleEnabled: false
    readonly property string recordResolution: apertarControlBridge && apertarControlBridge.resolution.length > 0
                                               ? apertarControlBridge.resolution
                                               : "1920x1080"
    readonly property string sensorNameLower: (typeof deviceInfoBridge !== "undefined"
                                               && deviceInfoBridge
                                               && deviceInfoBridge.sensorName)
                                              ? deviceInfoBridge.sensorName.toLowerCase()
                                              : ""
    readonly property string piModelLower: (typeof deviceInfoBridge !== "undefined"
                                            && deviceInfoBridge
                                            && deviceInfoBridge.piModel)
                                           ? deviceInfoBridge.piModel.toLowerCase()
                                           : ""
    readonly property bool imx577Detected: root.sensorNameLower.indexOf("imx577") !== -1
    readonly property bool imx477Detected: root.sensorNameLower.indexOf("imx477") !== -1
    readonly property bool fanModeSupported: root.piModelLower.indexOf("raspberry pi 4") === -1
    readonly property var resolutionOptions: root.imx577Detected
                                             ? ["1332x990", "2028x1080", "2028x1520", "4056x2160", "4056x3040"]
                                             : (root.imx477Detected
                                                ? ["1332x990", "2028x1080", "2028x1520"]
                                                : ["1920x1080", "3840x2160"])
    readonly property string recordFormat: apertarControlBridge && apertarControlBridge.recordingFormat.length > 0
                                           ? apertarControlBridge.recordingFormat
                                           : "cDNG"
    readonly property bool vmountPowerPresent: powerBridge.sensorAvailable && powerBridge.busVoltageV > 3.0
    readonly property string batteryVoltageText: powerBridge.sensorAvailable ? powerBridge.voltageText : "--.-V"
    readonly property string batteryCurrentText: powerBridge.sensorAvailable ? powerBridge.currentText : "--.-A"
    readonly property string batteryPowerDrawText: powerBridge.sensorAvailable ? (powerBridge.powerText + " Draw") : "INA219 unavailable"

    property int systemYear: 2026
    property int systemMonth: 3
    property int systemDay: 30
    property int systemHour: 22
    property int systemMinute: 14
    property string systemTimezone: "Europe/Bucharest"
    property var systemTimezoneOptions: [
        "UTC",
        "Etc/GMT+12",
        "Pacific/Honolulu",
        "America/Anchorage",
        "America/Los_Angeles",
        "America/Phoenix",
        "America/Denver",
        "America/Chicago",
        "Europe/Bucharest",
        "Europe/London",
        "Europe/Berlin",
        "America/New_York",
        "America/Toronto",
        "America/Mexico_City",
        "America/Bogota",
        "America/Caracas",
        "America/Santiago",
        "America/Sao_Paulo",
        "America/Argentina/Buenos_Aires",
        "Atlantic/Bermuda",
        "Atlantic/Azores",
        "Europe/Dublin",
        "Europe/Paris",
        "Europe/Madrid",
        "Europe/Rome",
        "Europe/Amsterdam",
        "Europe/Zurich",
        "Europe/Prague",
        "Europe/Warsaw",
        "Europe/Athens",
        "Europe/Helsinki",
        "Europe/Kiev",
        "Europe/Istanbul",
        "Europe/Moscow",
        "Africa/Casablanca",
        "Africa/Lagos",
        "Africa/Cairo",
        "Africa/Johannesburg",
        "Africa/Nairobi",
        "Asia/Jerusalem",
        "Asia/Baghdad",
        "Asia/Tehran",
        "Asia/Dubai",
        "Asia/Baku",
        "Asia/Kabul",
        "Asia/Karachi",
        "Asia/Calcutta",
        "Asia/Kathmandu",
        "Asia/Dhaka",
        "Asia/Almaty",
        "Asia/Bangkok",
        "Asia/Jakarta",
        "Asia/Singapore",
        "Asia/Hong_Kong",
        "Asia/Shanghai",
        "Asia/Taipei",
        "Asia/Seoul",
        "Asia/Tokyo",
        "Australia/Perth",
        "Australia/Adelaide",
        "Australia/Darwin",
        "Australia/Brisbane",
        "Australia/Sydney",
        "Australia/Melbourne",
        "Pacific/Noumea",
        "Pacific/Auckland",
        "Pacific/Fiji",
        "Pacific/Apia"
    ]
    property bool powerConfirmOpen: false
    property bool powerErrorOpen: false
    property string pendingPowerAction: ""
    property string powerErrorText: ""
    property bool ejectConfirmOpen: false
    property bool ejectErrorOpen: false
    property string ejectErrorText: ""
    property bool formatConfirmOpen: false
    property bool formatSuccessOpen: false
    property bool formatErrorOpen: false
    property string formatSuccessText: ""
    property string formatErrorText: ""
    property bool mediaMountErrorOpen: false
    property string mediaMountErrorText: ""
    property string selectedMediaDriveOption: ""
    property string selectedMediaFormatOption: "exFAT"
    readonly property var mediaFormatOptions: ["exFAT", "FAT32", "NTFS"]
    property bool timeApplySuccessOpen: false
    property bool timeApplyErrorOpen: false
    property string timeApplyErrorText: ""
    property bool thermalApplySuccessOpen: false
    property bool thermalApplyErrorOpen: false
    property string thermalApplyErrorText: ""
    property string wifiSelectedSsid: ""
    property string wifiSelectedSecurity: ""
    property string wifiPassword: ""
    property bool wifiPasswordVisible: false
    property bool hotspotPasswordVisible: false
    property bool hotspotEditPopupOpen: false
    property string hotspotEditTarget: ""
    property string hotspotEditDraft: ""
    property bool wifiPasswordPopupOpen: false
    property bool wifiKeyboardShift: false
    property bool wifiKeyboardCapsLock: false
    property bool wifiKeyboardLongPressHandled: false
    property string wifiKeyboardMode: "letters"
    property bool presetNamePopupOpen: false
    property string presetNameDraft: ""
    property bool presetKeyboardShift: false
    property bool presetKeyboardCapsLock: false
    property bool presetKeyboardLongPressHandled: false
    property string presetKeyboardMode: "letters"
    property bool presetDeleteConfirmOpen: false
    property string presetDeleteTargetName: ""
    readonly property int presetCount: root.settingsState ? root.settingsState.presetNames.length : 0
    readonly property var wifiLetterKeyboardRows: [
        ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"],
        ["a", "s", "d", "f", "g", "h", "j", "k", "l"],
        ["shift", "z", "x", "c", "v", "b", "n", "m", "back"],
        ["123", "@", "space", "."]
    ]
    readonly property var wifiSymbolKeyboardRows: [
        ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],
        ["-", "/", ":", ";", "(", ")", "$", "&", "@"],
        [".", ",", "?", "!", "'", "\"", "_"],
        ["ABC", "#", "space", "back"]
    ]
    readonly property var wifiKeyboardRows: root.wifiKeyboardMode === "symbols"
                                           ? root.wifiSymbolKeyboardRows
                                           : root.wifiLetterKeyboardRows
    readonly property var presetKeyboardRows: root.presetKeyboardMode === "symbols"
                                              ? root.wifiSymbolKeyboardRows
                                              : root.wifiLetterKeyboardRows
    readonly property var defaultMonitoringOrder: [
        "externalMonitor",
        "focusPeaking",
        "zebra",
        "falseColor",
        "smpteBars",
        "guides",
        "centerMarker",
        "greyscale",
        "anamorphicDesqueeze"
    ]
    readonly property var defaultRecordOrder: [
        "stillMode",
        "format",
        "autofocus",
        "timecode"
    ]
    readonly property var defaultAudioOrder: [
        "audioOptions",
        "levels"
    ]
    readonly property var defaultPowerOrder: [
        "media",
        "formatMedia",
        "mediaSpeed"
    ]
    readonly property var defaultSystemOrder: [
        "uiOrientation",
        "cameraControlsOpacity",
        "dateTime",
        "battery",
        "batteryInfo",
        "autoPowerOff",
        "thermal",
        "powerActions"
    ]
    readonly property var defaultWifiOrder: [
        "wifiToggle",
        "currentNetwork",
        "availableNetworks",
        "hotspot"
    ]
    readonly property var defaultInfoOrder: [
        "camera",
        "sbc",
        "systemInfo",
        "systemDrive"
    ]
    readonly property var defaultSidebarOrder: [
        "Favorites",
        "Monitoring",
        "Record",
        "Audio",
        "Power",
        "System",
        "Presets",
        "Wi-Fi",
        "Info"
    ]
    readonly property var favoriteCandidateOrder: [
        "externalMonitor",
        "focusPeaking",
        "zebra",
        "falseColor",
        "smpteBars",
        "guides",
        "centerMarker",
        "greyscale",
        "anamorphicDesqueeze",
        "stillMode",
        "format",
        "autofocus",
        "timecode",
        "audioOptions",
        "levels",
        "uiOrientation",
        "cameraControlsOpacity",
        "dateTime",
        "battery",
        "batteryInfo",
        "autoPowerOff",
        "thermal",
        "powerActions",
        "media",
        "formatMedia",
        "mediaSpeed",
        "wifiToggle",
        "currentNetwork",
        "availableNetworks",
        "hotspot",
        "camera",
        "sbc",
        "systemInfo",
        "systemDrive"
    ]
    property bool favoriteControlsEnabled: false
    property bool favoriteManagerOpen: false
    property var favoriteSelectionDraft: []
    property bool reorderPopupOpen: false
    property string reorderSection: ""
    property bool reorderDragging: false
    property bool sidebarDragging: false
    readonly property var controlsOpacityOptions: ["100%", "85%", "70%", "55%", "40%", "25%", "15%"]
    readonly property var controlsModeOptions: ["Light", "Dark"]

    onSelectedSectionChanged: {
        if (reorderPopupOpen && selectedSection !== reorderSection)
            reorderPopupOpen = false
        if (favoriteManagerOpen && selectedSection !== "Favorites")
            favoriteManagerOpen = false
        if (presetNamePopupOpen && selectedSection !== "Presets")
            root.closePresetNamePopup()

        if (typeof audioDeviceBridge !== "undefined" && audioDeviceBridge)
            audioDeviceBridge.setPollingEnabled(selectedSection === "Audio")

        if (selectedSection === "Wi-Fi")
            wifiBridge.refresh()
        else {
            root.cancelWifiConnect()
        }
        if (selectedSection === "Audio") {
            audioDeviceBridge.refresh()
            root.syncAudioDeviceSelections()
        }
        if (selectedSection === "Power")
            mediaBridge.refreshMountableDrives()
    }

    onSettingsStateChanged: {
        Qt.callLater(root.syncAudioDeviceSelections)
        Qt.callLater(root.syncSidebarOrderModel)
    }

    function syncAudioDeviceSelections() {
        if (!root.settingsState || typeof audioDeviceBridge === "undefined")
            return

        var normalizedInput = audioDeviceBridge.normalizeInputSelection(root.settingsState.audioInputDevice || "")
        if ((root.settingsState.audioInputDevice || "") !== normalizedInput)
            root.settingsState.audioInputDevice = normalizedInput

        var normalizedOutput = audioDeviceBridge.normalizeOutputSelection(root.settingsState.audioOutputDevice || "")
        if ((root.settingsState.audioOutputDevice || "") !== normalizedOutput)
            root.settingsState.audioOutputDevice = normalizedOutput
    }

    function sectionSupportsReorder(section) {
        return section === "Monitoring"
            || section === "Record"
            || section === "Audio"
            || section === "Power"
            || section === "System"
            || section === "Wi-Fi"
            || section === "Info"
            || section === "Favorites"
    }

    function defaultOrderForSection(section) {
        if (section === "Monitoring")
            return root.defaultMonitoringOrder
        if (section === "Record")
            return root.defaultRecordOrder
        if (section === "Audio")
            return root.defaultAudioOrder
        if (section === "Power")
            return root.defaultPowerOrder
        if (section === "System")
            return root.defaultSystemOrder
        if (section === "Wi-Fi")
            return root.defaultWifiOrder
        if (section === "Info")
            return root.defaultInfoOrder
        if (section === "Sidebar")
            return root.defaultSidebarOrder
        if (section === "Favorites")
            return root.favoriteItems()
        return []
    }

    function storedOrderForSection(section) {
        if (!root.settingsState)
            return []
        if (section === "Monitoring")
            return root.settingsState.monitoringOrder || []
        if (section === "Record")
            return root.settingsState.recordOrder || []
        if (section === "Audio")
            return root.settingsState.audioOrder || []
        if (section === "Power")
            return root.settingsState.powerOrder || []
        if (section === "System")
            return root.settingsState.systemOrder || []
        if (section === "Wi-Fi")
            return root.settingsState.wifiOrder || []
        if (section === "Info")
            return root.settingsState.infoOrder || []
        if (section === "Sidebar")
            return root.settingsState.sidebarOrder || []
        if (section === "Favorites")
            return root.settingsState.favoritesOrder || []
        return []
    }

    function normalizedSectionOrder(section) {
        var defaults = root.defaultOrderForSection(section)
        var stored = root.storedOrderForSection(section)
        var out = []
        var seen = {}

        if (section === "Favorites") {
            for (var favoriteIndex = 0; favoriteIndex < stored.length; ++favoriteIndex) {
                var favoriteId = String(stored[favoriteIndex])
                if (root.favoriteCandidateOrder.indexOf(favoriteId) >= 0 && !seen[favoriteId]) {
                    out.push(favoriteId)
                    seen[favoriteId] = true
                }
            }
            return out
        }

        for (var i = 0; i < stored.length; ++i) {
            var id = String(stored[i])
            if (defaults.indexOf(id) >= 0 && !seen[id]) {
                out.push(id)
                seen[id] = true
            }
        }

        if (section === "Sidebar" && !seen["Favorites"] && defaults.indexOf("Favorites") >= 0) {
            out.unshift("Favorites")
            seen["Favorites"] = true
        }

        for (var j = 0; j < defaults.length; ++j) {
            var defaultId = String(defaults[j])
            if (!seen[defaultId]) {
                out.push(defaultId)
                seen[defaultId] = true
            }
        }

        return out
    }

    function applySectionOrder(section, order) {
        if (!root.settingsState)
            return

        if (section === "Monitoring")
            root.settingsState.monitoringOrder = order
        else if (section === "Record")
            root.settingsState.recordOrder = order
        else if (section === "Audio")
            root.settingsState.audioOrder = order
        else if (section === "Power")
            root.settingsState.powerOrder = order
        else if (section === "System")
            root.settingsState.systemOrder = order
        else if (section === "Wi-Fi")
            root.settingsState.wifiOrder = order
        else if (section === "Info")
            root.settingsState.infoOrder = order
        else if (section === "Sidebar")
            root.settingsState.sidebarOrder = order
        else if (section === "Favorites")
            root.settingsState.favoritesOrder = order
    }

    function sectionItemTitle(section, itemId) {
        if (section === "Monitoring") {
            if (itemId === "externalMonitor") return "External Monitor"
            if (itemId === "focusPeaking") return "Focus Peaking"
            if (itemId === "zebra") return "Zebra"
            if (itemId === "falseColor") return "False Color"
            if (itemId === "smpteBars") return "SMPTE Bars"
            if (itemId === "guides") return "Guides"
            if (itemId === "centerMarker") return "Center Marker"
            if (itemId === "greyscale") return "Greyscale"
            if (itemId === "anamorphicDesqueeze") return "Anamorphic Desqueeze"
        }
        if (section === "Record") {
            if (itemId === "stillMode") return "Still Mode"
            if (itemId === "format") return "Format"
            if (itemId === "autofocus") return "Autofocus"
            if (itemId === "timecode") return "Timecode"
        }
        if (section === "Audio") {
            if (itemId === "audioOptions") return "Audio"
            if (itemId === "levels") return "Levels"
        }
        if (section === "Power") {
            if (itemId === "media") return "Media"
            if (itemId === "formatMedia") return "Format Media"
            if (itemId === "mediaSpeed") return "Media Speed"
        }
        if (section === "System") {
            if (itemId === "uiOrientation") return "UI Orientation"
            if (itemId === "cameraControlsOpacity") return "Controls Transparency"
            if (itemId === "dateTime") return "Date & Time"
            if (itemId === "battery") return "Battery"
            if (itemId === "batteryInfo") return "Battery Info"
            if (itemId === "autoPowerOff") return "Auto Power Off"
            if (itemId === "thermal") return "Thermal"
            if (itemId === "powerActions") return "Power Actions"
        }
        if (section === "Wi-Fi") {
            if (itemId === "wifiToggle") return "Wi-Fi"
            if (itemId === "currentNetwork") return "Current Network"
            if (itemId === "hotspot") return "Hotspot"
            if (itemId === "availableNetworks") return "Available Networks"
        }
        if (section === "Info") {
            if (itemId === "camera") return "Camera"
            if (itemId === "sbc") return "SBC"
            if (itemId === "systemInfo") return "System"
            if (itemId === "systemDrive") return "System Drive"
        }
        if (section === "Favorites")
            return root.sectionItemTitle(root.sourceSectionForItemId(itemId), itemId)
        if (section === "Sidebar" && itemId === "Power")
            return "Media"
        if (section === "Sidebar")
            return itemId
        return itemId
    }

    function sidebarIconForId(itemId) {
        if (itemId === "Favorites") return "qrc:/qml/icons/favorites.png"
        if (itemId === "Monitoring") return "qrc:/qml/icons/monitoring.png"
        if (itemId === "Record") return "qrc:/qml/icons/record.png"
        if (itemId === "Audio") return "qrc:/qml/icons/audio.png"
        if (itemId === "Power") return "qrc:/qml/icons/media.png"
        if (itemId === "System") return "qrc:/qml/icons/system.png"
        if (itemId === "Presets") return "qrc:/qml/icons/levels.png"
        if (itemId === "Wi-Fi") return "qrc:/qml/icons/wifi.png"
        if (itemId === "Info") return "qrc:/qml/icons/info.png"
        return ""
    }

    function syncSidebarOrderModel() {
        sidebarOrderModel.clear()
        var order = root.normalizedSectionOrder("Sidebar")
        for (var i = 0; i < order.length; ++i) {
            sidebarOrderModel.append({
                "itemId": order[i],
                "label": root.sectionItemTitle("Sidebar", order[i]),
                "iconSource": root.sidebarIconForId(order[i])
            })
        }
    }

    function saveSidebarOrderFromModel() {
        var order = []
        for (var i = 0; i < sidebarOrderModel.count; ++i)
            order.push(sidebarOrderModel.get(i).itemId)
        root.applySectionOrder("Sidebar", order)
    }

    function sourceSectionForItemId(itemId) {
        if (root.defaultMonitoringOrder.indexOf(itemId) >= 0) return "Monitoring"
        if (root.defaultRecordOrder.indexOf(itemId) >= 0) return "Record"
        if (root.defaultAudioOrder.indexOf(itemId) >= 0) return "Audio"
        if (root.defaultPowerOrder.indexOf(itemId) >= 0) return "Power"
        if (root.defaultSystemOrder.indexOf(itemId) >= 0) return "System"
        if (root.defaultWifiOrder.indexOf(itemId) >= 0) return "Wi-Fi"
        if (root.defaultInfoOrder.indexOf(itemId) >= 0) return "Info"
        return ""
    }

    function favoriteItems() {
        if (!root.settingsState)
            return []

        var stored = root.settingsState.favoritesOrder || []
        var out = []
        var seen = {}

        for (var i = 0; i < stored.length; ++i) {
            var id = String(stored[i])
            if (root.favoriteCandidateOrder.indexOf(id) >= 0 && !seen[id]) {
                out.push(id)
                seen[id] = true
            }
        }

        return out
    }

    function itemIsFavorited(itemId) {
        return root.favoriteItems().indexOf(itemId) >= 0
    }

    function toggleFavoriteItem(itemId) {
        if (!root.settingsState)
            return

        var order = root.favoriteItems().slice()
        var existingIndex = order.indexOf(itemId)
        if (existingIndex >= 0)
            order.splice(existingIndex, 1)
        else if (root.favoriteCandidateOrder.indexOf(itemId) >= 0)
            order.push(itemId)

        root.settingsState.favoritesOrder = order
    }

    function openFavoriteManager() {
        root.favoriteSelectionDraft = root.favoriteItems().slice()
        root.favoriteManagerOpen = true
    }

    function favoriteDraftContains(itemId) {
        return root.favoriteSelectionDraft.indexOf(itemId) >= 0
    }

    function toggleFavoriteDraftItem(itemId) {
        var draft = root.favoriteSelectionDraft.slice()
        var existingIndex = draft.indexOf(itemId)
        if (existingIndex >= 0)
            draft.splice(existingIndex, 1)
        else if (root.favoriteCandidateOrder.indexOf(itemId) >= 0)
            draft.push(itemId)

        root.favoriteSelectionDraft = draft
    }

    function clearFavoriteDraft() {
        root.favoriteSelectionDraft = []
    }

    function saveFavoriteManager() {
        if (!root.settingsState)
            return

        root.settingsState.favoritesOrder = root.favoriteSelectionDraft.slice()
        root.favoriteManagerOpen = false
    }

    function openReorderPopup(section) {
        if (!root.sectionSupportsReorder(section))
            return

        reorderSection = section
        reorderListModel.clear()

        var order = root.normalizedSectionOrder(section)
        for (var i = 0; i < order.length; ++i) {
            reorderListModel.append({
                "itemId": order[i],
                "title": root.sectionItemTitle(section, order[i])
            })
        }

        reorderPopupOpen = true
    }

    function resetReorderPopup() {
        if (reorderSection.length === 0)
            return

        reorderListModel.clear()
        var defaults = root.defaultOrderForSection(reorderSection)
        for (var i = 0; i < defaults.length; ++i) {
            reorderListModel.append({
                "itemId": defaults[i],
                "title": root.sectionItemTitle(reorderSection, defaults[i])
            })
        }
    }

    function saveReorderPopup() {
        var order = []
        for (var i = 0; i < reorderListModel.count; ++i)
            order.push(reorderListModel.get(i).itemId)

        root.applySectionOrder(reorderSection, order)
        reorderPopupOpen = false
    }

    function zebraLevelToThreshold(level) {
        if (level === "70%") return 0.70
        if (level === "75%") return 0.75
        if (level === "80%") return 0.80
        if (level === "85%") return 0.85
        if (level === "90%") return 0.90
        if (level === "95%") return 0.95
        if (level === "100%") return 0.99
        return 0.70
    }

    function thresholdToZebraLevel(threshold) {
        if (Math.abs(threshold - 0.70) < 0.001) return "70%"
        if (Math.abs(threshold - 0.75) < 0.001) return "75%"
        if (Math.abs(threshold - 0.80) < 0.001) return "80%"
        if (Math.abs(threshold - 0.85) < 0.001) return "85%"
        if (Math.abs(threshold - 0.90) < 0.001) return "90%"
        if (Math.abs(threshold - 0.95) < 0.001) return "95%"
        if (Math.abs(threshold - 0.99) < 0.001) return "100%"
        return "70%"
    }

    function focusThresholdToValue(label) {
        if (label === "Low") return 0.05
        if (label === "Medium") return 0.08
        if (label === "High") return 0.12
        return 0.08
    }

    function valueToFocusThreshold(v) {
        if (Math.abs(v - 0.05) < 0.01) return "Low"
        if (Math.abs(v - 0.08) < 0.01) return "Medium"
        if (Math.abs(v - 0.12) < 0.01) return "High"
        return "Medium"
    }

    function falseColorModeToInt(mode) {
        if (mode === "Exposure Based") return 0
        if (mode === "Skin Tone") return 1
        if (mode === "Highlight Priority") return 2
        if (mode === "Shadow Priority") return 3
        return 0
    }

    function opacityLabelToValue(label) {
        var parsed = parseInt(String(label).replace("%", ""))
        if (isNaN(parsed))
            return 1.0
        return Math.max(0.15, Math.min(1.0, parsed / 100.0))
    }

    function opacityValueToLabel(value) {
        var clamped = Math.max(0.15, Math.min(1.0, value))
        var bestLabel = root.controlsOpacityOptions[0]
        var bestDelta = Math.abs(root.opacityLabelToValue(bestLabel) - clamped)
        for (var i = 1; i < root.controlsOpacityOptions.length; ++i) {
            var candidate = root.controlsOpacityOptions[i]
            var delta = Math.abs(root.opacityLabelToValue(candidate) - clamped)
            if (delta < bestDelta) {
                bestLabel = candidate
                bestDelta = delta
            }
        }
        return bestLabel
    }

    Connections {
        target: typeof audioDeviceBridge !== "undefined" ? audioDeviceBridge : null

        function onInputDeviceOptionsChanged() {
            root.syncAudioDeviceSelections()
        }

        function onOutputDeviceOptionsChanged() {
            root.syncAudioDeviceSelections()
        }
    }

    function intToFalseColorMode(mode) {
        if (mode === 0) return "Exposure Based"
        if (mode === 1) return "Skin Tone"
        if (mode === 2) return "Highlight Priority"
        if (mode === 3) return "Shadow Priority"
        return "Exposure Based"
    }

    function adjustSystemNumber(key, delta, min, max) {
        var nextValue = root[key] + delta
        if (nextValue > max)
            nextValue = min
        if (nextValue < min)
            nextValue = max
        root[key] = nextValue
    }

    function twoDigits(value) {
        return value < 10 ? ("0" + value) : String(value)
    }

    function formattedSystemDateTime() {
        return String(systemYear)
             + "-" + twoDigits(systemMonth)
             + "-" + twoDigits(systemDay)
             + " • "
             + twoDigits(systemHour)
             + ":" + twoDigits(systemMinute)
    }

    function formatDataSize(bytes) {
        if (bytes <= 0)
            return "0 B"

        var value = bytes
        var units = ["B", "KB", "MB", "GB", "TB"]
        var unitIndex = 0
        while (value >= 1024 && unitIndex < units.length - 1) {
            value /= 1024
            unitIndex += 1
        }

        var precision = (value >= 100 || unitIndex === 0) ? 0 : 1
        return value.toFixed(precision) + " " + units[unitIndex]
    }

    function adjustCustomBatteryWh(delta) {
        if (!root.settingsState)
            return
        root.settingsState.customBatteryWh = Math.max(10, Math.min(500, root.settingsState.customBatteryWh + delta))
    }

    function selectedBatteryCapacityWh() {
        if (!root.settingsState)
            return 150

        if (root.settingsState.batteryCapacity === "Custom")
            return root.settingsState.customBatteryWh

        var parsed = parseInt(String(root.settingsState.batteryCapacity).replace("Wh", ""))
        return isNaN(parsed) ? 150 : parsed
    }

    function estimatedBatteryRuntimeText() {
        if (!powerBridge.sensorAvailable || powerBridge.powerW <= 0.1)
            return "Runtime unavailable"

        var remainingWh = (selectedBatteryCapacityWh() * powerBridge.batteryPercent) / 100.0
        if (remainingWh <= 0.05)
            return "Almost empty"

        var totalMinutes = Math.floor((remainingWh / powerBridge.powerW) * 60)
        if (totalMinutes < 1)
            return "<1 min left"

        var hours = Math.floor(totalMinutes / 60)
        var minutes = totalMinutes % 60

        if (hours > 0)
            return hours + "h " + twoDigits(minutes) + "m left"
        return minutes + " min left"
    }

    function mediaUsedBytes() {
        return Math.max(0, mediaBridge.totalBytes - mediaBridge.freeBytes)
    }

    function mediaUsedRatio() {
        return mediaBridge.totalBytes > 0 ? mediaUsedBytes() / mediaBridge.totalBytes : 0
    }

    function mediaFreePercent() {
        return mediaBridge.totalBytes > 0 ? Math.round((mediaBridge.freeBytes / mediaBridge.totalBytes) * 100) : 0
    }

    function selectedMediaDriveDisplay() {
        var options = mediaBridge.mountableDriveOptions || []
        if (options.length === 0)
            return "No available drives"
        if (root.selectedMediaDriveOption.length > 0 && options.indexOf(root.selectedMediaDriveOption) >= 0)
            return root.selectedMediaDriveOption
        return options[0]
    }

    function executeMountSelectedDrive() {
        mediaMountErrorOpen = false
        var option = root.selectedMediaDriveDisplay()
        if (option === "No available drives" || option.length === 0) {
            mediaMountErrorText = "No available non-system drives were found."
            mediaMountErrorOpen = true
            return
        }

        if (!mediaBridge.mountDriveByDisplayName(option)) {
            mediaMountErrorText = mediaBridge.lastActionError.length > 0
                                ? mediaBridge.lastActionError
                                : "The selected drive could not be mounted."
            mediaMountErrorOpen = true
            return
        }

        root.selectedMediaDriveOption = ""
    }

    function openPowerConfirmation(actionName) {
        pendingPowerAction = actionName
        powerErrorOpen = false
        powerConfirmOpen = true
    }

    function powerActionTitle() {
        return pendingPowerAction === "restart" ? "Restart Camera?" : "Shutdown Camera?"
    }

    function powerActionDescription() {
        return pendingPowerAction === "restart"
               ? "The camera UI will close and the system will reboot."
               : "The camera UI will close and the system will power down."
    }

    function powerActionButtonLabel() {
        return pendingPowerAction === "restart" ? "Restart" : "Shutdown"
    }

    function executePendingPowerAction() {
        powerConfirmOpen = false

        var ok = false
        if (pendingPowerAction === "restart")
            ok = systemActionBridge.restartCamera()
        else if (pendingPowerAction === "shutdown")
            ok = systemActionBridge.shutdownCamera()

        if (!ok) {
            powerErrorText = systemActionBridge.lastError.length > 0
                           ? systemActionBridge.lastError
                           : "The power action could not be completed."
            powerErrorOpen = true
        }
    }

    function openEjectConfirmation() {
        ejectErrorOpen = false
        ejectConfirmOpen = true
    }

    function executeEjectMedia() {
        ejectConfirmOpen = false
        if (!mediaBridge.ejectMedia()) {
            ejectErrorText = mediaBridge.lastActionError.length > 0
                           ? mediaBridge.lastActionError
                           : "The media could not be ejected."
            ejectErrorOpen = true
        }
    }

    function openFormatConfirmation() {
        formatSuccessOpen = false
        formatErrorOpen = false
        formatConfirmOpen = true
    }

    function executeFormatMedia() {
        formatConfirmOpen = false
        if (!mediaBridge.formatMedia(root.selectedMediaFormatOption)) {
            formatErrorText = mediaBridge.lastActionError.length > 0
                            ? mediaBridge.lastActionError
                            : "The card could not be formatted."
            formatErrorOpen = true
        } else {
            formatSuccessText = "Media formatted as " + root.selectedMediaFormatOption + " and mounted again."
            formatSuccessOpen = true
        }
    }

    function refreshSystemDateTimeDraftFromNow() {
        var now = new Date()
        systemYear = now.getFullYear()
        systemMonth = now.getMonth() + 1
        systemDay = now.getDate()
        systemHour = now.getHours()
        systemMinute = now.getMinutes()
    }

    function applySystemTimeZoneSelection(selectedTimeZone) {
        timeApplyErrorOpen = false

        var previousTimeZone = systemTimezone
        systemTimezone = selectedTimeZone

        if (!systemActionBridge.applyTimeZone(selectedTimeZone)) {
            systemTimezone = previousTimeZone
            timeApplyErrorText = systemActionBridge.lastError.length > 0
                               ? systemActionBridge.lastError
                               : "The timezone could not be updated."
            timeApplyErrorOpen = true
            return
        }

        systemTimezone = systemActionBridge.currentTimeZone.length > 0
                       ? systemActionBridge.currentTimeZone
                       : selectedTimeZone
        refreshSystemDateTimeDraftFromNow()
    }

    function executeApplyDateTime() {
        timeApplySuccessOpen = false
        timeApplyErrorOpen = false

        if (!systemActionBridge.applyDateTime(systemYear,
                                              systemMonth,
                                              systemDay,
                                              systemHour,
                                              systemMinute,
                                              systemTimezone)) {
            timeApplyErrorText = systemActionBridge.lastError.length > 0
                               ? systemActionBridge.lastError
                               : "The camera time could not be updated."
            timeApplyErrorOpen = true
        } else {
            systemTimezone = systemActionBridge.currentTimeZone.length > 0
                           ? systemActionBridge.currentTimeZone
                           : systemTimezone
            refreshSystemDateTimeDraftFromNow()
            timeApplySuccessOpen = true
        }
    }

    function executeApplyFanMode(mode) {
        thermalApplySuccessOpen = false
        thermalApplyErrorOpen = false

        if (!root.fanModeSupported) {
            thermalApplyErrorText = "Fan mode is unavailable on Raspberry Pi 4."
            thermalApplyErrorOpen = true
            return
        }

        if (!systemActionBridge.applyFanMode(mode)) {
            thermalApplyErrorText = systemActionBridge.lastError.length > 0
                                  ? systemActionBridge.lastError
                                  : "The thermal profile could not be updated."
            thermalApplyErrorOpen = true
        } else {
            thermalApplySuccessOpen = true
        }
    }

    function wifiRequiresPassword(security) {
        var normalized = security ? String(security).trim() : ""
        if (normalized.length === 0)
            return false
        return normalized.toLowerCase() !== "open" && normalized !== "--"
    }

    function openWifiConnect(ssid, security, active) {
        if (!ssid || ssid.length === 0 || active)
            return

        if (!root.wifiRequiresPassword(security)) {
            wifiBridge.connectToNetwork(ssid, "")
            return
        }

        wifiSelectedSsid = ssid
        wifiSelectedSecurity = security
        wifiPassword = ""
        wifiPasswordVisible = false
        wifiKeyboardShift = false
        wifiKeyboardCapsLock = false
        wifiKeyboardMode = "letters"
        wifiPasswordPopupOpen = true
    }

    function cancelWifiConnect() {
        wifiSelectedSsid = ""
        wifiSelectedSecurity = ""
        wifiPassword = ""
        wifiPasswordVisible = false
        wifiKeyboardShift = false
        wifiKeyboardCapsLock = false
        wifiKeyboardMode = "letters"
        wifiPasswordPopupOpen = false
    }

    function submitWifiConnect() {
        if (wifiSelectedSsid.length === 0)
            return

        if (wifiBridge.connectToNetwork(wifiSelectedSsid, wifiPassword))
            root.cancelWifiConnect()
    }

    function openHotspotEdit(target) {
        root.hotspotEditTarget = target
        root.hotspotEditDraft = target === "password"
                              ? wifiBridge.hotspotPassword
                              : wifiBridge.hotspotSsid
        root.wifiKeyboardShift = false
        root.wifiKeyboardCapsLock = false
        root.wifiKeyboardLongPressHandled = false
        root.wifiKeyboardMode = "letters"
        root.hotspotEditPopupOpen = true
    }

    function closeHotspotEdit() {
        root.hotspotEditPopupOpen = false
        root.hotspotEditTarget = ""
        root.hotspotEditDraft = ""
        root.wifiKeyboardShift = false
        root.wifiKeyboardCapsLock = false
        root.wifiKeyboardLongPressHandled = false
        root.wifiKeyboardMode = "letters"
    }

    function saveHotspotEdit() {
        if (root.hotspotEditTarget === "password") {
            if (root.hotspotEditDraft.length < 8)
                return
            wifiBridge.hotspotPassword = root.hotspotEditDraft
        } else {
            if (root.hotspotEditDraft.trim().length === 0)
                return
            wifiBridge.hotspotSsid = root.hotspotEditDraft.trim()
        }
        root.closeHotspotEdit()
    }

    function hotspotEditTitle() {
        return root.hotspotEditTarget === "password" ? "Hotspot Password" : "Hotspot Name"
    }

    function hotspotEditFieldLabel() {
        return root.hotspotEditTarget === "password" ? "Password" : "Network Name"
    }

    function currentWifiNetwork() {
        for (var i = 0; i < wifiBridge.networks.length; ++i) {
            var network = wifiBridge.networks[i]
            if (network.active)
                return network
        }
        return null
    }

    function currentWifiDetailText() {
        var network = root.currentWifiNetwork()
        if (network)
            return "Connected • " + network.signal + "% signal • " + network.security
        if (wifiBridge.currentSsid.length > 0)
            return "Connected"
        if (!wifiBridge.wifiEnabled)
            return "Wi-Fi adapter is turned off."
        return wifiBridge.wifiAvailable
               ? "Choose another network below to switch connections."
               : "No wireless adapter detected by NetworkManager."
    }

    function availableWifiNetworkCount() {
        var count = 0
        for (var i = 0; i < wifiBridge.networks.length; ++i) {
            var network = wifiBridge.networks[i]
            if (!network.active && network.ssid && network.ssid.length > 0)
                count += 1
        }
        return count
    }

    function wifiDisplayKeyLabel(key) {
        if (key === "shift")
            return root.wifiKeyboardCapsLock ? "CAPS" : (root.wifiKeyboardShift ? "SHIFT" : "Shift")
        if (key === "back")
            return "⌫"
        if (key === "space")
            return "Space"
        if (key === "123" || key === "ABC")
            return key
        if ((root.wifiKeyboardShift || root.wifiKeyboardCapsLock) && key.length === 1 && key >= "a" && key <= "z")
            return key.toUpperCase()
        return key
    }

    function wifiKeyWidth(key) {
        if (key === "space")
            return root.largeLandscapeLayout ? 348 : (root.standardLandscapeLayout ? 270 : 208)
        if (key === "123" || key === "ABC")
            return root.largeLandscapeLayout ? 116 : (root.standardLandscapeLayout ? 90 : 70)
        if (key === "shift" || key === "back")
            return root.largeLandscapeLayout ? 132 : (root.standardLandscapeLayout ? 102 : 80)
        return root.largeLandscapeLayout ? 78 : (root.standardLandscapeLayout ? 60 : 47)
    }

    function wifiKeyboardInsert(key) {
        if (key === "123") {
            root.wifiKeyboardMode = "symbols"
            root.wifiKeyboardShift = false
            return
        }

        if (key === "ABC") {
            root.wifiKeyboardMode = "letters"
            root.wifiKeyboardShift = false
            return
        }

        if (key === "shift") {
            if (root.wifiKeyboardCapsLock) {
                root.wifiKeyboardCapsLock = false
                root.wifiKeyboardShift = false
                return
            }
            root.wifiKeyboardShift = !root.wifiKeyboardShift
            return
        }

        if (key === "back") {
            if (root.hotspotEditPopupOpen) {
                if (root.hotspotEditDraft.length > 0)
                    root.hotspotEditDraft = root.hotspotEditDraft.slice(0, root.hotspotEditDraft.length - 1)
            } else if (root.wifiPassword.length > 0) {
                root.wifiPassword = root.wifiPassword.slice(0, root.wifiPassword.length - 1)
            }
            return
        }

        var text = key === "space" ? " " : key
        if ((root.wifiKeyboardShift || root.wifiKeyboardCapsLock) && text.length === 1 && text >= "a" && text <= "z")
            text = text.toUpperCase()

        if (root.hotspotEditPopupOpen)
            root.hotspotEditDraft += text
        else
            root.wifiPassword += text

        if (root.wifiKeyboardShift && !root.wifiKeyboardCapsLock && key !== "shift")
            root.wifiKeyboardShift = false
    }

    function wifiKeyboardToggleCapsLock() {
        root.wifiKeyboardCapsLock = !root.wifiKeyboardCapsLock
        root.wifiKeyboardShift = root.wifiKeyboardCapsLock
    }

    function openPresetNamePopup() {
        root.presetNameDraft = ""
        root.presetKeyboardShift = false
        root.presetKeyboardCapsLock = false
        root.presetKeyboardLongPressHandled = false
        root.presetKeyboardMode = "letters"
        if (root.settingsState)
            root.settingsState.clearPresetStatus()
        root.presetNamePopupOpen = true
    }

    function closePresetNamePopup() {
        root.presetNameDraft = ""
        root.presetKeyboardShift = false
        root.presetKeyboardCapsLock = false
        root.presetKeyboardLongPressHandled = false
        root.presetKeyboardMode = "letters"
        root.presetNamePopupOpen = false
    }

    function savePresetFromDraft() {
        if (!root.settingsState)
            return

        if (root.settingsState.saveCurrentAsPreset(root.presetNameDraft))
            root.closePresetNamePopup()
    }

    function importPresetsFromMedia() {
        if (!root.settingsState)
            return
        root.settingsState.importPresetsFromPath(mediaBridge.mountPath)
    }

    function applyPresetByName(name) {
        if (!root.settingsState)
            return
        root.settingsState.loadPreset(name)
    }

    function exportPresetByName(name) {
        if (!root.settingsState)
            return
        root.settingsState.exportPresetToPath(name, mediaBridge.mountPath)
    }

    function deletePresetByName(name) {
        if (!root.settingsState)
            return
        root.settingsState.deletePreset(name)
    }

    function openPresetDeleteConfirmation(name) {
        root.presetDeleteTargetName = name
        root.presetDeleteConfirmOpen = true
        if (root.settingsState)
            root.settingsState.clearPresetStatus()
    }

    function closePresetDeleteConfirmation() {
        root.presetDeleteTargetName = ""
        root.presetDeleteConfirmOpen = false
    }

    function executePresetDelete() {
        if (!root.settingsState || root.presetDeleteTargetName.length === 0)
            return

        root.settingsState.deletePreset(root.presetDeleteTargetName)
        root.closePresetDeleteConfirmation()
    }

    function presetDisplayKeyLabel(key) {
        if (key === "shift")
            return root.presetKeyboardCapsLock ? "CAPS" : (root.presetKeyboardShift ? "SHIFT" : "Shift")
        if (key === "back")
            return "⌫"
        if (key === "space")
            return "Space"
        if (key === "123" || key === "ABC")
            return key
        if ((root.presetKeyboardShift || root.presetKeyboardCapsLock) && key.length === 1 && key >= "a" && key <= "z")
            return key.toUpperCase()
        return key
    }

    function presetKeyWidth(key) {
        return root.wifiKeyWidth(key)
    }

    function presetKeyboardInsert(key) {
        if (key === "123") {
            root.presetKeyboardMode = "symbols"
            root.presetKeyboardShift = false
            return
        }

        if (key === "ABC") {
            root.presetKeyboardMode = "letters"
            root.presetKeyboardShift = false
            return
        }

        if (key === "shift") {
            if (root.presetKeyboardCapsLock) {
                root.presetKeyboardCapsLock = false
                root.presetKeyboardShift = false
                return
            }
            root.presetKeyboardShift = !root.presetKeyboardShift
            return
        }

        if (key === "back") {
            if (root.presetNameDraft.length > 0)
                root.presetNameDraft = root.presetNameDraft.slice(0, root.presetNameDraft.length - 1)
            return
        }

        var text = key === "space" ? " " : key
        if ((root.presetKeyboardShift || root.presetKeyboardCapsLock) && text.length === 1 && text >= "a" && text <= "z")
            text = text.toUpperCase()

        root.presetNameDraft += text

        if (root.presetKeyboardShift && !root.presetKeyboardCapsLock && key !== "shift")
            root.presetKeyboardShift = false
    }

    function presetKeyboardToggleCapsLock() {
        root.presetKeyboardCapsLock = !root.presetKeyboardCapsLock
        root.presetKeyboardShift = root.presetKeyboardCapsLock
    }

    Component.onCompleted: {
        refreshSystemDateTimeDraftFromNow()
        if (systemActionBridge.currentTimeZone.length > 0) {
            systemTimezone = systemActionBridge.currentTimeZone
            if (systemTimezoneOptions.indexOf(systemTimezone) < 0)
                systemTimezoneOptions = [systemTimezone].concat(systemTimezoneOptions)
        }
        if (typeof audioDeviceBridge !== "undefined" && audioDeviceBridge)
            audioDeviceBridge.setPollingEnabled(root.selectedSection === "Audio")
        root.syncSidebarOrderModel()
    }

    Connections {
        target: wifiBridge

        function onStatusChanged() {
            if (wifiBridge.currentSsid.length > 0 && wifiBridge.currentSsid === root.wifiSelectedSsid)
                root.cancelWifiConnect()
        }
    }

    QtObject {
        id: sharedDropdownController
        property var activeDropdown: null
    }

    ListModel {
        id: reorderListModel
    }

    ListModel {
        id: sidebarOrderModel
    }

    DelegateModel {
        id: sidebarDelegateModel
        model: sidebarOrderModel
        delegate: sidebarReorderDelegate
    }

    DelegateModel {
        id: reorderDelegateModel
        model: reorderListModel
        delegate: reorderDelegate
    }

    function monitoringComponentForId(itemId) {
        if (itemId === "externalMonitor") return monitoringExternalMonitorComponent
        if (itemId === "focusPeaking") return monitoringFocusPeakingComponent
        if (itemId === "zebra") return monitoringZebraComponent
        if (itemId === "falseColor") return monitoringFalseColorComponent
        if (itemId === "smpteBars") return monitoringSmpteComponent
        if (itemId === "guides") return monitoringGuidesComponent
        if (itemId === "centerMarker") return monitoringCenterMarkerComponent
        if (itemId === "greyscale") return monitoringGreyscaleComponent
        if (itemId === "anamorphicDesqueeze") return monitoringAnamorphicComponent
        return null
    }

    function recordComponentForId(itemId) {
        if (itemId === "stillMode") return recordStillModeComponent
        if (itemId === "format") return recordFormatComponent
        if (itemId === "autofocus") return recordAutofocusComponent
        if (itemId === "timecode") return recordTimecodeComponent
        return null
    }

    function audioComponentForId(itemId) {
        if (itemId === "audioOptions") return audioOptionsComponent
        if (itemId === "levels") return audioLevelsComponent
        return null
    }

    function powerComponentForId(itemId) {
        if (itemId === "media") return systemMediaComponent
        if (itemId === "formatMedia") return systemFormatMediaComponent
        if (itemId === "mediaSpeed") return systemMediaSpeedComponent
        return null
    }

    function systemComponentForId(itemId) {
        if (itemId === "uiOrientation") return systemUiOrientationComponent
        if (itemId === "cameraControlsOpacity") return systemControlsOpacityComponent
        if (itemId === "dateTime") return systemDateTimeComponent
        if (itemId === "battery") return powerBatteryComponent
        if (itemId === "batteryInfo") return powerBatteryInfoComponent
        if (itemId === "autoPowerOff") return powerAutoPowerOffComponent
        if (itemId === "thermal") return systemThermalComponent
        if (itemId === "powerActions") return systemPowerActionsComponent
        return null
    }

    function wifiComponentForId(itemId) {
        if (itemId === "wifiToggle") return wifiToggleComponent
        if (itemId === "currentNetwork") return wifiCurrentNetworkComponent
        if (itemId === "hotspot") return wifiHotspotComponent
        if (itemId === "availableNetworks") return wifiAvailableNetworksComponent
        return null
    }

    function infoComponentForId(itemId) {
        if (itemId === "camera") return infoCameraComponent
        if (itemId === "sbc") return infoSbcComponent
        if (itemId === "systemInfo") return infoSystemComponent
        if (itemId === "systemDrive") return infoSystemDriveComponent
        return null
    }

    function favoriteComponentForId(itemId) {
        var sourceSection = root.sourceSectionForItemId(itemId)
        if (sourceSection === "Monitoring") return root.monitoringComponentForId(itemId)
        if (sourceSection === "Record") return root.recordComponentForId(itemId)
        if (sourceSection === "Audio") return root.audioComponentForId(itemId)
        if (sourceSection === "Power") return root.powerComponentForId(itemId)
        if (sourceSection === "System") return root.systemComponentForId(itemId)
        if (sourceSection === "Wi-Fi") return root.wifiComponentForId(itemId)
        if (sourceSection === "Info") return root.infoComponentForId(itemId)
        return null
    }

    Component {
        id: monitoringExternalMonitorComponent

        MonitoringRow {
            property string reorderSectionName: "Monitoring"
            popupParent: dropdownOverlay
            dropdownController: sharedDropdownController
            title: "External Monitor"
            titleIconSource: "qrc:/qml/icons/monitoring.png"
            description: "Send a clean preview feed to HDMI"
            enabled: root.settingsState ? root.settingsState.externalMonitorEnabled : false
            favoriteEnabled: root.favoriteControlsEnabled
            favorited: root.itemIsFavorited("externalMonitor")
            choice1Label: "Mode"
            choice1Value: root.settingsState ? root.settingsState.externalMonitorMode : "Clean Feed"
            choice1Options: ["Clean Feed", "Assist Feed"]
            choice2Label: "Info Overlay"
            choice2Value: root.settingsState ? root.settingsState.externalMonitorInfoOverlay : "On"
            choice2Options: ["On", "Off"]
            choice3Label: "Orientation"
            choice3Value: root.settingsState ? root.settingsState.externalMonitorOrientation : "Landscape"
            choice3Options: ["Landscape", "Upside Down"]
            onPressAndHoldRequested: root.openReorderPopup(reorderSectionName)
            onFavoriteToggleRequested: root.toggleFavoriteItem("externalMonitor")
            onToggleRequested: {
                if (root.settingsState)
                    root.settingsState.externalMonitorEnabled = !root.settingsState.externalMonitorEnabled
            }
            onChoice1Selected: function(v) {
                if (root.settingsState)
                    root.settingsState.externalMonitorMode = v
            }
            onChoice2Selected: function(v) {
                if (root.settingsState)
                    root.settingsState.externalMonitorInfoOverlay = v
            }
            onChoice3Selected: function(v) {
                if (root.settingsState)
                    root.settingsState.externalMonitorOrientation = v
            }
        }
    }

    Component {
        id: monitoringFocusPeakingComponent

        MonitoringRow {
            property string reorderSectionName: "Monitoring"
            popupParent: dropdownOverlay
            dropdownController: sharedDropdownController
            title: "Focus Peaking"
            titleIconSource: "qrc:/qml/icons/focuspeaking.png"
            description: "Highlight in-focus edges"
            enabled: root.settingsState ? root.settingsState.focusPeakingEnabled : false
            favoriteEnabled: root.favoriteControlsEnabled
            favorited: root.itemIsFavorited("focusPeaking")
            choice1Label: "Threshold"
            choice1Value: root.valueToFocusThreshold(root.settingsState ? root.settingsState.focusPeakingThreshold : 0.04)
            choice1Options: ["Low", "Medium", "High"]
            choice2Label: "Color"
            choice2Value: root.settingsState ? root.settingsState.focusPeakingColor : "Red"
            choice2Options: ["Red", "Green", "Blue", "Yellow", "Pink"]
            onPressAndHoldRequested: root.openReorderPopup(reorderSectionName)
            onFavoriteToggleRequested: root.toggleFavoriteItem("focusPeaking")
            onToggleRequested: {
                if (root.settingsState)
                    root.settingsState.focusPeakingEnabled = !root.settingsState.focusPeakingEnabled
            }
            onChoice1Selected: function(v) {
                if (root.settingsState)
                    root.settingsState.focusPeakingThreshold = root.focusThresholdToValue(v)
            }
            onChoice2Selected: function(v) {
                if (root.settingsState)
                    root.settingsState.focusPeakingColor = v
            }
        }
    }

    Component {
        id: monitoringZebraComponent

        MonitoringRow {
            property string reorderSectionName: "Monitoring"
            popupParent: dropdownOverlay
            dropdownController: sharedDropdownController
            title: "Zebra"
            titleIconSource: "qrc:/qml/icons/zebra.png"
            description: "Exposure clipping warning"
            enabled: root.settingsState ? root.settingsState.zebraEnabled : false
            favoriteEnabled: root.favoriteControlsEnabled
            favorited: root.itemIsFavorited("zebra")
            choice1Label: "Level"
            choice1Value: root.thresholdToZebraLevel(root.settingsState ? root.settingsState.zebraThreshold : 0.70)
            choice1Options: ["70%", "75%", "80%", "85%", "90%", "95%", "100%"]
            onPressAndHoldRequested: root.openReorderPopup(reorderSectionName)
            onFavoriteToggleRequested: root.toggleFavoriteItem("zebra")
            onToggleRequested: {
                if (root.settingsState)
                    root.settingsState.zebraEnabled = !root.settingsState.zebraEnabled
            }
            onChoice1Selected: function(v) {
                if (root.settingsState)
                    root.settingsState.zebraThreshold = root.zebraLevelToThreshold(v)
            }
        }
    }

    Component {
        id: monitoringFalseColorComponent

        MonitoringRow {
            property string reorderSectionName: "Monitoring"
            popupParent: dropdownOverlay
            dropdownController: sharedDropdownController
            title: "False Color"
            titleIconSource: "qrc:/qml/icons/false-color.png"
            description: "Colorized exposure view"
            enabled: root.settingsState ? root.settingsState.falseColorEnabled : false
            favoriteEnabled: root.favoriteControlsEnabled
            favorited: root.itemIsFavorited("falseColor")
            choice1Label: "Mode"
            choice1Value: root.intToFalseColorMode(root.settingsState ? root.settingsState.falseColorMode : 0)
            choice1Options: [
                "Exposure Based",
                "Skin Tone",
                "Highlight Priority",
                "Shadow Priority"
            ]
            onPressAndHoldRequested: root.openReorderPopup(reorderSectionName)
            onFavoriteToggleRequested: root.toggleFavoriteItem("falseColor")
            onToggleRequested: {
                if (root.settingsState)
                    root.settingsState.falseColorEnabled = !root.settingsState.falseColorEnabled
            }
            onChoice1Selected: function(v) {
                if (root.settingsState)
                    root.settingsState.falseColorMode = root.falseColorModeToInt(v)
            }
        }
    }

    Component {
        id: monitoringGuidesComponent

        MonitoringRow {
            property string reorderSectionName: "Monitoring"
            popupParent: dropdownOverlay
            dropdownController: sharedDropdownController
            title: "Guides"
            titleIconSource: "qrc:/qml/icons/guides.png"
            description: "Frame guides and aspect masks"
            enabled: root.settingsState ? root.settingsState.guidesEnabled : true
            favoriteEnabled: root.favoriteControlsEnabled
            favorited: root.itemIsFavorited("guides")
            choice1Label: "Type"
            choice1Value: root.settingsState ? root.settingsState.guidesType : "Thirds"
            choice1Options: ["Thirds", "16:9", "2.39:1", "4:3", "1:1", "Academy 1.37:1", "5:4", "9:16", "14:9"]
            choice2Label: "Thickness"
            choice2Value: root.settingsState ? String(root.settingsState.guidesThickness) : "1"
            choice2Options: ["1", "2", "3", "4"]
            onPressAndHoldRequested: root.openReorderPopup(reorderSectionName)
            onFavoriteToggleRequested: root.toggleFavoriteItem("guides")
            onToggleRequested: {
                if (root.settingsState)
                    root.settingsState.guidesEnabled = !root.settingsState.guidesEnabled
            }
            onChoice1Selected: function(v) {
                if (root.settingsState)
                    root.settingsState.guidesType = v
            }
            onChoice2Selected: function(v) {
                if (root.settingsState)
                    root.settingsState.guidesThickness = parseInt(v)
            }
        }
    }

    Component {
        id: monitoringSmpteComponent

        MonitoringRow {
            property string reorderSectionName: "Monitoring"
            popupParent: dropdownOverlay
            dropdownController: sharedDropdownController
            title: "SMPTE Bars"
            titleIconSource: "qrc:/qml/icons/smpte.png"
            description: "Replace the preview image with SMPTE color bars"
            enabled: root.settingsState ? root.settingsState.smpteEnabled : false
            favoriteEnabled: root.favoriteControlsEnabled
            favorited: root.itemIsFavorited("smpteBars")
            onPressAndHoldRequested: root.openReorderPopup(reorderSectionName)
            onFavoriteToggleRequested: root.toggleFavoriteItem("smpteBars")
            onToggleRequested: {
                if (root.settingsState)
                    root.settingsState.smpteEnabled = !root.settingsState.smpteEnabled
            }
        }
    }

    Component {
        id: monitoringCenterMarkerComponent

        MonitoringRow {
            property string reorderSectionName: "Monitoring"
            popupParent: dropdownOverlay
            dropdownController: sharedDropdownController
            title: "Center Marker"
            titleIconSource: "qrc:/qml/icons/center-marker.png"
            description: "Independent center reference overlay"
            enabled: root.settingsState ? root.settingsState.centerMarkerEnabled : true
            favoriteEnabled: root.favoriteControlsEnabled
            favorited: root.itemIsFavorited("centerMarker")
            choice1Label: "Type"
            choice1Value: root.settingsState ? root.settingsState.centerMarkerType : "Circle/Dot"
            choice1Options: ["Circle/Dot", "Crosshair"]
            onPressAndHoldRequested: root.openReorderPopup(reorderSectionName)
            onFavoriteToggleRequested: root.toggleFavoriteItem("centerMarker")
            onToggleRequested: {
                if (root.settingsState)
                    root.settingsState.centerMarkerEnabled = !root.settingsState.centerMarkerEnabled
            }
            onChoice1Selected: function(v) {
                if (root.settingsState)
                    root.settingsState.centerMarkerType = v
            }
        }
    }

    Component {
        id: monitoringGreyscaleComponent

        MonitoringRow {
            property string reorderSectionName: "Monitoring"
            popupParent: dropdownOverlay
            dropdownController: sharedDropdownController
            title: "Greyscale"
            titleIconSource: "qrc:/qml/icons/grayscale.png"
            description: "Monochrome monitoring mode"
            enabled: root.settingsState ? root.settingsState.grayscaleEnabled : false
            favoriteEnabled: root.favoriteControlsEnabled
            favorited: root.itemIsFavorited("greyscale")
            onPressAndHoldRequested: root.openReorderPopup(reorderSectionName)
            onFavoriteToggleRequested: root.toggleFavoriteItem("greyscale")
            onToggleRequested: {
                if (root.settingsState)
                    root.settingsState.grayscaleEnabled = !root.settingsState.grayscaleEnabled
            }
        }
    }

    Component {
        id: monitoringAnamorphicComponent

        MonitoringRow {
            property string reorderSectionName: "Monitoring"
            popupParent: dropdownOverlay
            dropdownController: sharedDropdownController
            title: "Anamorphic Desqueeze"
            description: "Preview-only image desqueeze"
            enabled: root.settingsState ? root.settingsState.anamorphicDesqueezeEnabled : false
            favoriteEnabled: root.favoriteControlsEnabled
            favorited: root.itemIsFavorited("anamorphicDesqueeze")
            choice1Label: "Ratio"
            choice1Value: root.settingsState ? root.settingsState.anamorphicRatio : "1.33x"
            choice1Options: ["1.33x", "1.5x", "1.8x", "2.0x"]
            onPressAndHoldRequested: root.openReorderPopup(reorderSectionName)
            onFavoriteToggleRequested: root.toggleFavoriteItem("anamorphicDesqueeze")
            onToggleRequested: {
                if (root.settingsState)
                    root.settingsState.anamorphicDesqueezeEnabled = !root.settingsState.anamorphicDesqueezeEnabled
            }
            onChoice1Selected: function(v) {
                if (root.settingsState)
                    root.settingsState.anamorphicRatio = v
            }
        }
    }

    Component {
        id: recordStillModeComponent

        MonitoringRow {
            property string reorderSectionName: "Record"
            popupParent: dropdownOverlay
            dropdownController: sharedDropdownController
            title: "Still Mode"
            titleIconSource: "qrc:/qml/icons/camera.png"
            description: "Enable still capture"
            enabled: root.settingsState ? root.settingsState.photoModeEnabled : false
            favoriteEnabled: root.favoriteControlsEnabled
            favorited: root.itemIsFavorited("stillMode")
            choice1Label: "Format"
            choice1Value: root.settingsState ? root.settingsState.photoFormat : "DNG"
            choice1Options: ["DNG", "JPEG", "PNG", "TIFF", "DNG + JPEG", "DNG + PNG", "DNG + TIFF"]
            choice2Label: "Timer"
            choice2Value: root.settingsState ? root.settingsState.photoTimer : "Off"
            choice2Options: ["Off", "2s", "5s", "10s", "15s", "20s", "25s", "30s"]
            choice3Label: "Burst"
            choice3Value: root.settingsState ? root.settingsState.photoBurst : "Single"
            choice3Options: ["Single", "3 Shots", "5 Shots", "10 Shots"]
            onPressAndHoldRequested: root.openReorderPopup(reorderSectionName)
            onFavoriteToggleRequested: root.toggleFavoriteItem("stillMode")
            onToggleRequested: {
                if (root.settingsState)
                    root.settingsState.photoModeEnabled = !root.settingsState.photoModeEnabled
            }
            onChoice1Selected: function(v) {
                if (root.settingsState)
                    root.settingsState.photoFormat = v
            }
            onChoice2Selected: function(v) {
                if (root.settingsState)
                    root.settingsState.photoTimer = v
            }
            onChoice3Selected: function(v) {
                if (root.settingsState)
                    root.settingsState.photoBurst = v
            }
        }
    }

    Component {
        id: recordFormatComponent

        SystemSectionCard {
            property string reorderSectionName: "Record"
            title: "Format"
            titleIconSource: "qrc:/qml/icons/resolution.png"
            description: "Resolution and image quality"
            favoriteEnabled: root.favoriteControlsEnabled
            favorited: root.itemIsFavorited("format")
            onPressAndHoldRequested: root.openReorderPopup(reorderSectionName)
            onFavoriteToggleRequested: root.toggleFavoriteItem("format")

            Grid {
                width: parent.width
                columns: 2
                columnSpacing: 12
                rowSpacing: 12

                InlineDropdownField {
                    width: (parent.width - 12) / 2
                    label: "Resolution"
                    value: root.recordResolution
                    options: root.resolutionOptions
                    popupParent: dropdownOverlay
                    dropdownController: sharedDropdownController
                    onValueSelected: function(v) {
                        apertarControlBridge.applyResolution(v)
                    }
                }

                InlineDropdownField {
                    width: (parent.width - 12) / 2
                    label: "Format"
                    value: root.recordFormat
                    options: [
                        { value: "cDNG", label: "cDNG", enabled: true },
                        { value: "MLV", label: "MLV", enabled: false }
                    ]
                    popupParent: dropdownOverlay
                    dropdownController: sharedDropdownController
                    onValueSelected: function(v) {
                        apertarControlBridge.applyRecordingFormat(v)
                    }
                }
            }
        }
    }

    Component {
        id: recordTimecodeComponent

        SystemSectionCard {
            property string reorderSectionName: "Record"
            title: "Timecode"
            titleIconSource: "qrc:/qml/icons/timecode.png"
            description: "Timecode behavior"
            favoriteEnabled: root.favoriteControlsEnabled
            favorited: root.itemIsFavorited("timecode")
            onPressAndHoldRequested: root.openReorderPopup(reorderSectionName)
            onFavoriteToggleRequested: root.toggleFavoriteItem("timecode")

            InlineDropdownField {
                width: parent.width
                label: "Mode"
                value: root.settingsState ? root.settingsState.timecodeMode : "Free Run"
                options: ["Free Run", "Rec Run"]
                openUpwards: true
                popupParent: dropdownOverlay
                dropdownController: sharedDropdownController
                onValueSelected: function(v) {
                    if (root.settingsState)
                        root.settingsState.timecodeMode = v
                    if (typeof apertarControlBridge !== "undefined" && apertarControlBridge)
                        apertarControlBridge.applyTimecodeMode(v)
                }
            }
        }
    }

    Component {
        id: recordAutofocusComponent

        SystemSectionCard {
            property string reorderSectionName: "Record"
            title: "Autofocus"
            titleIconSource: "qrc:/qml/icons/autofocus.png"
            description: "Lens autofocus behavior"
            favoriteEnabled: root.favoriteControlsEnabled
            favorited: root.itemIsFavorited("autofocus")
            onPressAndHoldRequested: root.openReorderPopup(reorderSectionName)
            onFavoriteToggleRequested: root.toggleFavoriteItem("autofocus")

            Grid {
                width: parent.width
                columns: 2
                columnSpacing: 12
                rowSpacing: 12

                InlineDropdownField {
                    width: (parent.width - 12) / 2
                    label: "Mode"
                    value: typeof apertarControlBridge !== "undefined" && apertarControlBridge
                           ? apertarControlBridge.autofocusMode
                           : "Continuous"
                    options: ["Manual", "Auto", "Continuous"]
                    popupParent: dropdownOverlay
                    dropdownController: sharedDropdownController
                    onValueSelected: function(v) {
                        apertarControlBridge.applyAutofocusMode(v)
                    }
                }

                InlineDropdownField {
                    width: (parent.width - 12) / 2
                    label: "Range"
                    value: typeof apertarControlBridge !== "undefined" && apertarControlBridge
                           ? apertarControlBridge.autofocusRange
                           : "Normal"
                    options: ["Normal", "Macro", "Full"]
                    popupParent: dropdownOverlay
                    dropdownController: sharedDropdownController
                    onValueSelected: function(v) {
                        apertarControlBridge.applyAutofocusRange(v)
                    }
                }

                InlineDropdownField {
                    width: (parent.width - 12) / 2
                    label: "Speed"
                    value: typeof apertarControlBridge !== "undefined" && apertarControlBridge
                           ? apertarControlBridge.autofocusSpeed
                           : "Normal"
                    options: ["Normal", "Fast"]
                    popupParent: dropdownOverlay
                    dropdownController: sharedDropdownController
                    onValueSelected: function(v) {
                        apertarControlBridge.applyAutofocusSpeed(v)
                    }
                }

                InlineDropdownField {
                    width: (parent.width - 12) / 2
                    label: "Window"
                    value: typeof apertarControlBridge !== "undefined" && apertarControlBridge
                           ? apertarControlBridge.autofocusWindow
                           : "Center"
                    options: ["Center", "Full Frame"]
                    popupParent: dropdownOverlay
                    dropdownController: sharedDropdownController
                    onValueSelected: function(v) {
                        apertarControlBridge.applyAutofocusWindow(v)
                    }
                }
            }
        }
    }

    Component {
        id: audioOptionsComponent

        SystemSectionCard {
            property string reorderSectionName: "Audio"
            title: "Audio"
            titleIconSource: "qrc:/qml/icons/audio.png"
            description: "Input and recording options"
            favoriteEnabled: root.favoriteControlsEnabled
            favorited: root.itemIsFavorited("audioOptions")
            onPressAndHoldRequested: root.openReorderPopup(reorderSectionName)
            onFavoriteToggleRequested: root.toggleFavoriteItem("audioOptions")

            MonitoringRow {
                width: parent.width
                title: "Record Audio"
                description: (typeof audioDeviceBridge !== "undefined" && audioDeviceBridge && !audioDeviceBridge.hasInputDevices)
                             ? "No audio input device detected"
                             : "Capture audio alongside recorded clips"
                enabled: root.settingsState
                         ? ((typeof audioDeviceBridge !== "undefined" && audioDeviceBridge && audioDeviceBridge.hasInputDevices)
                            ? root.settingsState.recordAudioEnabled
                            : false)
                         : false
                available: typeof audioDeviceBridge !== "undefined"
                           ? audioDeviceBridge.hasInputDevices
                           : false
                onToggleRequested: {
                    if (root.settingsState)
                        root.settingsState.recordAudioEnabled = !root.settingsState.recordAudioEnabled
                }
            }

            MonitoringRow {
                width: parent.width
                title: "Live Audio Monitoring"
                description: "Live Input audio monitoring"
                enabled: root.settingsState ? root.settingsState.liveAudioMonitoringEnabled : true
                onToggleRequested: {
                    if (root.settingsState)
                        root.settingsState.liveAudioMonitoringEnabled = !root.settingsState.liveAudioMonitoringEnabled
                }
            }

            MonitoringRow {
                width: parent.width
                title: "VU Meter"
                description: "Show an on-screen audio meter overlay"
                enabled: root.settingsState ? root.settingsState.audioMeterEnabled : false
                onToggleRequested: {
                    if (root.settingsState)
                        root.settingsState.audioMeterEnabled = !root.settingsState.audioMeterEnabled
                }
            }

            InlineDropdownField {
                width: parent.width
                label: "Input Device"
                value: typeof audioDeviceBridge !== "undefined"
                       ? audioDeviceBridge.resolvedInputDeviceLabel(
                             root.settingsState ? root.settingsState.audioInputDevice : "")
                       : "No audio input device detected"
                options: typeof audioDeviceBridge !== "undefined"
                         ? audioDeviceBridge.inputDeviceOptions
                         : []
                fieldEnabled: typeof audioDeviceBridge !== "undefined"
                              ? audioDeviceBridge.hasInputDevices
                              : false
                popupParent: dropdownOverlay
                dropdownController: sharedDropdownController
                openUpwards: true
                onValueSelected: function(v) {
                    if (root.settingsState)
                        root.settingsState.audioInputDevice = audioDeviceBridge.inputDeviceIdForLabel(v)
                }
            }

            InlineDropdownField {
                width: parent.width
                label: "Output Device"
                value: typeof audioDeviceBridge !== "undefined"
                       ? audioDeviceBridge.resolvedOutputDeviceLabel(
                             root.settingsState ? root.settingsState.audioOutputDevice : "")
                       : "No audio output device detected"
                options: typeof audioDeviceBridge !== "undefined"
                         ? audioDeviceBridge.outputDeviceOptions
                         : []
                fieldEnabled: typeof audioDeviceBridge !== "undefined"
                              ? audioDeviceBridge.hasOutputDevices
                              : false
                popupParent: dropdownOverlay
                dropdownController: sharedDropdownController
                openUpwards: true
                onValueSelected: function(v) {
                    if (root.settingsState)
                        root.settingsState.audioOutputDevice = audioDeviceBridge.outputDeviceIdForLabel(v)
                }
            }
        }
    }

    Component {
        id: audioLevelsComponent

        SystemSectionCard {
            property string reorderSectionName: "Audio"
            title: "Levels"
            titleIconSource: "qrc:/qml/icons/levels.png"
            description: "Adjust recording and monitoring volume"
            favoriteEnabled: root.favoriteControlsEnabled
            favorited: root.itemIsFavorited("levels")
            onPressAndHoldRequested: root.openReorderPopup(reorderSectionName)
            onFavoriteToggleRequested: root.toggleFavoriteItem("levels")

            AudioLevelCard {
                iconSource: "qrc:/qml/icons/microphone.png"
                mutedIconSource: "qrc:/qml/icons/microphone-muted.png"
                title: "Input Volume"
                description: "Microphone recording gain"
                level: root.settingsState ? root.settingsState.inputVolume : 60
                onLevelAdjusted: function(v) {
                    if (root.settingsState)
                        root.settingsState.inputVolume = v
                }
            }

            AudioLevelCard {
                iconSource: "qrc:/qml/icons/headphones.png"
                mutedIconSource: "qrc:/qml/icons/headphones-muted.png"
                title: "Headphone Volume"
                description: "Monitor output level"
                level: root.settingsState ? root.settingsState.headphoneVolume : 55
                onLevelAdjusted: function(v) {
                    if (root.settingsState)
                        root.settingsState.headphoneVolume = v
                }
            }
        }
    }

    Component {
        id: powerBatteryComponent

        SystemSectionCard {
            property string reorderSectionName: "System"
            title: "Battery"
            titleIconSource: "qrc:/qml/icons/power.png"
            description: "Battery capacity configuration"
            favoriteEnabled: root.favoriteControlsEnabled
            favorited: root.itemIsFavorited("battery")
            onPressAndHoldRequested: root.openReorderPopup(reorderSectionName)
            onFavoriteToggleRequested: root.toggleFavoriteItem("battery")

            InlineDropdownField {
                width: parent.width
                label: "Battery Capacity"
                value: root.settingsState ? root.settingsState.batteryCapacity : "150Wh"
                options: ["50Wh", "95Wh", "150Wh", "190Wh", "Custom"]
                fieldEnabled: root.vmountPowerPresent
                popupParent: dropdownOverlay
                dropdownController: sharedDropdownController
                onValueSelected: function(v) {
                    if (root.settingsState)
                        root.settingsState.batteryCapacity = v
                }
            }

            Text {
                width: parent.width
                visible: powerBridge.sensorAvailable && !root.vmountPowerPresent
                text: "Not available while using external input"
                color: "#ff5c5c"
                font.family: interMedium.font.family
                font.pixelSize: 13
                renderType: Text.NativeRendering
            }

            Rectangle {
                width: parent.width
                height: customBatteryColumn.implicitHeight + 24
                radius: 18
                color: "#171717"
                border.width: 1
                border.color: "#1affffff"
                visible: root.settingsState
                         && root.vmountPowerPresent
                         && root.settingsState.batteryCapacity === "Custom"

                Item {
                    anchors.fill: parent
                    anchors.margins: 12

                    Column {
                        id: customBatteryColumn
                        width: parent.width
                        spacing: 10

                        Text {
                            text: "Custom Capacity"
                            color: "#66ffffff"
                            font.family: interMedium.font.family
                            font.pixelSize: 11
                            font.capitalization: Font.AllUppercase
                            font.letterSpacing: 2.2
                            renderType: Text.NativeRendering
                        }

                        Rectangle {
                            width: parent.width
                            height: 72
                            radius: 14
                            color: "#18ffffff"
                            border.width: 1
                            border.color: "#1affffff"

                            Row {
                                anchors.fill: parent
                                anchors.margins: 12
                                spacing: 10

                                Rectangle {
                                    width: 42
                                    height: 42
                                    radius: 12
                                    anchors.verticalCenter: parent.verticalCenter
                                    color: minusCapacityArea.containsPress ? "#20ffffff" : "#1f000000"
                                    border.width: 1
                                    border.color: "#1affffff"
                                    scale: minusCapacityArea.containsPress ? 0.97 : 1.0

                                    Behavior on scale {
                                        NumberAnimation { duration: 120; easing.type: Easing.OutCubic }
                                    }

                                    Text {
                                        anchors.centerIn: parent
                                        text: "−"
                                        color: "white"
                                        font.family: interMedium.font.family
                                        font.pixelSize: 22
                                        renderType: Text.NativeRendering
                                    }

                                    MouseArea {
                                        id: minusCapacityArea
                                        anchors.fill: parent
                                        onClicked: root.adjustCustomBatteryWh(-5)
                                    }
                                }

                                Column {
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: parent.width - 104
                                    spacing: 2

                                    Text {
                                        text: root.settingsState ? (root.settingsState.customBatteryWh + "Wh") : "150Wh"
                                        color: "white"
                                        font.family: interBold.font.family
                                        font.pixelSize: 24
                                        horizontalAlignment: Text.AlignHCenter
                                        width: parent.width
                                        renderType: Text.NativeRendering
                                    }

                                    Text {
                                        text: "Battery Capacity"
                                        color: "#66ffffff"
                                        font.family: interMedium.font.family
                                        font.pixelSize: 11
                                        font.capitalization: Font.AllUppercase
                                        font.letterSpacing: 1.8
                                        horizontalAlignment: Text.AlignHCenter
                                        width: parent.width
                                        renderType: Text.NativeRendering
                                    }
                                }

                                Rectangle {
                                    width: 42
                                    height: 42
                                    radius: 12
                                    anchors.verticalCenter: parent.verticalCenter
                                    color: plusCapacityArea.containsPress ? "#20ffffff" : "#1f000000"
                                    border.width: 1
                                    border.color: "#1affffff"
                                    scale: plusCapacityArea.containsPress ? 0.97 : 1.0

                                    Behavior on scale {
                                        NumberAnimation { duration: 120; easing.type: Easing.OutCubic }
                                    }

                                    Text {
                                        anchors.centerIn: parent
                                        text: "+"
                                        color: "white"
                                        font.family: interMedium.font.family
                                        font.pixelSize: 22
                                        renderType: Text.NativeRendering
                                    }

                                    MouseArea {
                                        id: plusCapacityArea
                                        anchors.fill: parent
                                        onClicked: root.adjustCustomBatteryWh(5)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Component {
        id: powerBatteryInfoComponent

        SystemSectionCard {
            property string reorderSectionName: "System"
            title: "Battery Info"
            titleIconSource: "qrc:/qml/icons/info.png"
            description: "Live battery information"
            favoriteEnabled: root.favoriteControlsEnabled
            favorited: root.itemIsFavorited("batteryInfo")
            onPressAndHoldRequested: root.openReorderPopup(reorderSectionName)
            onFavoriteToggleRequested: root.toggleFavoriteItem("batteryInfo")

            Rectangle {
                width: parent.width
                height: 100
                radius: 18
                color: "#171717"
                border.width: 1
                border.color: "#1affffff"

                Item {
                    anchors.fill: parent
                    anchors.margins: 16

                    Column {
                        anchors.fill: parent
                        spacing: 4

                        Text {
                            text: "Voltage / Current"
                            color: "#66ffffff"
                            font.family: interMedium.font.family
                            font.pixelSize: 11
                            font.capitalization: Font.AllUppercase
                            font.letterSpacing: 2.2
                            renderType: Text.NativeRendering
                        }

                        Text {
                            text: !powerBridge.sensorAvailable
                                  ? "INA219 Unavailable"
                                  : (!root.vmountPowerPresent
                                     ? "External Input"
                                     : (root.batteryVoltageText
                                        + " • "
                                        + root.batteryCurrentText
                                        + " • "
                                        + powerBridge.batteryPercentText))
                            color: "white"
                            font.family: interBold.font.family
                            font.pixelSize: 18
                            renderType: Text.NativeRendering
                        }

                        Text {
                            text: !powerBridge.sensorAvailable
                                  ? "Check ~/apertar-hardware.conf and INA219 wiring"
                                  : (!root.vmountPowerPresent
                                     ? "DC INPUT active"
                                     : (root.batteryPowerDrawText + " • " + root.estimatedBatteryRuntimeText()))
                            color: "#8cffffff"
                            font.family: interRegular.font.family
                            font.pixelSize: root.settingsHintSize
                            renderType: Text.NativeRendering
                        }
                    }
                }
            }
        }
    }

    Component {
        id: powerAutoPowerOffComponent

        SystemSectionCard {
            property string reorderSectionName: "System"
            title: "Auto Power Off"
            titleIconSource: "qrc:/qml/icons/auto-power-off.png"
            description: "Automatically shut down after inactivity"
            favoriteEnabled: root.favoriteControlsEnabled
            favorited: root.itemIsFavorited("autoPowerOff")
            onPressAndHoldRequested: root.openReorderPopup(reorderSectionName)
            onFavoriteToggleRequested: root.toggleFavoriteItem("autoPowerOff")

            InlineDropdownField {
                width: parent.width
                label: "Power Off"
                value: root.settingsState ? root.settingsState.sleepMode : "Off"
                options: ["Off", "1 min", "2 min", "5 min", "10 min"]
                popupParent: dropdownOverlay
                dropdownController: sharedDropdownController
                openUpwards: true
                onValueSelected: function(v) {
                    if (root.settingsState)
                        root.settingsState.sleepMode = v
                }
            }
        }
    }

    Component {
        id: systemUiOrientationComponent

        SystemSectionCard {
            property string reorderSectionName: "System"
            title: "UI Orientation"
            titleIconSource: "qrc:/qml/icons/orientation.png"
            description: "Rotate the full DPI interface and live preview"
            favoriteEnabled: root.favoriteControlsEnabled
            favorited: root.itemIsFavorited("uiOrientation")
            onPressAndHoldRequested: root.openReorderPopup(reorderSectionName)
            onFavoriteToggleRequested: root.toggleFavoriteItem("uiOrientation")

            InlineDropdownField {
                width: parent.width
                label: "Orientation"
                value: root.settingsState ? root.settingsState.uiOrientation : "Landscape"
                options: ["Landscape", "Left Side", "Right Side", "Upside Down"]
                popupParent: dropdownOverlay
                dropdownController: sharedDropdownController
                onValueSelected: function(v) {
                    if (root.settingsState)
                        root.settingsState.uiOrientation = v
                }
            }
        }
    }

    Component {
        id: systemControlsOpacityComponent

        SystemSectionCard {
            property string reorderSectionName: "System"
            title: "Controls Transparency"
            titleIconSource: "qrc:/qml/icons/settings.png"
            description: "Fade the main camera page controls for cleaner monitoring"
            favoriteEnabled: root.favoriteControlsEnabled
            favorited: root.itemIsFavorited("cameraControlsOpacity")
            onPressAndHoldRequested: root.openReorderPopup(reorderSectionName)
            onFavoriteToggleRequested: root.toggleFavoriteItem("cameraControlsOpacity")

            Column {
                width: parent.width
                spacing: 12

                InlineDropdownField {
                    width: parent.width
                    label: "Opacity"
                    value: root.opacityValueToLabel(root.settingsState ? root.settingsState.cameraControlsOpacity : 1.0)
                    options: root.controlsOpacityOptions
                    popupParent: dropdownOverlay
                    dropdownController: sharedDropdownController
                    onValueSelected: function(v) {
                        if (root.settingsState)
                            root.settingsState.cameraControlsOpacity = root.opacityLabelToValue(v)
                    }
                }

                InlineDropdownField {
                    width: parent.width
                    label: "Controls"
                    value: root.settingsState ? root.settingsState.cameraControlsMode : "Light"
                    options: root.controlsModeOptions
                    popupParent: dropdownOverlay
                    dropdownController: sharedDropdownController
                    onValueSelected: function(v) {
                        if (root.settingsState)
                            root.settingsState.cameraControlsMode = v
                    }
                }
            }
        }
    }

    Component {
        id: systemDateTimeComponent

        SystemSectionCard {
            property string reorderSectionName: "System"
            title: "Date & Time"
            titleIconSource: "qrc:/qml/icons/time-date.png"
            description: "Set local time and date for clips and metadata"
            favoriteEnabled: root.favoriteControlsEnabled
            favorited: root.itemIsFavorited("dateTime")
            onPressAndHoldRequested: root.openReorderPopup(reorderSectionName)
            onFavoriteToggleRequested: root.toggleFavoriteItem("dateTime")

            Rectangle {
                width: parent.width
	                height: dateTimePanelBody.implicitHeight + (root.largeLandscapeLayout ? 56 : (root.standardLandscapeLayout ? 40 : 32))
	                radius: root.largeLandscapeLayout ? 30 : (root.standardLandscapeLayout ? 24 : 22)
                color: "#18ffffff"
                border.width: 1
                border.color: "#1affffff"

                Item {
                    anchors.fill: parent
	                    anchors.margins: root.largeLandscapeLayout ? 28 : (root.standardLandscapeLayout ? 20 : 16)

                        Column {
                            id: dateTimePanelBody
                            width: parent.width
	                            spacing: root.largeLandscapeLayout ? 28 : (root.standardLandscapeLayout ? 20 : 16)

                            InlineDropdownField {
                                width: parent.width
                                label: "Timezone"
                                value: root.systemTimezone
                                options: root.systemTimezoneOptions
                                popupParent: dropdownOverlay
                                dropdownController: sharedDropdownController
                                onValueSelected: function(v) {
                                    root.applySystemTimeZoneSelection(v)
                                }
                            }

                            Column {
                                width: parent.width
                                spacing: 4

                            Text {
                                text: "Date"
                                color: "#66ffffff"
                                font.family: interMedium.font.family
	                                font.pixelSize: root.largeLandscapeLayout ? 17 : (root.standardLandscapeLayout ? 13 : 11)
	                                font.capitalization: Font.AllUppercase
	                                font.letterSpacing: root.largeLandscapeLayout ? 3.5 : (root.standardLandscapeLayout ? 2.8 : 2.4)
                                renderType: Text.NativeRendering
                            }

                            Text {
                                text: String(root.systemYear)
                                      + "-" + root.twoDigits(root.systemMonth)
                                      + "-" + root.twoDigits(root.systemDay)
                                color: "white"
                                font.family: interBold.font.family
	                                font.pixelSize: root.largeLandscapeLayout ? 40 : (root.standardLandscapeLayout ? 30 : 26)
                                renderType: Text.NativeRendering
                            }
                        }

                        Column {
                            id: dateAdjustGrid
                            width: parent.width
	                            spacing: root.largeLandscapeLayout ? 18 : (root.standardLandscapeLayout ? 12 : 10)

                            AdjustNumberTile {
                                width: dateAdjustGrid.width
                                label: "Year"
                                value: String(root.systemYear)
                                onDecrementRequested: root.adjustSystemNumber("systemYear", -1, 2024, 2035)
                                onIncrementRequested: root.adjustSystemNumber("systemYear", 1, 2024, 2035)
                            }

                            AdjustNumberTile {
                                width: dateAdjustGrid.width
                                label: "Month"
                                value: root.twoDigits(root.systemMonth)
                                onDecrementRequested: root.adjustSystemNumber("systemMonth", -1, 1, 12)
                                onIncrementRequested: root.adjustSystemNumber("systemMonth", 1, 1, 12)
                            }

                            AdjustNumberTile {
                                width: dateAdjustGrid.width
                                label: "Day"
                                value: root.twoDigits(root.systemDay)
                                onDecrementRequested: root.adjustSystemNumber("systemDay", -1, 1, 31)
                                onIncrementRequested: root.adjustSystemNumber("systemDay", 1, 1, 31)
                            }
                        }

                        Column {
                            width: parent.width
	                            spacing: root.largeLandscapeLayout ? 8 : (root.standardLandscapeLayout ? 5 : 4)

                            Text {
                                text: "Time"
                                color: "#66ffffff"
                                font.family: interMedium.font.family
	                                font.pixelSize: root.largeLandscapeLayout ? 17 : (root.standardLandscapeLayout ? 13 : 11)
	                                font.capitalization: Font.AllUppercase
	                                font.letterSpacing: root.largeLandscapeLayout ? 3.5 : (root.standardLandscapeLayout ? 2.8 : 2.4)
                                renderType: Text.NativeRendering
                            }

                            Text {
                                text: root.twoDigits(root.systemHour)
                                      + ":" + root.twoDigits(root.systemMinute)
                                color: "white"
                                font.family: interBold.font.family
	                                font.pixelSize: root.largeLandscapeLayout ? 40 : (root.standardLandscapeLayout ? 30 : 26)
                                renderType: Text.NativeRendering
                            }
                        }

                        Column {
                            width: parent.width
	                            spacing: root.largeLandscapeLayout ? 18 : (root.standardLandscapeLayout ? 12 : 10)

                            AdjustNumberTile {
                                width: parent.width
                                label: "Hour"
                                value: root.twoDigits(root.systemHour)
                                onDecrementRequested: root.adjustSystemNumber("systemHour", -1, 0, 23)
                                onIncrementRequested: root.adjustSystemNumber("systemHour", 1, 0, 23)
                            }

                            AdjustNumberTile {
                                width: parent.width
                                label: "Minute"
                                value: root.twoDigits(root.systemMinute)
                                onDecrementRequested: root.adjustSystemNumber("systemMinute", -1, 0, 59)
                                onIncrementRequested: root.adjustSystemNumber("systemMinute", 1, 0, 59)
                            }
                        }
                    }
                }
            }

            Rectangle {
                width: parent.width
	                height: root.largeLandscapeLayout ? 118 : (root.standardLandscapeLayout ? 88 : 76)
	                radius: root.largeLandscapeLayout ? 26 : (root.standardLandscapeLayout ? 20 : 18)
                color: "#14ffffff"
                border.width: 1
                border.color: "#1affffff"

                Item {
                    anchors.fill: parent
	                    anchors.leftMargin: root.largeLandscapeLayout ? 30 : (root.standardLandscapeLayout ? 22 : 18)
	                    anchors.rightMargin: root.largeLandscapeLayout ? 26 : (root.standardLandscapeLayout ? 18 : 16)

                    Column {
                        anchors.left: parent.left
                        anchors.right: dateTimeOverlayToggle.left
                        anchors.rightMargin: root.largeLandscapeLayout ? 26 : 18
                        anchors.verticalCenter: parent.verticalCenter
	                        spacing: root.largeLandscapeLayout ? 8 : (root.standardLandscapeLayout ? 6 : 5)

                        Text {
                            width: parent.width
                            text: "Show on Camera Page"
                            color: "white"
                            font.family: interBold.font.family
	                            font.pixelSize: root.largeLandscapeLayout ? 27 : (root.standardLandscapeLayout ? 20 : 16)
                            renderType: Text.NativeRendering
                            elide: Text.ElideRight
                        }

                        Text {
                            width: parent.width
                            text: "Display date and time on camera page"
                            color: "#8cffffff"
                            font.family: interRegular.font.family
	                            font.pixelSize: root.largeLandscapeLayout ? 19 : (root.standardLandscapeLayout ? 14 : 12)
                            renderType: Text.NativeRendering
                            elide: Text.ElideRight
                        }
                    }

                    TogglePill {
                        id: dateTimeOverlayToggle
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        checked: root.settingsState ? root.settingsState.dateTimeOverlayEnabled : false
                        onToggled: {
                            if (root.settingsState)
                                root.settingsState.dateTimeOverlayEnabled = checked
                        }
                    }

                    MouseArea {
                        anchors.left: parent.left
                        anchors.right: dateTimeOverlayToggle.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        onClicked: {
                            if (root.settingsState)
                                root.settingsState.dateTimeOverlayEnabled = !root.settingsState.dateTimeOverlayEnabled
                        }
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 56
                radius: 18
                color: applyDateTimeArea.containsPress ? "#20ffffff" : "#14ffffff"
                border.width: 1
                border.color: "#1affffff"
                scale: applyDateTimeArea.containsPress ? 0.985 : 1.0

                Behavior on scale {
                    NumberAnimation { duration: 140; easing.type: Easing.OutCubic }
                }

                Text {
                    anchors.centerIn: parent
                    text: "Apply Date & Time"
                    color: "white"
                    font.family: interMedium.font.family
                    font.pixelSize: 16
                    renderType: Text.NativeRendering
                }

                MouseArea {
                    id: applyDateTimeArea
                    anchors.fill: parent
                    onClicked: root.executeApplyDateTime()
                }
            }
        }
    }

    Component {
        id: systemMediaComponent

        SystemSectionCard {
            property string reorderSectionName: "Power"
            title: "Media"
            titleIconSource: "qrc:/qml/icons/media.png"
            description: "Manage and prepare recording media"
            favoriteEnabled: root.favoriteControlsEnabled
            favorited: root.itemIsFavorited("media")
            onPressAndHoldRequested: root.openReorderPopup(reorderSectionName)
            onFavoriteToggleRequested: root.toggleFavoriteItem("media")

            Rectangle {
                width: parent.width
	                height: root.largeLandscapeLayout ? 232 : (root.standardLandscapeLayout ? 174 : 150)
	                radius: root.largeLandscapeLayout ? 26 : (root.standardLandscapeLayout ? 20 : 18)
                color: "#171717"
                border.width: 1
                border.color: "#1affffff"

                Item {
                    anchors.fill: parent
	                    anchors.margins: root.largeLandscapeLayout ? 24 : (root.standardLandscapeLayout ? 18 : 16)

                    Column {
                        anchors.fill: parent
	                        spacing: root.largeLandscapeLayout ? 16 : (root.standardLandscapeLayout ? 12 : 10)

                        Row {
                            width: parent.width

                            Text {
                                text: "Storage"
                                color: "#66ffffff"
                                font.family: interMedium.font.family
	                                font.pixelSize: root.largeLandscapeLayout ? 16 : (root.standardLandscapeLayout ? 12 : 11)
                                font.capitalization: Font.AllUppercase
                                font.letterSpacing: 2.0
                                renderType: Text.NativeRendering
                            }
                        }

                        Text {
                            text: mediaBridge.mediaMounted
                                  ? (root.formatDataSize(mediaBridge.freeBytes) + " Free")
                                  : "No Media Mounted"
                            color: "white"
                            font.family: interBold.font.family
	                                font.pixelSize: root.largeLandscapeLayout ? 32 : (root.standardLandscapeLayout ? 24 : 20)
                            renderType: Text.NativeRendering
                        }

                        Text {
                            text: mediaBridge.mediaMounted
                                  ? ("of " + root.formatDataSize(mediaBridge.totalBytes)
                                     + " total • Estimated "
                                     + mediaBridge.remainingMinutesText
                                     + " remaining")
                                  : "Mount /media/RAW to manage media"
                            color: "#8cffffff"
                            font.family: interRegular.font.family
                            font.pixelSize: root.settingsHintSize
                            wrapMode: Text.WordWrap
                            width: parent.width
                            renderType: Text.NativeRendering
                        }

                        Rectangle {
                            width: parent.width
	                            height: root.largeLandscapeLayout ? 16 : (root.standardLandscapeLayout ? 12 : 10)
	                            radius: height / 2
                            color: "#1a1a1a"
                            border.width: 1
                            border.color: "#1affffff"

                            Rectangle {
                                width: parent.width * root.mediaUsedRatio()
                                height: parent.height
                                radius: parent.radius
                                color: "#d7d9de"
                            }
                        }

                        Row {
                            width: parent.width

                            Text {
                                text: "Used " + root.formatDataSize(root.mediaUsedBytes())
                                color: "#66ffffff"
                                font.family: interMedium.font.family
	                                font.pixelSize: root.largeLandscapeLayout ? 16 : (root.standardLandscapeLayout ? 12 : 11)
                                font.capitalization: Font.AllUppercase
                                font.letterSpacing: 1.8
                                renderType: Text.NativeRendering
                            }
                        }
                    }
                }
            }

            Rectangle {
                width: parent.width
	                height: root.largeLandscapeLayout ? 218 : (root.standardLandscapeLayout ? 164 : 128)
	                radius: root.largeLandscapeLayout ? 26 : (root.standardLandscapeLayout ? 20 : 18)
                color: "#171717"
                border.width: 1
                border.color: "#1affffff"
                opacity: mediaBridge.mediaMounted ? 0.48 : 1.0

                Item {
                    anchors.fill: parent
	                    anchors.margins: root.largeLandscapeLayout ? 22 : (root.standardLandscapeLayout ? 16 : 14)

                    Column {
                        width: parent.width
	                        spacing: root.largeLandscapeLayout ? 18 : (root.standardLandscapeLayout ? 12 : 10)

                        InlineDropdownField {
                            width: parent.width
                            label: "Mount Drive"
                            value: root.selectedMediaDriveDisplay()
                            options: mediaBridge.mountableDriveOptions.length > 0
                                     ? mediaBridge.mountableDriveOptions
                                     : ["No available drives"]
                            fieldEnabled: !mediaBridge.mediaMounted
                                          && mediaBridge.mountableDriveOptions.length > 0
                            popupParent: dropdownOverlay
                            dropdownController: sharedDropdownController
                            onValueSelected: function(v) {
                                root.selectedMediaDriveOption = v
                            }
                        }

                        Text {
                            width: parent.width
                            text: mediaBridge.mediaMounted
                                  ? "Eject current media before mounting another drive."
                                  : "Supports exFAT, FAT32, NTFS, and other Linux-supported filesystems."
                            color: "#8cffffff"
                            font.family: interRegular.font.family
	                            font.pixelSize: root.largeLandscapeLayout ? 19 : (root.standardLandscapeLayout ? 14 : 13)
                            wrapMode: Text.WordWrap
                            renderType: Text.NativeRendering
                        }
                    }
                }
            }

            Grid {
                id: mediaMountGrid
                width: parent.width
                columns: 2
                columnSpacing: 12
                rowSpacing: 12

                ActionTile {
                    width: (mediaMountGrid.width - 12) / 2
                    label: "Refresh Drives"
                    onClicked: mediaBridge.refreshMountableDrives()
                }

                ActionTile {
                    width: (mediaMountGrid.width - 12) / 2
                    label: "Mount Selected"
                    actionEnabled: !mediaBridge.mediaMounted
                                  && mediaBridge.mountableDriveOptions.length > 0
                    onClicked: root.executeMountSelectedDrive()
                }
            }

            ActionTile {
                width: parent.width
                label: "Eject Media"
                actionEnabled: mediaBridge.mediaMounted
                onClicked: root.openEjectConfirmation()
            }
        }
    }

    Component {
        id: systemFormatMediaComponent

        SystemSectionCard {
            property string reorderSectionName: "Power"
            title: "Format Media"
            titleIconSource: "qrc:/qml/icons/media.png"
            description: "Choose a filesystem and prepare mounted media"
            favoriteEnabled: root.favoriteControlsEnabled
            favorited: root.itemIsFavorited("formatMedia")
            onPressAndHoldRequested: root.openReorderPopup(reorderSectionName)
            onFavoriteToggleRequested: root.toggleFavoriteItem("formatMedia")

            Rectangle {
                width: parent.width
                height: root.largeLandscapeLayout ? (formatMediaColumn.implicitHeight + 46) : (root.standardLandscapeLayout ? (formatMediaColumn.implicitHeight + 34) : (root.compactLandscapeLayout ? 172 : 210))
                radius: root.largeLandscapeLayout ? 26 : (root.standardLandscapeLayout ? 20 : (root.compactLandscapeLayout ? 16 : 18))
                color: "#171717"
                border.width: 1
                border.color: "#26ff6b6b"
                opacity: mediaBridge.mediaMounted ? 1.0 : 0.48

                Item {
                    anchors.fill: parent
                    anchors.margins: root.largeLandscapeLayout ? 20 : (root.standardLandscapeLayout ? 14 : (root.compactLandscapeLayout ? 10 : 12))

                    Column {
                        id: formatMediaColumn
                        width: parent.width
                        spacing: root.largeLandscapeLayout ? 15 : (root.standardLandscapeLayout ? 10 : (root.compactLandscapeLayout ? 7 : 8))

                        InlineDropdownField {
                            width: parent.width
                            label: "Format As"
                            value: root.selectedMediaFormatOption
                            options: root.mediaFormatOptions
                            fieldEnabled: mediaBridge.mediaMounted
                            popupParent: dropdownOverlay
                            dropdownController: sharedDropdownController
                            onValueSelected: function(v) {
                                root.selectedMediaFormatOption = v
                            }
                        }

                        Text {
                            width: parent.width
                            text: mediaBridge.mediaMounted
                                  ? "Keeps the current drive name/label when possible, then remounts it for Apertar."
                                  : "Mount media before formatting."
                            color: "#8cffffff"
                            font.family: interRegular.font.family
                            font.pixelSize: root.largeLandscapeLayout ? 19 : (root.standardLandscapeLayout ? 14 : (root.compactLandscapeLayout ? 11 : 13))
                            wrapMode: Text.WordWrap
                            renderType: Text.NativeRendering
                        }

                        ActionTile {
                            width: parent.width
                            label: "Format Media"
                            tone: "danger"
                            actionEnabled: mediaBridge.mediaMounted
                            holdToActivate: true
                            holdDuration: 950
                            holdLabel: "Hold..."
                            onClicked: root.openFormatConfirmation()
                        }
                    }
                }
            }
        }
    }

    Component {
        id: systemMediaSpeedComponent

        SystemSectionCard {
            property string reorderSectionName: "Power"
            title: "Media Speed"
            titleIconSource: "qrc:/qml/icons/media-speed.png"
            description: mediaBridge.mediaMounted
                         ? ("Measure sequential write performance for the mounted "
                            + mediaBridge.mediaPromptLabel)
                         : "Measure sequential write performance for the mounted media"
            favoriteEnabled: root.favoriteControlsEnabled
            favorited: root.itemIsFavorited("mediaSpeed")
            onPressAndHoldRequested: root.openReorderPopup(reorderSectionName)
            onFavoriteToggleRequested: root.toggleFavoriteItem("mediaSpeed")

            Rectangle {
                width: parent.width
                height: root.largeLandscapeLayout ? 214 : 156
                radius: root.largeLandscapeLayout ? 26 : 18
                color: "#171717"
                border.width: 1
                border.color: "#1affffff"

                Item {
                    anchors.fill: parent
                    anchors.margins: root.largeLandscapeLayout ? 24 : 16

                    Column {
                        anchors.fill: parent
                        spacing: root.largeLandscapeLayout ? 16 : 10

                        Text {
                            text: "Write Test"
                            color: "#66ffffff"
                            font.family: interMedium.font.family
                            font.pixelSize: root.largeLandscapeLayout ? 16 : 11
                            font.capitalization: Font.AllUppercase
                            font.letterSpacing: 2.0
                            renderType: Text.NativeRendering
                        }

                        Text {
                            text: mediaBridge.writeSpeedResultText
                            color: "white"
                            font.family: interBold.font.family
                            font.pixelSize: root.largeLandscapeLayout ? 38 : 28
                            renderType: Text.NativeRendering
                        }

                        Text {
                            text: mediaBridge.writeSpeedDetailText
                            color: "#8cffffff"
                            font.family: interRegular.font.family
                            font.pixelSize: root.largeLandscapeLayout ? 19 : (root.standardLandscapeLayout ? 14 : 13)
                            wrapMode: Text.WordWrap
                            width: parent.width
                            renderType: Text.NativeRendering
                        }

                        Item {
                            width: parent.width
                            height: root.largeLandscapeLayout ? 38 : 28

                            Rectangle {
                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                height: root.largeLandscapeLayout ? 14 : 10
                                radius: height / 2
                                color: "#111111"
                                border.width: 1
                                border.color: "#1affffff"
                                opacity: mediaBridge.writeSpeedTestRunning ? 1.0 : 0.55
                                clip: true

                                Rectangle {
                                    id: speedTestPulse
                                    width: root.largeLandscapeLayout ? 118 : 88
                                    height: parent.height
                                    radius: parent.radius
                                    color: "#d7d9de"
                                    opacity: mediaBridge.writeSpeedTestRunning ? 0.9 : 0.0
                                    x: -width
                                }

                                NumberAnimation {
                                    id: speedTestPulseAnim
                                    target: speedTestPulse
                                    property: "x"
                                    from: -speedTestPulse.width
                                    to: parent.width
                                    duration: 1100
                                    loops: Animation.Infinite
                                    running: mediaBridge.writeSpeedTestRunning
                                }
                            }
                        }
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: root.largeLandscapeLayout ? 92 : 70
                radius: root.largeLandscapeLayout ? 24 : 18
                color: runSpeedTestArea.containsPress && runSpeedTestArea.enabled
                       ? "#20ffffff"
                       : "#171717"
                border.width: 1
                border.color: "#1affffff"
                opacity: mediaBridge.mediaMounted ? 1.0 : 0.45
                scale: runSpeedTestArea.containsPress && runSpeedTestArea.enabled ? 0.985 : 1.0

                Behavior on scale {
                    NumberAnimation { duration: 140; easing.type: Easing.OutCubic }
                }

                Text {
                    anchors.centerIn: parent
                    text: mediaBridge.writeSpeedTestRunning ? "Testing..." : "Run Speed Test"
                    color: "white"
                    font.family: interMedium.font.family
                    font.pixelSize: root.largeLandscapeLayout ? 23 : 16
                    renderType: Text.NativeRendering
                }

                MouseArea {
                    id: runSpeedTestArea
                    anchors.fill: parent
                    enabled: mediaBridge.mediaMounted && !mediaBridge.writeSpeedTestRunning
                    onClicked: mediaBridge.startWriteSpeedTest()
                }
            }
        }
    }

    Component {
        id: systemThermalComponent

        SystemSectionCard {
            property string reorderSectionName: "System"
            title: "Thermal"
            titleIconSource: "qrc:/qml/icons/thermal.png"
            description: root.fanModeSupported
                         ? "Fan control and temperature management"
                         : "Temperature monitoring. Fan mode is unavailable on Raspberry Pi 4."
            opacity: root.fanModeSupported ? 1.0 : 0.42
            favoriteEnabled: root.favoriteControlsEnabled
            favorited: root.itemIsFavorited("thermal")
            onPressAndHoldRequested: root.openReorderPopup(reorderSectionName)
            onFavoriteToggleRequested: root.toggleFavoriteItem("thermal")

            Behavior on opacity {
                NumberAnimation { duration: 160; easing.type: Easing.OutCubic }
            }

            Row {
                width: parent.width
                spacing: 8

                Text {
                    text: "\u2022"
                    color: "#66ffffff"
                    font.family: interBold.font.family
                    font.pixelSize: 14
                    renderType: Text.NativeRendering
                }

                Text {
                    text: "CPU " + Math.round(statsBridge.socTempC) + "°C"
                    color: "#66ffffff"
                    font.family: interMedium.font.family
                    font.pixelSize: 11
                    font.capitalization: Font.AllUppercase
                    font.letterSpacing: 2.0
                    renderType: Text.NativeRendering
                }
            }

            InlineDropdownField {
                width: parent.width
                label: "Fan Mode"
                value: systemActionBridge.fanMode
                options: ["Silent", "Auto", "Full Blast"]
                fieldEnabled: root.fanModeSupported
                popupParent: dropdownOverlay
                dropdownController: sharedDropdownController
                onValueSelected: function(v) {
                    root.executeApplyFanMode(v)
                }
            }
        }
    }

    Component {
        id: systemPowerActionsComponent

        SystemSectionCard {
            property string reorderSectionName: "System"
            title: "Power Actions"
            titleIconSource: "qrc:/qml/icons/shutdown.png"
            description: "Safe device control actions"
            favoriteEnabled: root.favoriteControlsEnabled
            favorited: root.itemIsFavorited("powerActions")
            onPressAndHoldRequested: root.openReorderPopup(reorderSectionName)
            onFavoriteToggleRequested: root.toggleFavoriteItem("powerActions")

            Grid {
                id: powerActionGrid
                width: parent.width
                columns: 2
                columnSpacing: 12
                rowSpacing: 12

                ActionTile {
                    width: (powerActionGrid.width - 12) / 2
                    label: "Restart Camera"
                    onClicked: root.openPowerConfirmation("restart")
                }

                ActionTile {
                    width: (powerActionGrid.width - 12) / 2
                    label: "Shutdown"
                    tone: "danger"
                    onClicked: root.openPowerConfirmation("shutdown")
                }
            }
        }
    }

    Component {
        id: wifiToggleComponent

        MonitoringRow {
            property string reorderSectionName: "Wi-Fi"
            title: "Wi-Fi"
            titleIconSource: wifiBridge.wifiEnabled
                             ? "qrc:/qml/icons/wifi.png"
                             : "qrc:/qml/icons/wifioff.png"
            description: "Turn wireless networking on or off"
            enabled: wifiBridge.wifiEnabled
            centerToggleVertically: true
            favoriteEnabled: root.favoriteControlsEnabled
            favorited: root.itemIsFavorited("wifiToggle")
            onPressAndHoldRequested: root.openReorderPopup(reorderSectionName)
            onFavoriteToggleRequested: root.toggleFavoriteItem("wifiToggle")
            onToggleRequested: wifiBridge.setWifiEnabled(!wifiBridge.wifiEnabled)
        }
    }

    Component {
        id: wifiCurrentNetworkComponent

        SystemSectionCard {
            property string reorderSectionName: "Wi-Fi"
            title: "Current Network"
            titleIconSource: ""
            description: "Check connection status and manage the wireless link"
            opacity: wifiBridge.wifiEnabled ? 1.0 : 0.42
            favoriteEnabled: root.favoriteControlsEnabled
            favorited: root.itemIsFavorited("currentNetwork")
            onPressAndHoldRequested: root.openReorderPopup(reorderSectionName)
            onFavoriteToggleRequested: root.toggleFavoriteItem("currentNetwork")

            Behavior on opacity {
                NumberAnimation { duration: 160; easing.type: Easing.OutCubic }
            }

            Rectangle {
                width: parent.width
	                height: root.currentWifiNetwork() || wifiBridge.currentSsid.length > 0 ? (root.largeLandscapeLayout ? 142 : (root.standardLandscapeLayout ? 106 : 92)) : (root.largeLandscapeLayout ? 210 : (root.standardLandscapeLayout ? 158 : 138))
	                radius: root.largeLandscapeLayout ? 26 : (root.standardLandscapeLayout ? 20 : 18)
                color: "#171717"
                border.width: 1
                border.color: "#1affffff"

                Item {
                    anchors.fill: parent
	                    anchors.margins: root.largeLandscapeLayout ? 20 : (root.standardLandscapeLayout ? 14 : 12)

                    Rectangle {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
	                        height: root.currentWifiNetwork() || wifiBridge.currentSsid.length > 0 ? (root.largeLandscapeLayout ? 104 : (root.standardLandscapeLayout ? 78 : 68)) : (root.largeLandscapeLayout ? 172 : (root.standardLandscapeLayout ? 130 : 114))
	                        radius: root.largeLandscapeLayout ? 24 : (root.standardLandscapeLayout ? 18 : 16)
                        color: root.currentWifiNetwork() || wifiBridge.currentSsid.length > 0 ? "#1f2c36" : "#141414"
                        border.width: 1
                        border.color: root.currentWifiNetwork() || wifiBridge.currentSsid.length > 0 ? "#3fd0ff" : "#1affffff"

                        Item {
                            anchors.fill: parent
	                            anchors.margins: root.largeLandscapeLayout ? 22 : (root.standardLandscapeLayout ? 16 : 14)

                            Column {
                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
	                                spacing: root.largeLandscapeLayout ? 8 : (root.standardLandscapeLayout ? 5 : 4)

                                Text {
                                    text: wifiBridge.currentSsid.length > 0
                                          ? wifiBridge.currentSsid
                                          : wifiBridge.statusText
                                    color: "white"
                                    font.family: interBold.font.family
		                                    font.pixelSize: root.largeLandscapeLayout ? 29 : (root.standardLandscapeLayout ? 21 : 18)
                                    elide: Text.ElideRight
                                    renderType: Text.NativeRendering
                                }

                                Text {
                                    text: root.currentWifiDetailText()
                                    color: "#8cffffff"
                                    font.family: interRegular.font.family
		                                    font.pixelSize: root.largeLandscapeLayout ? 20 : (root.standardLandscapeLayout ? 15 : 13)
                                    width: parent.width
                                    wrapMode: Text.WordWrap
                                    renderType: Text.NativeRendering
                                }
                            }
                        }
                    }

                    Text {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        visible: wifiBridge.lastError.length > 0
                        text: wifiBridge.lastError
                        color: "#ff9b9b"
                        font.family: interRegular.font.family
	                        font.pixelSize: root.largeLandscapeLayout ? 19 : (root.standardLandscapeLayout ? 14 : 13)
                        wrapMode: Text.WordWrap
                        renderType: Text.NativeRendering
                    }
                }
            }

            Grid {
                width: parent.width
                columns: 2
                columnSpacing: 12
                rowSpacing: 12

                ActionTile {
                    width: (parent.width - 12) / 2
                    label: wifiBridge.scanning ? "Scanning..." : "Refresh"
                    actionEnabled: wifiBridge.wifiEnabled && !wifiBridge.scanning && !wifiBridge.connecting
                    onClicked: wifiBridge.refresh()
                }

                ActionTile {
                    width: (parent.width - 12) / 2
                    label: wifiBridge.connecting ? "Working..." : "Disconnect"
                    actionEnabled: wifiBridge.wifiEnabled
                                   && wifiBridge.currentSsid.length > 0
                                   && !wifiBridge.connecting
                                   && !wifiBridge.scanning
                    onClicked: wifiBridge.disconnectCurrent()
                }
            }
        }
    }

    Component {
        id: wifiHotspotComponent

        SystemSectionCard {
            property string reorderSectionName: "Wi-Fi"
            title: "Hotspot"
            titleIconSource: "qrc:/qml/icons/hotspot.png"
            description: "Create a local camera network when no Wi-Fi is available"
            opacity: wifiBridge.wifiEnabled ? 1.0 : 0.42
            favoriteEnabled: root.favoriteControlsEnabled
            favorited: root.itemIsFavorited("hotspot")
            onPressAndHoldRequested: root.openReorderPopup(reorderSectionName)
            onFavoriteToggleRequested: root.toggleFavoriteItem("hotspot")

            Behavior on opacity {
                NumberAnimation { duration: 160; easing.type: Easing.OutCubic }
            }

            Rectangle {
                width: parent.width
	                height: root.largeLandscapeLayout ? 132 : (root.standardLandscapeLayout ? 98 : 82)
	                radius: root.largeLandscapeLayout ? 26 : (root.standardLandscapeLayout ? 20 : 18)
                color: wifiBridge.hotspotActive ? "#1f2c36" : "#171717"
                border.width: 1
                border.color: wifiBridge.hotspotActive ? "#3fd0ff" : "#1affffff"

                Item {
                    anchors.fill: parent
	                    anchors.margins: root.largeLandscapeLayout ? 22 : (root.standardLandscapeLayout ? 16 : 14)

                    Column {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
	                        spacing: root.largeLandscapeLayout ? 8 : (root.standardLandscapeLayout ? 5 : 4)

                        Text {
                            text: wifiBridge.hotspotActive ? wifiBridge.hotspotSsid : wifiBridge.hotspotStatusText
                            color: "white"
                            font.family: interBold.font.family
	                            font.pixelSize: root.largeLandscapeLayout ? 29 : (root.standardLandscapeLayout ? 21 : 18)
                            elide: Text.ElideRight
                            renderType: Text.NativeRendering
                        }

                        Text {
                            text: wifiBridge.hotspotActive
                                  ? "Local network active"
                                  : "Start this when you need local WebUI access."
                            color: "#8cffffff"
                            font.family: interRegular.font.family
	                            font.pixelSize: root.largeLandscapeLayout ? 20 : (root.standardLandscapeLayout ? 15 : 13)
                            width: parent.width
                            elide: Text.ElideRight
                            renderType: Text.NativeRendering
                        }
                    }
                }
            }

            Column {
                width: parent.width
	                spacing: root.largeLandscapeLayout ? 20 : (root.standardLandscapeLayout ? 14 : 12)

                Row {
                    width: parent.width
	                    spacing: root.largeLandscapeLayout ? 20 : (root.standardLandscapeLayout ? 14 : 12)

                Column {
	                        width: (parent.width - (root.largeLandscapeLayout ? 20 : (root.standardLandscapeLayout ? 14 : 12))) / 2
	                        spacing: root.largeLandscapeLayout ? 13 : (root.standardLandscapeLayout ? 9 : 8)

                        Text {
                            text: "Network Name"
                            color: "#66ffffff"
                            font.family: interMedium.font.family
	                            font.pixelSize: root.largeLandscapeLayout ? 16 : (root.standardLandscapeLayout ? 12 : 11)
                            font.capitalization: Font.AllUppercase
                            font.letterSpacing: 2.2
                            renderType: Text.NativeRendering
                        }

                        TextField {
                            width: parent.width
	                            height: root.largeLandscapeLayout ? 88 : (root.standardLandscapeLayout ? 66 : 54)
                            text: wifiBridge.hotspotSsid
                            placeholderText: "Apertar"
                            readOnly: true
                            enabled: wifiBridge.wifiEnabled && !wifiBridge.connecting
                            color: "white"
                            font.family: interMedium.font.family
	                            font.pixelSize: root.largeLandscapeLayout ? 24 : (root.standardLandscapeLayout ? 18 : 16)
	                            selectByMouse: true
	                            leftPadding: root.largeLandscapeLayout ? 22 : (root.standardLandscapeLayout ? 16 : 14)
	                            rightPadding: root.largeLandscapeLayout ? 22 : (root.standardLandscapeLayout ? 16 : 14)

                            background: Rectangle {
	                                radius: root.largeLandscapeLayout ? 26 : (root.standardLandscapeLayout ? 20 : 17)
                                color: "#171717"
                                border.width: 1
                                border.color: "#1affffff"
                            }

                            TapHandler {
                                onTapped: root.openHotspotEdit("ssid")
                            }
                        }
                    }

                Column {
	                        width: (parent.width - (root.largeLandscapeLayout ? 20 : (root.standardLandscapeLayout ? 14 : 12))) / 2
	                        spacing: root.largeLandscapeLayout ? 13 : (root.standardLandscapeLayout ? 9 : 8)

                        Text {
                            text: "Password"
                            color: "#66ffffff"
                            font.family: interMedium.font.family
	                            font.pixelSize: root.largeLandscapeLayout ? 16 : (root.standardLandscapeLayout ? 12 : 11)
                            font.capitalization: Font.AllUppercase
                            font.letterSpacing: 2.2
                            renderType: Text.NativeRendering
                        }

                        TextField {
                            width: parent.width
	                            height: root.largeLandscapeLayout ? 88 : (root.standardLandscapeLayout ? 66 : 54)
                            text: wifiBridge.hotspotPassword
                            placeholderText: "8+ characters"
                            echoMode: root.hotspotPasswordVisible ? TextInput.Normal : TextInput.Password
                            readOnly: true
                            enabled: wifiBridge.wifiEnabled && !wifiBridge.connecting
                            color: "white"
                            font.family: interMedium.font.family
	                            font.pixelSize: root.largeLandscapeLayout ? (root.hotspotPasswordVisible ? 24 : 22) : (root.standardLandscapeLayout ? (root.hotspotPasswordVisible ? 18 : 16) : (root.hotspotPasswordVisible ? 16 : 14))
                            selectByMouse: true
	                            leftPadding: root.largeLandscapeLayout ? 22 : (root.standardLandscapeLayout ? 16 : 14)
	                            rightPadding: root.largeLandscapeLayout ? 22 : (root.standardLandscapeLayout ? 16 : 14)

                            background: Rectangle {
	                                radius: root.largeLandscapeLayout ? 26 : (root.standardLandscapeLayout ? 20 : 17)
                                color: "#171717"
                                border.width: 1
                                border.color: wifiBridge.hotspotPassword.length >= 8 ? "#1affffff" : "#4dffb14d"
                            }

                            TapHandler {
                                onTapped: root.openHotspotEdit("password")
                            }
                        }
                    }
                }

                Grid {
                    width: parent.width
                    columns: 2
	                    columnSpacing: root.largeLandscapeLayout ? 20 : (root.standardLandscapeLayout ? 14 : 12)
	                    rowSpacing: root.largeLandscapeLayout ? 20 : (root.standardLandscapeLayout ? 14 : 12)

                    ActionTile {
	                        width: (parent.width - (root.largeLandscapeLayout ? 20 : (root.standardLandscapeLayout ? 14 : 12))) / 2
	                        height: root.largeLandscapeLayout ? 88 : (root.standardLandscapeLayout ? 68 : 58)
                        label: wifiBridge.connecting ? "Working..." : (wifiBridge.hotspotActive ? "Restart" : "Start")
                        actionEnabled: wifiBridge.wifiEnabled
                                       && !wifiBridge.scanning
                                       && !wifiBridge.connecting
                                       && wifiBridge.hotspotSsid.length > 0
                                       && wifiBridge.hotspotPassword.length >= 8
                        onClicked: wifiBridge.startHotspot(wifiBridge.hotspotSsid, wifiBridge.hotspotPassword)
                    }

                    ActionTile {
	                        width: (parent.width - (root.largeLandscapeLayout ? 20 : (root.standardLandscapeLayout ? 14 : 12))) / 2
	                        height: root.largeLandscapeLayout ? 88 : (root.standardLandscapeLayout ? 68 : 58)
                        label: "Stop"
                        tone: "danger"
                        actionEnabled: wifiBridge.hotspotActive
                                       && !wifiBridge.scanning
                                       && !wifiBridge.connecting
                        onClicked: wifiBridge.stopHotspot()
                    }
                }

                Text {
                    width: parent.width
                    visible: wifiBridge.hotspotPassword.length > 0 && wifiBridge.hotspotPassword.length < 8
                    text: "Hotspot password must be at least 8 characters."
                    color: "#ffcf73"
                    font.family: interRegular.font.family
	                    font.pixelSize: root.largeLandscapeLayout ? 19 : (root.standardLandscapeLayout ? 14 : 12)
                    renderType: Text.NativeRendering
                }

                Text {
                    width: parent.width
                    visible: wifiBridge.lastError.length > 0
                    text: wifiBridge.lastError
                    color: "#ff9b9b"
                    font.family: interRegular.font.family
	                    font.pixelSize: root.largeLandscapeLayout ? 19 : (root.standardLandscapeLayout ? 14 : 12)
                    wrapMode: Text.WordWrap
                    renderType: Text.NativeRendering
                }
            }
        }
    }

    Component {
        id: wifiAvailableNetworksComponent

        SystemSectionCard {
            property string reorderSectionName: "Wi-Fi"
            title: "Available Networks"
            titleIconSource: ""
            description: "Other nearby networks available to join"
            opacity: wifiBridge.wifiEnabled ? 1.0 : 0.42
            favoriteEnabled: root.favoriteControlsEnabled
            favorited: root.itemIsFavorited("availableNetworks")
            onPressAndHoldRequested: root.openReorderPopup(reorderSectionName)
            onFavoriteToggleRequested: root.toggleFavoriteItem("availableNetworks")

            Behavior on opacity {
                NumberAnimation { duration: 160; easing.type: Easing.OutCubic }
            }

            Rectangle {
                width: parent.width
                height: wifiBridge.scanning
                        ? 120
                        : Math.min(420, Math.max(96, wifiNetworkList.implicitHeight + 24))
                radius: 18
                color: "#171717"
                border.width: 1
                border.color: "#1affffff"

                Item {
                    anchors.fill: parent
                    anchors.margins: 12

                    Text {
                        anchors.centerIn: parent
                        visible: wifiBridge.scanning
                        text: "Scanning Wi-Fi networks..."
                        color: "white"
                        font.family: interMedium.font.family
                        font.pixelSize: 16
                        renderType: Text.NativeRendering
                    }

                    Text {
                        anchors.centerIn: parent
                        visible: !wifiBridge.scanning && root.availableWifiNetworkCount() === 0
                        text: wifiBridge.wifiAvailable
                              ? "No other networks found right now."
                              : "Wi-Fi is not currently available."
                        color: "#8cffffff"
                        font.family: interRegular.font.family
                        font.pixelSize: 14
                        width: parent.width - 24
                        horizontalAlignment: Text.AlignHCenter
                        wrapMode: Text.WordWrap
                        renderType: Text.NativeRendering
                    }

                    Flickable {
                        id: wifiListFlick
                        anchors.fill: parent
                        clip: true
                        contentWidth: width
                        contentHeight: wifiNetworkList.implicitHeight
                        interactive: visible && contentHeight > height
                        boundsBehavior: Flickable.StopAtBounds
                        flickableDirection: Flickable.VerticalFlick
                        pressDelay: 80
                        visible: !wifiBridge.scanning && root.availableWifiNetworkCount() > 0

                        onMovementStarted: sectionFlick.interactive = false
                        onMovementEnded: {
                            if (!dragging && !flicking)
                                sectionFlick.interactive = true
                        }
                        onFlickEnded: sectionFlick.interactive = true
                        onDraggingChanged: {
                            if (!dragging && !flicking)
                                sectionFlick.interactive = true
                        }

                        Column {
                            id: wifiNetworkList
                            width: wifiListFlick.width
                            spacing: 8

                            Repeater {
                                model: wifiBridge.networks

                                delegate: Rectangle {
                                    property var network: modelData

                                    visible: !network.active
                                    width: wifiNetworkList.width
                                    height: visible ? 72 : 0
                                    radius: 16
                                    color: "#141414"
                                    border.width: 1
                                    border.color: "#1affffff"

                                    Item {
                                        anchors.fill: parent
                                        anchors.margins: 14

                                        Column {
                                            anchors.left: parent.left
                                            anchors.right: networkAction.left
                                            anchors.rightMargin: 12
                                            anchors.verticalCenter: parent.verticalCenter
                                            spacing: 4

                                            Text {
                                                text: network.ssid
                                                color: "white"
                                                font.family: interBold.font.family
                                                font.pixelSize: 18
                                                elide: Text.ElideRight
                                                renderType: Text.NativeRendering
                                            }

                                            Text {
                                                text: network.signal + "% signal"
                                                      + (network.security
                                                         ? " • " + network.security
                                                         : "")
                                                color: "#8cffffff"
                                                font.family: interRegular.font.family
                                                font.pixelSize: 13
                                                elide: Text.ElideRight
                                                renderType: Text.NativeRendering
                                            }
                                        }

                                        Rectangle {
                                            id: networkAction
                                            anchors.right: parent.right
                                            anchors.verticalCenter: parent.verticalCenter
                                            width: 96
                                            height: 40
                                            radius: 14
                                            color: networkActionArea.containsPress && networkActionArea.enabled ? "#20ffffff" : "#16ffffff"
                                            border.width: 1
                                            border.color: "#22ffffff"
                                            opacity: networkActionArea.enabled ? 1.0 : 0.55

                                            Text {
                                                anchors.centerIn: parent
                                                text: "Join"
                                                color: "white"
                                                font.family: interMedium.font.family
                                                font.pixelSize: 14
                                                renderType: Text.NativeRendering
                                            }

                                            MouseArea {
                                                id: networkActionArea
                                                anchors.fill: parent
                                                enabled: wifiBridge.wifiEnabled
                                                         && !wifiBridge.connecting
                                                         && !wifiBridge.scanning
                                                onClicked: root.openWifiConnect(network.ssid, network.security, false)
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        Rectangle {
                            anchors.right: parent.right
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            anchors.rightMargin: 2
                            width: 4
                            radius: 2
                            color: "#16ffffff"
                            visible: wifiListFlick.interactive

                            Rectangle {
                                width: parent.width
                                radius: 2
                                color: "#66ffffff"
                                visible: wifiListFlick.contentHeight > wifiListFlick.height
                                height: Math.max(28, (wifiListFlick.height * wifiListFlick.height) / Math.max(wifiListFlick.contentHeight, 1))
                                y: (wifiListFlick.contentY / Math.max(wifiListFlick.contentHeight - wifiListFlick.height, 1))
                                   * (parent.height - height)
                            }
                        }
                    }
                }
            }
        }
    }

    Component {
        id: infoCameraComponent

        SystemSectionCard {
            property string reorderSectionName: "Info"
            title: "Camera"
            titleIconSource: "qrc:/qml/icons/camera.png"
            description: "Detected camera backend and sensor information"
            favoriteEnabled: root.favoriteControlsEnabled
            favorited: root.itemIsFavorited("camera")
            onPressAndHoldRequested: root.openReorderPopup(reorderSectionName)
            onFavoriteToggleRequested: root.toggleFavoriteItem("camera")

            InfoDataRow {
                label: "Sensor"
                value: deviceInfoBridge.sensorName
                detail: apertarPreviewBridge.connected
                        ? "Preview pipeline connected"
                        : "Waiting for Apertar-Core preview connection"
            }

            InfoDataRow {
                label: "Backend"
                value: deviceInfoBridge.backendName
                detail: apertarPreviewBridge.connected
                        ? "Connected and streaming preview"
                        : (apertarPreviewBridge.statusText.indexOf("failed") >= 0
                           ? apertarPreviewBridge.statusText
                           : "Waiting for Apertar-Core preview connection")
            }
        }
    }

    Component {
        id: infoSbcComponent

        SystemSectionCard {
            property string reorderSectionName: "Info"
            title: "SBC"
            titleIconSource: "qrc:/qml/icons/sbc.png"
            description: "Board identity and system memory details"
            favoriteEnabled: root.favoriteControlsEnabled
            favorited: root.itemIsFavorited("sbc")
            onPressAndHoldRequested: root.openReorderPopup(reorderSectionName)
            onFavoriteToggleRequested: root.toggleFavoriteItem("sbc")

            InfoDataRow {
                label: "Model"
                value: deviceInfoBridge.piModel
            }

            InfoDataRow {
                label: "Serial Number"
                value: deviceInfoBridge.serialNumber
            }

            InfoDataRow {
                label: "Memory"
                value: deviceInfoBridge.ramTotalText + " total"
                detail: deviceInfoBridge.ramUsedText + " used"
            }

            InfoDataRow {
                label: "Operating System"
                value: deviceInfoBridge.osVersion
                detail: "Hostname " + deviceInfoBridge.hostname
            }
        }
    }

    Component {
        id: infoSystemComponent

        SystemSectionCard {
            property string reorderSectionName: "Info"
            title: "System"
            titleIconSource: "qrc:/qml/icons/info.png"
            description: "Runtime and network information"
            favoriteEnabled: root.favoriteControlsEnabled
            favorited: root.itemIsFavorited("systemInfo")
            onPressAndHoldRequested: root.openReorderPopup(reorderSectionName)
            onFavoriteToggleRequested: root.toggleFavoriteItem("systemInfo")

            InfoDataRow {
                label: "Kernel Version"
                value: deviceInfoBridge.kernelVersion
            }

            InfoDataRow {
                label: "Uptime"
                value: deviceInfoBridge.uptimeText
            }

            InfoDataRow {
                label: "IP Address"
                value: deviceInfoBridge.ipAddress
            }
        }
    }

    Component {
        id: infoSystemDriveComponent

        SystemSectionCard {
            property string reorderSectionName: "Info"
            title: "System Drive"
            titleIconSource: "qrc:/qml/icons/system-drive.png"
            description: "Internal system and boot storage information"
            favoriteEnabled: root.favoriteControlsEnabled
            favorited: root.itemIsFavorited("systemDrive")
            onPressAndHoldRequested: root.openReorderPopup(reorderSectionName)
            onFavoriteToggleRequested: root.toggleFavoriteItem("systemDrive")

            InfoDataRow {
                label: "System / SD Storage"
                value: deviceInfoBridge.systemStorageTotalText + " total"
                detail: deviceInfoBridge.systemStorageFreeText
                        + " free • Mounted at "
                        + deviceInfoBridge.systemStorageMountPoint
            }
        }
    }

    Component {
        id: reorderDelegate

        Item {
            id: dragArea
            required property string itemId
            required property string title
            property int visualIndex: DelegateModel.itemsIndex
            property bool held: false
            width: ListView.view.width
            height: root.largeLandscapeLayout ? 110 : (root.standardLandscapeLayout ? 84 : 74)

            function beginDrag() {
                held = true
                root.reorderDragging = true
            }

            function endDrag() {
                held = false
                root.reorderDragging = false
                contentItem.x = 4
                contentItem.y = 5
            }

            function maybeMoveDraggedItem() {
                if (!held || !reorderListView)
                    return

                var stride = dragArea.height + reorderListView.spacing
                var restY = 5
                var moveThreshold = stride * 0.5

                if (contentItem.y > restY + moveThreshold && visualIndex < reorderListModel.count - 1) {
                    reorderListModel.move(visualIndex, visualIndex + 1, 1)
                    contentItem.y -= stride
                } else if (contentItem.y < restY - moveThreshold && visualIndex > 0) {
                    reorderListModel.move(visualIndex, visualIndex - 1, 1)
                    contentItem.y += stride
                }
            }

            Rectangle {
                id: contentItem
                width: dragArea.width - 8
                height: root.largeLandscapeLayout ? 96 : (root.standardLandscapeLayout ? 72 : 64)
                x: 4
                y: root.largeLandscapeLayout ? 7 : (root.standardLandscapeLayout ? 6 : 5)
                radius: root.largeLandscapeLayout ? 28 : (root.standardLandscapeLayout ? 21 : 18)
                color: dragArea.held ? "#202020" : "#181818"
                border.width: 1
                border.color: dragArea.held ? "#55ffffff" : "#1affffff"
                z: dragArea.held ? 20 : 1
                scale: dragArea.held ? 1.01 : 1.0

                Drag.active: dragArea.held
                Drag.source: dragArea
                Drag.hotSpot.x: width / 2
                Drag.hotSpot.y: height / 2

                Behavior on scale {
                    NumberAnimation { duration: 120; easing.type: Easing.OutCubic }
                }

                Row {
                    anchors.fill: parent
                    anchors.margins: root.largeLandscapeLayout ? 26 : (root.standardLandscapeLayout ? 20 : 18)
                    spacing: root.largeLandscapeLayout ? 20 : (root.standardLandscapeLayout ? 14 : 12)

                    Rectangle {
                        width: root.largeLandscapeLayout ? 56 : (root.standardLandscapeLayout ? 42 : 36)
                        height: root.largeLandscapeLayout ? 64 : (root.standardLandscapeLayout ? 48 : 42)
                        anchors.verticalCenter: parent.verticalCenter
                        color: "transparent"

                        Text {
                            anchors.centerIn: parent
                            text: "≡"
                            color: dragArea.held ? "#ffffff" : "#8cffffff"
                            font.family: interMedium.font.family
                            font.pixelSize: root.largeLandscapeLayout ? 38 : (root.standardLandscapeLayout ? 28 : 24)
                            renderType: Text.NativeRendering
                        }
                    }

                    Text {
                        text: dragArea.title
                        color: "white"
                        font.family: interMedium.font.family
                        font.pixelSize: root.largeLandscapeLayout ? 29 : (root.standardLandscapeLayout ? 21 : 18)
                        renderType: Text.NativeRendering
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton
                pressAndHoldInterval: 260
                preventStealing: false
                drag.target: dragArea.held ? contentItem : undefined
                drag.axis: Drag.YAxis
                onPressAndHold: dragArea.beginDrag()
                onPositionChanged: dragArea.maybeMoveDraggedItem()
                onReleased: dragArea.endDrag()
                onCanceled: dragArea.endDrag()
            }
        }
    }

    Component {
        id: sidebarReorderDelegate

        Item {
            id: sidebarDragArea
            required property string itemId
            required property string label
            required property string iconSource
            property bool held: false
            property bool suppressClick: false
            property int visualIndex: DelegateModel.itemsIndex
            width: ListView.view.width
            height: root.settingsSidebarItemHeight

            function beginDrag() {
                held = true
                suppressClick = true
                root.sidebarDragging = true
            }

            function endDrag() {
                if (!held)
                    return

                held = false
                root.sidebarDragging = false
                contentItem.y = 0
                root.saveSidebarOrderFromModel()
            }

            function maybeMoveDraggedItem() {
                if (!held || !sidebarListView)
                    return

                var stride = sidebarDragArea.height + sidebarListView.spacing
                var moveThreshold = stride * 0.5

                if (contentItem.y > moveThreshold && visualIndex < sidebarOrderModel.count - 1) {
                    sidebarOrderModel.move(visualIndex, visualIndex + 1, 1)
                    contentItem.y -= stride
                } else if (contentItem.y < -moveThreshold && visualIndex > 0) {
                    sidebarOrderModel.move(visualIndex, visualIndex - 1, 1)
                    contentItem.y += stride
                }
            }

            SettingsMenuItem {
                id: contentItem
                width: sidebarDragArea.width - 4
                height: sidebarDragArea.height
                x: 2
                label: sidebarDragArea.label
                iconSource: sidebarDragArea.iconSource
                active: root.selectedSection === sidebarDragArea.itemId || sidebarDragArea.held
                compact: root.settingsSidebarItemCompact
                large: root.settingsSidebarItemLarge
                oversized: root.largeLandscapeLayout
                inputEnabled: false
                z: sidebarDragArea.held ? 10 : 1
                scale: sidebarDragArea.held ? 1.01 : 1.0

                Drag.active: sidebarDragArea.held
                Drag.source: sidebarDragArea
                Drag.hotSpot.x: width / 2
                Drag.hotSpot.y: height / 2

                Behavior on scale {
                    NumberAnimation { duration: 120; easing.type: Easing.OutCubic }
                }
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton
                pressAndHoldInterval: 260
                preventStealing: false
                drag.target: sidebarDragArea.held ? contentItem : undefined
                drag.axis: Drag.YAxis
                onPressed: sidebarDragArea.suppressClick = false
                onPressAndHold: sidebarDragArea.beginDrag()
                onPositionChanged: sidebarDragArea.maybeMoveDraggedItem()
                onReleased: sidebarDragArea.endDrag()
                onCanceled: {
                    sidebarDragArea.endDrag()
                    sidebarDragArea.suppressClick = false
                }
                onClicked: {
                    if (!sidebarDragArea.suppressClick) {
                        root.selectedSection = sidebarDragArea.itemId
                    } else {
                        sidebarDragArea.suppressClick = false
                    }
                }
            }
        }
    }

    Item {
        id: reorderDragLayer
        anchors.fill: parent
        z: 260
        visible: reorderPopupOpen
    }

    Rectangle {
        anchors.fill: parent
        color: "#000000"
    }

    Item {
        anchors.fill: parent
        anchors.margins: root.largeLandscapeLayout ? 32 : (root.compactLandscapeLayout ? 16 : 24)

        Item {
            id: header
            x: 0
            y: 0
            width: parent.width
            height: root.largeLandscapeLayout ? 110 : (root.compactLandscapeLayout ? 58 : 86)

            Column {
                anchors.left: parent.left
                anchors.top: parent.top
                spacing: root.largeLandscapeLayout ? 8 : (root.standardLandscapeLayout ? 5 : (root.compactLandscapeLayout ? 3 : 6))

                Text {
                    text: "Camera Menu"
                    color: "#66ffffff"
                    font.family: interMedium.font.family
                    font.pixelSize: root.largeLandscapeLayout ? 16 : (root.standardLandscapeLayout ? 11 : (root.compactLandscapeLayout ? 9 : 12))
                    font.capitalization: Font.AllUppercase
                    font.letterSpacing: root.largeLandscapeLayout ? 4.2 : (root.standardLandscapeLayout ? 3.0 : (root.compactLandscapeLayout ? 2.6 : 3.2))
                    renderType: Text.NativeRendering
                }

                Text {
                    text: "Settings"
                    color: "white"
                    font.family: interBold.font.family
                    font.pixelSize: root.largeLandscapeLayout ? 52 : (root.standardLandscapeLayout ? 34 : (root.compactLandscapeLayout ? 26 : 34))
                    renderType: Text.NativeRendering
                }
            }

            Rectangle {
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.topMargin: root.largeLandscapeLayout
                                   ? Math.round((root.settingsContentTopOffset - height) / 2) - 16
                                   : root.regularLandscapeLayout
                                   ? Math.round((root.settingsContentTopOffset - height) / 2) - 6
                                   : (root.compactLandscapeLayout ? 0 : 3)
                width: root.largeLandscapeLayout ? 184 : (root.standardLandscapeLayout ? 126 : (root.regularLandscapeLayout ? 102 : (root.compactLandscapeLayout ? 92 : 128)))
                height: root.largeLandscapeLayout ? 82 : (root.standardLandscapeLayout ? 56 : (root.regularLandscapeLayout ? 46 : (root.compactLandscapeLayout ? 42 : 70)))
                radius: root.largeLandscapeLayout ? 26 : (root.standardLandscapeLayout ? 18 : (root.regularLandscapeLayout ? 16 : (root.compactLandscapeLayout ? 15 : 18)))
                color: "#14ffffff"
                border.width: 1
                border.color: "#1affffff"

                Row {
                    anchors.centerIn: parent
                    spacing: root.largeLandscapeLayout ? 12 : (root.standardLandscapeLayout ? 9 : (root.regularLandscapeLayout ? 7 : (root.compactLandscapeLayout ? 6 : 8)))

                    Text {
                        text: "←"
                        color: "white"
                        font.family: interMedium.font.family
                        font.pixelSize: root.largeLandscapeLayout ? 30 : (root.standardLandscapeLayout ? 20 : (root.regularLandscapeLayout ? 17 : (root.compactLandscapeLayout ? 16 : 19)))
                        renderType: Text.NativeRendering
                    }

                    Text {
                        text: "Back"
                        color: "white"
                        font.family: interMedium.font.family
                        font.pixelSize: root.largeLandscapeLayout ? 25 : (root.standardLandscapeLayout ? 17 : (root.regularLandscapeLayout ? 14 : (root.compactLandscapeLayout ? 13 : 18)))
                        renderType: Text.NativeRendering
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: root.backRequested()
                }
            }
        }

        Item {
            id: contentArea
            x: 0
            y: root.settingsContentTopOffset
            width: parent.width
            height: root.compactLandscapeLayout ? (parent.height - y) : 620

            Rectangle {
                id: sidebar
                x: 0
                y: 0
                width: root.settingsSidebarWidth
                height: parent.height + root.compactSettingsBottomOverhang
                radius: root.largeLandscapeLayout ? 34 : (root.compactLandscapeLayout ? 22 : 28)
                color: "#151515"
                border.width: 1
                border.color: "#1affffff"
                clip: true

                ListView {
                    id: sidebarListView
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.leftMargin: root.settingsSidebarHorizontalMargin
                    anchors.rightMargin: root.settingsSidebarHorizontalMargin
                    anchors.topMargin: root.settingsSidebarTopMargin
                    height: root.regularLandscapeLayout
                            ? (contentArea.height - root.settingsSidebarTopMargin)
                            : (parent.height - root.settingsSidebarBottomInset)
                    spacing: root.settingsSidebarSpacing
                    model: sidebarDelegateModel
                    interactive: !root.sidebarDragging && contentHeight > height
                    boundsBehavior: Flickable.StopAtBounds
                    clip: true

                    moveDisplaced: Transition {
                        NumberAnimation {
                            properties: "x,y"
                            duration: 180
                            easing.type: Easing.OutCubic
                        }
                    }

                    displaced: Transition {
                        NumberAnimation {
                            properties: "x,y"
                            duration: 180
                            easing.type: Easing.OutCubic
                        }
                    }
                }
            }

            Rectangle {
                id: panel
                x: root.settingsSidebarWidth + root.settingsSidebarGap
                y: 0
                width: parent.width - x
                height: parent.height + root.compactSettingsBottomOverhang
                radius: root.largeLandscapeLayout ? 34 : (root.compactLandscapeLayout ? 22 : 28)
                color: "#151515"
                border.width: 1
                border.color: "#1affffff"
                clip: true

                Flickable {
                    id: sectionFlick
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.leftMargin: root.largeLandscapeLayout ? 34 : (root.standardLandscapeLayout ? 22 : (root.compactLandscapeLayout ? 16 : 20))
                    anchors.rightMargin: root.largeLandscapeLayout ? 34 : (root.standardLandscapeLayout ? 22 : (root.compactLandscapeLayout ? 16 : 20))
                    anchors.topMargin: 0
                    height: root.compactLandscapeLayout ? parent.height : (parent.height - 20)

                    contentWidth: width
                    contentHeight: root.selectedSection === "Favorites"
                                   ? (favoritesColumn.implicitHeight + root.settingsScrollBottomPadding)
                                   : root.selectedSection === "Monitoring"
                                   ? (monitoringColumn.implicitHeight + root.settingsScrollBottomPadding)
                                   : root.selectedSection === "Record"
                                     ? (recordColumn.implicitHeight + root.settingsScrollBottomPadding)
                                   : root.selectedSection === "Audio"
                                     ? (audioColumn.implicitHeight + root.settingsScrollBottomPadding)
                                   : root.selectedSection === "Power"
                                     ? (powerColumn.implicitHeight + root.settingsScrollBottomPadding)
                                   : root.selectedSection === "System"
                                     ? (systemColumn.implicitHeight + root.settingsScrollBottomPadding)
                                   : root.selectedSection === "Presets"
                                     ? (presetsColumn.implicitHeight + root.settingsScrollBottomPadding)
                                   : root.selectedSection === "Wi-Fi"
                                     ? (wifiColumn.implicitHeight + root.settingsScrollBottomPadding)
                                   : root.selectedSection === "Info"
                                     ? (infoColumn.implicitHeight + root.settingsScrollBottomPadding)
                                     : (placeholderSection.height + root.settingsScrollBottomPadding)
                    clip: true

                    Column {
                        id: favoritesColumn
                        width: parent.width
                        spacing: root.settingsSectionSpacing
                        visible: root.selectedSection === "Favorites"

                        Item {
                            width: 1
                            height: root.settingsSectionTopSpacer
                        }

                        Text {
                            text: "Quick Access"
                            color: "#66ffffff"
                            font.family: interMedium.font.family
                            font.pixelSize: root.settingsEyebrowSize
                            font.capitalization: Font.AllUppercase
                            font.letterSpacing: root.settingsEyebrowSpacing
                            renderType: Text.NativeRendering
                        }

                        Text {
                            text: "Favorites"
                            color: "white"
                            font.family: interBold.font.family
                            font.pixelSize: root.settingsTitleSize
                            renderType: Text.NativeRendering
                        }

                        Text {
                            text: root.favoriteItems().length > 0
                                  ? "Edit the list, then long press an option tile to reorder your favorites"
                                  : "Choose the settings you want quick access to"
                            color: "#66ffffff"
                            font.family: interRegular.font.family
                            font.pixelSize: root.settingsHintSize
                            renderType: Text.NativeRendering
                        }

                        Rectangle {
                            width: root.largeLandscapeLayout ? 340 : (root.standardLandscapeLayout ? 252 : (root.compactLandscapeLayout ? 154 : 192))
                            height: root.largeLandscapeLayout ? 96 : (root.standardLandscapeLayout ? 72 : (root.compactLandscapeLayout ? 42 : 54))
                            radius: root.largeLandscapeLayout ? 30 : (root.standardLandscapeLayout ? 23 : (root.compactLandscapeLayout ? 15 : 18))
                            color: favoriteManagerButtonArea.containsPress ? "#20ffffff" : "#14ffffff"
                            border.width: 1
                            border.color: "#1affffff"
                            scale: favoriteManagerButtonArea.containsPress ? 0.985 : 1.0

                            Behavior on scale {
                                NumberAnimation { duration: 140; easing.type: Easing.OutCubic }
                            }

                            Row {
                                anchors.centerIn: parent
                                spacing: root.largeLandscapeLayout ? 18 : (root.standardLandscapeLayout ? 13 : (root.compactLandscapeLayout ? 7 : 10))

                                Image {
                                    source: "qrc:/qml/icons/favorites.png"
                                    width: root.largeLandscapeLayout ? 34 : (root.standardLandscapeLayout ? 25 : (root.compactLandscapeLayout ? 15 : 18))
                                    height: root.largeLandscapeLayout ? 34 : (root.standardLandscapeLayout ? 25 : (root.compactLandscapeLayout ? 15 : 18))
                                    fillMode: Image.PreserveAspectFit
                                    smooth: true
                                    mipmap: true
                                }

                                Text {
                                    text: root.favoriteItems().length > 0 ? "Edit Favorites" : "Add Favorites"
                                    color: "white"
                                    font.family: interMedium.font.family
                                    font.pixelSize: root.largeLandscapeLayout ? 29 : (root.standardLandscapeLayout ? 21 : (root.compactLandscapeLayout ? 13 : 16))
                                    renderType: Text.NativeRendering
                                }
                            }

                            MouseArea {
                                id: favoriteManagerButtonArea
                                anchors.fill: parent
                                onClicked: root.openFavoriteManager()
                            }
                        }

                        Rectangle {
                            visible: root.favoriteItems().length === 0
                            width: favoritesColumn.width
                            height: root.largeLandscapeLayout ? 210 : (root.compactLandscapeLayout ? 128 : 170)
                            radius: root.largeLandscapeLayout ? 28 : (root.compactLandscapeLayout ? 18 : 22)
                            color: "#181818"
                            border.width: 1
                            border.color: "#1affffff"

                            Column {
                                anchors.centerIn: parent
                                spacing: root.largeLandscapeLayout ? 12 : (root.compactLandscapeLayout ? 6 : 8)

                                Image {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    source: "qrc:/qml/icons/favorites.png"
                                    width: root.largeLandscapeLayout ? 40 : (root.compactLandscapeLayout ? 22 : 28)
                                    height: root.largeLandscapeLayout ? 40 : (root.compactLandscapeLayout ? 22 : 28)
                                    fillMode: Image.PreserveAspectFit
                                    smooth: true
                                    mipmap: true
                                }

                                Text {
                                    text: "No favorites yet"
                                    color: "white"
                                    font.family: interBold.font.family
                                    font.pixelSize: root.largeLandscapeLayout ? 26 : (root.compactLandscapeLayout ? 15 : 18)
                                    horizontalAlignment: Text.AlignHCenter
                                    renderType: Text.NativeRendering
                                }

                                Text {
                                    text: "Use Add Favorites to choose the settings you want quick access to."
                                    color: "#8cffffff"
                                    font.family: interRegular.font.family
                                    font.pixelSize: root.largeLandscapeLayout ? 19 : (root.compactLandscapeLayout ? 11 : 14)
                                    width: root.largeLandscapeLayout ? 520 : (root.compactLandscapeLayout ? 260 : 360)
                                    wrapMode: Text.WordWrap
                                    horizontalAlignment: Text.AlignHCenter
                                    renderType: Text.NativeRendering
                                }
                            }
                        }

                        Repeater {
                            model: root.favoriteItems()

                            Loader {
                                width: favoritesColumn.width
                                sourceComponent: root.favoriteComponentForId(modelData)

                                onLoaded: {
                                    if (item && item.reorderSectionName !== undefined)
                                        item.reorderSectionName = "Favorites"
                                }
                            }
                        }
                    }

                    Column {
                        id: monitoringColumn
                        width: parent.width
                        spacing: root.settingsSectionSpacing
                        visible: root.selectedSection === "Monitoring"

                        Item {
                            width: 1
                            height: root.settingsSectionTopSpacer
                        }

                        Text {
                            text: "Monitoring Tools"
                            color: "#66ffffff"
                            font.family: interMedium.font.family
                            font.pixelSize: root.settingsEyebrowSize
                            font.capitalization: Font.AllUppercase
                            font.letterSpacing: root.settingsEyebrowSpacing
                            renderType: Text.NativeRendering
                        }

                        Text {
                            text: "Overlays & Assist"
                            color: "white"
                            font.family: interBold.font.family
                            font.pixelSize: root.settingsTitleSize
                            renderType: Text.NativeRendering
                        }

                        Text {
                            text: "Long press an option tile to reorder this section"
                            color: "#66ffffff"
                            font.family: interRegular.font.family
                            font.pixelSize: root.settingsHintSize
                            renderType: Text.NativeRendering
                        }

                        Repeater {
                            model: root.normalizedSectionOrder("Monitoring")

                            Loader {
                                width: monitoringColumn.width
                                sourceComponent: root.monitoringComponentForId(modelData)
                            }
                        }
                    }

                    Column {
                        id: systemColumn
                        width: parent.width
                        spacing: root.settingsSectionSpacing
                        visible: root.selectedSection === "System"

                        Item {
                            width: 1
                            height: root.settingsSectionTopSpacer
                        }

                        Text {
                            text: "System Controls"
                            color: "#66ffffff"
                            font.family: interMedium.font.family
                            font.pixelSize: root.settingsEyebrowSize
                            font.capitalization: Font.AllUppercase
                            font.letterSpacing: root.settingsEyebrowSpacing
                            renderType: Text.NativeRendering
                        }

                        Text {
                            text: "Device & Power"
                            color: "white"
                            font.family: interBold.font.family
                            font.pixelSize: root.settingsTitleSize
                            renderType: Text.NativeRendering
                        }

                        Text {
                            text: "Long press an option tile to reorder this section"
                            color: "#66ffffff"
                            font.family: interRegular.font.family
                            font.pixelSize: root.settingsHintSize
                            renderType: Text.NativeRendering
                        }

                        Repeater {
                            model: root.normalizedSectionOrder("System")

                            Loader {
                                width: systemColumn.width
                                sourceComponent: root.systemComponentForId(modelData)
                            }
                        }
                    }

                    Column {
                        id: presetsColumn
                        width: parent.width
                        spacing: root.settingsSectionSpacing
                        visible: root.selectedSection === "Presets"

                        Item {
                            width: 1
                            height: root.settingsSectionTopSpacer
                        }

                        Text {
                            text: "Preset Library"
                            color: "#66ffffff"
                            font.family: interMedium.font.family
                            font.pixelSize: root.settingsEyebrowSize
                            font.capitalization: Font.AllUppercase
                            font.letterSpacing: root.settingsEyebrowSpacing
                            renderType: Text.NativeRendering
                        }

                        Text {
                            text: "Save & Share"
                            color: "white"
                            font.family: interBold.font.family
                            font.pixelSize: root.settingsTitleSize
                            renderType: Text.NativeRendering
                        }

                        Text {
                            text: "Capture the current setup as a preset, then import or export it as a shareable file."
                            color: "#66ffffff"
                            font.family: interRegular.font.family
                            font.pixelSize: 13
                            width: parent.width
                            wrapMode: Text.WordWrap
                            renderType: Text.NativeRendering
                        }

                        SystemSectionCard {
                            width: presetsColumn.width
                            title: "Preset Library"
                            titleIconSource: "qrc:/qml/icons/folder.png"
                            description: "Manage local presets and share them through the mounted media drive."

                            Rectangle {
                                width: parent.width
                                height: root.largeLandscapeLayout ? 134 : (root.standardLandscapeLayout ? 100 : (root.compactLandscapeLayout ? 72 : 88))
                                radius: root.largeLandscapeLayout ? 26 : (root.standardLandscapeLayout ? 20 : (root.compactLandscapeLayout ? 15 : 18))
                                color: "#171717"
                                border.width: 1
                                border.color: "#1affffff"

                                Item {
                                    anchors.fill: parent
                                    anchors.margins: root.largeLandscapeLayout ? 22 : (root.standardLandscapeLayout ? 16 : (root.compactLandscapeLayout ? 12 : 16))

                                    Column {
                                        anchors.fill: parent
                                        spacing: root.largeLandscapeLayout ? 8 : (root.standardLandscapeLayout ? 5 : (root.compactLandscapeLayout ? 3 : 4))

                                        Text {
                                            text: "Saved Presets"
                                            color: "#66ffffff"
                                            font.family: interMedium.font.family
                                            font.pixelSize: root.largeLandscapeLayout ? 16 : (root.standardLandscapeLayout ? 12 : (root.compactLandscapeLayout ? 9 : 11))
                                            font.capitalization: Font.AllUppercase
                                            font.letterSpacing: root.largeLandscapeLayout ? 3.2 : (root.standardLandscapeLayout ? 2.4 : (root.compactLandscapeLayout ? 1.8 : 2.2))
                                            renderType: Text.NativeRendering
                                        }

                                        Text {
                                            text: root.presetCount === 1
                                                  ? "1 preset available"
                                                  : (root.presetCount + " presets available")
                                            color: "white"
                                            font.family: interBold.font.family
                                            font.pixelSize: root.largeLandscapeLayout ? 31 : (root.standardLandscapeLayout ? 23 : (root.compactLandscapeLayout ? 17 : 21))
                                            renderType: Text.NativeRendering
                                        }

                                        Text {
                                            text: mediaBridge.mediaMounted
                                                  ? ("Import/export path: " + mediaBridge.mountPath + "/Apertar Presets")
                                                  : "Mount media to import or export preset files."
                                            color: "#8cffffff"
                                            font.family: interRegular.font.family
                                            font.pixelSize: root.largeLandscapeLayout ? 19 : (root.standardLandscapeLayout ? 14 : (root.compactLandscapeLayout ? 11 : 13))
                                            width: parent.width
                                            wrapMode: Text.WordWrap
                                            renderType: Text.NativeRendering
                                        }
                                    }
                                }
                            }

                            Row {
                                width: parent.width
                                spacing: root.largeLandscapeLayout ? 18 : (root.standardLandscapeLayout ? 12 : (root.compactLandscapeLayout ? 8 : 12))

                                ActionTile {
                                    width: (parent.width - (root.largeLandscapeLayout ? 18 : (root.standardLandscapeLayout ? 12 : (root.compactLandscapeLayout ? 8 : 12)))) / 2
                                    label: "Save Current"
                                    onClicked: root.openPresetNamePopup()
                                }

                                ActionTile {
                                    width: (parent.width - (root.largeLandscapeLayout ? 18 : (root.standardLandscapeLayout ? 12 : (root.compactLandscapeLayout ? 8 : 12)))) / 2
                                    label: "Import From Media"
                                    actionEnabled: mediaBridge.mediaMounted
                                    onClicked: root.importPresetsFromMedia()
                                }
                            }
                        }

                        Rectangle {
                            width: presetsColumn.width
                            height: presetStatusText.implicitHeight + (root.largeLandscapeLayout ? 42 : (root.standardLandscapeLayout ? 30 : (root.compactLandscapeLayout ? 20 : 28)))
                            radius: root.largeLandscapeLayout ? 26 : (root.standardLandscapeLayout ? 20 : (root.compactLandscapeLayout ? 15 : 18))
                            visible: root.settingsState
                                     && root.settingsState.presetStatusText.length > 0
                            color: root.settingsState && root.settingsState.presetStatusError
                                   ? "#2a1717"
                                   : "#163022"
                            border.width: 1
                            border.color: root.settingsState && root.settingsState.presetStatusError
                                          ? "#8f3f3f"
                                          : "#2f8f61"

                            Text {
                                id: presetStatusText
                                anchors.fill: parent
                                anchors.margins: root.largeLandscapeLayout ? 21 : (root.standardLandscapeLayout ? 15 : (root.compactLandscapeLayout ? 10 : 14))
                                text: root.settingsState ? root.settingsState.presetStatusText : ""
                                color: "white"
                                font.family: interMedium.font.family
                                font.pixelSize: root.largeLandscapeLayout ? 20 : (root.standardLandscapeLayout ? 15 : (root.compactLandscapeLayout ? 11 : 14))
                                wrapMode: Text.WordWrap
                                renderType: Text.NativeRendering
                            }
                        }

                        SystemSectionCard {
                            width: presetsColumn.width
                            visible: root.settingsState && root.settingsState.presetNames.length === 0
                            title: "No Presets Yet"
                            titleIconSource: "qrc:/qml/icons/settings.png"
                            description: "Save the current setup as your first preset, or import a shared preset from the media drive."
                        }

                        Repeater {
                            model: root.settingsState ? root.settingsState.presetNames : []

                            delegate: SystemSectionCard {
                                required property var modelData
                                width: presetsColumn.width
                                title: String(modelData)
                                titleIconSource: "qrc:/qml/icons/settings.png"
                                description: "Load this preset instantly, export it to media, or delete it from local storage."

                                Row {
                                    width: parent.width
                                    spacing: root.largeLandscapeLayout ? 18 : (root.standardLandscapeLayout ? 12 : (root.compactLandscapeLayout ? 8 : 12))

                                    ActionTile {
                                        width: (parent.width - (root.largeLandscapeLayout ? 36 : (root.standardLandscapeLayout ? 24 : (root.compactLandscapeLayout ? 16 : 24)))) / 3
                                        label: "Load"
                                        onClicked: root.applyPresetByName(String(modelData))
                                    }

                                    ActionTile {
                                        width: (parent.width - (root.largeLandscapeLayout ? 36 : (root.standardLandscapeLayout ? 24 : (root.compactLandscapeLayout ? 16 : 24)))) / 3
                                        label: "Export"
                                        actionEnabled: mediaBridge.mediaMounted
                                        onClicked: root.exportPresetByName(String(modelData))
                                    }

                                    ActionTile {
                                        width: (parent.width - (root.largeLandscapeLayout ? 36 : (root.standardLandscapeLayout ? 24 : (root.compactLandscapeLayout ? 16 : 24)))) / 3
                                        label: "Delete"
                                        tone: "danger"
                                        onClicked: root.openPresetDeleteConfirmation(String(modelData))
                                    }
                                }
                            }
                        }
                    }

                    Column {
                        id: wifiColumn
                        width: parent.width
                        spacing: root.settingsSectionSpacing
                        visible: root.selectedSection === "Wi-Fi"

                        Item {
                            width: 1
                            height: root.settingsSectionTopSpacer
                        }

                        Text {
                            text: "Wireless"
                            color: "#66ffffff"
                            font.family: interMedium.font.family
                            font.pixelSize: root.settingsEyebrowSize
                            font.capitalization: Font.AllUppercase
                            font.letterSpacing: root.settingsEyebrowSpacing
                            renderType: Text.NativeRendering
                        }

                        Text {
                            text: "Wi-Fi & Network"
                            color: "white"
                            font.family: interBold.font.family
                            font.pixelSize: root.settingsTitleSize
                            renderType: Text.NativeRendering
                        }

                        Text {
                            text: "Long press an option tile to reorder this section"
                            color: "#66ffffff"
                            font.family: interRegular.font.family
                            font.pixelSize: root.settingsHintSize
                            renderType: Text.NativeRendering
                        }

                        Repeater {
                            model: root.normalizedSectionOrder("Wi-Fi")

                            Loader {
                                width: wifiColumn.width
                                sourceComponent: root.wifiComponentForId(modelData)
                            }
                        }
                    }

                    Column {
                        id: recordColumn
                        width: parent.width
                        spacing: root.settingsSectionSpacing
                        visible: root.selectedSection === "Record"

                        Item {
                            width: 1
                            height: root.settingsSectionTopSpacer
                        }

                        Text {
                            text: "Recording"
                            color: "#66ffffff"
                            font.family: interMedium.font.family
                            font.pixelSize: root.settingsEyebrowSize
                            font.capitalization: Font.AllUppercase
                            font.letterSpacing: root.settingsEyebrowSpacing
                            renderType: Text.NativeRendering
                        }

                        Text {
                            text: "Capture Settings"
                            color: "white"
                            font.family: interBold.font.family
                            font.pixelSize: root.settingsTitleSize
                            renderType: Text.NativeRendering
                        }

                        Text {
                            text: "Long press an option tile to reorder this section"
                            color: "#66ffffff"
                            font.family: interRegular.font.family
                            font.pixelSize: root.settingsHintSize
                            renderType: Text.NativeRendering
                        }

                        Repeater {
                            model: root.normalizedSectionOrder("Record")

                            Loader {
                                width: recordColumn.width
                                sourceComponent: root.recordComponentForId(modelData)
                            }
                        }
                    }

                    Column {
                        id: powerColumn
                        width: parent.width
                        spacing: root.settingsSectionSpacing
                        visible: root.selectedSection === "Power"

                        Item {
                            width: 1
                            height: root.settingsSectionTopSpacer
                        }

                        Text {
                            text: "Media"
                            color: "#66ffffff"
                            font.family: interMedium.font.family
                            font.pixelSize: root.settingsEyebrowSize
                            font.capitalization: Font.AllUppercase
                            font.letterSpacing: root.settingsEyebrowSpacing
                            renderType: Text.NativeRendering
                        }

                        Text {
                            text: "Recording Media"
                            color: "white"
                            font.family: interBold.font.family
                            font.pixelSize: root.settingsTitleSize
                            renderType: Text.NativeRendering
                        }

                        Text {
                            text: "Long press an option tile to reorder this section"
                            color: "#66ffffff"
                            font.family: interRegular.font.family
                            font.pixelSize: root.settingsHintSize
                            renderType: Text.NativeRendering
                        }

                        Repeater {
                            model: root.normalizedSectionOrder("Power")

                            Loader {
                                width: powerColumn.width
                                sourceComponent: root.powerComponentForId(modelData)
                            }
                        }
                    }

                    Column {
                        id: audioColumn
                        width: parent.width
                        spacing: root.settingsSectionSpacing
                        visible: root.selectedSection === "Audio"

                        Item {
                            width: 1
                            height: root.settingsSectionTopSpacer
                        }

                        Text {
                            text: "Audio"
                            color: "#66ffffff"
                            font.family: interMedium.font.family
                            font.pixelSize: root.settingsEyebrowSize
                            font.capitalization: Font.AllUppercase
                            font.letterSpacing: root.settingsEyebrowSpacing
                            renderType: Text.NativeRendering
                        }

                        Text {
                            text: "Input & Monitoring"
                            color: "white"
                            font.family: interBold.font.family
                            font.pixelSize: root.settingsTitleSize
                            renderType: Text.NativeRendering
                        }

                        Text {
                            text: "Long press an option tile to reorder this section"
                            color: "#66ffffff"
                            font.family: interRegular.font.family
                            font.pixelSize: root.settingsHintSize
                            renderType: Text.NativeRendering
                        }

                        Repeater {
                            model: root.normalizedSectionOrder("Audio")

                            Loader {
                                width: audioColumn.width
                                sourceComponent: root.audioComponentForId(modelData)
                            }
                        }
                    }

                    Column {
                        id: infoColumn
                        width: parent.width
                        spacing: root.settingsSectionSpacing
                        visible: root.selectedSection === "Info"

                        Item {
                            width: 1
                            height: root.settingsSectionTopSpacer
                        }

                        Text {
                            text: "Camera Information"
                            color: "#66ffffff"
                            font.family: interMedium.font.family
                            font.pixelSize: root.settingsEyebrowSize
                            font.capitalization: Font.AllUppercase
                            font.letterSpacing: root.settingsEyebrowSpacing
                            renderType: Text.NativeRendering
                        }

                        Text {
                            text: "About Device"
                            color: "white"
                            font.family: interBold.font.family
                            font.pixelSize: root.settingsTitleSize
                            renderType: Text.NativeRendering
                        }

                        Text {
                            text: "Long press an option tile to reorder this section"
                            color: "#66ffffff"
                            font.family: interRegular.font.family
                            font.pixelSize: root.settingsHintSize
                            renderType: Text.NativeRendering
                        }

                        Repeater {
                            model: root.normalizedSectionOrder("Info")

                            Loader {
                                width: infoColumn.width
                                sourceComponent: root.infoComponentForId(modelData)
                            }
                        }
                    }

                    Item {
                        id: placeholderSection
                        visible: root.selectedSection !== "Monitoring"
                                 && root.selectedSection !== "Favorites"
                                 && root.selectedSection !== "Record"
                                 && root.selectedSection !== "Audio"
                                 && root.selectedSection !== "Power"
                                 && root.selectedSection !== "Wi-Fi"
                                 && root.selectedSection !== "System"
                                 && root.selectedSection !== "Presets"
                                 && root.selectedSection !== "Info"
                        width: parent.width
                        height: 200

                        Text {
                            anchors.centerIn: parent
                            text: root.selectedSection + " settings coming next"
                            color: "#80ffffff"
                            font.family: interMedium.font.family
                            font.pixelSize: 22
                            renderType: Text.NativeRendering
                        }
                    }
                }

                Item {
                    id: dropdownOverlay
                    anchors.fill: parent
                    z: 99999

                    MouseArea {
                        anchors.fill: parent
                        enabled: sharedDropdownController.activeDropdown !== null
                        visible: enabled
                        onClicked: sharedDropdownController.activeDropdown = null
                    }
                }
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "#cc000000"
        visible: root.favoriteManagerOpen
        opacity: root.favoriteManagerOpen ? 1.0 : 0.0
        z: 19988

        Behavior on opacity {
            NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: root.favoriteManagerOpen = false
        }
    }

    Rectangle {
        id: favoriteManagerCard
        readonly property int popupMargin: root.largeLandscapeLayout ? 34 : (root.standardLandscapeLayout ? 26 : (root.compactLandscapeLayout ? 16 : 22))
        readonly property int bottomButtonGap: root.largeLandscapeLayout ? 24 : (root.standardLandscapeLayout ? 20 : 0)
        width: root.largeLandscapeLayout ? 940 : (root.standardLandscapeLayout ? 720 : (root.compactLandscapeLayout ? 500 : 620))
        height: root.largeLandscapeLayout ? (favoriteManagerColumn.implicitHeight + popupMargin + bottomButtonGap) : (root.standardLandscapeLayout ? (favoriteManagerColumn.implicitHeight + popupMargin + bottomButtonGap) : (root.compactLandscapeLayout ? 458 : 608))
        anchors.centerIn: parent
        radius: root.largeLandscapeLayout ? 38 : (root.standardLandscapeLayout ? 30 : (root.compactLandscapeLayout ? 22 : 26))
        color: "#151515"
        border.width: 1
        border.color: "#1affffff"
        visible: root.favoriteManagerOpen
        opacity: root.favoriteManagerOpen ? 1.0 : 0.0
        scale: root.favoriteManagerOpen ? 1.0 : 0.97
        z: 19989

        Behavior on opacity {
            NumberAnimation { duration: 220; easing.type: Easing.OutCubic }
        }

        Behavior on scale {
            NumberAnimation { duration: 220; easing.type: Easing.OutCubic }
        }

        MouseArea {
            anchors.fill: parent
        }

        Column {
            id: favoriteManagerColumn
            anchors.fill: parent
            anchors.margins: favoriteManagerCard.popupMargin
            spacing: root.largeLandscapeLayout ? 22 : (root.standardLandscapeLayout ? 16 : (root.compactLandscapeLayout ? 9 : 14))

            Column {
                width: parent.width
                spacing: 4

                Text {
                    text: root.favoriteItems().length > 0 ? "Edit Favorites" : "Add Favorites"
                    color: "white"
                    font.family: interBold.font.family
                    font.pixelSize: root.largeLandscapeLayout ? 40 : (root.standardLandscapeLayout ? 30 : (root.compactLandscapeLayout ? 20 : 24))
                    renderType: Text.NativeRendering
                }

                Text {
                    text: "Choose the settings you want in your quick access tab."
                    color: "#8f9096"
                    font.family: interRegular.font.family
                    font.pixelSize: root.largeLandscapeLayout ? 22 : (root.standardLandscapeLayout ? 16 : (root.compactLandscapeLayout ? 12 : 14))
                    renderType: Text.NativeRendering
                }
            }

            Rectangle {
                width: parent.width
                height: root.largeLandscapeLayout ? 630 : (root.standardLandscapeLayout ? 486 : (root.compactLandscapeLayout ? 322 : 422))
                radius: root.largeLandscapeLayout ? 30 : (root.standardLandscapeLayout ? 22 : (root.compactLandscapeLayout ? 16 : 20))
                color: "#171717"
                border.width: 1
                border.color: "#1affffff"
                clip: true

                ListView {
                    id: favoriteManagerListView
                    anchors.fill: parent
                    anchors.margins: root.largeLandscapeLayout ? 22 : (root.standardLandscapeLayout ? 16 : (root.compactLandscapeLayout ? 10 : 14))
                    spacing: root.largeLandscapeLayout ? 12 : (root.standardLandscapeLayout ? 9 : (root.compactLandscapeLayout ? 5 : 8))
                    model: root.favoriteCandidateOrder
                    boundsBehavior: Flickable.StopAtBounds
                    clip: true

                    delegate: Rectangle {
                        required property string modelData

                        width: favoriteManagerListView.width
                        height: root.largeLandscapeLayout ? 108 : (root.standardLandscapeLayout ? 82 : (root.compactLandscapeLayout ? 54 : 70))
                        radius: root.largeLandscapeLayout ? 28 : (root.standardLandscapeLayout ? 21 : (root.compactLandscapeLayout ? 15 : 18))
                        color: favoriteManagerRowArea.containsPress
                               ? (root.favoriteDraftContains(modelData) ? "#233540" : "#202020")
                               : (root.favoriteDraftContains(modelData) ? "#1f2c36" : "#181818")
                        border.width: 1
                        border.color: root.favoriteDraftContains(modelData) ? "#3fd0ff" : "#1affffff"
                        scale: favoriteManagerRowArea.containsPress ? 0.992 : 1.0

                        Behavior on scale {
                            NumberAnimation { duration: 120; easing.type: Easing.OutCubic }
                        }

                        Item {
                            anchors.fill: parent
                            anchors.margins: root.largeLandscapeLayout ? 24 : (root.standardLandscapeLayout ? 18 : (root.compactLandscapeLayout ? 12 : 16))

                            Column {
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.right: favoriteStatePill.left
                                anchors.rightMargin: root.largeLandscapeLayout ? 22 : (root.standardLandscapeLayout ? 16 : (root.compactLandscapeLayout ? 10 : 14))
                                spacing: root.largeLandscapeLayout ? 8 : (root.standardLandscapeLayout ? 5 : (root.compactLandscapeLayout ? 2 : 4))

                                Text {
                                    text: root.sectionItemTitle(root.sourceSectionForItemId(modelData), modelData)
                                    color: "white"
                                    font.family: interBold.font.family
                                    font.pixelSize: root.largeLandscapeLayout ? 30 : (root.standardLandscapeLayout ? 22 : (root.compactLandscapeLayout ? 15 : 18))
                                    elide: Text.ElideRight
                                    renderType: Text.NativeRendering
                                }

                                Text {
                                    text: root.sourceSectionForItemId(modelData)
                                    color: "#8cffffff"
                                    font.family: interRegular.font.family
                                    font.pixelSize: root.largeLandscapeLayout ? 20 : (root.standardLandscapeLayout ? 15 : (root.compactLandscapeLayout ? 11 : 13))
                                    elide: Text.ElideRight
                                    renderType: Text.NativeRendering
                                }
                            }

                            Rectangle {
                                id: favoriteStatePill
                                width: root.largeLandscapeLayout ? 132 : (root.standardLandscapeLayout ? 98 : (root.compactLandscapeLayout ? 68 : 84))
                                height: root.largeLandscapeLayout ? 54 : (root.standardLandscapeLayout ? 40 : (root.compactLandscapeLayout ? 28 : 34))
                                radius: root.largeLandscapeLayout ? 20 : (root.standardLandscapeLayout ? 15 : (root.compactLandscapeLayout ? 10 : 12))
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                color: "#141414"
                                border.width: 1
                                border.color: root.favoriteDraftContains(modelData) ? "#3fd0ff" : "#1affffff"

                                Text {
                                    anchors.centerIn: parent
                                    text: root.favoriteDraftContains(modelData) ? "Added" : "Add"
                                    color: root.favoriteDraftContains(modelData) ? "white" : "white"
                                    font.family: root.favoriteDraftContains(modelData)
                                                 ? interBold.font.family
                                                 : interMedium.font.family
                                    font.pixelSize: root.largeLandscapeLayout ? 22 : (root.standardLandscapeLayout ? 16 : (root.compactLandscapeLayout ? 12 : 14))
                                    renderType: Text.NativeRendering
                                }
                            }
                        }

                        MouseArea {
                            id: favoriteManagerRowArea
                            anchors.fill: parent
                            onClicked: root.toggleFavoriteDraftItem(modelData)
                        }
                    }
                }
            }

            Row {
                width: parent.width
                spacing: root.largeLandscapeLayout ? 18 : (root.standardLandscapeLayout ? 13 : (root.compactLandscapeLayout ? 8 : 12))

                Rectangle {
                    width: (parent.width - (root.largeLandscapeLayout ? 36 : (root.standardLandscapeLayout ? 26 : (root.compactLandscapeLayout ? 16 : 24)))) / 3
                    height: root.largeLandscapeLayout ? 84 : (root.standardLandscapeLayout ? 64 : (root.compactLandscapeLayout ? 46 : 56))
                    radius: root.largeLandscapeLayout ? 28 : (root.standardLandscapeLayout ? 21 : (root.compactLandscapeLayout ? 15 : 18))
                    color: clearFavoritesArea.containsPress ? "#20ffffff" : "#14ffffff"
                    border.width: 1
                    border.color: "#e0b447"
                    opacity: root.favoriteSelectionDraft.length > 0 ? 1.0 : 0.45
                    scale: clearFavoritesArea.containsPress ? 0.985 : 1.0

                    Behavior on scale {
                        NumberAnimation { duration: 140; easing.type: Easing.OutCubic }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "Clear All"
                        color: "white"
                        font.family: interMedium.font.family
                        font.pixelSize: root.largeLandscapeLayout ? 24 : (root.standardLandscapeLayout ? 18 : (root.compactLandscapeLayout ? 13 : 16))
                        renderType: Text.NativeRendering
                    }

                    MouseArea {
                        id: clearFavoritesArea
                        anchors.fill: parent
                        enabled: root.favoriteSelectionDraft.length > 0
                        onClicked: root.clearFavoriteDraft()
                    }
                }

                Rectangle {
                    width: (parent.width - (root.largeLandscapeLayout ? 36 : (root.standardLandscapeLayout ? 26 : (root.compactLandscapeLayout ? 16 : 24)))) / 3
                    height: root.largeLandscapeLayout ? 84 : (root.standardLandscapeLayout ? 64 : (root.compactLandscapeLayout ? 46 : 56))
                    radius: root.largeLandscapeLayout ? 28 : (root.standardLandscapeLayout ? 21 : (root.compactLandscapeLayout ? 15 : 18))
                    color: cancelFavoriteManagerArea.containsPress ? "#20ffffff" : "#14ffffff"
                    border.width: 1
                    border.color: "#1affffff"
                    scale: cancelFavoriteManagerArea.containsPress ? 0.985 : 1.0

                    Behavior on scale {
                        NumberAnimation { duration: 140; easing.type: Easing.OutCubic }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "Cancel"
                        color: "white"
                        font.family: interMedium.font.family
                        font.pixelSize: root.largeLandscapeLayout ? 24 : (root.standardLandscapeLayout ? 18 : (root.compactLandscapeLayout ? 13 : 16))
                        renderType: Text.NativeRendering
                    }

                    MouseArea {
                        id: cancelFavoriteManagerArea
                        anchors.fill: parent
                        onClicked: root.favoriteManagerOpen = false
                    }
                }

                Rectangle {
                    width: (parent.width - (root.largeLandscapeLayout ? 36 : (root.standardLandscapeLayout ? 26 : (root.compactLandscapeLayout ? 16 : 24)))) / 3
                    height: root.largeLandscapeLayout ? 84 : (root.standardLandscapeLayout ? 64 : (root.compactLandscapeLayout ? 46 : 56))
                    radius: root.largeLandscapeLayout ? 28 : (root.standardLandscapeLayout ? 21 : (root.compactLandscapeLayout ? 15 : 18))
                    color: applyFavoriteManagerArea.containsPress ? "#d7d9de" : "#d0d3d9"
                    border.width: 1
                    border.color: "#1affffff"
                    scale: applyFavoriteManagerArea.containsPress ? 0.985 : 1.0

                    Behavior on scale {
                        NumberAnimation { duration: 140; easing.type: Easing.OutCubic }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "Apply"
                        color: "#111111"
                        font.family: interBold.font.family
                        font.pixelSize: root.largeLandscapeLayout ? 24 : (root.standardLandscapeLayout ? 18 : (root.compactLandscapeLayout ? 13 : 16))
                        renderType: Text.NativeRendering
                    }

                    MouseArea {
                        id: applyFavoriteManagerArea
                        anchors.fill: parent
                        onClicked: root.saveFavoriteManager()
                    }
                }
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "#cc000000"
        visible: root.reorderPopupOpen
        opacity: root.reorderPopupOpen ? 1.0 : 0.0
        z: 19990

        Behavior on opacity {
            NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: root.reorderPopupOpen = false
        }
    }

    Rectangle {
        id: reorderPopupCard
        readonly property int popupMargin: root.largeLandscapeLayout ? 34 : (root.standardLandscapeLayout ? 26 : (root.compactLandscapeLayout ? 16 : 22))
        readonly property int bottomButtonGap: root.largeLandscapeLayout ? 24 : (root.standardLandscapeLayout ? 20 : 0)
        width: root.largeLandscapeLayout ? 900 : (root.standardLandscapeLayout ? 680 : (root.compactLandscapeLayout ? 486 : 560))
        height: root.largeLandscapeLayout ? (reorderPopupColumn.implicitHeight + popupMargin + bottomButtonGap) : (root.standardLandscapeLayout ? (reorderPopupColumn.implicitHeight + popupMargin + bottomButtonGap) : (root.compactLandscapeLayout ? 448 : 566))
        anchors.centerIn: parent
        radius: root.largeLandscapeLayout ? 38 : (root.standardLandscapeLayout ? 30 : (root.compactLandscapeLayout ? 22 : 26))
        color: "#151515"
        border.width: 1
        border.color: "#1affffff"
        visible: root.reorderPopupOpen
        opacity: root.reorderPopupOpen ? 1.0 : 0.0
        scale: root.reorderPopupOpen ? 1.0 : 0.97
        z: 19991

        Behavior on opacity {
            NumberAnimation { duration: 220; easing.type: Easing.OutCubic }
        }

        Behavior on scale {
            NumberAnimation { duration: 220; easing.type: Easing.OutCubic }
        }

        MouseArea {
            anchors.fill: parent
        }

        Column {
            id: reorderPopupColumn
            anchors.fill: parent
            anchors.margins: reorderPopupCard.popupMargin
            spacing: root.largeLandscapeLayout ? 22 : (root.standardLandscapeLayout ? 16 : (root.compactLandscapeLayout ? 8 : 14))

            Column {
                width: parent.width
                spacing: 4

                Text {
                    text: root.sectionItemTitle("Sidebar", root.reorderSection) + " Order"
                    color: "white"
                    font.family: interBold.font.family
                    font.pixelSize: root.largeLandscapeLayout ? 40 : (root.standardLandscapeLayout ? 30 : (root.compactLandscapeLayout ? 19 : 24))
                    renderType: Text.NativeRendering
                }

                Text {
                    text: "Long press any item to rearrange it."
                         + " Swipe to scroll."
                    color: "#8f9096"
                    font.family: interRegular.font.family
                    font.pixelSize: root.largeLandscapeLayout ? 22 : (root.standardLandscapeLayout ? 16 : (root.compactLandscapeLayout ? 11 : 14))
                    renderType: Text.NativeRendering
                }
            }

            Rectangle {
                width: parent.width
                height: root.largeLandscapeLayout ? 590 : (root.standardLandscapeLayout ? 448 : (root.compactLandscapeLayout ? 296 : 380))
                radius: root.largeLandscapeLayout ? 30 : (root.standardLandscapeLayout ? 22 : (root.compactLandscapeLayout ? 16 : 20))
                color: "#171717"
                border.width: 1
                border.color: "#1affffff"
                clip: true

                ListView {
                    id: reorderListView
                    anchors.fill: parent
                    anchors.margins: root.largeLandscapeLayout ? 22 : (root.standardLandscapeLayout ? 16 : (root.compactLandscapeLayout ? 10 : 14))
                    spacing: root.largeLandscapeLayout ? 12 : (root.standardLandscapeLayout ? 9 : (root.compactLandscapeLayout ? 5 : 8))
                    model: reorderDelegateModel
                    interactive: !root.reorderDragging && contentHeight > height
                    boundsBehavior: Flickable.StopAtBounds
                    clip: true

                    moveDisplaced: Transition {
                        NumberAnimation {
                            properties: "x,y"
                            duration: 180
                            easing.type: Easing.OutCubic
                        }
                    }

                    displaced: Transition {
                        NumberAnimation {
                            properties: "x,y"
                            duration: 180
                            easing.type: Easing.OutCubic
                        }
                    }
                }
            }

            Item {
                width: 1
                height: root.largeLandscapeLayout ? 6 : (root.standardLandscapeLayout ? 3 : (root.compactLandscapeLayout ? 8 : 0))
            }

            Row {
                width: parent.width
                spacing: root.largeLandscapeLayout ? 18 : (root.standardLandscapeLayout ? 13 : (root.compactLandscapeLayout ? 8 : 12))

                Rectangle {
                    width: (parent.width - (root.largeLandscapeLayout ? 36 : (root.standardLandscapeLayout ? 26 : (root.compactLandscapeLayout ? 16 : 24)))) / 3
                    height: root.largeLandscapeLayout ? 84 : (root.standardLandscapeLayout ? 64 : (root.compactLandscapeLayout ? 46 : 56))
                    radius: root.largeLandscapeLayout ? 28 : (root.standardLandscapeLayout ? 21 : (root.compactLandscapeLayout ? 15 : 18))
                    color: resetOrderArea.containsPress ? "#20ffffff" : "#14ffffff"
                    border.width: 1
                    border.color: "#e0b447"
                    scale: resetOrderArea.containsPress ? 0.985 : 1.0

                    Behavior on scale {
                        NumberAnimation { duration: 140; easing.type: Easing.OutCubic }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "Reset"
                        color: "white"
                        font.family: interMedium.font.family
                        font.pixelSize: root.largeLandscapeLayout ? 24 : (root.standardLandscapeLayout ? 18 : (root.compactLandscapeLayout ? 13 : 16))
                        renderType: Text.NativeRendering
                    }

                    MouseArea {
                        id: resetOrderArea
                        anchors.fill: parent
                        onClicked: root.resetReorderPopup()
                    }
                }

                Rectangle {
                    width: (parent.width - (root.largeLandscapeLayout ? 36 : (root.standardLandscapeLayout ? 26 : (root.compactLandscapeLayout ? 16 : 24)))) / 3
                    height: root.largeLandscapeLayout ? 84 : (root.standardLandscapeLayout ? 64 : (root.compactLandscapeLayout ? 46 : 56))
                    radius: root.largeLandscapeLayout ? 28 : (root.standardLandscapeLayout ? 21 : (root.compactLandscapeLayout ? 15 : 18))
                    color: cancelReorderArea.containsPress ? "#20ffffff" : "#14ffffff"
                    border.width: 1
                    border.color: "#1affffff"
                    scale: cancelReorderArea.containsPress ? 0.985 : 1.0

                    Behavior on scale {
                        NumberAnimation { duration: 140; easing.type: Easing.OutCubic }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "Cancel"
                        color: "white"
                        font.family: interMedium.font.family
                        font.pixelSize: root.largeLandscapeLayout ? 24 : (root.standardLandscapeLayout ? 18 : (root.compactLandscapeLayout ? 13 : 16))
                        renderType: Text.NativeRendering
                    }

                    MouseArea {
                        id: cancelReorderArea
                        anchors.fill: parent
                        onClicked: root.reorderPopupOpen = false
                    }
                }

                Rectangle {
                    width: (parent.width - (root.largeLandscapeLayout ? 36 : (root.standardLandscapeLayout ? 26 : (root.compactLandscapeLayout ? 16 : 24)))) / 3
                    height: root.largeLandscapeLayout ? 84 : (root.standardLandscapeLayout ? 64 : (root.compactLandscapeLayout ? 46 : 56))
                    radius: root.largeLandscapeLayout ? 28 : (root.standardLandscapeLayout ? 21 : (root.compactLandscapeLayout ? 15 : 18))
                    color: applyReorderArea.containsPress ? "#d7d9de" : "#d0d3d9"
                    border.width: 1
                    border.color: "#1affffff"
                    scale: applyReorderArea.containsPress ? 0.985 : 1.0

                    Behavior on scale {
                        NumberAnimation { duration: 140; easing.type: Easing.OutCubic }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "Apply"
                        color: "#111111"
                        font.family: interBold.font.family
                        font.pixelSize: root.largeLandscapeLayout ? 24 : (root.standardLandscapeLayout ? 18 : (root.compactLandscapeLayout ? 13 : 16))
                        renderType: Text.NativeRendering
                    }

                    MouseArea {
                        id: applyReorderArea
                        anchors.fill: parent
                        onClicked: root.saveReorderPopup()
                    }
                }
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "#cc000000"
        visible: root.powerConfirmOpen
                 || root.powerErrorOpen
                 || root.ejectConfirmOpen
                 || root.ejectErrorOpen
                 || root.formatConfirmOpen
                 || root.formatSuccessOpen
                 || root.formatErrorOpen
                 || root.presetNamePopupOpen
                 || root.presetDeleteConfirmOpen
                 || root.hotspotEditPopupOpen
                 || root.wifiPasswordPopupOpen
                 || root.timeApplySuccessOpen
                 || root.timeApplyErrorOpen
                 || root.thermalApplySuccessOpen
                 || root.thermalApplyErrorOpen
        opacity: root.powerConfirmOpen
                 || root.powerErrorOpen
                 || root.ejectConfirmOpen
                 || root.ejectErrorOpen
                 || root.formatConfirmOpen
                 || root.formatSuccessOpen
                 || root.formatErrorOpen
                 || root.presetNamePopupOpen
                 || root.presetDeleteConfirmOpen
                 || root.hotspotEditPopupOpen
                 || root.wifiPasswordPopupOpen
                 || root.timeApplySuccessOpen
                 || root.timeApplyErrorOpen
                 || root.thermalApplySuccessOpen
                 || root.thermalApplyErrorOpen ? 1.0 : 0.0
        z: 20000

        Behavior on opacity {
            NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                root.powerConfirmOpen = false
                root.powerErrorOpen = false
                root.ejectConfirmOpen = false
                root.ejectErrorOpen = false
                root.formatConfirmOpen = false
                root.formatSuccessOpen = false
                root.formatErrorOpen = false
                root.closePresetNamePopup()
                root.closePresetDeleteConfirmation()
                root.cancelWifiConnect()
                root.timeApplySuccessOpen = false
                root.timeApplyErrorOpen = false
                root.thermalApplySuccessOpen = false
                root.thermalApplyErrorOpen = false
            }
        }
    }

    Rectangle {
        width: root.settingsKeyboardPopupWidth
        height: root.settingsKeyboardPopupHeight
        anchors.centerIn: parent
        radius: root.largeLandscapeLayout ? 36 : (root.standardLandscapeLayout ? 26 : 23)
        color: "#151515"
        border.width: 1
        border.color: "#1affffff"
        visible: root.presetNamePopupOpen
        opacity: root.presetNamePopupOpen ? 1.0 : 0.0
        scale: root.presetNamePopupOpen ? 1.0 : 0.96
        z: 20001

        Behavior on opacity {
            NumberAnimation { duration: 220; easing.type: Easing.OutCubic }
        }

        Behavior on scale {
            NumberAnimation { duration: 240; easing.type: Easing.OutCubic }
        }

        MouseArea {
            anchors.fill: parent
        }

        Column {
            anchors.fill: parent
            anchors.margins: root.settingsKeyboardPopupMargin
            spacing: root.settingsKeyboardPopupSpacing

            Column {
                width: parent.width
                spacing: 4

                Text {
                    text: "Save Current Preset"
                    color: "white"
                    font.family: interBold.font.family
                    font.pixelSize: root.settingsKeyboardTitleSize
                    renderType: Text.NativeRendering
                }

                Text {
                    text: "Save the current camera setup as a preset for quick recall or export."
                    color: "#8f9096"
                    font.family: interRegular.font.family
                    font.pixelSize: root.settingsKeyboardHintSize
                    width: parent.width
                    wrapMode: Text.WordWrap
                    renderType: Text.NativeRendering
                }
            }

            Column {
                width: parent.width
                spacing: 8

                Text {
                    text: "Preset Name"
                    color: "#66ffffff"
                    font.family: interMedium.font.family
                    font.pixelSize: root.settingsKeyboardLabelSize
                    font.capitalization: Font.AllUppercase
                    font.letterSpacing: 2.2
                    renderType: Text.NativeRendering
                }

                TextField {
                    id: presetNameField
                    width: parent.width
                    height: root.settingsKeyboardFieldHeight
                    text: root.presetNameDraft
                    placeholderText: "Preset Name"
                    placeholderTextColor: "#5e636b"
                    color: "white"
                    font.family: interMedium.font.family
                    font.pixelSize: root.settingsKeyboardFieldTextSize
                    selectByMouse: true
                    leftPadding: root.largeLandscapeLayout ? 24 : (root.standardLandscapeLayout ? 18 : 15)
                    rightPadding: root.largeLandscapeLayout ? 24 : (root.standardLandscapeLayout ? 18 : 15)
                    onTextChanged: root.presetNameDraft = text

                    background: Rectangle {
                        radius: root.largeLandscapeLayout ? 26 : (root.standardLandscapeLayout ? 20 : 17)
                        color: "#171717"
                        border.width: 1
                        border.color: "#1affffff"
                    }
                }
            }

            Column {
                width: parent.width
                spacing: root.settingsKeyboardRowSpacing

                Item {
                    width: 1
                    height: root.largeLandscapeLayout ? 12 : (root.standardLandscapeLayout ? 8 : 7)
                }

                Repeater {
                    model: root.presetKeyboardRows

                    delegate: Row {
                        required property var modelData
                        x: (parent.width - implicitWidth) / 2
                        spacing: root.settingsKeyboardRowSpacing

                        Repeater {
                            model: modelData

                            delegate: Rectangle {
                                required property string modelData

                                width: root.presetKeyWidth(modelData)
                                height: root.settingsKeyboardKeyHeight
                                radius: root.largeLandscapeLayout ? 20 : (root.standardLandscapeLayout ? 15 : 13)
                                color: presetKeyArea.containsPress
                                       ? "#20ffffff"
                                       : ((modelData === "shift" && (root.presetKeyboardShift || root.presetKeyboardCapsLock))
                                          ? "#25414b"
                                          : "#171717")
                                border.width: 1
                                border.color: (modelData === "shift" && (root.presetKeyboardShift || root.presetKeyboardCapsLock))
                                              ? "#3fd0ff"
                                              : "#1affffff"
                                scale: presetKeyArea.containsPress ? 0.985 : 1.0

                                Behavior on scale {
                                    NumberAnimation { duration: 120; easing.type: Easing.OutCubic }
                                }

                                Text {
                                    anchors.centerIn: parent
                                    text: root.presetDisplayKeyLabel(modelData)
                                    color: "white"
                                    font.family: interMedium.font.family
                                    font.pixelSize: modelData === "space" ? root.settingsKeyboardSpaceTextSize : root.settingsKeyboardKeyTextSize
                                    renderType: Text.NativeRendering
                                }

                                MouseArea {
                                    id: presetKeyArea
                                    anchors.fill: parent
                                    pressAndHoldInterval: 450
                                    onPressed: root.presetKeyboardLongPressHandled = false
                                    onClicked: {
                                        if (modelData === "shift" && root.presetKeyboardLongPressHandled) {
                                            root.presetKeyboardLongPressHandled = false
                                            return
                                        }
                                        root.presetKeyboardInsert(modelData)
                                    }
                                    onPressAndHold: {
                                        if (modelData === "shift") {
                                            root.presetKeyboardLongPressHandled = true
                                            root.presetKeyboardToggleCapsLock()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            Item {
                width: 1
                height: root.largeLandscapeLayout ? 12 : (root.standardLandscapeLayout ? 8 : 0)
            }

            Row {
                width: parent.width
                height: root.settingsKeyboardButtonHeight
                spacing: root.largeLandscapeLayout ? 14 : (root.standardLandscapeLayout ? 10 : 9)

                Rectangle {
                    width: (parent.width - (root.largeLandscapeLayout ? 28 : (root.standardLandscapeLayout ? 20 : 18))) / 3
                    height: root.settingsKeyboardButtonHeight
                    radius: root.largeLandscapeLayout ? 26 : (root.standardLandscapeLayout ? 19 : 17)
                    color: presetClearArea.containsPress ? "#20ffffff" : "#14ffffff"
                    border.width: 1
                    border.color: "#1affffff"
                    scale: presetClearArea.containsPress ? 0.985 : 1.0

                    Behavior on scale {
                        NumberAnimation { duration: 140; easing.type: Easing.OutCubic }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "Clear"
                        color: "white"
                        font.family: interMedium.font.family
                        font.pixelSize: root.settingsKeyboardButtonTextSize
                        renderType: Text.NativeRendering
                    }

                    MouseArea {
                        id: presetClearArea
                        anchors.fill: parent
                        onClicked: root.presetNameDraft = ""
                    }
                }

                Rectangle {
                    width: (parent.width - (root.largeLandscapeLayout ? 28 : (root.standardLandscapeLayout ? 20 : 18))) / 3
                    height: root.settingsKeyboardButtonHeight
                    radius: root.largeLandscapeLayout ? 26 : (root.standardLandscapeLayout ? 19 : 17)
                    color: presetSaveArea.containsPress && presetSaveArea.enabled ? "#d7d9de" : "#d0d3d9"
                    border.width: 1
                    border.color: "#1affffff"
                    opacity: presetSaveArea.enabled ? 1.0 : 0.45
                    scale: presetSaveArea.containsPress && presetSaveArea.enabled ? 0.985 : 1.0

                    Behavior on scale {
                        NumberAnimation { duration: 140; easing.type: Easing.OutCubic }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "Save"
                        color: "#111111"
                        font.family: interBold.font.family
                        font.pixelSize: root.settingsKeyboardButtonTextSize
                        renderType: Text.NativeRendering
                    }

                    MouseArea {
                        id: presetSaveArea
                        anchors.fill: parent
                        enabled: root.presetNameDraft.trim().length > 0
                        onClicked: root.savePresetFromDraft()
                    }
                }

                Rectangle {
                    width: (parent.width - (root.largeLandscapeLayout ? 28 : (root.standardLandscapeLayout ? 20 : 18))) / 3
                    height: root.settingsKeyboardButtonHeight
                    radius: root.largeLandscapeLayout ? 26 : (root.standardLandscapeLayout ? 19 : 17)
                    color: presetCancelArea.containsPress ? "#20ffffff" : "#14ffffff"
                    border.width: 1
                    border.color: "#1affffff"
                    scale: presetCancelArea.containsPress ? 0.985 : 1.0

                    Behavior on scale {
                        NumberAnimation { duration: 140; easing.type: Easing.OutCubic }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "Cancel"
                        color: "white"
                        font.family: interMedium.font.family
                        font.pixelSize: root.settingsKeyboardButtonTextSize
                        renderType: Text.NativeRendering
                    }

                    MouseArea {
                        id: presetCancelArea
                        anchors.fill: parent
                        onClicked: root.closePresetNamePopup()
                    }
                }
            }
        }
    }

    Rectangle {
        width: 420
        height: 250
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -10
        radius: 26
        color: "#151515"
        border.width: 1
        border.color: "#1affffff"
        visible: root.presetDeleteConfirmOpen
        opacity: root.presetDeleteConfirmOpen ? 1.0 : 0.0
        scale: root.presetDeleteConfirmOpen ? 1.0 : 0.96
        z: 20001

        Behavior on opacity {
            NumberAnimation { duration: 220; easing.type: Easing.OutCubic }
        }

        Behavior on scale {
            NumberAnimation { duration: 240; easing.type: Easing.OutCubic }
        }

        MouseArea {
            anchors.fill: parent
        }

        Column {
            anchors.fill: parent
            anchors.margins: 24
            spacing: 16

            Rectangle {
                width: 40
                height: 40
                radius: 20
                color: "#2a1717"
                border.width: 1
                border.color: "#4a2a2a"

                Text {
                    anchors.centerIn: parent
                    text: "!"
                    color: "white"
                    font.family: interBold.font.family
                    font.pixelSize: 18
                    renderType: Text.NativeRendering
                }
            }

            Column {
                width: parent.width
                spacing: 4

                Text {
                    text: "Delete Preset?"
                    color: "white"
                    font.family: interBold.font.family
                    font.pixelSize: 24
                    renderType: Text.NativeRendering
                }

                Text {
                    text: "Are you sure you want to delete \"" + root.presetDeleteTargetName + "\"? This only removes the local preset."
                    color: "#8f9096"
                    font.family: interRegular.font.family
                    font.pixelSize: 14
                    wrapMode: Text.WordWrap
                    width: parent.width
                    renderType: Text.NativeRendering
                }
            }

            Row {
                spacing: 12

                Rectangle {
                    width: 156
                    height: 54
                    radius: 18
                    color: cancelPresetDeleteArea.containsPress ? "#20ffffff" : "#14ffffff"
                    border.width: 1
                    border.color: "#1affffff"
                    scale: cancelPresetDeleteArea.containsPress ? 0.985 : 1.0

                    Behavior on scale {
                        NumberAnimation { duration: 140; easing.type: Easing.OutCubic }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "Cancel"
                        color: "white"
                        font.family: interMedium.font.family
                        font.pixelSize: 16
                        renderType: Text.NativeRendering
                    }

                    MouseArea {
                        id: cancelPresetDeleteArea
                        anchors.fill: parent
                        onClicked: root.closePresetDeleteConfirmation()
                    }
                }

                Rectangle {
                    width: 192
                    height: 54
                    radius: 18
                    color: confirmPresetDeleteArea.containsPress ? "#a32828" : "#8d2020"
                    border.width: 1
                    border.color: "#ba4a4a"
                    scale: confirmPresetDeleteArea.containsPress ? 0.985 : 1.0

                    Behavior on scale {
                        NumberAnimation { duration: 140; easing.type: Easing.OutCubic }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "Delete"
                        color: "#ffd6d6"
                        font.family: interMedium.font.family
                        font.pixelSize: 16
                        renderType: Text.NativeRendering
                    }

                    MouseArea {
                        id: confirmPresetDeleteArea
                        anchors.fill: parent
                        onClicked: root.executePresetDelete()
                    }
                }
            }
        }
    }

    Rectangle {
        width: root.settingsKeyboardPopupWidth
        height: root.settingsKeyboardPopupHeight
        anchors.centerIn: parent
        radius: root.largeLandscapeLayout ? 36 : (root.standardLandscapeLayout ? 26 : 23)
        color: "#151515"
        border.width: 1
        border.color: "#1affffff"
        visible: root.hotspotEditPopupOpen
        opacity: root.hotspotEditPopupOpen ? 1.0 : 0.0
        scale: root.hotspotEditPopupOpen ? 1.0 : 0.96
        z: 20001

        Behavior on opacity {
            NumberAnimation { duration: 220; easing.type: Easing.OutCubic }
        }

        Behavior on scale {
            NumberAnimation { duration: 240; easing.type: Easing.OutCubic }
        }

        MouseArea {
            anchors.fill: parent
        }

        Column {
            anchors.fill: parent
            anchors.margins: root.settingsKeyboardPopupMargin
            spacing: root.settingsKeyboardPopupSpacing

            Column {
                width: parent.width
                spacing: 4

                Text {
                    text: root.hotspotEditTitle()
                    color: "white"
                    font.family: interBold.font.family
                    font.pixelSize: root.settingsKeyboardTitleSize
                    renderType: Text.NativeRendering
                    elide: Text.ElideRight
                }

                Text {
                    text: "Edit hotspot details using the on-screen keyboard."
                    color: "#8f9096"
                    font.family: interRegular.font.family
                    font.pixelSize: root.settingsKeyboardHintSize
                    width: parent.width
                    wrapMode: Text.WordWrap
                    renderType: Text.NativeRendering
                }
            }

            Column {
                width: parent.width
                spacing: 8

                Text {
                    text: root.hotspotEditFieldLabel()
                    color: "#66ffffff"
                    font.family: interMedium.font.family
                    font.pixelSize: root.settingsKeyboardLabelSize
                    font.capitalization: Font.AllUppercase
                    font.letterSpacing: 2.2
                    renderType: Text.NativeRendering
                }

                TextField {
                    width: parent.width
                    height: root.settingsKeyboardFieldHeight
                    text: root.hotspotEditDraft
                    placeholderText: root.hotspotEditTarget === "password" ? "8+ characters" : "Apertar"
                    echoMode: root.hotspotEditTarget === "password" && !root.hotspotPasswordVisible
                              ? TextInput.Password
                              : TextInput.Normal
                    enabled: !wifiBridge.connecting
                    color: "white"
                    font.family: interMedium.font.family
                    font.pixelSize: root.hotspotEditTarget === "password" && !root.hotspotPasswordVisible
                                    ? (root.largeLandscapeLayout ? 25 : (root.standardLandscapeLayout ? 19 : 17))
                                    : root.settingsKeyboardFieldTextSize
                    selectByMouse: true
                    leftPadding: root.largeLandscapeLayout ? 24 : (root.standardLandscapeLayout ? 18 : 15)
                    rightPadding: root.largeLandscapeLayout ? 24 : (root.standardLandscapeLayout ? 18 : 15)
                    onTextChanged: root.hotspotEditDraft = text

                    background: Rectangle {
                        radius: root.largeLandscapeLayout ? 26 : (root.standardLandscapeLayout ? 20 : 17)
                        color: "#171717"
                        border.width: 1
                        border.color: "#1affffff"
                    }
                }
            }

            Column {
                width: parent.width
                spacing: root.settingsKeyboardRowSpacing

                Item {
                    width: 1
                    height: root.largeLandscapeLayout ? 12 : (root.standardLandscapeLayout ? 8 : 7)
                }

                Repeater {
                    model: root.wifiKeyboardRows

                    delegate: Row {
                        required property var modelData
                        x: (parent.width - implicitWidth) / 2
                        spacing: root.settingsKeyboardRowSpacing

                        Repeater {
                            model: modelData

                            delegate: Rectangle {
                                required property string modelData

                                width: root.wifiKeyWidth(modelData)
                                height: root.settingsKeyboardKeyHeight
                                radius: root.largeLandscapeLayout ? 20 : (root.standardLandscapeLayout ? 15 : 13)
                                color: wifiKeyArea.containsPress
                                       ? "#20ffffff"
                                       : ((modelData === "shift" && (root.wifiKeyboardShift || root.wifiKeyboardCapsLock))
                                          ? "#25414b"
                                          : "#171717")
                                border.width: 1
                                border.color: (modelData === "shift" && (root.wifiKeyboardShift || root.wifiKeyboardCapsLock))
                                              ? "#3fd0ff"
                                              : "#1affffff"
                                scale: wifiKeyArea.containsPress ? 0.985 : 1.0

                                Behavior on scale {
                                    NumberAnimation { duration: 120; easing.type: Easing.OutCubic }
                                }

                                Text {
                                    anchors.centerIn: parent
                                    text: root.wifiDisplayKeyLabel(modelData)
                                    color: "white"
                                    font.family: interMedium.font.family
                                    font.pixelSize: modelData === "space" ? root.settingsKeyboardSpaceTextSize : root.settingsKeyboardKeyTextSize
                                    renderType: Text.NativeRendering
                                }

                                MouseArea {
                                    id: wifiKeyArea
                                    anchors.fill: parent
                                    enabled: !wifiBridge.connecting
                                    pressAndHoldInterval: 450
                                    onPressed: root.wifiKeyboardLongPressHandled = false
                                    onClicked: {
                                            if (modelData === "shift" && root.wifiKeyboardLongPressHandled) {
                                                root.wifiKeyboardLongPressHandled = false
                                                return
                                            }
                                            root.wifiKeyboardInsert(modelData)
                                    }
                                    onPressAndHold: {
                                        if (modelData === "shift") {
                                            root.wifiKeyboardLongPressHandled = true
                                            root.wifiKeyboardToggleCapsLock()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            Item {
                width: 1
                height: root.largeLandscapeLayout ? 12 : (root.standardLandscapeLayout ? 8 : 0)
            }

            Row {
                width: parent.width
                height: root.settingsKeyboardButtonHeight
                spacing: root.largeLandscapeLayout ? 14 : (root.standardLandscapeLayout ? 10 : 9)

                Rectangle {
                    width: (parent.width - (root.largeLandscapeLayout ? 28 : (root.standardLandscapeLayout ? 20 : 18))) / 3
                    height: root.settingsKeyboardButtonHeight
                    radius: root.largeLandscapeLayout ? 26 : (root.standardLandscapeLayout ? 19 : 17)
                    color: wifiShowPasswordArea.containsPress ? "#20ffffff" : "#14ffffff"
                    border.width: 1
                    border.color: "#1affffff"
                    scale: wifiShowPasswordArea.containsPress ? 0.985 : 1.0

                    Behavior on scale {
                        NumberAnimation { duration: 140; easing.type: Easing.OutCubic }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: root.hotspotEditTarget === "password"
                              ? (root.hotspotPasswordVisible ? "Hide Password" : "Show Password")
                              : "Clear"
                        color: "white"
                        font.family: interMedium.font.family
                        font.pixelSize: root.largeLandscapeLayout ? 20 : (root.standardLandscapeLayout ? 15 : 13)
                        renderType: Text.NativeRendering
                    }

                    MouseArea {
                        id: wifiShowPasswordArea
                        anchors.fill: parent
                        enabled: !wifiBridge.connecting
                        onClicked: {
                            if (root.hotspotEditTarget === "password")
                                root.hotspotPasswordVisible = !root.hotspotPasswordVisible
                            else
                                root.hotspotEditDraft = ""
                        }
                    }
                }

                Rectangle {
                    width: (parent.width - (root.largeLandscapeLayout ? 28 : (root.standardLandscapeLayout ? 20 : 18))) / 3
                    height: root.settingsKeyboardButtonHeight
                    radius: root.largeLandscapeLayout ? 26 : (root.standardLandscapeLayout ? 19 : 17)
                    color: wifiConnectArea.containsPress && wifiConnectArea.enabled ? "#20ffffff" : "#111111"
                    border.width: 1
                    border.color: "#1affffff"
                    opacity: wifiConnectArea.enabled ? 1.0 : 0.45
                    scale: wifiConnectArea.containsPress && wifiConnectArea.enabled ? 0.985 : 1.0

                    Behavior on scale {
                        NumberAnimation { duration: 140; easing.type: Easing.OutCubic }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "Save"
                        color: "white"
                        font.family: interMedium.font.family
                        font.pixelSize: root.settingsKeyboardButtonTextSize
                        renderType: Text.NativeRendering
                    }

                    MouseArea {
                        id: wifiConnectArea
                        anchors.fill: parent
                        enabled: !wifiBridge.connecting
                                 && (root.hotspotEditTarget === "password"
                                     ? root.hotspotEditDraft.length >= 8
                                     : root.hotspotEditDraft.trim().length > 0)
                        onClicked: root.saveHotspotEdit()
                    }
                }

                Rectangle {
                    width: (parent.width - (root.largeLandscapeLayout ? 28 : (root.standardLandscapeLayout ? 20 : 18))) / 3
                    height: root.settingsKeyboardButtonHeight
                    radius: root.largeLandscapeLayout ? 26 : (root.standardLandscapeLayout ? 19 : 17)
                    color: wifiCancelArea.containsPress ? "#20ffffff" : "#14ffffff"
                    border.width: 1
                    border.color: "#1affffff"
                    scale: wifiCancelArea.containsPress ? 0.985 : 1.0

                    Behavior on scale {
                        NumberAnimation { duration: 140; easing.type: Easing.OutCubic }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "Cancel"
                        color: "white"
                        font.family: interMedium.font.family
                        font.pixelSize: root.settingsKeyboardButtonTextSize
                        renderType: Text.NativeRendering
                    }

                    MouseArea {
                        id: wifiCancelArea
                        anchors.fill: parent
                        enabled: !wifiBridge.connecting
                        onClicked: root.closeHotspotEdit()
                    }
                }
            }
        }
    }

    Rectangle {
        width: root.settingsKeyboardPopupWidth
        height: root.settingsKeyboardPopupHeight
        anchors.centerIn: parent
        radius: root.largeLandscapeLayout ? 36 : (root.standardLandscapeLayout ? 26 : 23)
        color: "#151515"
        border.width: 1
        border.color: "#1affffff"
        visible: root.wifiPasswordPopupOpen
        opacity: root.wifiPasswordPopupOpen ? 1.0 : 0.0
        scale: root.wifiPasswordPopupOpen ? 1.0 : 0.96
        z: 20001

        Behavior on opacity {
            NumberAnimation { duration: 220; easing.type: Easing.OutCubic }
        }

        Behavior on scale {
            NumberAnimation { duration: 240; easing.type: Easing.OutCubic }
        }

        MouseArea {
            anchors.fill: parent
        }

        Column {
            anchors.fill: parent
            anchors.margins: root.settingsKeyboardPopupMargin
            spacing: root.settingsKeyboardPopupSpacing

            Column {
                width: parent.width
                spacing: 4

                Text {
                    text: "Join " + root.wifiSelectedSsid
                    color: "white"
                    font.family: interBold.font.family
                    font.pixelSize: root.settingsKeyboardTitleSize
                    renderType: Text.NativeRendering
                    elide: Text.ElideRight
                }

                Text {
                    text: "Enter the Wi-Fi password using the on-screen keyboard."
                    color: "#8f9096"
                    font.family: interRegular.font.family
                    font.pixelSize: root.settingsKeyboardHintSize
                    width: parent.width
                    wrapMode: Text.WordWrap
                    renderType: Text.NativeRendering
                }
            }

            Column {
                width: parent.width
                spacing: 8

                Text {
                    text: "Password"
                    color: "#66ffffff"
                    font.family: interMedium.font.family
                    font.pixelSize: root.settingsKeyboardLabelSize
                    font.capitalization: Font.AllUppercase
                    font.letterSpacing: 2.2
                    renderType: Text.NativeRendering
                }

                TextField {
                    id: wifiPasswordField
                    width: parent.width
                    height: root.settingsKeyboardFieldHeight
                    text: root.wifiPassword
                    placeholderText: "Wi-Fi password"
                    echoMode: root.wifiPasswordVisible ? TextInput.Normal : TextInput.Password
                    enabled: !wifiBridge.connecting
                    color: "white"
                    font.family: interMedium.font.family
                    font.pixelSize: root.wifiPasswordVisible
                                    ? root.settingsKeyboardFieldTextSize
                                    : (root.largeLandscapeLayout ? 25 : (root.standardLandscapeLayout ? 19 : 17))
                    selectByMouse: true
                    leftPadding: root.largeLandscapeLayout ? 24 : (root.standardLandscapeLayout ? 18 : 15)
                    rightPadding: root.largeLandscapeLayout ? 24 : (root.standardLandscapeLayout ? 18 : 15)
                    onTextChanged: root.wifiPassword = text

                    background: Rectangle {
                        radius: root.largeLandscapeLayout ? 26 : (root.standardLandscapeLayout ? 20 : 17)
                        color: "#171717"
                        border.width: 1
                        border.color: "#1affffff"
                    }
                }
            }

            Column {
                width: parent.width
                spacing: root.settingsKeyboardRowSpacing

                Item {
                    width: 1
                    height: root.largeLandscapeLayout ? 12 : (root.standardLandscapeLayout ? 8 : 7)
                }

                Repeater {
                    model: root.wifiKeyboardRows

                    delegate: Row {
                        required property var modelData
                        x: (parent.width - implicitWidth) / 2
                        spacing: root.settingsKeyboardRowSpacing

                        Repeater {
                            model: modelData

                            delegate: Rectangle {
                                required property string modelData

                                width: root.wifiKeyWidth(modelData)
                                height: root.settingsKeyboardKeyHeight
                                radius: root.largeLandscapeLayout ? 20 : (root.standardLandscapeLayout ? 15 : 13)
                                color: wifiKeyArea.containsPress
                                       ? "#20ffffff"
                                       : ((modelData === "shift" && (root.wifiKeyboardShift || root.wifiKeyboardCapsLock))
                                          ? "#25414b"
                                          : "#171717")
                                border.width: 1
                                border.color: (modelData === "shift" && (root.wifiKeyboardShift || root.wifiKeyboardCapsLock))
                                              ? "#3fd0ff"
                                              : "#1affffff"
                                scale: wifiKeyArea.containsPress ? 0.985 : 1.0

                                Behavior on scale {
                                    NumberAnimation { duration: 120; easing.type: Easing.OutCubic }
                                }

                                Text {
                                    anchors.centerIn: parent
                                    text: root.wifiDisplayKeyLabel(modelData)
                                    color: "white"
                                    font.family: interMedium.font.family
                                    font.pixelSize: modelData === "space" ? root.settingsKeyboardSpaceTextSize : root.settingsKeyboardKeyTextSize
                                    renderType: Text.NativeRendering
                                }

                                MouseArea {
                                    id: wifiKeyArea
                                    anchors.fill: parent
                                    pressAndHoldInterval: 420
                                    onPressed: root.wifiKeyboardLongPressHandled = false
                                    onClicked: {
                                        if (modelData === "shift" && root.wifiKeyboardLongPressHandled) {
                                            root.wifiKeyboardLongPressHandled = false
                                            return
                                        }
                                        root.wifiKeyboardInsert(modelData)
                                    }
                                    onPressAndHold: {
                                        if (modelData !== "shift")
                                            return
                                        root.wifiKeyboardLongPressHandled = true
                                        root.wifiKeyboardToggleCapsLock()
                                    }
                                }
                            }
                        }
                    }
                }
            }

            Item {
                width: 1
                height: root.largeLandscapeLayout ? 12 : (root.standardLandscapeLayout ? 8 : 0)
            }

            Row {
                width: parent.width
                spacing: root.largeLandscapeLayout ? 14 : (root.standardLandscapeLayout ? 10 : 9)

                Rectangle {
                    width: (parent.width - (root.largeLandscapeLayout ? 28 : (root.standardLandscapeLayout ? 20 : 18))) / 3
                    height: root.settingsKeyboardButtonHeight
                    radius: root.largeLandscapeLayout ? 26 : (root.standardLandscapeLayout ? 19 : 17)
                    color: wifiShowPasswordArea2.containsPress ? "#20ffffff" : "#14ffffff"
                    border.width: 1
                    border.color: "#1affffff"
                    scale: wifiShowPasswordArea2.containsPress ? 0.985 : 1.0

                    Behavior on scale {
                        NumberAnimation { duration: 140; easing.type: Easing.OutCubic }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: root.wifiPasswordVisible ? "Hide Password" : "Show Password"
                        color: "white"
                        font.family: interMedium.font.family
                        font.pixelSize: root.largeLandscapeLayout ? 20 : (root.standardLandscapeLayout ? 15 : 14)
                        renderType: Text.NativeRendering
                    }

                    MouseArea {
                        id: wifiShowPasswordArea2
                        anchors.fill: parent
                        enabled: !wifiBridge.connecting
                        onClicked: root.wifiPasswordVisible = !root.wifiPasswordVisible
                    }
                }

                Rectangle {
                    width: (parent.width - (root.largeLandscapeLayout ? 28 : (root.standardLandscapeLayout ? 20 : 18))) / 3
                    height: root.settingsKeyboardButtonHeight
                    radius: root.largeLandscapeLayout ? 26 : (root.standardLandscapeLayout ? 19 : 17)
                    color: wifiConnectArea2.containsPress && wifiConnectArea2.enabled ? "#20ffffff" : "#111111"
                    border.width: 1
                    border.color: "#1affffff"
                    opacity: wifiConnectArea2.enabled ? 1.0 : 0.45
                    scale: wifiConnectArea2.containsPress && wifiConnectArea2.enabled ? 0.985 : 1.0

                    Behavior on scale {
                        NumberAnimation { duration: 140; easing.type: Easing.OutCubic }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: wifiBridge.connecting ? "Connecting..." : "Connect"
                        color: "white"
                        font.family: interMedium.font.family
                        font.pixelSize: root.settingsKeyboardButtonTextSize
                        renderType: Text.NativeRendering
                    }

                    MouseArea {
                        id: wifiConnectArea2
                        anchors.fill: parent
                        enabled: root.wifiPassword.length > 0 && !wifiBridge.connecting
                        onClicked: root.submitWifiConnect()
                    }
                }

                Rectangle {
                    width: (parent.width - (root.largeLandscapeLayout ? 28 : (root.standardLandscapeLayout ? 20 : 18))) / 3
                    height: root.settingsKeyboardButtonHeight
                    radius: root.largeLandscapeLayout ? 26 : (root.standardLandscapeLayout ? 19 : 17)
                    color: wifiCancelArea2.containsPress ? "#20ffffff" : "#14ffffff"
                    border.width: 1
                    border.color: "#1affffff"
                    scale: wifiCancelArea2.containsPress ? 0.985 : 1.0

                    Behavior on scale {
                        NumberAnimation { duration: 140; easing.type: Easing.OutCubic }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "Cancel"
                        color: "white"
                        font.family: interMedium.font.family
                        font.pixelSize: root.settingsKeyboardButtonTextSize
                        renderType: Text.NativeRendering
                    }

                    MouseArea {
                        id: wifiCancelArea2
                        anchors.fill: parent
                        enabled: !wifiBridge.connecting
                        onClicked: root.cancelWifiConnect()
                    }
                }
            }
        }
    }

    Rectangle {
        width: root.largeLandscapeLayout ? 660 : (root.standardLandscapeLayout ? 500 : (root.compactLandscapeLayout ? 360 : 408))
        height: root.largeLandscapeLayout ? (formatConfirmColumn.implicitHeight + 74) : (root.standardLandscapeLayout ? (formatConfirmColumn.implicitHeight + 60) : (root.compactLandscapeLayout ? (formatConfirmColumn.implicitHeight + 30) : 266))
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -10
        radius: root.largeLandscapeLayout ? 38 : (root.standardLandscapeLayout ? 30 : (root.compactLandscapeLayout ? 22 : 26))
        color: "#151515"
        border.width: 1
        border.color: "#1affffff"
        visible: root.formatConfirmOpen
        opacity: root.formatConfirmOpen ? 1.0 : 0.0
        scale: root.formatConfirmOpen ? 1.0 : 0.96
        z: 20001

        Behavior on opacity {
            NumberAnimation { duration: 220; easing.type: Easing.OutCubic }
        }

        Behavior on scale {
            NumberAnimation { duration: 240; easing.type: Easing.OutCubic }
        }

        Column {
            id: formatConfirmColumn
            anchors.fill: parent
            anchors.margins: root.largeLandscapeLayout ? 38 : (root.standardLandscapeLayout ? 30 : (root.compactLandscapeLayout ? 15 : 24))
            spacing: root.largeLandscapeLayout ? 26 : (root.standardLandscapeLayout ? 20 : (root.compactLandscapeLayout ? 10 : 16))

            Rectangle {
                width: root.largeLandscapeLayout ? 70 : (root.standardLandscapeLayout ? 52 : (root.compactLandscapeLayout ? 34 : 40))
                height: root.largeLandscapeLayout ? 70 : (root.standardLandscapeLayout ? 52 : (root.compactLandscapeLayout ? 34 : 40))
                radius: width / 2
                color: "#2a1717"
                border.width: 1
                border.color: "#4a2a2a"

                Text {
                    anchors.centerIn: parent
                    text: "!"
                    color: "white"
                    font.family: interBold.font.family
                    font.pixelSize: root.largeLandscapeLayout ? 32 : (root.standardLandscapeLayout ? 24 : (root.compactLandscapeLayout ? 16 : 18))
                    renderType: Text.NativeRendering
                }
            }

            Column {
                width: parent.width
                spacing: root.largeLandscapeLayout ? 9 : (root.standardLandscapeLayout ? 6 : 4)

                Text {
                    text: "Format Media?"
                    color: "white"
                    font.family: interBold.font.family
                    font.pixelSize: root.largeLandscapeLayout ? 40 : (root.standardLandscapeLayout ? 30 : (root.compactLandscapeLayout ? 21 : 24))
                    renderType: Text.NativeRendering
                }

                Text {
                    text: "All clips on the " + mediaBridge.mediaPromptLabel
                          + " will be permanently erased. The media will be formatted as "
                          + root.selectedMediaFormatOption
                          + ", keep its current drive name where the filesystem allows it, and mount again."
                    color: "#8f9096"
                    font.family: interRegular.font.family
                    font.pixelSize: root.largeLandscapeLayout ? 23 : (root.standardLandscapeLayout ? 17 : (root.compactLandscapeLayout ? 12 : 14))
                    wrapMode: Text.WordWrap
                    width: parent.width
                    renderType: Text.NativeRendering
                }
            }

            Row {
                spacing: root.largeLandscapeLayout ? 20 : (root.standardLandscapeLayout ? 14 : (root.compactLandscapeLayout ? 10 : 12))

                Rectangle {
                    width: root.largeLandscapeLayout ? 250 : (root.standardLandscapeLayout ? 190 : (root.compactLandscapeLayout ? 136 : 156))
                    height: root.largeLandscapeLayout ? 84 : (root.standardLandscapeLayout ? 64 : (root.compactLandscapeLayout ? 46 : 54))
                    radius: root.largeLandscapeLayout ? 28 : (root.standardLandscapeLayout ? 21 : (root.compactLandscapeLayout ? 15 : 18))
                    color: cancelFormatArea.containsPress ? "#20ffffff" : "#14ffffff"
                    border.width: 1
                    border.color: "#1affffff"
                    scale: cancelFormatArea.containsPress ? 0.985 : 1.0

                    Behavior on scale {
                        NumberAnimation { duration: 140; easing.type: Easing.OutCubic }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "Cancel"
                        color: "white"
                        font.family: interMedium.font.family
                        font.pixelSize: root.largeLandscapeLayout ? 25 : (root.standardLandscapeLayout ? 19 : (root.compactLandscapeLayout ? 13 : 16))
                        renderType: Text.NativeRendering
                    }

                    MouseArea {
                        id: cancelFormatArea
                        anchors.fill: parent
                        onClicked: root.formatConfirmOpen = false
                    }
                }

                Rectangle {
                    width: root.largeLandscapeLayout ? 292 : (root.standardLandscapeLayout ? 220 : (root.compactLandscapeLayout ? 164 : 192))
                    height: root.largeLandscapeLayout ? 84 : (root.standardLandscapeLayout ? 64 : (root.compactLandscapeLayout ? 46 : 54))
                    radius: root.largeLandscapeLayout ? 28 : (root.standardLandscapeLayout ? 21 : (root.compactLandscapeLayout ? 15 : 18))
                    color: confirmFormatArea.containsPress ? "#a32828" : "#8d2020"
                    border.width: 1
                    border.color: "#ba4a4a"
                    scale: confirmFormatArea.containsPress ? 0.985 : 1.0

                    Behavior on scale {
                        NumberAnimation { duration: 140; easing.type: Easing.OutCubic }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "Format Media"
                        color: "#ffd6d6"
                        font.family: interMedium.font.family
                        font.pixelSize: root.largeLandscapeLayout ? 25 : (root.standardLandscapeLayout ? 19 : (root.compactLandscapeLayout ? 13 : 16))
                        renderType: Text.NativeRendering
                    }

                    MouseArea {
                        id: confirmFormatArea
                        anchors.fill: parent
                        onClicked: root.executeFormatMedia()
                    }
                }
            }
        }
    }

    Rectangle {
        width: root.largeLandscapeLayout ? 620 : (root.standardLandscapeLayout ? 470 : 408)
        height: root.largeLandscapeLayout ? (formatSuccessColumn.implicitHeight + 74) : (root.standardLandscapeLayout ? (formatSuccessColumn.implicitHeight + 60) : 154)
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -10
        radius: root.largeLandscapeLayout ? 38 : (root.standardLandscapeLayout ? 30 : 26)
        color: "#151515"
        border.width: 1
        border.color: "#2634d399"
        visible: root.formatSuccessOpen
        opacity: root.formatSuccessOpen ? 1.0 : 0.0
        scale: root.formatSuccessOpen ? 1.0 : 0.96
        z: 20002

        Behavior on opacity {
            NumberAnimation { duration: 220; easing.type: Easing.OutCubic }
        }

        Behavior on scale {
            NumberAnimation { duration: 240; easing.type: Easing.OutCubic }
        }

        Column {
            id: formatSuccessColumn
            anchors.fill: parent
            anchors.margins: root.largeLandscapeLayout ? 38 : (root.standardLandscapeLayout ? 30 : 14)
            spacing: root.largeLandscapeLayout ? 26 : (root.standardLandscapeLayout ? 20 : 8)

            Row {
                width: parent.width
                spacing: root.largeLandscapeLayout ? 20 : (root.standardLandscapeLayout ? 14 : 12)

                Rectangle {
                    width: root.largeLandscapeLayout ? 70 : (root.standardLandscapeLayout ? 52 : 36)
                    height: root.largeLandscapeLayout ? 70 : (root.standardLandscapeLayout ? 52 : 36)
                    radius: width / 2
                    color: "#1834d399"
                    border.width: 1
                    border.color: "#6634d399"

                    Text {
                        anchors.centerIn: parent
                        text: "✓"
                        color: "#34d399"
                        font.family: interBold.font.family
                        font.pixelSize: root.largeLandscapeLayout ? 40 : (root.standardLandscapeLayout ? 30 : 22)
                        renderType: Text.NativeRendering
                    }
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Media Formatted"
                    color: "white"
                    font.family: interBold.font.family
                    font.pixelSize: root.largeLandscapeLayout ? 40 : (root.standardLandscapeLayout ? 30 : 24)
                    renderType: Text.NativeRendering
                }
            }

            Text {
                text: root.formatSuccessText
                color: "#8f9096"
                font.family: interRegular.font.family
                font.pixelSize: root.largeLandscapeLayout ? 23 : (root.standardLandscapeLayout ? 17 : 14)
                wrapMode: Text.WordWrap
                width: parent.width
                renderType: Text.NativeRendering
            }

            Rectangle {
                width: parent.width
                height: root.largeLandscapeLayout ? 84 : (root.standardLandscapeLayout ? 64 : 48)
                radius: root.largeLandscapeLayout ? 28 : (root.standardLandscapeLayout ? 21 : 18)
                color: formatSuccessCloseArea.containsPress ? "#2234d399" : "#14ffffff"
                border.width: 1
                border.color: "#2634d399"
                scale: formatSuccessCloseArea.containsPress ? 0.985 : 1.0

                Behavior on scale {
                    NumberAnimation { duration: 140; easing.type: Easing.OutCubic }
                }

                Text {
                    anchors.centerIn: parent
                    text: "OK"
                    color: "white"
                    font.family: interMedium.font.family
                    font.pixelSize: root.largeLandscapeLayout ? 25 : (root.standardLandscapeLayout ? 19 : 16)
                    renderType: Text.NativeRendering
                }

                MouseArea {
                    id: formatSuccessCloseArea
                    anchors.fill: parent
                    onClicked: root.formatSuccessOpen = false
                }
            }
        }
    }

    Rectangle {
        width: root.largeLandscapeLayout ? 660 : (root.standardLandscapeLayout ? 500 : (root.compactLandscapeLayout ? 360 : 408))
        height: root.largeLandscapeLayout ? (ejectConfirmColumn.implicitHeight + 74) : (root.standardLandscapeLayout ? (ejectConfirmColumn.implicitHeight + 60) : (root.compactLandscapeLayout ? (ejectConfirmColumn.implicitHeight + 30) : 248))
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -10
        radius: root.largeLandscapeLayout ? 38 : (root.standardLandscapeLayout ? 30 : (root.compactLandscapeLayout ? 22 : 26))
        color: "#151515"
        border.width: 1
        border.color: "#1affffff"
        visible: root.ejectConfirmOpen
        opacity: root.ejectConfirmOpen ? 1.0 : 0.0
        scale: root.ejectConfirmOpen ? 1.0 : 0.96
        z: 20001

        Behavior on opacity {
            NumberAnimation { duration: 220; easing.type: Easing.OutCubic }
        }

        Behavior on scale {
            NumberAnimation { duration: 240; easing.type: Easing.OutCubic }
        }

        Column {
            id: ejectConfirmColumn
            anchors.fill: parent
            anchors.margins: root.largeLandscapeLayout ? 38 : (root.standardLandscapeLayout ? 30 : (root.compactLandscapeLayout ? 15 : 24))
            spacing: root.largeLandscapeLayout ? 26 : (root.standardLandscapeLayout ? 20 : (root.compactLandscapeLayout ? 10 : 16))

            Rectangle {
                width: root.largeLandscapeLayout ? 70 : (root.standardLandscapeLayout ? 52 : (root.compactLandscapeLayout ? 34 : 40))
                height: root.largeLandscapeLayout ? 70 : (root.standardLandscapeLayout ? 52 : (root.compactLandscapeLayout ? 34 : 40))
                radius: width / 2
                color: "#1d1d1d"
                border.width: 1
                border.color: "#1affffff"

                Text {
                    anchors.centerIn: parent
                    text: "⏏"
                    color: "white"
                    font.family: interBold.font.family
                    font.pixelSize: root.largeLandscapeLayout ? 32 : (root.standardLandscapeLayout ? 24 : (root.compactLandscapeLayout ? 16 : 18))
                    renderType: Text.NativeRendering
                }
            }

            Column {
                width: parent.width
                spacing: root.largeLandscapeLayout ? 9 : (root.standardLandscapeLayout ? 6 : 4)

                Text {
                    text: "Eject Media?"
                    color: "white"
                    font.family: interBold.font.family
                    font.pixelSize: root.largeLandscapeLayout ? 40 : (root.standardLandscapeLayout ? 30 : (root.compactLandscapeLayout ? 21 : 24))
                    renderType: Text.NativeRendering
                }

                Text {
                    text: "Make sure recording and playback are stopped before removing the " + mediaBridge.mediaPromptLabel + "."
                    color: "#8f9096"
                    font.family: interRegular.font.family
                    font.pixelSize: root.largeLandscapeLayout ? 23 : (root.standardLandscapeLayout ? 17 : (root.compactLandscapeLayout ? 12 : 14))
                    wrapMode: Text.WordWrap
                    width: parent.width
                    renderType: Text.NativeRendering
                }
            }

            Row {
                spacing: root.largeLandscapeLayout ? 20 : (root.standardLandscapeLayout ? 14 : (root.compactLandscapeLayout ? 10 : 12))

                Rectangle {
                    width: root.largeLandscapeLayout ? 250 : (root.standardLandscapeLayout ? 190 : (root.compactLandscapeLayout ? 136 : 156))
                    height: root.largeLandscapeLayout ? 84 : (root.standardLandscapeLayout ? 64 : (root.compactLandscapeLayout ? 46 : 54))
                    radius: root.largeLandscapeLayout ? 28 : (root.standardLandscapeLayout ? 21 : (root.compactLandscapeLayout ? 15 : 18))
                    color: cancelEjectArea.containsPress ? "#20ffffff" : "#14ffffff"
                    border.width: 1
                    border.color: "#1affffff"
                    scale: cancelEjectArea.containsPress ? 0.985 : 1.0

                    Behavior on scale {
                        NumberAnimation { duration: 140; easing.type: Easing.OutCubic }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "Cancel"
                        color: "white"
                        font.family: interMedium.font.family
                        font.pixelSize: root.largeLandscapeLayout ? 25 : (root.standardLandscapeLayout ? 19 : (root.compactLandscapeLayout ? 13 : 16))
                        renderType: Text.NativeRendering
                    }

                    MouseArea {
                        id: cancelEjectArea
                        anchors.fill: parent
                        onClicked: root.ejectConfirmOpen = false
                    }
                }

                Rectangle {
                    width: root.largeLandscapeLayout ? 292 : (root.standardLandscapeLayout ? 220 : (root.compactLandscapeLayout ? 164 : 192))
                    height: root.largeLandscapeLayout ? 84 : (root.standardLandscapeLayout ? 64 : (root.compactLandscapeLayout ? 46 : 54))
                    radius: root.largeLandscapeLayout ? 28 : (root.standardLandscapeLayout ? 21 : (root.compactLandscapeLayout ? 15 : 18))
                    color: confirmEjectArea.containsPress ? "#20ffffff" : "#111111"
                    border.width: 1
                    border.color: "#1affffff"
                    scale: confirmEjectArea.containsPress ? 0.985 : 1.0

                    Behavior on scale {
                        NumberAnimation { duration: 140; easing.type: Easing.OutCubic }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "Eject Media"
                        color: "white"
                        font.family: interMedium.font.family
                        font.pixelSize: root.largeLandscapeLayout ? 25 : (root.standardLandscapeLayout ? 19 : (root.compactLandscapeLayout ? 13 : 16))
                        renderType: Text.NativeRendering
                    }

                    MouseArea {
                        id: confirmEjectArea
                        anchors.fill: parent
                        onClicked: root.executeEjectMedia()
                    }
                }
            }
        }
    }

    Rectangle {
        width: root.largeLandscapeLayout ? 540 : (root.compactLandscapeLayout ? 360 : 408)
        height: root.largeLandscapeLayout ? 288 : (root.compactLandscapeLayout ? 188 : 230)
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -10
        radius: root.largeLandscapeLayout ? 34 : (root.compactLandscapeLayout ? 22 : 26)
        color: "#151515"
        border.width: 1
        border.color: "#1affffff"
        visible: root.mediaMountErrorOpen
        opacity: root.mediaMountErrorOpen ? 1.0 : 0.0
        scale: root.mediaMountErrorOpen ? 1.0 : 0.96
        z: 20002

        Behavior on opacity {
            NumberAnimation { duration: 220; easing.type: Easing.OutCubic }
        }

        Behavior on scale {
            NumberAnimation { duration: 240; easing.type: Easing.OutCubic }
        }

        Column {
            anchors.fill: parent
            anchors.margins: root.largeLandscapeLayout ? 34 : (root.compactLandscapeLayout ? 18 : 24)
            spacing: root.largeLandscapeLayout ? 24 : (root.compactLandscapeLayout ? 10 : 16)

            Rectangle {
                width: root.largeLandscapeLayout ? 64 : 40
                height: root.largeLandscapeLayout ? 64 : 40
                radius: width / 2
                color: "#2a1717"
                border.width: 1
                border.color: "#4a2a2a"

                Text {
                    anchors.centerIn: parent
                    text: "!"
                    color: "white"
                    font.family: interBold.font.family
                    font.pixelSize: root.largeLandscapeLayout ? 30 : 18
                    renderType: Text.NativeRendering
                }
            }

            Column {
                width: parent.width
                spacing: 4

                Text {
                    text: "Mount Failed"
                    color: "white"
                    font.family: interBold.font.family
                    font.pixelSize: root.largeLandscapeLayout ? 34 : 24
                    renderType: Text.NativeRendering
                }

                Text {
                    text: root.mediaMountErrorText
                    color: "#8f9096"
                    font.family: interRegular.font.family
                    font.pixelSize: root.largeLandscapeLayout ? 20 : 14
                    wrapMode: Text.WordWrap
                    width: parent.width
                    renderType: Text.NativeRendering
                }
            }

            Rectangle {
                width: parent.width
                height: root.largeLandscapeLayout ? 76 : 54
                radius: root.largeLandscapeLayout ? 26 : 18
                color: closeMediaMountErrorArea.containsPress ? "#20ffffff" : "#111111"
                border.width: 1
                border.color: "#1affffff"
                scale: closeMediaMountErrorArea.containsPress ? 0.985 : 1.0

                Behavior on scale {
                    NumberAnimation { duration: 140; easing.type: Easing.OutCubic }
                }

                Text {
                    anchors.centerIn: parent
                    text: "OK"
                    color: "white"
                    font.family: interMedium.font.family
                    font.pixelSize: root.largeLandscapeLayout ? 24 : 16
                    renderType: Text.NativeRendering
                }

                MouseArea {
                    id: closeMediaMountErrorArea
                    anchors.fill: parent
                    onClicked: root.mediaMountErrorOpen = false
                }
            }
        }
    }

    Rectangle {
        width: root.largeLandscapeLayout ? 660 : (root.standardLandscapeLayout ? 500 : (root.compactLandscapeLayout ? 360 : 408))
        height: root.largeLandscapeLayout ? (powerConfirmColumn.implicitHeight + 74) : (root.standardLandscapeLayout ? (powerConfirmColumn.implicitHeight + 60) : (root.compactLandscapeLayout ? (powerConfirmColumn.implicitHeight + 32) : 248))
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -10
        radius: root.largeLandscapeLayout ? 38 : (root.standardLandscapeLayout ? 30 : (root.compactLandscapeLayout ? 22 : 26))
        color: "#151515"
        border.width: 1
        border.color: "#1affffff"
        visible: root.powerConfirmOpen
        opacity: root.powerConfirmOpen ? 1.0 : 0.0
        scale: root.powerConfirmOpen ? 1.0 : 0.96
        z: 20001

        Behavior on opacity {
            NumberAnimation { duration: 220; easing.type: Easing.OutCubic }
        }

        Behavior on scale {
            NumberAnimation { duration: 240; easing.type: Easing.OutCubic }
        }

        Column {
            id: powerConfirmColumn
            anchors.fill: parent
            anchors.margins: root.largeLandscapeLayout ? 38 : (root.standardLandscapeLayout ? 30 : (root.compactLandscapeLayout ? 16 : 24))
            spacing: root.largeLandscapeLayout ? 26 : (root.standardLandscapeLayout ? 20 : (root.compactLandscapeLayout ? 10 : 16))

            Rectangle {
                width: root.largeLandscapeLayout ? 70 : (root.standardLandscapeLayout ? 52 : (root.compactLandscapeLayout ? 34 : 40))
                height: root.largeLandscapeLayout ? 70 : (root.standardLandscapeLayout ? 52 : (root.compactLandscapeLayout ? 34 : 40))
                radius: width / 2
                color: root.pendingPowerAction === "shutdown" ? "#2a1717" : "#1d1d1d"
                border.width: 1
                border.color: root.pendingPowerAction === "shutdown" ? "#4a2a2a" : "#1affffff"

                Text {
                    anchors.centerIn: parent
                    text: root.pendingPowerAction === "shutdown" ? "!" : "↻"
                    color: "white"
                    font.family: interBold.font.family
                    font.pixelSize: root.largeLandscapeLayout ? 32 : (root.standardLandscapeLayout ? 24 : (root.compactLandscapeLayout ? 16 : 18))
                    renderType: Text.NativeRendering
                }
            }

            Column {
                width: parent.width
                spacing: root.largeLandscapeLayout ? 9 : (root.standardLandscapeLayout ? 6 : 4)

                Text {
                    text: root.powerActionTitle()
                    color: "white"
                    font.family: interBold.font.family
                    font.pixelSize: root.largeLandscapeLayout ? 40 : (root.standardLandscapeLayout ? 30 : (root.compactLandscapeLayout ? 21 : 24))
                    renderType: Text.NativeRendering
                }

                Text {
                    text: root.powerActionDescription()
                    color: "#8f9096"
                    font.family: interRegular.font.family
                    font.pixelSize: root.largeLandscapeLayout ? 23 : (root.standardLandscapeLayout ? 17 : (root.compactLandscapeLayout ? 12 : 14))
                    wrapMode: Text.WordWrap
                    width: parent.width
                    renderType: Text.NativeRendering
                }
            }

            Row {
                spacing: root.largeLandscapeLayout ? 20 : (root.standardLandscapeLayout ? 14 : (root.compactLandscapeLayout ? 10 : 12))

                Rectangle {
                    width: root.largeLandscapeLayout ? 250 : (root.standardLandscapeLayout ? 190 : (root.compactLandscapeLayout ? 136 : 156))
                    height: root.largeLandscapeLayout ? 84 : (root.standardLandscapeLayout ? 64 : (root.compactLandscapeLayout ? 46 : 54))
                    radius: root.largeLandscapeLayout ? 28 : (root.standardLandscapeLayout ? 21 : (root.compactLandscapeLayout ? 15 : 18))
                    color: cancelPowerArea.containsPress ? "#20ffffff" : "#14ffffff"
                    border.width: 1
                    border.color: "#1affffff"
                    scale: cancelPowerArea.containsPress ? 0.985 : 1.0

                    Behavior on scale {
                        NumberAnimation { duration: 140; easing.type: Easing.OutCubic }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "Cancel"
                        color: "white"
                        font.family: interMedium.font.family
                        font.pixelSize: root.largeLandscapeLayout ? 25 : (root.standardLandscapeLayout ? 19 : (root.compactLandscapeLayout ? 13 : 16))
                        renderType: Text.NativeRendering
                    }

                    MouseArea {
                        id: cancelPowerArea
                        anchors.fill: parent
                        onClicked: root.powerConfirmOpen = false
                    }
                }

                Rectangle {
                    width: root.largeLandscapeLayout ? 292 : (root.standardLandscapeLayout ? 220 : (root.compactLandscapeLayout ? 164 : 192))
                    height: root.largeLandscapeLayout ? 84 : (root.standardLandscapeLayout ? 64 : (root.compactLandscapeLayout ? 46 : 54))
                    radius: root.largeLandscapeLayout ? 28 : (root.standardLandscapeLayout ? 21 : (root.compactLandscapeLayout ? 15 : 18))
                    color: confirmPowerArea.containsPress
                           ? (root.pendingPowerAction === "shutdown" ? "#a32828" : "#20ffffff")
                           : (root.pendingPowerAction === "shutdown" ? "#8d2020" : "#111111")
                    border.width: 1
                    border.color: root.pendingPowerAction === "shutdown" ? "#ba4a4a" : "#1affffff"
                    scale: confirmPowerArea.containsPress ? 0.985 : 1.0

                    Behavior on scale {
                        NumberAnimation { duration: 140; easing.type: Easing.OutCubic }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: root.powerActionButtonLabel()
                        color: root.pendingPowerAction === "shutdown" ? "#ffd6d6" : "white"
                        font.family: interMedium.font.family
                        font.pixelSize: root.largeLandscapeLayout ? 25 : (root.standardLandscapeLayout ? 19 : (root.compactLandscapeLayout ? 13 : 16))
                        renderType: Text.NativeRendering
                    }

                    MouseArea {
                        id: confirmPowerArea
                        anchors.fill: parent
                        onClicked: root.executePendingPowerAction()
                    }
                }
            }
        }
    }

    Rectangle {
        width: root.largeLandscapeLayout ? 540 : 408
        height: root.largeLandscapeLayout ? 320 : 246
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -10
        radius: root.largeLandscapeLayout ? 34 : 26
        color: "#151515"
        border.width: 1
        border.color: "#1affffff"
        visible: root.powerErrorOpen
        opacity: root.powerErrorOpen ? 1.0 : 0.0
        scale: root.powerErrorOpen ? 1.0 : 0.96
        z: 20002

        Behavior on opacity {
            NumberAnimation { duration: 220; easing.type: Easing.OutCubic }
        }

        Behavior on scale {
            NumberAnimation { duration: 240; easing.type: Easing.OutCubic }
        }

        Column {
            anchors.fill: parent
            anchors.margins: root.largeLandscapeLayout ? 34 : 24
            spacing: root.largeLandscapeLayout ? 24 : 16

            Text {
                text: "Power Action Failed"
                color: "white"
                font.family: interBold.font.family
                font.pixelSize: root.largeLandscapeLayout ? 34 : (root.compactLandscapeLayout ? 21 : 24)
                renderType: Text.NativeRendering
            }

            Text {
                text: root.powerErrorText
                color: "#8f9096"
                font.family: interRegular.font.family
                font.pixelSize: root.largeLandscapeLayout ? 20 : (root.compactLandscapeLayout ? 12 : 14)
                wrapMode: Text.WordWrap
                width: parent.width
                renderType: Text.NativeRendering
            }

            Rectangle {
                width: parent.width
                height: root.largeLandscapeLayout ? 76 : (root.compactLandscapeLayout ? 46 : 54)
                radius: root.largeLandscapeLayout ? 26 : (root.compactLandscapeLayout ? 15 : 18)
                color: powerErrorCloseArea.containsPress ? "#20ffffff" : "#14ffffff"
                border.width: 1
                border.color: "#1affffff"
                scale: powerErrorCloseArea.containsPress ? 0.985 : 1.0

                Behavior on scale {
                    NumberAnimation { duration: 140; easing.type: Easing.OutCubic }
                }

                Text {
                    anchors.centerIn: parent
                    text: "OK"
                    color: "white"
                    font.family: interMedium.font.family
                    font.pixelSize: root.largeLandscapeLayout ? 24 : (root.compactLandscapeLayout ? 13 : 16)
                    renderType: Text.NativeRendering
                }

                MouseArea {
                    id: powerErrorCloseArea
                    anchors.fill: parent
                    onClicked: root.powerErrorOpen = false
                }
            }
        }
    }

    Rectangle {
        width: root.largeLandscapeLayout ? 620 : (root.standardLandscapeLayout ? 470 : (root.compactLandscapeLayout ? 340 : 408))
        height: root.largeLandscapeLayout ? (thermalApplySuccessColumn.implicitHeight + 74) : (root.standardLandscapeLayout ? (thermalApplySuccessColumn.implicitHeight + 60) : (root.compactLandscapeLayout ? (thermalApplySuccessColumn.implicitHeight + 30) : 222))
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -10
        radius: root.largeLandscapeLayout ? 38 : (root.standardLandscapeLayout ? 30 : (root.compactLandscapeLayout ? 20 : 26))
        color: "#151515"
        border.width: 1
        border.color: "#1affffff"
        visible: root.thermalApplySuccessOpen
        opacity: root.thermalApplySuccessOpen ? 1.0 : 0.0
        scale: root.thermalApplySuccessOpen ? 1.0 : 0.96
        z: 20002

        Behavior on opacity {
            NumberAnimation { duration: 220; easing.type: Easing.OutCubic }
        }

        Behavior on scale {
            NumberAnimation { duration: 240; easing.type: Easing.OutCubic }
        }

        Column {
            id: thermalApplySuccessColumn
            anchors.fill: parent
            anchors.margins: root.largeLandscapeLayout ? 38 : (root.standardLandscapeLayout ? 30 : (root.compactLandscapeLayout ? 15 : 24))
            spacing: root.largeLandscapeLayout ? 26 : (root.standardLandscapeLayout ? 20 : (root.compactLandscapeLayout ? 8 : 16))

            Text {
                text: "Fan Mode Saved"
                color: "white"
                font.family: interBold.font.family
                font.pixelSize: root.largeLandscapeLayout ? 40 : (root.standardLandscapeLayout ? 30 : (root.compactLandscapeLayout ? 20 : 24))
                renderType: Text.NativeRendering
            }

            Text {
                text: systemActionBridge.fanMode + " is ready. Restart the camera to apply the new thermal profile."
                color: "#8f9096"
                font.family: interRegular.font.family
                font.pixelSize: root.largeLandscapeLayout ? 23 : (root.standardLandscapeLayout ? 17 : (root.compactLandscapeLayout ? 12 : 14))
                wrapMode: Text.WordWrap
                width: parent.width
                renderType: Text.NativeRendering
            }

            Rectangle {
                width: parent.width
                height: root.largeLandscapeLayout ? 84 : (root.standardLandscapeLayout ? 64 : (root.compactLandscapeLayout ? 44 : 54))
                radius: root.largeLandscapeLayout ? 28 : (root.standardLandscapeLayout ? 21 : (root.compactLandscapeLayout ? 14 : 18))
                color: thermalApplySuccessCloseArea.containsPress ? "#20ffffff" : "#14ffffff"
                border.width: 1
                border.color: "#1affffff"
                scale: thermalApplySuccessCloseArea.containsPress ? 0.985 : 1.0

                Behavior on scale {
                    NumberAnimation { duration: 140; easing.type: Easing.OutCubic }
                }

                Text {
                    anchors.centerIn: parent
                    text: "OK"
                    color: "white"
                    font.family: interMedium.font.family
                    font.pixelSize: root.largeLandscapeLayout ? 25 : (root.standardLandscapeLayout ? 19 : (root.compactLandscapeLayout ? 13 : 16))
                    renderType: Text.NativeRendering
                }

                MouseArea {
                    id: thermalApplySuccessCloseArea
                    anchors.fill: parent
                    onClicked: root.thermalApplySuccessOpen = false
                }
            }
        }
    }

    Rectangle {
        width: root.largeLandscapeLayout ? 620 : (root.standardLandscapeLayout ? 470 : (root.compactLandscapeLayout ? 340 : 408))
        height: root.largeLandscapeLayout ? (thermalApplyErrorColumn.implicitHeight + 74) : (root.standardLandscapeLayout ? (thermalApplyErrorColumn.implicitHeight + 60) : (root.compactLandscapeLayout ? (thermalApplyErrorColumn.implicitHeight + 30) : 246))
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -10
        radius: root.largeLandscapeLayout ? 38 : (root.standardLandscapeLayout ? 30 : (root.compactLandscapeLayout ? 20 : 26))
        color: "#151515"
        border.width: 1
        border.color: "#1affffff"
        visible: root.thermalApplyErrorOpen
        opacity: root.thermalApplyErrorOpen ? 1.0 : 0.0
        scale: root.thermalApplyErrorOpen ? 1.0 : 0.96
        z: 20002

        Behavior on opacity {
            NumberAnimation { duration: 220; easing.type: Easing.OutCubic }
        }

        Behavior on scale {
            NumberAnimation { duration: 240; easing.type: Easing.OutCubic }
        }

        Column {
            id: thermalApplyErrorColumn
            anchors.fill: parent
            anchors.margins: root.largeLandscapeLayout ? 38 : (root.standardLandscapeLayout ? 30 : (root.compactLandscapeLayout ? 15 : 24))
            spacing: root.largeLandscapeLayout ? 26 : (root.standardLandscapeLayout ? 20 : (root.compactLandscapeLayout ? 8 : 16))

            Text {
                text: "Thermal Update Failed"
                color: "white"
                font.family: interBold.font.family
                font.pixelSize: root.largeLandscapeLayout ? 40 : (root.standardLandscapeLayout ? 30 : (root.compactLandscapeLayout ? 20 : 24))
                renderType: Text.NativeRendering
            }

            Text {
                text: root.thermalApplyErrorText
                color: "#8f9096"
                font.family: interRegular.font.family
                font.pixelSize: root.largeLandscapeLayout ? 23 : (root.standardLandscapeLayout ? 17 : (root.compactLandscapeLayout ? 12 : 14))
                wrapMode: Text.WordWrap
                width: parent.width
                renderType: Text.NativeRendering
            }

            Rectangle {
                width: parent.width
                height: root.largeLandscapeLayout ? 84 : (root.standardLandscapeLayout ? 64 : (root.compactLandscapeLayout ? 44 : 54))
                radius: root.largeLandscapeLayout ? 28 : (root.standardLandscapeLayout ? 21 : (root.compactLandscapeLayout ? 14 : 18))
                color: thermalApplyErrorCloseArea.containsPress ? "#20ffffff" : "#14ffffff"
                border.width: 1
                border.color: "#1affffff"
                scale: thermalApplyErrorCloseArea.containsPress ? 0.985 : 1.0

                Behavior on scale {
                    NumberAnimation { duration: 140; easing.type: Easing.OutCubic }
                }

                Text {
                    anchors.centerIn: parent
                    text: "OK"
                    color: "white"
                    font.family: interMedium.font.family
                    font.pixelSize: root.largeLandscapeLayout ? 25 : (root.standardLandscapeLayout ? 19 : (root.compactLandscapeLayout ? 13 : 16))
                    renderType: Text.NativeRendering
                }

                MouseArea {
                    id: thermalApplyErrorCloseArea
                    anchors.fill: parent
                    onClicked: root.thermalApplyErrorOpen = false
                }
            }
        }
    }

    Rectangle {
        width: root.largeLandscapeLayout ? 620 : (root.standardLandscapeLayout ? 470 : (root.compactLandscapeLayout ? 340 : 408))
        height: root.largeLandscapeLayout ? (timeApplySuccessColumn.implicitHeight + 74) : (root.standardLandscapeLayout ? (timeApplySuccessColumn.implicitHeight + 60) : (root.compactLandscapeLayout ? (timeApplySuccessColumn.implicitHeight + 30) : 230))
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -10
        radius: root.largeLandscapeLayout ? 38 : (root.standardLandscapeLayout ? 30 : (root.compactLandscapeLayout ? 20 : 26))
        color: "#151515"
        border.width: 1
        border.color: "#1affffff"
        visible: root.timeApplySuccessOpen
        opacity: root.timeApplySuccessOpen ? 1.0 : 0.0
        scale: root.timeApplySuccessOpen ? 1.0 : 0.96
        z: 20002

        Behavior on opacity {
            NumberAnimation { duration: 220; easing.type: Easing.OutCubic }
        }

        Behavior on scale {
            NumberAnimation { duration: 240; easing.type: Easing.OutCubic }
        }

        Column {
            id: timeApplySuccessColumn
            anchors.fill: parent
            anchors.margins: root.largeLandscapeLayout ? 38 : (root.standardLandscapeLayout ? 30 : (root.compactLandscapeLayout ? 15 : 24))
            spacing: root.largeLandscapeLayout ? 26 : (root.standardLandscapeLayout ? 20 : (root.compactLandscapeLayout ? 8 : 16))

            Text {
                text: "Date & Time Applied"
                color: "white"
                font.family: interBold.font.family
                font.pixelSize: root.largeLandscapeLayout ? 40 : (root.standardLandscapeLayout ? 30 : (root.compactLandscapeLayout ? 20 : 24))
                renderType: Text.NativeRendering
            }

            Text {
                text: "The camera clock and RTC have been updated successfully."
                color: "#8f9096"
                font.family: interRegular.font.family
                font.pixelSize: root.largeLandscapeLayout ? 23 : (root.standardLandscapeLayout ? 17 : (root.compactLandscapeLayout ? 12 : 14))
                wrapMode: Text.WordWrap
                width: parent.width
                renderType: Text.NativeRendering
            }

            Rectangle {
                width: parent.width
                height: root.largeLandscapeLayout ? 84 : (root.standardLandscapeLayout ? 64 : (root.compactLandscapeLayout ? 44 : 54))
                radius: root.largeLandscapeLayout ? 28 : (root.standardLandscapeLayout ? 21 : (root.compactLandscapeLayout ? 14 : 18))
                color: timeApplySuccessCloseArea.containsPress ? "#20ffffff" : "#14ffffff"
                border.width: 1
                border.color: "#1affffff"
                scale: timeApplySuccessCloseArea.containsPress ? 0.985 : 1.0

                Behavior on scale {
                    NumberAnimation { duration: 140; easing.type: Easing.OutCubic }
                }

                Text {
                    anchors.centerIn: parent
                    text: "OK"
                    color: "white"
                    font.family: interMedium.font.family
                    font.pixelSize: root.largeLandscapeLayout ? 25 : (root.standardLandscapeLayout ? 19 : (root.compactLandscapeLayout ? 13 : 16))
                    renderType: Text.NativeRendering
                }

                MouseArea {
                    id: timeApplySuccessCloseArea
                    anchors.fill: parent
                    onClicked: root.timeApplySuccessOpen = false
                }
            }
        }
    }

    Rectangle {
        width: root.largeLandscapeLayout ? 620 : (root.standardLandscapeLayout ? 470 : (root.compactLandscapeLayout ? 340 : 408))
        height: root.largeLandscapeLayout ? (ejectErrorColumn.implicitHeight + 74) : (root.standardLandscapeLayout ? (ejectErrorColumn.implicitHeight + 60) : (root.compactLandscapeLayout ? (ejectErrorColumn.implicitHeight + 30) : 246))
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -10
        radius: root.largeLandscapeLayout ? 38 : (root.standardLandscapeLayout ? 30 : (root.compactLandscapeLayout ? 20 : 26))
        color: "#151515"
        border.width: 1
        border.color: "#1affffff"
        visible: root.ejectErrorOpen
        opacity: root.ejectErrorOpen ? 1.0 : 0.0
        scale: root.ejectErrorOpen ? 1.0 : 0.96
        z: 20002

        Behavior on opacity {
            NumberAnimation { duration: 220; easing.type: Easing.OutCubic }
        }

        Behavior on scale {
            NumberAnimation { duration: 240; easing.type: Easing.OutCubic }
        }

        Column {
            id: ejectErrorColumn
            anchors.fill: parent
            anchors.margins: root.largeLandscapeLayout ? 38 : (root.standardLandscapeLayout ? 30 : (root.compactLandscapeLayout ? 15 : 24))
            spacing: root.largeLandscapeLayout ? 26 : (root.standardLandscapeLayout ? 20 : (root.compactLandscapeLayout ? 8 : 16))

            Text {
                text: "Eject Failed"
                color: "white"
                font.family: interBold.font.family
                font.pixelSize: root.largeLandscapeLayout ? 40 : (root.standardLandscapeLayout ? 30 : (root.compactLandscapeLayout ? 20 : 24))
                renderType: Text.NativeRendering
            }

            Text {
                text: root.ejectErrorText
                color: "#8f9096"
                font.family: interRegular.font.family
                font.pixelSize: root.largeLandscapeLayout ? 23 : (root.standardLandscapeLayout ? 17 : (root.compactLandscapeLayout ? 12 : 14))
                wrapMode: Text.WordWrap
                width: parent.width
                renderType: Text.NativeRendering
            }

            Rectangle {
                width: parent.width
                height: root.largeLandscapeLayout ? 84 : (root.standardLandscapeLayout ? 64 : (root.compactLandscapeLayout ? 44 : 54))
                radius: root.largeLandscapeLayout ? 28 : (root.standardLandscapeLayout ? 21 : (root.compactLandscapeLayout ? 14 : 18))
                color: ejectErrorCloseArea.containsPress ? "#20ffffff" : "#14ffffff"
                border.width: 1
                border.color: "#1affffff"
                scale: ejectErrorCloseArea.containsPress ? 0.985 : 1.0

                Behavior on scale {
                    NumberAnimation { duration: 140; easing.type: Easing.OutCubic }
                }

                Text {
                    anchors.centerIn: parent
                    text: "OK"
                    color: "white"
                    font.family: interMedium.font.family
                    font.pixelSize: root.largeLandscapeLayout ? 25 : (root.standardLandscapeLayout ? 19 : (root.compactLandscapeLayout ? 13 : 16))
                    renderType: Text.NativeRendering
                }

                MouseArea {
                    id: ejectErrorCloseArea
                    anchors.fill: parent
                    onClicked: root.ejectErrorOpen = false
                }
            }
        }
    }

    Rectangle {
        width: root.largeLandscapeLayout ? 620 : (root.standardLandscapeLayout ? 470 : 408)
        height: root.largeLandscapeLayout ? (formatErrorColumn.implicitHeight + 74) : (root.standardLandscapeLayout ? (formatErrorColumn.implicitHeight + 60) : 246)
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -10
        radius: root.largeLandscapeLayout ? 38 : (root.standardLandscapeLayout ? 30 : 26)
        color: "#151515"
        border.width: 1
        border.color: "#1affffff"
        visible: root.formatErrorOpen
        opacity: root.formatErrorOpen ? 1.0 : 0.0
        scale: root.formatErrorOpen ? 1.0 : 0.96
        z: 20002

        Behavior on opacity {
            NumberAnimation { duration: 220; easing.type: Easing.OutCubic }
        }

        Behavior on scale {
            NumberAnimation { duration: 240; easing.type: Easing.OutCubic }
        }

        Column {
            id: formatErrorColumn
            anchors.fill: parent
            anchors.margins: root.largeLandscapeLayout ? 38 : (root.standardLandscapeLayout ? 30 : 24)
            spacing: root.largeLandscapeLayout ? 26 : (root.standardLandscapeLayout ? 20 : 16)

            Text {
                text: "Format Failed"
                color: "white"
                font.family: interBold.font.family
                font.pixelSize: root.largeLandscapeLayout ? 40 : (root.standardLandscapeLayout ? 30 : 24)
                renderType: Text.NativeRendering
            }

            Text {
                text: root.formatErrorText
                color: "#8f9096"
                font.family: interRegular.font.family
                font.pixelSize: root.largeLandscapeLayout ? 23 : (root.standardLandscapeLayout ? 17 : 14)
                wrapMode: Text.WordWrap
                width: parent.width
                renderType: Text.NativeRendering
            }

            Rectangle {
                width: parent.width
                height: root.largeLandscapeLayout ? 84 : (root.standardLandscapeLayout ? 64 : 54)
                radius: root.largeLandscapeLayout ? 28 : (root.standardLandscapeLayout ? 21 : 18)
                color: formatErrorCloseArea.containsPress ? "#20ffffff" : "#14ffffff"
                border.width: 1
                border.color: "#1affffff"
                scale: formatErrorCloseArea.containsPress ? 0.985 : 1.0

                Behavior on scale {
                    NumberAnimation { duration: 140; easing.type: Easing.OutCubic }
                }

                Text {
                    anchors.centerIn: parent
                    text: "OK"
                    color: "white"
                    font.family: interMedium.font.family
                    font.pixelSize: root.largeLandscapeLayout ? 25 : (root.standardLandscapeLayout ? 19 : 16)
                    renderType: Text.NativeRendering
                }

                MouseArea {
                    id: formatErrorCloseArea
                    anchors.fill: parent
                    onClicked: root.formatErrorOpen = false
                }
            }
        }
    }

    Rectangle {
        width: root.largeLandscapeLayout ? 620 : 408
        height: root.largeLandscapeLayout ? 320 : 246
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -10
        radius: root.largeLandscapeLayout ? 38 : 26
        color: "#151515"
        border.width: 1
        border.color: "#1affffff"
        visible: root.timeApplyErrorOpen
        opacity: root.timeApplyErrorOpen ? 1.0 : 0.0
        scale: root.timeApplyErrorOpen ? 1.0 : 0.96
        z: 20002

        Behavior on opacity {
            NumberAnimation { duration: 220; easing.type: Easing.OutCubic }
        }

        Behavior on scale {
            NumberAnimation { duration: 240; easing.type: Easing.OutCubic }
        }

        Column {
            anchors.fill: parent
            anchors.margins: root.largeLandscapeLayout ? 38 : 24
            spacing: root.largeLandscapeLayout ? 26 : 16

            Text {
                text: "Time Update Failed"
                color: "white"
                font.family: interBold.font.family
                font.pixelSize: root.largeLandscapeLayout ? 40 : (root.standardLandscapeLayout ? 30 : 24)
                renderType: Text.NativeRendering
            }

            Text {
                text: root.timeApplyErrorText
                color: "#8f9096"
                font.family: interRegular.font.family
                font.pixelSize: root.largeLandscapeLayout ? 23 : (root.standardLandscapeLayout ? 17 : 14)
                wrapMode: Text.WordWrap
                width: parent.width
                renderType: Text.NativeRendering
            }

            Rectangle {
                width: parent.width
                height: root.largeLandscapeLayout ? 84 : (root.standardLandscapeLayout ? 64 : 54)
                radius: root.largeLandscapeLayout ? 28 : (root.standardLandscapeLayout ? 21 : 18)
                color: timeApplyErrorCloseArea.containsPress ? "#20ffffff" : "#14ffffff"
                border.width: 1
                border.color: "#1affffff"
                scale: timeApplyErrorCloseArea.containsPress ? 0.985 : 1.0

                Behavior on scale {
                    NumberAnimation { duration: 140; easing.type: Easing.OutCubic }
                }

                Text {
                    anchors.centerIn: parent
                    text: "OK"
                    color: "white"
                    font.family: interMedium.font.family
                    font.pixelSize: root.largeLandscapeLayout ? 25 : (root.standardLandscapeLayout ? 19 : 16)
                    renderType: Text.NativeRendering
                }

                MouseArea {
                    id: timeApplyErrorCloseArea
                    anchors.fill: parent
                    onClicked: root.timeApplyErrorOpen = false
                }
            }
        }
    }
}
