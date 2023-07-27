/*
    SPDX-FileCopyrightText: 2014 Marco Martin <mart@kde.org>

    SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
*/

import QtQuick 2.15
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0
import org.kde.kirigami 2.10 as Kirigami
import org.kde.taskmanager 0.1 as TaskManager
import org.kde.plasma.private.quicklaunch 1.0

Item {
    id: root

    property bool horizontal: Plasmoid.formFactor !== PlasmaCore.Types.Vertical
    property var activeTaskLocal: null
    property bool noWindowActive: true
    property bool currentWindowMaximized: false
    property bool isActiveWindowPinned: false
    property int startY: 0
    property int startX: 0
    property int movementX: 0
    property int movementY: 0
    property bool wasDoubleClicked: false
    property int minMovement: horizontal ? root.height+10 : root.width+10
    property var mouseButton: undefined

    property var singleClickAction: plasmoid.configuration.singleClickAction.split(",")
    property var singleClickCommand: plasmoid.configuration.singleClickCommand
    property var singleClickAppUrl: plasmoid.configuration.singleClickAppUrl

    property var doubleClickAction: plasmoid.configuration.doubleClickAction.split(",")
    property var doubleClickCommand: plasmoid.configuration.doubleClickCommand
    property var doubleClickAppUrl: plasmoid.configuration.doubleClickAppUrl

    property var middleClickAction: plasmoid.configuration.middleClickAction.split(",")
    property var middleClickCommand: plasmoid.configuration.middleClickCommand
    property var middleClickAppUrl: plasmoid.configuration.middleClickAppUrl

    property var mouseWheelUpAction: plasmoid.configuration.mouseWheelUpAction.split(",")
    property var mouseWheelUpCommand: plasmoid.configuration.mouseWheelUpCommand
    property var mouseWheelUpAppUrl: plasmoid.configuration.mouseWheelUpAppUrl

    property var mouseWheelDownAction: plasmoid.configuration.mouseWheelDownAction.split(",")
    property var mouseWheelDownCommand: plasmoid.configuration.mouseWheelDownCommand
    property var mouseWheelDownAppUrl: plasmoid.configuration.mouseWheelDownAppUrl

    property var mouseDragDownAction: plasmoid.configuration.mouseDragDownAction.split(",")
    property var mouseDragDownCommand: plasmoid.configuration.mouseDragDownCommand
    property var mouseDragDownAppUrl: plasmoid.configuration.mouseDragDownAppUrl

    property var mouseDragUpAction: plasmoid.configuration.mouseDragUpAction.split(",")
    property var mouseDragUpCommand: plasmoid.configuration.mouseDragUpCommand
    property var mouseDragUpAppUrl: plasmoid.configuration.mouseDragUpAppUrl

    property var mouseDragLeftAction: plasmoid.configuration.mouseDragLeftAction.split(",")
    property var mouseDragLeftCommand: plasmoid.configuration.mouseDragLeftCommand
    property var mouseDragLeftAppUrl: plasmoid.configuration.mouseDragLeftAppUrl

    property var mouseDragRightAction: plasmoid.configuration.mouseDragRightAction.split(",")
    property var mouseDragRightCommand: plasmoid.configuration.mouseDragRightCommand
    property var mouseDragRightAppUrl: plasmoid.configuration.mouseDragRightAppUrl

    property var pressHoldAction: plasmoid.configuration.pressHoldAction.split(",")
    property var pressHoldCommand: plasmoid.configuration.pressHoldCommand
    property var pressHoldAppUrl: plasmoid.configuration.pressHoldAppUrl

    property bool enableDebug: plasmoid.configuration.enableDebug
    property bool showTooltip: plasmoid.configuration.showTooltip

    Layout.fillWidth: Plasmoid.configuration.expanding
    Layout.fillHeight: Plasmoid.configuration.expanding

    Layout.minimumWidth: Plasmoid.editMode ? PlasmaCore.Units.gridUnit * 2 : 1
    Layout.minimumHeight: Plasmoid.editMode ? PlasmaCore.Units.gridUnit * 2 : 1
    Layout.preferredWidth: horizontal
        ? (Plasmoid.configuration.expanding ? optimalSize : Plasmoid.configuration.length)
        : 0
    Layout.preferredHeight: horizontal
        ? 0
        : (Plasmoid.configuration.expanding ? optimalSize : Plasmoid.configuration.length)

    Plasmoid.preferredRepresentation: Plasmoid.fullRepresentation

    function action_expanding() {
        Plasmoid.configuration.expanding = Plasmoid.action("expanding").checked;
    }

    // Toggle maximize with mouse wheel/left click from https://invent.kde.org/plasma/plasma-active-window-control
    //
    // MODEL
    //
    TaskManager.TasksModel {
        id: tasksModel
        sortMode: TaskManager.TasksModel.SortVirtualDesktop
        groupMode: TaskManager.TasksModel.GroupDisabled

        screenGeometry: plasmoid.screenGeometry
        filterByScreen: true //plasmoid.configuration.showForCurrentScreenOnly

        onActiveTaskChanged: {
            updateActiveWindowInfo()
        }
        onDataChanged: {
            updateActiveWindowInfo()
        }
        onCountChanged: {
            updateActiveWindowInfo()
        }
    }

    function updateActiveWindowInfo() {

        var activeTaskIndex = tasksModel.activeTask

        // fallback for Plasma 5.8
        var abstractTasksModel = TaskManager.AbstractTasksModel || {}
        var isActive = abstractTasksModel.IsActive || 271
        var appName = abstractTasksModel.AppName || 258
        var isMaximized = abstractTasksModel.IsMaximized || 276
        var virtualDesktop = abstractTasksModel.VirtualDesktop || 286

        if (!tasksModel.data(activeTaskIndex, isActive)) {
            activeTaskLocal = {}
        } else {
            activeTaskLocal = {
                display: tasksModel.data(activeTaskIndex, Qt.DisplayRole),
                decoration: tasksModel.data(activeTaskIndex, Qt.DecorationRole),
                AppName: tasksModel.data(activeTaskIndex, appName),
                IsMaximized: tasksModel.data(activeTaskIndex, isMaximized),
                VirtualDesktop: tasksModel.data(activeTaskIndex, virtualDesktop)
            }
        }

        var actTask = activeTask()
        noWindowActive = !activeTaskExists()
        currentWindowMaximized = !noWindowActive && actTask.IsMaximized === true
        isActiveWindowPinned = actTask.VirtualDesktop === -1;
        // if (noWindowActive) {
        //     windowTitleText.text = composeNoWindowText()
        //     iconItem.source = plasmoid.configuration.noWindowIcon
        // } else {
        //     windowTitleText.text = (textType === 1 ? actTask.AppName : null) || replaceTitle(actTask.display)
        //     iconItem.source = actTask.decoration
        // }
        //updateTooltip()
    }

    function activeTask() {
        return activeTaskLocal
    }

    function activeTaskExists() {
        return activeTaskLocal.display !== undefined
    }


    function toggleMaximized() {
        tasksModel.requestToggleMaximized(tasksModel.activeTask);
    }

    function setMaximized(maximized) {
        if ((maximized && !activeTask().IsMaximized)
            || (!maximized && activeTask().IsMaximized)) {
            toggleMaximized()
        }
    }

    PlasmaCore.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []
        onNewData: disconnectSource(sourceName)

        function exec(cmd) {
            executable.connectSource(cmd)
        }
    }

    Logic {
        id: logic
    }

    function runAction(action,command,application) {
        printLog `RUNNING_ACTION: ${action}`
        var actionNme = action[0]
        var component = action[1]
        if (actionNme != "Disabled") {
            // custom command
            if (component == "custom_command") {
                var commandFormatted = ""
                var commandLines = command.split('\n')
                for (let i=0;i<commandLines.length;i++){
                    commandFormatted += commandLines[i] + (commandLines[i].endsWith(";")?" ":"; ")
                }
                printLog `RUNNING_CUSTOM_COMMAND: ${command}`
                executable.exec(commandFormatted);
                return
            }

            if (component == "launch_application"){
                if (application !== "") {
                    printLog `LAUNCHING_APPLICATION_URL: ${application}`
                    logic.openUrl(application);
                }
                return
            }

            if (actionNme == "Window Maximize Only"){
                setMaximized(true)
                return
            }
            if (actionNme == "Window Unmaximize Only"){
                setMaximized(false)
                return
            }
            var shortcutCommand = 'qdbus org.kde.kglobalaccel /component/'+component+' org.kde.kglobalaccel.Component.invokeShortcut '+'\"'+actionNme+'\"'
            printLog `RUNNING_SHORTCUT_COMMAND: ${shortcutCommand}`
            executable.exec(shortcutCommand);
        }
    }

    function printLog(strings, ...values) {
        if (enableDebug) {
            let str = 'PPSE: ';
            strings.forEach((string, i) => {
                str += string + (values[i] || '');
            });
            if (enableDebug) {
                console.log(str);
            }
        }
    }

    // Search the actual gridLayout of the panel
    property GridLayout panelLayout: {
        var candidate = root.parent;
        while (candidate) {
            if (candidate instanceof GridLayout) {
                return candidate;
            }
            candidate = candidate.parent;
        }
        return null;
    }

    Component.onCompleted: {
        Plasmoid.setAction("expanding", i18n("Set flexible size"));
        var action = Plasmoid.action("expanding");
        action.checkable = true;
        action.checked = Qt.binding(function() {return Plasmoid.configuration.expanding});

        //Plasmoid.removeAction("configure");
    }

    property real optimalSize: {
        if (!panelLayout || !Plasmoid.configuration.expanding) return Plasmoid.configuration.length;
        let expandingSpacers = 0;
        let thisSpacerIndex = null;
        let sizeHints = [0];
        // Children order is guaranteed to be the same as the visual order of items in the layout
        for (var i in panelLayout.children) {
            var child = panelLayout.children[i];
            if (!child.visible) continue;

            if (child.applet && child.applet.pluginName === Plasmoid.pluginName && child.applet.configuration.expanding) {
                if (child === Plasmoid.parent) {
                    thisSpacerIndex = expandingSpacers
                }
                sizeHints.push(0)
                expandingSpacers += 1
            } else if (root.horizontal) {
                sizeHints[sizeHints.length - 1] += Math.min(child.Layout.maximumWidth, Math.max(child.Layout.minimumWidth, child.Layout.preferredWidth)) + panelLayout.rowSpacing;
            } else {
                sizeHints[sizeHints.length - 1] += Math.min(child.Layout.maximumHeight, Math.max(child.Layout.minimumHeight, child.Layout.preferredHeight)) + panelLayout.columnSpacing;
            }
        }
        sizeHints[0] *= 2; sizeHints[sizeHints.length - 1] *= 2
        let containment = panelLayout
        let opt = (root.horizontal ? containment.width : containment.height) / expandingSpacers - sizeHints[thisSpacerIndex] / 2 - sizeHints[thisSpacerIndex + 1] / 2
        return Math.max(opt, 0)
    }

    Rectangle {
        anchors.fill: parent
        color: PlasmaCore.Theme.highlightColor
        opacity: Plasmoid.editMode ? 1 : 0
        visible: Plasmoid.editMode || animator.running

        Behavior on opacity {
            NumberAnimation {
                id: animator
                duration: PlasmaCore.Units.longDuration
                // easing.type is updated after animation starts
                easing.type: Plasmoid.editMode ? Easing.InCubic : Easing.OutCubic
            }
        }

    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton

        onEntered: {
            printLog `Entered MouseArea`
        }

        onClicked: {
            // ignore id moved
            wasDoubleClicked = false
            clickTimer.restart()
            movementY = mouseY - startY
            movementX = mouseX - startX
            mouseButton = mouse.button
        }

        onDoubleClicked: {
            printLog `DOUBLE CLICK`
            wasDoubleClicked = true
            runAction(doubleClickAction,doubleClickCommand,doubleClickAppUrl)
        }

        Timer {
            id: clickTimer
            interval: 300
            repeat: false
            onTriggered: {
                if (!wasDoubleClicked) {
                    printLog `SINGLE CLICK`
                    var movementAbsX = Math.abs(movementX)
                    var movementAbsY = Math.abs(movementY)
                    if (movementAbsY < minMovement && movementAbsX < minMovement) {
                        if (mouseButton === Qt.MiddleButton) {
                            printLog `Middle button pressed`
                            runAction(middleClickAction,middleClickCommand,middleClickAppUrl)
                        } else {
                            printLog `Left button pressed`
                            runAction(singleClickAction,singleClickCommand,singleClickAppUrl)
                        }
                    } else {
                        printLog `MOVED WHILE CLICKING, IGNORED`
                        ;
                    }
                }
            }
        }

        onWheel: {
            if (wheel.angleDelta.y > 0) {
                printLog `WHEEL UP`
                runAction(mouseWheelUpAction,mouseWheelUpCommand,mouseWheelUpAppUrl)
            } else {
                printLog `WHEEL DOWN`
                runAction(mouseWheelDownAction,mouseWheelDownCommand,mouseWheelDownAppUrl)
            }
        }

        onPressed: {
            startY = mouseY
            startX = mouseX
        }

        onReleased: {
            printLog `startY: ${startY}, endY ${mouseY} threshold: ${root.height+10}`;
            printLog `startX: ${startX}, "endX: ${mouseX} threshold: ${root.height+10}`
            movementY = mouseY - startY
            movementX = mouseX - startX
            var movementAbsX = Math.abs(movementX)
            var movementAbsY = Math.abs(movementY)
            printLog `Mov X: ${movementX} Mov Y: ${movementY}`
            if (movementAbsY > movementAbsX && movementAbsY >= minMovement) {
                // UP DOWN
                if (movementY > 0) {
                    printLog `DRAG DOWN`
                    runAction(mouseDragDownAction,mouseDragDownCommand,mouseDragDownAppUrl)
                    return
                }
                if (movementY < 0) {
                    printLog `DRAG UP`
                    runAction(mouseDragUpAction,mouseDragUpCommand,mouseDragUpAppUrl)
                    return
                }
            }

            if (movementAbsX > movementAbsY && movementAbsX >= minMovement) {
                // LEFT RIGHT
                if (movementX > 0) {
                    printLog `DRAG LEFT`
                    runAction(mouseDragRightAction,mouseDragRightCommand,mouseDragRightAppUrl)
                    return
                }
                if (movementX < 0) {
                    printLog `DRAG RIGHT`
                    runAction(mouseDragLeftAction,mouseDragLeftCommand,mouseDragLeftAppUrl)
                    return
                }
            }
        }

        onPressAndHold: {
            printLog `LONG PRESS`
            runAction(pressHoldAction,pressHoldCommand,pressHoldAppUrl)
            return
        }
    }

    PlasmaCore.ToolTipArea {
        anchors.fill: parent
        mainItem: Tooltip {}
        visible: showTooltip
    }
}
