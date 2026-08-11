import QtQuick

Rectangle {
    id: root

    property string title: ""
    property string titleIconSource: ""
    property string description: ""
    property bool enabled: false
    property bool available: true
    property bool centerToggleVertically: false
    property bool favoriteEnabled: false
    property bool favorited: false
    property bool landscapeCompact: typeof displayConfigBridge !== "undefined"
                                    && displayConfigBridge.uiLayout === "landscape_compact"
    property bool mediumLandscape: typeof displayConfigBridge !== "undefined"
                                   && displayConfigBridge.uiLayout === "landscape_medium"
    property bool largeLandscape: typeof displayConfigBridge !== "undefined"
                                  && displayConfigBridge.uiLayout === "landscape_large"
    property bool standardLandscape: typeof displayConfigBridge !== "undefined"
                                     && displayConfigBridge.uiLayout === "landscape"
    property bool regularLandscape: mediumLandscape || standardLandscape || largeLandscape
    property bool compact: landscapeCompact || regularLandscape

    property string choice1Label: ""
    property string choice1Value: ""
    property var choice1Options: []

    property string choice2Label: ""
    property string choice2Value: ""
    property var choice2Options: []

    property string choice3Label: ""
    property string choice3Value: ""
    property var choice3Options: []

    property Item popupParent: null
    property var dropdownController: null

    readonly property int choiceCount: (choice1Label.length > 0 ? 1 : 0)
                                     + (choice2Label.length > 0 ? 1 : 0)
                                     + (choice3Label.length > 0 ? 1 : 0)
    readonly property int dropdownRows: Math.max(1, Math.ceil(choiceCount / 2))
    readonly property int cardMargin: largeLandscape ? 26 : (standardLandscape ? 18 : (compact ? 14 : 20))
    readonly property int dropdownTopMargin: largeLandscape ? 102 : (standardLandscape ? 74 : (compact ? 56 : 70))
    readonly property int dropdownRowSpacing: largeLandscape ? 18 : (standardLandscape ? 12 : (compact ? 8 : 10))
    readonly property int dropdownChoiceHeight: largeLandscape ? 92 : (standardLandscape ? 70 : (compact ? 58 : 72))
    readonly property int dropdownBottomPadding: largeLandscape ? 28 : (standardLandscape ? 20 : (compact ? 14 : 20))
    readonly property int dropdownContentHeight: cardMargin
                                                + dropdownTopMargin
                                                + (dropdownRows * dropdownChoiceHeight)
                                                + ((dropdownRows - 1) * dropdownRowSpacing)
                                                + dropdownBottomPadding

    signal toggleRequested()
    signal choice1Selected(string value)
    signal choice2Selected(string value)
    signal choice3Selected(string value)
    signal pressAndHoldRequested()
    signal favoriteToggleRequested()

    width: parent ? parent.width : 400
    height: dropdowns.visible
            ? Math.max(root.dropdownContentHeight, root.dropdownRows > 1 ? (root.largeLandscape ? 330 : (root.standardLandscape ? 252 : (root.compact ? 214 : 264))) : (root.largeLandscape ? 226 : (root.standardLandscape ? 172 : (root.compact ? 142 : 176))))
            : (root.largeLandscape ? 140 : (root.standardLandscape ? 104 : (root.compact ? 78 : 98)))
    radius: root.largeLandscape ? 30 : (root.standardLandscape ? 22 : (root.compact ? 18 : 22))
    color: "#181818"
    opacity: root.available ? 1.0 : 0.42
    border.width: 1
    border.color: "#1affffff"

    Item {
        anchors.fill: parent
        anchors.margins: root.cardMargin

        Column {
            id: titleColumn
            anchors.left: parent.left
            anchors.right: root.favoriteEnabled ? favoriteButton.left : toggle.left
            anchors.rightMargin: root.favoriteEnabled ? (root.largeLandscape ? 16 : (root.standardLandscape ? 12 : (root.compact ? 8 : 12))) : (root.largeLandscape ? 34 : (root.standardLandscape ? 24 : (root.compact ? 16 : 24)))
            anchors.top: parent.top
            spacing: root.largeLandscape ? 7 : (root.standardLandscape ? 4 : (root.compact ? 2 : 4))

            Row {
                width: parent.width
                spacing: root.largeLandscape ? 12 : (root.standardLandscape ? 8 : (root.compact ? 6 : 8))

                Text {
                    width: Math.min(implicitWidth, parent.width - (root.titleIconSource.length > 0 ? (root.largeLandscape ? 48 : (root.standardLandscape ? 36 : (root.compact ? 26 : 32))) : 0))
                    text: root.title
                    color: "white"
                    font.family: interBold.font.family
                    font.pixelSize: root.largeLandscape ? 34 : (root.standardLandscape ? 24 : (root.compact ? 18 : 22))
                    renderType: Text.NativeRendering
                    elide: Text.ElideRight
                }

                Image {
                    visible: root.titleIconSource.length > 0
                    source: root.titleIconSource
                    width: root.largeLandscape ? 36 : (root.standardLandscape ? 26 : (root.compact ? 20 : 24))
                    height: root.largeLandscape ? 36 : (root.standardLandscape ? 26 : (root.compact ? 20 : 24))
                    anchors.verticalCenter: parent.verticalCenter
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    mipmap: true
                }
            }

            Text {
                text: root.description
                color: "#8cffffff"
                font.family: interRegular.font.family
                font.pixelSize: root.largeLandscape ? 19 : (root.standardLandscape ? 14 : (root.compact ? 11 : 14))
                renderType: Text.NativeRendering
                elide: Text.ElideRight
            }
        }

        MouseArea {
            anchors.fill: titleColumn
            acceptedButtons: Qt.LeftButton
            preventStealing: false
            pressAndHoldInterval: 320
            onPressAndHold: root.pressAndHoldRequested()
        }

        Rectangle {
            id: favoriteButton
            visible: root.favoriteEnabled
            width: root.largeLandscape ? 46 : (root.standardLandscape ? 34 : (root.compact ? 28 : 34))
            height: root.largeLandscape ? 46 : (root.standardLandscape ? 34 : (root.compact ? 28 : 34))
            radius: root.largeLandscape ? 16 : (root.standardLandscape ? 12 : (root.compact ? 10 : 12))
            anchors.right: toggle.left
            anchors.rightMargin: root.largeLandscape ? 14 : (root.standardLandscape ? 10 : (root.compact ? 7 : 10))
            anchors.top: root.centerToggleVertically ? undefined : parent.top
            anchors.verticalCenter: root.centerToggleVertically ? parent.verticalCenter : undefined
            color: favoriteButtonArea.containsPress
                   ? (root.favorited ? "#7a6120" : "#20ffffff")
                   : (root.favorited ? "#5f4b16" : "#141414")
            border.width: 1
            border.color: root.favorited ? "#e0b447" : "#1affffff"
            scale: favoriteButtonArea.containsPress ? 0.96 : 1.0

            Behavior on scale {
                NumberAnimation { duration: 120; easing.type: Easing.OutCubic }
            }

            Text {
                anchors.centerIn: parent
                text: root.favorited ? "★" : "☆"
                color: root.favorited ? "#ffd86f" : "#b6b8bd"
                font.family: interMedium.font.family
                font.pixelSize: root.largeLandscape ? 24 : (root.standardLandscape ? 18 : (root.compact ? 15 : 18))
                renderType: Text.NativeRendering
            }

            MouseArea {
                id: favoriteButtonArea
                anchors.fill: parent
                onClicked: root.favoriteToggleRequested()
            }
        }

        TogglePill {
            id: toggle
            anchors.right: parent.right
            anchors.top: root.centerToggleVertically ? undefined : parent.top
            anchors.verticalCenter: root.centerToggleVertically ? parent.verticalCenter : undefined
            checked: root.enabled
            compact: root.compact
            large: root.standardLandscape || root.largeLandscape
            onToggled: root.toggleRequested()
        }

        Grid {
            id: dropdowns
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.topMargin: root.dropdownTopMargin
            columns: 2
            rowSpacing: root.dropdownRowSpacing
            columnSpacing: root.largeLandscape ? 18 : (root.standardLandscape ? 12 : (root.compact ? 8 : 12))
            visible: root.choiceCount > 0

            SettingsChoice {
                id: choice1
                visible: root.choice1Label.length > 0
                label: root.choice1Label
                value: root.choice1Value
                options: root.choice1Options
                popupParent: root.popupParent
                dropdownController: root.dropdownController
                compact: root.compact
                large: root.standardLandscape || root.largeLandscape
                onValueSelected: function(v) {
                    root.choice1Selected(v)
                }
            }

            SettingsChoice {
                id: choice2
                visible: root.choice2Label.length > 0
                label: root.choice2Label
                value: root.choice2Value
                options: root.choice2Options
                popupParent: root.popupParent
                dropdownController: root.dropdownController
                compact: root.compact
                large: root.standardLandscape || root.largeLandscape
                onValueSelected: function(v) {
                    root.choice2Selected(v)
                }
            }

            SettingsChoice {
                id: choice3
                visible: root.choice3Label.length > 0
                label: root.choice3Label
                value: root.choice3Value
                options: root.choice3Options
                popupParent: root.popupParent
                dropdownController: root.dropdownController
                compact: root.compact
                large: root.standardLandscape || root.largeLandscape
                onValueSelected: function(v) {
                    root.choice3Selected(v)
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        visible: !root.available
        enabled: visible
        z: 100
    }

    onAvailableChanged: {
        if (!available && dropdownController) {
            if (dropdownController.activeDropdown === choice1)
                dropdownController.activeDropdown = null
            if (dropdownController.activeDropdown === choice2)
                dropdownController.activeDropdown = null
            if (dropdownController.activeDropdown === choice3)
                dropdownController.activeDropdown = null
        }
    }
}
