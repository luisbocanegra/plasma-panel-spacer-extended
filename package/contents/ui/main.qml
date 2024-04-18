/*
    SPDX-FileCopyrightText: 2014 Marco Martin <mart@kde.org>

    SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
*/

import QtQuick
import QtQuick.Layouts
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami
import org.kde.taskmanager as TaskManager
import org.kde.plasma.private.quicklaunch
import org.kde.plasma.plasma5support as P5Support
import org.kde.plasma.components as PC3

PlasmoidItem {
    id: root

    property bool horizontal: Plasmoid.formFactor !== PlasmaCore.Types.Vertical
    property var activeTaskLocal: null
    property bool noWindowActive: true
    property bool currentWindowMaximized: false
    property bool isActiveWindowPinned: false
    property var startPos
    property var endPos
    property bool pressed: dragHandler.active || tapHandler.pressed
    property bool dragging: false
    property bool wasDoubleClicked: false
    // TODO make distance configurable instead??
    property int minDragDistance: horizontal ? root.height : root.width
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
    property bool hideTooltip: false // hide tooltip after action
    property string qdbusCommand: plasmoid.configuration.qdbusCommand
    property bool showHoverBg: plasmoid.configuration.showHoverBg
    property int hoverBgRadius: plasmoid.configuration.hoverBgRadius

    property bool bgFillPanel: plasmoid.configuration.bgFillPanel
    Plasmoid.constraintHints: bgFillPanel ? Plasmoid.CanFillArea : Plasmoid.NoHint

    Layout.fillWidth: Plasmoid.configuration.expanding
    Layout.fillHeight: Plasmoid.configuration.expanding

    Layout.minimumWidth: Plasmoid.containment.corona?.editMode ? Kirigami.Units.gridUnit * 2 : 1
    Layout.minimumHeight: Plasmoid.containment.corona?.editMode ? Kirigami.Units.gridUnit * 2 : 1
    Layout.preferredWidth: horizontal
        ? (Plasmoid.configuration.expanding ? optimalSize : Plasmoid.configuration.length)
        : 0
    Layout.preferredHeight: horizontal
        ? 0
        : (Plasmoid.configuration.expanding ? optimalSize : Plasmoid.configuration.length)

    preferredRepresentation: fullRepresentation

    // Toggle maximize with mouse wheel/left click from https://invent.kde.org/plasma/plasma-active-window-control
    //
    // MODEL
    //
    TaskManager.TasksModel {
        id: tasksModel
        sortMode: TaskManager.TasksModel.SortVirtualDesktop
        groupMode: TaskManager.TasksModel.GroupDisabled

        // screenGeometry: plasmoid.screenGeometry
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

    P5Support.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []
        onNewData: function(source) {
            disconnectSource(source) // cmd finished
        }

        function exec(cmd) {
            executable.connectSource(cmd)
        }
    }

    Logic {
        id: logic
    }

    function runAction(action,command,application) {
        printLog `RUNNING_ACTION: ${action}`
        var component = action[0]
        var actionNme = action[1]
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
            var shortcutCommand = qdbusCommand+' org.kde.kglobalaccel /component/'+component+' org.kde.kglobalaccel.Component.invokeShortcut '+'\"'+actionNme+'\"'
            printLog `RUNNING_SHORTCUT_COMMAND: ${shortcutCommand}`
            executable.exec(shortcutCommand);
        }
    }

    function printLog(strings, ...values) {
        if (enableDebug) {
            let str = 'PPSE: ';
            strings.forEach((string, i) => {
                str += string + (values[i] !== undefined ? values[i] : '');
            });
            if (enableDebug) {
                console.log(str);
            }
        }
    }

    // Search the actual gridLayout of the panel
    property GridLayout panelLayout: {
        let candidate = root.parent;
        while (candidate) {
            if (candidate instanceof GridLayout) {
                return candidate;
            }
            candidate = candidate.parent;
        }
        return null;
    }

    Plasmoid.contextualActions: [
        PlasmaCore.Action {
            text: i18n("Set flexible size")
            checkable: true
            checked: Plasmoid.configuration.expanding
            onTriggered: checked => {
                Plasmoid.configuration.expanding = checked;
            }
        }
    ]

    property real optimalSize: {
        if (!panelLayout || !Plasmoid.configuration.expanding) return Plasmoid.configuration.length;
        let expandingSpacers = 0;
        let thisSpacerIndex = null;
        let sizeHints = [0];
        // Children order is guaranteed to be the same as the visual order of items in the layout
        for (var i in panelLayout.children) {
            const child = panelLayout.children[i];
            if (!child.visible) continue;

            if (child.applet && child.applet.plasmoid.pluginName === 'luisbocanegra.panelspacer.extended' && child.applet.plasmoid.configuration.expanding) {
                if (child.applet.plasmoid === Plasmoid) {

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
        let opt = (horizontal ? panelLayout.width : panelLayout.height) / expandingSpacers - sizeHints[thisSpacerIndex] / 2 - sizeHints[thisSpacerIndex + 1] / 2
        return Math.max(opt, 0)
    }

    property string info: ""
    property string btn: ""
    property string dragInfo: ""
    Rectangle {
        anchors.fill: parent
        color: Kirigami.Theme.highlightColor
        opacity: Plasmoid.containment.corona?.editMode || (pressed && showHoverBg) ? 0.6 : 0.2
        visible: Plasmoid.containment.corona?.editMode || animator.running || (hoverHandler.hovered && showHoverBg) || Plasmoid.userConfiguring
        radius: hoverBgRadius

        Behavior on opacity {
            NumberAnimation {
                id: animator
                duration: Kirigami.Units.longDuration
                // easing.type is updated after animation starts
                easing.type: Plasmoid.containment.corona?.editMode ? Easing.InCubic : Easing.OutCubic
            }
        }
    }

    RowLayout {
        anchors.centerIn: parent
        Kirigami.Icon {
            width: horizontal ? parent.height : parent.width
            height: width
            visible: Plasmoid.userConfiguring
            source: "configure"
            smooth: true
            NumberAnimation on rotation {
                from: 0
                to: 360
                running: Plasmoid.userConfiguring
                loops: Animation.Infinite
                duration: 3000
            }
        }

        PC3.Label {
            text: info + " " + btn + " " + dragInfo
            rotation : horizontal ? 0 : 270
            visible: enableDebug && !(Plasmoid.containment.corona?.editMode || animator.running)
        }
    }

    function getDragDirection(startPoint, endPoint) {
        var dx = endPoint.x - startPoint.x;
        var dy = endPoint.y - startPoint.y;
        if (Math.abs(dx) > Math.abs(dy)) {
            return dx > 0 ? 'right' : 'left';
        } else {
            return dy > 0 ? 'down' : 'up';
        }
    }

    function getDistance(startPoint, endPoint) {
        var dx = endPoint.x - startPoint.x;
        var dy = endPoint.y - startPoint.y;
        return Math.sqrt(dx * dx + dy * dy)
    }

    PlasmaCore.ToolTipArea {
        anchors.fill: parent
        mainItem: Tooltip {}
        enabled: hoverHandler.hovered && !hideTooltip
        visible: showTooltip
    }

    Rectangle {
        id: dragArea
        height: minDragDistance * 2
        width: height
        opacity: 0.5
        color: (enableDebug && dragging) ? "red" : "transparent"
    }

    HoverHandler {
        id: hoverHandler
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
        cursorShape: Qt.PointingHandCursor
        onHoveredChanged: {
            if (hovered) {
                hideTooltip = false
                info = "In " + Plasmoid.configuration.length +"|"+ optimalSize
            } else {
                info = qsTr('Out (pressed=') + pressed + ') ' + Plasmoid.configuration.length +"|"+ optimalSize
            }
        }
    }

    PointHandler {
        id: dragHandler
        target: null
        onActiveChanged: {
            if (active) {
                dragging = true
                startPos = Qt.point(point.pressPosition.x, point.pressPosition.y)
                dragArea.x = startPos.x - (dragArea.width / 2)
                dragArea.y = startPos.y - (dragArea.height / 2)
                printLog `Drag start: ${startPos}`
            }
        }

        onPointChanged: {
            if (active && dragging) {
                endPos = Qt.point(point.position.x, point.position.y);
                const distance = getDistance(startPos, endPos)
                if (!tapHandler.pressed && distance >= minDragDistance) {
                    btn = ''
                    dragging = false
                    printLog `Drag end: ${endPos}`
                    const dragDirection = getDragDirection(startPos, endPos)
                    printLog `Drag direction ${dragDirection}`
                    switch (dragDirection) {
                        case "up":
                            printLog `Drag up detected`
                            dragInfo = qsTr('Drag up')
                            runAction(mouseDragUpAction, mouseDragUpCommand, mouseDragUpAppUrl)
                            break
                        case "down":
                            printLog `Drag down detected`
                            dragInfo = qsTr('Drag down')
                            runAction(mouseDragDownAction, mouseDragDownCommand, mouseDragDownAppUrl)
                            break
                        case "left":
                            printLog `Drag left detected`
                            dragInfo = qsTr('Drag left')
                            runAction(mouseDragLeftAction, mouseDragLeftCommand, mouseDragLeftAppUrl)
                            break
                        case "right":
                            printLog `Drag right detected`
                            dragInfo = qsTr('Drag right')
                            runAction(mouseDragRightAction, mouseDragRightCommand, mouseDragRightAppUrl)
                            break
                        default:
                            dragInfo = ''
                    }
                }
            }
        }
    }

    Timer {
        id: singleTapTimer
        interval: 300
        onTriggered: {
            btn = qsTr('Single clicked')
            if (mouseButton === Qt.MiddleButton) {
                printLog `Middle button pressed`
                runAction(middleClickAction,middleClickCommand,middleClickAppUrl)
            } else {
                printLog `Left button pressed`
                runAction(singleClickAction,singleClickCommand,singleClickAppUrl)
            }
        }
    }

    TapHandler {
        id: tapHandler
        onTapped: (eventPoint, button) => {
            dragInfo = ''
            hideTooltip = true
            if (!singleTapTimer.running) {
                mouseButton = button
                singleTapTimer.start();
            }
        }

        onDoubleTapped: {
            singleTapTimer.stop()
            printLog `Double tap detected!`
            btn = qsTr('Double clicked')
            runAction(doubleClickAction,doubleClickCommand,doubleClickAppUrl)
        }

        onLongPressed: {
            printLog `Long press detected!`
            btn = "Hold"
            runAction(pressHoldAction,pressHoldCommand,pressHoldAppUrl)
            target = null
            enabled = root
        }
    }

    WheelHandler {
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
        onWheel: (event) => {
            if (event.angleDelta.y > 0) {
                printLog `WHEEL UP`
                btn = qsTr('Wheel up')
                runAction(mouseWheelUpAction,mouseWheelUpCommand,mouseWheelUpAppUrl)
            } else {
                printLog `WHEEL DOWN`
                btn = qsTr('Wheel down')
                runAction(mouseWheelDownAction,mouseWheelDownCommand,mouseWheelDownAppUrl)
            }
        }
    }

    Component.onCompleted: {
        plasmoid.configuration.screenWidth = horizontal ? screenGeometry.width : screenGeometry.height
    }

    onHorizontalChanged: {
        plasmoid.configuration.screenWidth = horizontal ? screenGeometry.width : screenGeometry.height
    }
}
