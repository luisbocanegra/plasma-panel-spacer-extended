import QtQuick
import org.kde.plasma.plasmoid
import org.kde.taskmanager as TaskManager

Item {
    id: root
    property bool enableDebug: Plasmoid.configuration.enableDebug
    property var activeTask: null
    property var activeProps: {
        "name": "",
        "title": "",
        "id": ""
    }

    property var abstractTasksModel: TaskManager.AbstractTasksModel
    property var isMaximized: abstractTasksModel.IsMaximized
    property var isActive: abstractTasksModel.IsActive
    property var isWindow: abstractTasksModel.IsWindow

    property var isFullScreen: abstractTasksModel.IsFullScreen
    property var isMinimized: abstractTasksModel.IsMinimized
    property bool noWindowActive: true
    property bool currentWindowMaximized: false

    TaskManager.VirtualDesktopInfo {
        id: virtualDesktopInfo
    }

    TaskManager.ActivityInfo {
        id: activityInfo
        readonly property string nullUuid: "00000000-0000-0000-0000-000000000000"
    }

    TaskManager.TasksModel {
        id: tasksModel
        sortMode: TaskManager.TasksModel.SortVirtualDesktop
        groupMode: TaskManager.TasksModel.GroupDisabled
        virtualDesktop: virtualDesktopInfo.currentDesktop
        activity: activityInfo.currentActivity
        screenGeometry: Plasmoid.containment.screenGeometry
        filterByVirtualDesktop: true
        filterByScreen: true
        filterByActivity: true
        filterMinimized: true

        onActiveTaskChanged: {
            Qt.callLater(root.updateWindowsInfo);
        }
        onCountChanged: {
            Qt.callLater(root.updateWindowsInfo);
        }
    }

    function printLog(strings, ...values) {
        if (enableDebug) {
            let str = Plasmoid.pluginName + " S:" + root.screen + " ID:" + Plasmoid.id + " ";
            strings.forEach((string, i) => {
                str += string + (values[i] !== undefined ? values[i] : '');
            });
            console.log(str);
        }
    }

    function updateWindowsInfo() {
        for (var i = 0; i < tasksModel.count; i++) {
            const currentTask = tasksModel.index(i, 0);
            if (currentTask === undefined)
                continue;
            if (tasksModel.data(currentTask, isWindow)) {
                if (tasksModel.data(currentTask, isActive))
                    activeTask = currentTask;
            }
        }
        if (activeTask) {
            activeProps.name = tasksModel.data(activeTask, abstractTasksModel.AppName);
            activeProps.id = tasksModel.data(activeTask, abstractTasksModel.WinIdList);
            activeProps.title = tasksModel.data(activeTask, abstractTasksModel.display);
            printLog`Active task: Name: ${activeProps.name} Title: ${activeProps.title} Id: ${activeProps.id}`;
        }
    }

    function activeTaskExists() {
        return activeTask.display !== undefined;
    }

    function activateLastWindow() {
        printLog`Trying to activate last window...`;
        if (activeTask) {
            if (activeTask !== tasksModel.activeTask) {
                tasksModel.requestActivate(activeTask);
            }
        }
    }

    function toggleMaximized() {
        tasksModel.requestToggleMaximized(tasksModel.activeTask);
    }

    function setMaximized(maximized) {
        if (maximized !== activeTask.IsMaximized) {
            toggleMaximized();
        }
    }
}
