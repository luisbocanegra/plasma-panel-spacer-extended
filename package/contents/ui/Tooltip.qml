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
                    var command = truncateString(command,20)
                    commandShort = command
                }
                return parts[1]+" - "+commandShort
            }
            if (parts[0] == "launch_application"){
                var appName = logic.launcherData(plasmoid.configuration[configKey+"AppUrl"]).applicationName
                return parts[1]+" - "+ (appName.length>0?appName:"Nothing is set")
            }
            if (parts[0] == "Disabled") {
                return parts[0]
            }
            return parts[0]+" - "+parts[1]
        }
        return "unknown"
    }

    ColumnLayout {
        id: mainLayout

        anchors {
            left: parent.left
            top: parent.top
            margins: Kirigami.Units.largeSpacing
        }

        Kirigami.Heading {
            id: tooltipMaintext
            Layout.minimumWidth: Math.min(implicitWidth, preferredTextWidth)
            Layout.maximumWidth: preferredTextWidth
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
                    Layout.minimumWidth: Math.min(implicitWidth, preferredTextWidth)
                    Layout.maximumWidth: preferredTextWidth
                    elide: Text.ElideRight
                }

                RowLayout {
                    Item { implicitWidth: Kirigami.Units.smallSpacing }
                    PlasmaComponents.Label {
                        text: getShownAction(modelData[1])
                        opacity: .7
                        Layout.minimumWidth: Math.min(implicitWidth, preferredTextWidth)
                        Layout.maximumWidth: preferredTextWidth
                        elide: Text.ElideRight
                    }
                }
            }
        }
    }
}
