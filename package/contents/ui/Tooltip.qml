import QtQuick
import QtQuick.Layouts
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.extras as PlasmaExtras
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami

ColumnLayout {

    function truncateString(str, n) {
        if (str.length > n) {
            return str.slice(0, n) + "...";
        } else {
            return str;
        }
    }

    function getShownAction(configKey){
        var configValue = plasmoid.configuration[configKey+"Action"]
        if (configValue != "") {
            var parts = configValue.toString().split(",")
            if (parts[1] == "custom_command") {
                var command = plasmoid.configuration[configKey+"Command"]
                var commandShort = "Nothing is set"
                if (command!==undefined && command!==""){
                    var command = truncateString(command,20)
                    commandShort = command
                }
                return parts[0]+" - "+commandShort///.length>0?commandShort:"nothing set"
            }
            if (parts[1] == "launch_application"){
                var appName = logic.launcherData(plasmoid.configuration[configKey+"AppUrl"]).applicationName
                return parts[0]+" - "+ (appName.length>0?appName:"Nothing is set")
            }
            return parts[0]
        }
        return "unknown"
    }

    ColumnLayout {
        Layout.topMargin: Kirigami.Units.gridUnit / 2
        Layout.leftMargin: Kirigami.Units.gridUnit / 2
        Layout.bottomMargin: Kirigami.Units.gridUnit / 2
        Layout.rightMargin: Kirigami.Units.gridUnit / 2

        PlasmaExtras.Heading {
            id: tooltipMaintext
            level: 3
            elide: Text.ElideRight
            text: Plasmoid.metaData.name
        }

        Repeater {
            model: [
                ["Single click","singleClick"],
                ["Double click","doubleClick"],
                ["Middle click","middleClick"],
                ["Wheel up","mouseWheelUp"],
                ["Wheel down","mouseWheelDown"],
                ["Drag up","mouseDragUp"],
                ["Drag down","mouseDragDown"],
                ["Drag left","mouseDragLeft"],
                ["Drag right","mouseDragRight"],
                ["Long press","pressHold"],
                ]
            delegate: ColumnLayout {

                PlasmaComponents.Label {
                    text: modelData[0]
                    opacity: 1
                }

                RowLayout {
                    Item { implicitWidth: Kirigami.Units.smallSpacing }
                    PlasmaComponents.Label {
                        text: getShownAction(modelData[1])
                        opacity: .7
                    }
                }
            }
        }
    }
}
