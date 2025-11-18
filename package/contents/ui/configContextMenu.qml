pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kcmutils as KCM
import org.kde.kirigami as Kirigami
import "components/"

KCM.ScrollViewKCM {
    id: root
    property string cfg_contextMenuActions
    property bool isLoading: actionsModel.isLoading
    readonly property Kirigami.Action addContextMenuAction: Kirigami.Action {
        icon.name: "list-add-symbolic"
        text: i18n("Add action")
        onTriggered: contextMenuModel.addMenuItem()
    }

    readonly property Kirigami.Action restoreDefaultAction: Kirigami.Action {
        icon.name: "edit-undo-symbolic"
        text: i18n("Reset to default")
        onTriggered: contextMenuModel.restoreDefault()
    }

    function updateConfig() {
        let actions = new Array();
        for (let i = 0; i < contextMenuModel.model.count; i++) {
            let item = contextMenuModel.model.get(i);
            actions.push({
                "action": item.action,
                "command": item.command,
                "url": item.url,
                "icon": item.icon,
                "name": item.name
            });
        }
        cfg_contextMenuActions = JSON.stringify(actions);
    }

    ActionsModel {
        id: actionsModel
    }

    ContextMenuModel {
        id: contextMenuModel
        onUpdated: () => {
            root.updateConfig();
        }
    }

    Component.onCompleted: {
        contextMenuModel.initModel(cfg_contextMenuActions);
    }

    header: Kirigami.FormLayout {

        Button {
            text: i18n("Refresh actions")
            icon.name: "view-refresh-symbolic"
            onClicked: {
                actionsModel.reloadActions();
            }

            Layout.fillWidth: true
        }
    }

    view: ListView {
        id: list
        model: contextMenuModel.model
        headerPositioning: ListView.OverlayHeader
        header: Kirigami.InlineViewHeader {
            width: list.width
            text: i18n("Actions")
            actions: [root.restoreDefaultAction, root.addContextMenuAction]
        }
        delegate: Item {
            id: itemDelegate
            readonly property var view: ListView.view
            required property string action
            required property string command
            required property string url
            required property string icon
            required property string name
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
                            contextMenuModel.moveItem(oldIndex, newIndex, 1);
                        }
                        visible: itemDelegate.view.count > 1
                    }

                    GroupedActions {
                        Layout.fillWidth: true
                        modelData: actionsModel.model
                        confInternalName: "menuAction"
                        isLoading: root.isLoading
                        configValue: itemDelegate.action
                        commandValue: itemDelegate.command
                        applicationUrlValue: itemDelegate.url
                        customIcon: itemDelegate.icon
                        customName: itemDelegate.name
                        showSeparator: false
                        showCustomNameAndIcon: true

                        onConfigValueChanged: {
                            if (root.isLoading)
                                return;
                            contextMenuModel.updateItem(itemDelegate.index, "action", configValue);
                        }
                        onCommandValueChanged: {
                            if (root.isLoading)
                                return;
                            contextMenuModel.updateItem(itemDelegate.index, "command", commandValue);
                        }
                        onApplicationUrlValueChanged: {
                            if (root.isLoading)
                                return;
                            contextMenuModel.updateItem(itemDelegate.index, "url", applicationUrlValue);
                        }
                        onCustomIconChanged: {
                            if (root.isLoading)
                                return;
                            contextMenuModel.updateItem(itemDelegate.index, "icon", customIcon);
                        }
                        onCustomNameChanged: {
                            if (root.isLoading)
                                return;
                            contextMenuModel.updateItem(itemDelegate.index, "name", customName);
                        }
                    }

                    Button {
                        icon.name: "edit-delete-remove"
                        onClicked: contextMenuModel.removeMenuItem(itemDelegate.index)
                    }
                }
            }
        }
    }
}
