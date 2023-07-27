import QtQuick 2.0
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.plasma.plasmoid 2.0

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
        Layout.topMargin: PlasmaCore.Units.gridUnit / 2
        Layout.leftMargin: PlasmaCore.Units.gridUnit / 2
        Layout.bottomMargin: PlasmaCore.Units.gridUnit / 2
        Layout.rightMargin: PlasmaCore.Units.gridUnit / 2

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

                PlasmaComponents3.Label {
                    text: modelData[0]
                    opacity: 1
                }

                RowLayout {
                    Item { implicitWidth: units.smallSpacing }
                    PlasmaComponents3.Label {
                        text: getShownAction(modelData[1])
                        opacity: .7
                    }
                }
            }
        }
    }
}
