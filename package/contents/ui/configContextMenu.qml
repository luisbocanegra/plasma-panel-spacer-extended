pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kcmutils as KCM
import org.kde.kirigami as Kirigami
import org.kde.plasma.plasma5support as P5Support
import "components/"

KCM.ScrollViewKCM {
    id: root
    property string cfg_contextMenuActions
    property bool isLoading: true
    readonly property string toolsDir: Qt.resolvedUrl("./tools").toString().substring(7)
    readonly property string getShortcutsCommand: `'${toolsDir}/get_shortcuts.sh'`
    readonly property Kirigami.Action addContextMenuAction: Kirigami.Action {
        icon.name: "list-add-symbolic"
        text: i18n("Add")
        onTriggered: root.addMenuItem()
    }

    function initModel() {
        let actions = JSON.parse(root.cfg_contextMenuActions);
        contextMenuActionsModel.clear();
        for (let action of actions) {
            contextMenuActionsModel.append(action);
        }
    }

    function addMenuItem() {
        contextMenuActionsModel.append({
            "action": "kwin,Overview",
            "command": "",
            "url": "",
        });
        root.updateConfig();
    }

    function updateConfig() {
        let actions = new Array();
        console.log("updateConfig()", contextMenuActionsModel.count);
        for (let i = 0; i < contextMenuActionsModel.count; i++) {
            let item = contextMenuActionsModel.get(i);
            actions.push({
                "action": item.action,
                "command": item.command,
                "url": item.url
            });
        }
        cfg_contextMenuActions = JSON.stringify(actions);
    }

    function removeMenuItem(index) {
        contextMenuActionsModel.remove(index, 1);
        root.updateConfig();
    }

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

    ListModel {
        id: contextMenuActionsModel
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
            shortcutsList.clear();
            shortcutsList.append(shortcutsListTemp.get(0));
            shortcutsList.append(shortcutsListTemp.get(1));
            shortcutsList.append(shortcutsListTemp.get(2));
            for (let i = 0; i < lines.length; i++) {
                if (blackList.some(term => lines[i].includes(term))) {
                    continue;
                }
                const line = lines[i].toString().split(",");
                var component = line[0].split("/");
                component = component[component.length - 1];
                const shortcutName = line[1];
                // console.log(component + " - " + shortcutName);
                shortcutsList.append({
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
        initModel();
    }

    header: Kirigami.FormLayout {

        Button {
            text: i18n("Refresh actions")
            icon.name: "view-refresh-symbolic"
            onClicked: {
                getShortcuts.exec();
            }

            Layout.fillWidth: true
        }
    }

    view: ListView {
        id: list
        model: contextMenuActionsModel
        headerPositioning: ListView.OverlayHeader
        header: Kirigami.InlineViewHeader {
            width: list.width
            text: i18n("Actions")
            actions: [root.addContextMenuAction]
        }
        delegate: Item {
            id: itemDelegate
            readonly property var view: ListView.view
            required property string action
            required property string command
            required property string url
            required property int index

            implicitWidth: ListView.view.width
            implicitHeight: delegate.height
            Rectangle {
                anchors.fill: parent
                color: Kirigami.Theme.alternateBackgroundColor
                visible: parseInt(itemDelegate.index) % 2 !== 0
            }

            ItemDelegate {
                id: delegate
                implicitWidth: itemDelegate.implicitWidth
                // There's no need for a list item to ever be selected
                down: false
                highlighted: false
                contentItem: RowLayout {
                    spacing: Kirigami.Units.smallSpacing
                    Layout.fillWidth: true

                    Kirigami.ListItemDragHandle {
                        listItem: delegate
                        listView: itemDelegate.view
                        onMoveRequested: (oldIndex, newIndex) => {
                            contextMenuActionsModel.move(oldIndex, newIndex, 1);
                            root.updateConfig();
                        }
                        visible: itemDelegate.view.count > 1
                    }

                    GroupedActions {
                        Layout.fillWidth: true
                        modelData: isLoading ? shortcutsListTemp : shortcutsList
                        confInternalName: "menuAction"
                        isLoading: root.isLoading
                        configValue: itemDelegate.action
                        commandValue: itemDelegate.command
                        applicationUrlValue: itemDelegate.url
                        showSeparator: false

                        onConfigValueChanged: {
                            if (root.isLoading)
                                return;
                            contextMenuActionsModel.setProperty(itemDelegate.index, "action", configValue);
                            root.updateConfig();
                        }
                        onCommandValueChanged: {
                            if (root.isLoading)
                                return;
                            contextMenuActionsModel.setProperty(itemDelegate.index, "command", commandValue);
                            root.updateConfig();
                        }
                        onApplicationUrlValueChanged: {
                            if (root.isLoading)
                                return;
                            contextMenuActionsModel.setProperty(itemDelegate.index, "url", applicationUrlValue);
                            root.updateConfig();
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    Button {
                        icon.name: "edit-delete-remove"
                        onClicked: root.removeMenuItem(itemDelegate.index)
                    }
                }
            }
        }
    }
}
