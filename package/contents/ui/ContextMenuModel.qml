pragma ComponentBehavior: Bound
import QtQuick

Item {
    id: root
    property ListModel model: ListModel {}
    property bool isLoading: true

    signal updated

    function initModel(actionsConfigString) {
        model.clear();
        let actions = [];
        try {
            actions = JSON.parse(actionsConfigString);
        } catch (e) {
            console.log("Error parsing contextMenuActions:", e);
        }

        for (let action of actions) {
            model.append(action);
        }
        root.isLoading = false;
    }

    function addMenuItem() {
        model.append({
            "action": "kwin,Overview",
            "command": "",
            "url": "",
            "icon": "",
            "name": ""
        });
        updated();
    }

    function restoreDefault() {
        model.clear();
        updated();
    }

    function removeMenuItem(index) {
        model.remove(index, 1);
        updated();
    }

    function updateItem(index, actionType, value) {
        model.setProperty(index, actionType, value);
        updated();
    }

    function moveItem(oldIndex, newIndex) {
        model.move(oldIndex, newIndex, 1);
        updated();
    }
}
