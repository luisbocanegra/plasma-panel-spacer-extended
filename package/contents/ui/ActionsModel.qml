pragma ComponentBehavior: Bound
import QtQuick
import org.kde.plasma.plasma5support as P5Support

Item {
    id: root
    readonly property string toolsDir: Qt.resolvedUrl("./tools").toString().substring(7)
    readonly property string getShortcutsCommand: `'${toolsDir}/get_shortcuts.sh'`
    property bool isLoading: true
    property ListModel model: isLoading ? actionsTemp : actions
    property ListModel actions: ListModel {
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

    readonly property ListModel actionsTemp: ListModel {
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

    P5Support.DataSource {
        id: getShortcuts
        engine: "executable"
        connectedSources: []

        onNewData: function (source, data) {
            var exitCode = data["exit code"];
            var exitStatus = data["exit status"];
            var stdout = data["stdout"];
            var stderr = data["stderr"];
            exited(source, exitCode, exitStatus, stdout, stderr);
            disconnectSource(source); // cmd finished
        }

        function exec() {
            getShortcuts.connectSource(root.getShortcutsCommand);
        }

        signal exited(string source, int exitCode, int exitStatus, string stdout, string stderr)
    }

    Connections {
        target: getShortcuts
        function onExited(cmd, exitCode, exitStatus, stdout, stderr) {
            console.warn("----");
            console.warn("cmd:", cmd);
            console.warn("exitCode:", exitCode);
            console.warn("exitStatus:", exitStatus);
            console.warn("stdout:", stdout);
            console.warn("stderr:", stderr);
            var lines = stdout.trim().split("\n");
            const blackList = ["activate widget", "activate task", "clear-history", "clipboard_action", "cycleNextAction", "cyclePrevAction", "edit_clipboard", "khotkeys", "repeat_action", "show-barcode", "show-on-mouse-pos", "knotes", "kwin,cycle-panels", "kwin,next activity", "kwin,switch to next activity", "kwin,switch to previous activity", "kwin,manage activities", "kwin,show dashboard", "kwin,stop current activity", "kwin,toggle do not disturb"];
            root.actions.clear();
            root.actions.append(root.actionsTemp.get(0));
            root.actions.append(root.actionsTemp.get(1));
            root.actions.append(root.actionsTemp.get(2));
            for (let i = 0; i < lines.length; i++) {
                if (blackList.some(term => lines[i].includes(term))) {
                    continue;
                }
                const line = lines[i].toString().split(",");
                var component = line[0].split("/");
                component = component[component.length - 1];
                const shortcutName = line[1];
                // console.log(component + " - " + shortcutName);
                root.actions.append({
                    "label": component + " - " + shortcutName,
                    "component": component,
                    "shortcutName": shortcutName
                });
            }
            console.log("SHORTCUTS LOADING FINISHED");
            root.isLoading = false;
        }
    }

    Component.onCompleted: {
        getShortcuts.exec();
    }

    function reloadActions() {
        getShortcuts.exec();
    }
}
