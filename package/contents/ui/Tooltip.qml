import QtQuick
import QtQuick.Layouts
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.extras as PlasmaExtras
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami

Item {

    property int preferredTextWidth: Kirigami.Units.gridUnit * 20

    implicitWidth: mainLayout.implicitWidth + Kirigami.Units.gridUnit
    implicitHeight: mainLayout.implicitHeight + Kirigami.Units.gridUnit

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
            if (parts[0] == "custom_command") {
                var command = plasmoid.configuration[configKey+"Command"]
                var commandShort = "Nothing is set"
                if (command!==undefined && command!==""){
                    var command = truncateString(command,30)
                    commandShort = command
                }
                return "Run " + commandShort
            }
            if (parts[0] == "launch_application"){
                var appName = logic.launcherData(plasmoid.configuration[configKey+"AppUrl"]).applicationName
                if (appName.length>0) {
                    return "Open" + appName
                }
                return "Nothing is set"
            }
            if (parts[0] == "Disabled") {
                return parts[0]
            }
            return parts[1]
        }
        return "unknown"
    }

    property var repeaterModel: [
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

    ColumnLayout {
        id: mainLayout

        anchors {
            left: parent.left
            top: parent.top
            margins: Kirigami.Units.largeSpacing
        }

        // Kirigami.Heading {
        //     id: tooltipMaintext
        //     Layout.minimumWidth: Math.min(implicitWidth, preferredTextWidth)
        //     Layout.maximumWidth: preferredTextWidth
        //     level: 3
        //     elide: Text.ElideRight
        //     text: Plasmoid.metaData.name
        // }
        
        GridLayout {
            columns: 2
            rowSpacing: Kirigami.Units.smallSpacing
            columnSpacing: Kirigami.Units.gridUnit / 2.5
            Layout.minimumWidth: Math.min(implicitWidth, preferredTextWidth)
            Layout.maximumWidth: preferredTextWidth
            Repeater {
                model: repeaterModel
                PlasmaComponents.Label {
                    text: modelData[0]
                    Layout.row: index
                    Layout.column: 0
                    Layout.fillWidth: true
                    opacity: 0.8
                    font.weight: Font.DemiBold
                    horizontalAlignment: Text.AlignRight
                }
            }
            Repeater {
                model: repeaterModel
                PlasmaComponents.Label {
                    text: getShownAction(modelData[1])
                    Layout.row: index
                    Layout.column: 1
                    Layout.fillWidth: true
                    opacity: 0.65
                    elide: Text.ElideRight
                }
            }
        }
    }
}
