import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kcmutils as KCM
import org.kde.kirigami as Kirigami
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasma5support as P5Support
import "components" as Components


KCM.SimpleKCM {
    id: root
    property alias cfg_singleClickAction: singleClick.configValue
    property alias cfg_singleClickCommand: singleClick.commandValue
    property alias cfg_singleClickAppUrl: singleClick.applicationUrlValue

    property alias cfg_doubleClickAction: doubleClick.configValue
    property alias cfg_doubleClickCommand: doubleClick.commandValue
    property alias cfg_doubleClickAppUrl: doubleClick.applicationUrlValue
    
    property alias cfg_middleClickAction: middleClick.configValue
    property alias cfg_middleClickCommand: middleClick.commandValue
    property alias cfg_middleClickAppUrl: middleClick.applicationUrlValue
    
    property alias cfg_mouseWheelUpAction: wheelUp.configValue
    property alias cfg_mouseWheelUpCommand: wheelUp.commandValue
    property alias cfg_mouseWheelUpAppUrl: wheelUp.applicationUrlValue

    property alias cfg_mouseWheelDownAction: wheelDown.configValue
    property alias cfg_mouseWheelDownCommand: wheelDown.commandValue
    property alias cfg_mouseWheelDownAppUrl: wheelDown.applicationUrlValue

    property alias cfg_mouseDragUpAction: dragUp.configValue
    property alias cfg_mouseDragUpCommand: dragUp.commandValue
    property alias cfg_mouseDragUpAppUrl: dragUp.applicationUrlValue

    property alias cfg_mouseDragDownAction: dragDown.configValue
    property alias cfg_mouseDragDownCommand: dragDown.commandValue
    property alias cfg_mouseDragDownAppUrl: dragDown.applicationUrlValue

    property alias cfg_mouseDragLeftAction: dragLeft.configValue
    property alias cfg_mouseDragLeftCommand: dragLeft.commandValue
    property alias cfg_mouseDragLeftAppUrl: dragLeft.applicationUrlValue

    property alias cfg_mouseDragRightAction: dragRight.configValue
    property alias cfg_mouseDragRightCommand: dragRight.commandValue
    property alias cfg_mouseDragRightAppUrl: dragRight.applicationUrlValue

    property alias cfg_pressHoldAction: pressHold.configValue
    property alias cfg_pressHoldCommand: pressHold.commandValue
    property alias cfg_pressHoldAppUrl: pressHold.applicationUrlValue

    property alias cfg_showTooltip: showTooltip.checked
    property alias cfg_qdbusCommand: qdbusCommand.text
    property alias cfg_scrollSensitivity: scrollSensitivity.value

    property bool isLoading: true

    property string getShortcutsCommand: "for comp in $("+qdbusCommand.text+" org.kde.kglobalaccel | grep '/component/'); do IFS=$'\\n';for shortcut in $("+qdbusCommand.text+" org.kde.kglobalaccel $comp org.kde.kglobalaccel.Component.shortcutNames); do echo $comp,$shortcut;done; done | sort"

    ListModel {
        id: shortcutsList
        ListElement {
            label: qsTr("Disabled")
            shortcutName: "Disabled"
            component: "Disabled"
        }
        ListElement {
            label: qsTr("Custom Command")
            shortcutName: "Custom Command"
            component: "custom_command"
        }
        ListElement {
            label: qsTr("Launch Application/URL")
            shortcutName: "Launch Application/URL"
            component: "launch_application"
        }
    }

    ListModel {
        id: shortcutsListTemp
        ListElement {
            label: qsTr("Disabled")
            shortcutName: "Disabled"
            component: "Disabled"
        }
        ListElement {
            label: qsTr("Custom Command")
            shortcutName: "Custom Command"
            component: "custom_command"
        }
        ListElement {
            label: qsTr("Launch Application/URL")
            shortcutName: "Launch Application/URL"
            component: "launch_application"
        }

        ListElement {
            label: qsTr("Launch Application/URL")
            shortcutName: "Launch Application/URL"
            component: "launch_application"
        }
    }

    P5Support.DataSource {
        id: getShortcuts
        engine: "executable"
        connectedSources: []

        onNewData: function(source, data) {
            var exitCode = data["exit code"]
            var exitStatus = data["exit status"]
            var stdout = data["stdout"]
            var stderr = data["stderr"]
            exited(source, exitCode, exitStatus, stdout, stderr)
            disconnectSource(source) // cmd finished
        }

        function exec() {
            getShortcuts.connectSource(getShortcutsCommand)
        }
    }

    signal exited(string source, int exitCode, int exitStatus, string stdout, string stderr)


    Component.onCompleted: {
        getShortcuts.exec()

        exited.connect(function (cmd, exitCode, exitStatus, stdout, stderr) {
            var lines = stdout.trim().split("\n")
            const blackList = [
                "activate widget",
                "activate task",
                "clear-history",
                "clipboard_action",
                "cycleNextAction",
                "cyclePrevAction",
                "edit_clipboard",
                "khotkeys",
                "repeat_action",
                "show-barcode",
                "show-on-mouse-pos",
                "knotes",
                "kwin,cycle-panels",
                "kwin,next activity",
                "kwin,switch to next activity",
                "kwin,switch to previous activity",
                "kwin,manage activities",
                "kwin,show dashboard",
                "kwin,stop current activity",
                "kwin,toggle do not disturb"

                ]
            for (let i = 0; i < lines.length; i++) {
                if (blackList.some(term => lines[i].includes(term))) {
                    continue
                }
                const line = lines[i].toString().split(",")
                var component = line[0].split("/")
                component = component[component.length - 1]
                const shortcutName = line[1]
                shortcutsList.append({
                    "label": component + " - " + shortcutName,
                    "component": component,
                    "shortcutName": shortcutName
                    })
            }
            console.log("SHORTCUTS LOADING FINISHED");
            isLoading = false
        })
    }

    signal configurationChanged

    ColumnLayout {
        Kirigami.FormLayout {
            Layout.alignment: Qt.AlignTop

            Kirigami.Separator {
                Kirigami.FormData.label: i18n("General")
                Kirigami.FormData.isSection: true
            }

            RowLayout {
                Kirigami.FormData.label: i18n("Show tooltip:")

                CheckBox {
                    id: showTooltip
                    checked: cfg_showTooltip
                    onCheckedChanged: {
                        cfg_showTooltip = checked
                    }
                    text: i18n("Show list of actions when hovering the spacer")
                }
            }

            TextField {
                Kirigami.FormData.label: i18n("Qdbus executable:")
                id: qdbusCommand
                placeholderText: qsTr("e.g. qdbus, qdbus6, qdbus-qt6")
            }

            RowLayout {
                Kirigami.FormData.label: i18n("Scroll threshold:")
                SpinBox {
                    id: scrollSensitivity
                    from: 1
                    to: 10000
                }
                KCM.ContextualHelpButton {
                    toolTipText: "Higher values may help reducing repeated scrolling events on some devices"
                }
            }
        }
        Kirigami.FormLayout {

            Kirigami.Separator {
                Kirigami.FormData.label: i18n("Actions")
                Kirigami.FormData.isSection: true
            }

            Components.GroupedActions {
                id: singleClick
                modelData: isLoading ? shortcutsListTemp : shortcutsList
                confInternalName: "singleClickAction"
                sectionLabel: "Single Click"
                Kirigami.FormData.label: sectionLabel+":"
                isLoading: root.isLoading
            }

            Components.GroupedActions {
                id: doubleClick
                modelData: isLoading ? shortcutsListTemp : shortcutsList
                confInternalName: "doubleClickAction"
                sectionLabel: "Double Click"
                Kirigami.FormData.label: sectionLabel+":"
                isLoading: root.isLoading
            }

            Components.GroupedActions {
                id: middleClick
                modelData: isLoading ? shortcutsListTemp : shortcutsList
                confInternalName: "middleClickAction"
                sectionLabel: "Middle Click"
                Kirigami.FormData.label: sectionLabel+":"
                isLoading: root.isLoading
            }


            Components.GroupedActions {
                id: wheelUp
                modelData: isLoading ? shortcutsListTemp : shortcutsList
                confInternalName: "mouseWheelUpAction"
                sectionLabel: "Wheel Up"
                Kirigami.FormData.label: sectionLabel+":"
                isLoading: root.isLoading
            }


            Components.GroupedActions {
                id: wheelDown
                modelData: isLoading ? shortcutsListTemp : shortcutsList
                confInternalName: "mouseWheelDownAction"
                sectionLabel: "Wheel Down"
                Kirigami.FormData.label: sectionLabel+":"
                isLoading: root.isLoading
            }


            Components.GroupedActions {
                id: dragUp
                modelData: isLoading ? shortcutsListTemp : shortcutsList
                confInternalName: "mouseDragUpAction"
                sectionLabel: "Drag Up"
                Kirigami.FormData.label: sectionLabel+":"
                isLoading: root.isLoading
            }


            Components.GroupedActions {
                id: dragDown
                modelData: isLoading ? shortcutsListTemp : shortcutsList
                confInternalName: "mouseDragDownAction"
                sectionLabel: "Drag Down"
                Kirigami.FormData.label: sectionLabel+":"
                isLoading: root.isLoading
            }


            Components.GroupedActions {
                id: dragLeft
                modelData: isLoading ? shortcutsListTemp : shortcutsList
                confInternalName: "mouseDragLeftAction"
                sectionLabel: "Drag Left"
                Kirigami.FormData.label: sectionLabel+":"
                isLoading: root.isLoading
            }

            Components.GroupedActions {
                id: dragRight
                modelData: isLoading ? shortcutsListTemp : shortcutsList
                confInternalName: "mouseDragRightAction"
                sectionLabel: "Drag Right"
                Kirigami.FormData.label: sectionLabel+":"
                isLoading: root.isLoading
            }

            Components.GroupedActions {
                id: pressHold
                modelData: isLoading ? shortcutsListTemp : shortcutsList
                confInternalName: "pressHoldAction"
                sectionLabel: "Long press"
                Kirigami.FormData.label: sectionLabel+":"
                showSeparator: false
                isLoading: root.isLoading
            }
        }
    }
}
