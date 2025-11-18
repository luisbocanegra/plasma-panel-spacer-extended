import QtQuick
import QtQuick.Layouts
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami
import "code/utils.js" as Utils

Item {
    id: root
    property int preferredTextWidth: Kirigami.Units.gridUnit * 25

    implicitWidth: mainLayout.implicitWidth + Kirigami.Units.gridUnit
    implicitHeight: mainLayout.implicitHeight + Kirigami.Units.gridUnit

    ListModel {
        id: shortcutsList
    }

    Component.onCompleted: {
        updateShortcutsList();
    }

    function updateShortcutsList() {
        shortcutsList.clear();
        for (let gesture of gestures) {
            var action = getShownAction(gesture.key);
            if (action) {
                shortcutsList.append({
                    "gesture": gesture.name,
                    "action": action
                });
            }
        }
    }

    Connections {
        target: Plasmoid.configuration
        function onValueChanged() {
            root.updateShortcutsList();
        }
    }

    property var gestures: [
        {
            key: "singleClick",
            name: "Single click"
        },
        {
            key: "doubleClick",
            name: "Double click"
        },
        {
            key: "middleClick",
            name: "Middle click"
        },
        {
            key: "mouseWheelUp",
            name: "Wheel up"
        },
        {
            key: "mouseWheelDown",
            name: "Wheel down"
        },
        {
            key: "mouseDragUp",
            name: "Drag up"
        },
        {
            key: "mouseDragDown",
            name: "Drag down"
        },
        {
            key: "mouseDragLeft",
            name: "Drag left"
        },
        {
            key: "mouseDragRight",
            name: "Drag right"
        },
        {
            key: "pressHold",
            name: "Long press"
        },
    ]

    function getShownAction(configKey) {
        var configValue = Plasmoid.configuration[configKey + "Action"];
        if (configValue != "") {
            var parts = configValue.toString().split(",");
            let component = parts[0];
            let shortcut = parts[1];

            var action = null;

            switch (component) {
            case "custom_command":
                var command = Plasmoid.configuration[configKey + "Command"];

                if (command) {
                    action = "Command • " + Utils.truncateString(command, 70).replace(/(\r\n|\n|\r)/gm, " ").replace(/\s+/g, ' ');
                }
                break;
            case "launch_application":
                // main QuickLaunch {}
                if (quickLaunch.pluginFound) {
                    var appName = quickLaunch.launcherData(Plasmoid.configuration[configKey + "AppUrl"]).applicationName;
                    if (appName.length > 0) {
                        action = "Open • " + appName;
                    }
                }
                break;
            default:
                component = (component.charAt(0).toUpperCase() + component.substring(1)).replace(/-|_/g, " ");
                if (shortcut && shortcut != "Disabled") {
                    action = component + " • " + shortcut.replace(/-|_/g, " ");
                }
            }
        }
        return action;
    }

    ColumnLayout {
        id: mainLayout

        anchors {
            centerIn: parent
        }

        GridLayout {
            Layout.alignment: Qt.AlignRight
            columns: 2
            rowSpacing: Kirigami.Units.mediumSpacing
            columnSpacing: Kirigami.Units.gridUnit / 2.5
            Layout.maximumWidth: Math.min(implicitWidth, root.preferredTextWidth)
            Repeater {
                model: shortcutsList
                PlasmaComponents.Label {
                    required property string gesture
                    required property int index
                    text: gesture
                    Layout.row: index
                    Layout.column: 0
                    opacity: 0.9
                    font.weight: Font.DemiBold
                    Layout.alignment: Qt.AlignTop | Qt.AlignRight
                }
            }
            Repeater {
                model: shortcutsList
                PlasmaComponents.Label {
                    required property string action
                    required property int index
                    text: action
                    Layout.row: index
                    Layout.column: 1
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignTop
                    opacity: 0.75
                    wrapMode: Text.Wrap
                }
            }
        }
    }
}
