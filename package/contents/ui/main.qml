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
    property bool isWayland: Qt.platform.pluginName.includes("wayland")
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
    property bool isActiveWindowPinned: false
    property var startPos: {
        "x": 0,
        "y": 0
    }
    property var endPos: {
        "x": 0,
        "y": 0
    }
    property var localStartPos: dragHandler.parent.mapFromGlobal(startPos.x, startPos.y)
    property var dragHandler
    property bool pressed: dragHandler.active || tapHandler.pressed
    property bool dragging: false
    property bool wasDoubleClicked: false
    // TODO make distance configurable instead??
    property bool doubleClickAllowed: doubleClickAction[0] !== "Disabled"
    property int minDragDistance: horizontal ? root.height : root.width
    property var mouseButton: undefined

    property string toolsDir: Qt.resolvedUrl("./tools").toString().substring(7)
    property string scriptUtil: `${toolsDir}/run_kwin_script.sh`

    property string kwinScriptFile: `${toolsDir}/focusTopWindow.js`
    property string kwinCommand: `'${scriptUtil}' focusTopWindow '${kwinScriptFile}' ${enableDebug}`

    property var requiresFocus: ["kwin,ExposeClass", "kwin,Decrease Opacity", "kwin,Increase Opacity", "kwin,InvertWindow", "kwin,Kill Window", "kwin,Setup Window Shortcut", "kwin,Switch Window Down", "kwin,Switch Window Left", "kwin,Switch Window Right", "kwin,Switch Window Up", "kwin,Toggle Window Raise/Lower", "kwin,Walk Through Windows of Current Application", "kwin,Window Above Other Windows", "kwin,Window Below Other Windows", "kwin,Window Close", "kwin,Window Fullscreen", "kwin,Window Grow", "kwin,Window Lower", "kwin,Window Maximize", "kwin,Window Minimize", "kwin,Window Move", "kwin,Window No Border", "kwin,Window On All Desktops", "kwin,Window One Desktop", "kwin,Window One Screen", "kwin,Window Operations Menu", "kwin,Window Pack", "kwin,Window Quick Tile", "kwin,Window Raise", "kwin,Window Resize", "kwin,Window Shade", "kwin,Window Shrink", "kwin,Window to"]

    property var blockContinuousDrag: ["kwin,ExposeClass", "kwin,Kill Window", "kwin,Setup Window Shortcut", "kwin,Toggle Window Raise/Lower", "kwin,Window Above Other Windows", "kwin,Window Below Other Windows", "kwin,Window Fullscreen", "kwin,Window Maximize", "kwin,Window Move", "kwin,Window Operations Menu", "kwin,Window Resize", "kwin,Window Shade", "kwin,Window Shrink", "kwin,Cube", "kwin,Overview", "kwin,Cycle Overview", "kwin,Cycle Overview Opposite", "kwin,Edit Tiles", "kwin,Expose", "kwin,ExposeAll", "kwin,Grid View",]

    function stopContinuousDrag(action) {
        var component = action[0];
        var actionNme = action[1];
        return blockContinuousDrag.includes(component + "," + actionNme);
    }

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
    property bool showHoverBg: plasmoid.configuration.showHoverBg
    property int hoverBgRadius: plasmoid.configuration.hoverBgRadius
    property int scrollSensitivity: plasmoid.configuration.scrollSensitivity
    property bool isContinuous: plasmoid.configuration.isContinuous

    property bool bgFillPanel: plasmoid.configuration.bgFillPanel
    Plasmoid.constraintHints: bgFillPanel ? Plasmoid.CanFillArea : Plasmoid.NoHint

    property bool overPanel: false
    property string gestureDisplayName
    property string actionDisplayText

    Layout.fillWidth: Plasmoid.configuration.expanding
    Layout.fillHeight: Plasmoid.configuration.expanding

    Layout.minimumWidth: Plasmoid.containment.corona?.editMode ? Kirigami.Units.gridUnit * 2 : 1
    Layout.minimumHeight: Plasmoid.containment.corona?.editMode ? Kirigami.Units.gridUnit * 2 : 1
    Layout.preferredWidth: horizontal ? (Plasmoid.configuration.expanding ? optimalSize : Plasmoid.configuration.length) : 0
    Layout.preferredHeight: horizontal ? 0 : (Plasmoid.configuration.expanding ? optimalSize : Plasmoid.configuration.length)

    preferredRepresentation: fullRepresentation

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
            Qt.callLater(updateWindowsinfo);
        }
        onCountChanged: {
            Qt.callLater(updateWindowsinfo);
        }
    }

    function updateWindowsinfo() {
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

    function dumpProps(obj) {
        console.error("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
        for (var k of Object.keys(obj)) {
            const val = obj[k];
            // if (typeof val === 'function') continue
            if (k === 'metaData')
                continue;
            print(k + "=" + val + "\n");
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

    P5Support.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []
        onNewData: function (source) {
            disconnectSource(source); // cmd finished
        }

        function exec(cmd) {
            executable.connectSource(cmd);
        }
    }

    Logic {
        id: logic
    }

    P5Support.DataSource {
        id: sendNotification
        engine: "executable"
        connectedSources: []
        onNewData: function (source) {
            disconnectSource(source); // cmd finished
        }

        function exec(cmd) {
            executable.connectSource(cmd);
        }
    }

    property bool tick: false

    function notify(title, text) {
        let cmd;
        if (plasmoid.configuration.notificationType === 1) {
            // avoid hitting org.freedesktop.Notifications.Error.ExcessNotificationGeneration
            // by addind extra space every other notification
            if (tick) {
                title += " ";
            }
            tick = !tick;
            cmd = `gdbus call --session --dest org.freedesktop.Notifications --object-path /org/freedesktop/Notifications --method org.freedesktop.Notifications.Notify "${Plasmoid.metaData.name}" 0 "" "${title}" '${text}' "[]" {} 1000`;
        } else if (plasmoid.configuration.notificationType === 2) {
            cmd = `gdbus call --session --dest org.kde.plasmashell --object-path /org/kde/osdService --method org.kde.osdService.showText plasmashell '${title} • ${text}'`;
        } else {
            return;
        }
        sendNotification.exec(cmd);
    }

    function runAction(action, command, application) {
        printLog`RUNNING_ACTION: ${action}`;
        var component = action[0];
        var actionNme = action[1];
        if (actionNme != "Disabled") {
            // custom command
            if (component == "custom_command") {
                var commandFormatted = "";
                var commandLines = command.split('\n');
                for (let i = 0; i < commandLines.length; i++) {
                    commandFormatted += commandLines[i] + (commandLines[i].endsWith(";") ? " " : "; ");
                }
                printLog`RUNNING_CUSTOM_COMMAND: ${command}`;
                notify(gestureDisplayName, command);
                executable.exec(commandFormatted);
                return;
            }

            if (component == "launch_application") {
                if (application !== "") {
                    printLog`LAUNCHING_APPLICATION_URL: ${application}`;
                    notify(gestureDisplayName, `Opening ${application}`);
                    logic.openUrl(application);
                }
                return;
            }

            if (actionNme == "Window Maximize Only") {
                notify(gestureDisplayName, actionNme);
                setMaximized(true);
                return;
            }
            if (actionNme == "Window Unmaximize Only") {
                notify(gestureDisplayName, actionNme);
                setMaximized(false);
                return;
            }
            const shortcutCommand = 'gdbus call --session --dest org.kde.kglobalaccel --object-path /component/' + component + ' --method org.kde.kglobalaccel.Component.invokeShortcut ' + '\"' + actionNme + '\"';
            let preCmd = "true";
            if (requiresFocus.includes(component + "," + actionNme)) {
                activateLastWindow();
                preCmd = kwinCommand;
            }
            printLog`RUNNING_SHORTCUT: ${preCmd + ";" + shortcutCommand}`;
            notify(gestureDisplayName, `${component} • ${actionNme}`);
            executable.exec(preCmd + ";" + shortcutCommand);
        }
        // end the drag for these
        if (stopContinuousDrag(action)) {
            dragging = false;
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

    property Item containment: {
        let candidate = root.parent;
        while (candidate) {
            if (candidate.toString().indexOf("ContainmentItem_QML") > -1) {
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
        if (!panelLayout || !Plasmoid.configuration.expanding)
            return Plasmoid.configuration.length;
        let expandingSpacers = 0;
        let thisSpacerIndex = null;
        let sizeHints = [0];
        // Children order is guaranteed to be the same as the visual order of items in the layout
        for (const child of panelLayout.children) {
            if (!child.visible) {
                continue;
            }

            if (child.applet?.plasmoid?.pluginName === 'luisbocanegra.panelspacer.extended' && child.applet.plasmoid.configuration.expanding) {
                if (child.applet.plasmoid === Plasmoid) {
                    thisSpacerIndex = expandingSpacers;
                }
                sizeHints.push(0);
                expandingSpacers += 1;
            } else if (root.horizontal) {
                sizeHints[sizeHints.length - 1] += Math.min(child.Layout.maximumWidth, Math.max(child.Layout.minimumWidth, child.Layout.preferredWidth)) + panelLayout.columnSpacing + child.Layout.leftMargin + child.Layout.rightMargin;
            } else {
                sizeHints[sizeHints.length - 1] += Math.min(child.Layout.maximumHeight, Math.max(child.Layout.minimumHeight, child.Layout.preferredHeight)) + panelLayout.rowSpacing + child.Layout.topMargin + child.Layout.bottomMargin;
            }
        }
        sizeHints[0] *= 2;
        sizeHints[sizeHints.length - 1] *= 2;
        let panelWidth = horizontal ? containment.width : containment.height;
        let layoutWidth = horizontal ? panelLayout.width : panelLayout.height;
        panelWidth -= panelWidth - layoutWidth;
        let opt = panelWidth / expandingSpacers - sizeHints[thisSpacerIndex] / 2 - sizeHints[thisSpacerIndex + 1] / 2;
        return Math.max(opt, 0);
    }

    property string info: ""
    property string btn: ""
    property string dragInfo: ""
    Rectangle {
        anchors.fill: parent
        color: Kirigami.Theme.highlightColor
        opacity: {
            if (Plasmoid.containment.corona?.editMode) {
                return 1;
            } else if (pressed && showHoverBg && overPanel) {
                return 0.6;
            } else if (showHoverBg && hoverHandler.hovered) {
                return 0.3;
            } else if (plasmoid.configuration.alwaysHighlighted) {
                return 0.15;
            } else {
                return 0;
            }
        }
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
            rotation: horizontal ? 0 : 270
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
        return Math.sqrt(dx * dx + dy * dy);
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
        color: (enableDebug && pressed && hoverHandler.hovered) ? "red" : "transparent"
    }

    HoverHandler {
        id: hoverHandler
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
        onHoveredChanged: {
            if (hovered) {
                hideTooltip = false;
                info = "In " + Plasmoid.configuration.length + "|" + optimalSize;
            } else {
                info = i18n('Out (pressed=') + pressed + ') ' + Plasmoid.configuration.length + "|" + optimalSize;
            }
        }
    }

    onWidthChanged: {
        localStartPos = dragHandler.parent.mapFromGlobal(startPos.x, startPos.y);
    }

    onHeightChanged: {
        localStartPos = dragHandler.parent.mapFromGlobal(startPos.x, startPos.y);
    }

    onLocalStartPosChanged: {
        dragArea.x = localStartPos.x - (dragArea.width / 2);
        dragArea.y = localStartPos.y - (dragArea.height / 2);
    }

    function runDragAction(direction) {
        btn = '';
        printLog`Drag end: ${endPos}`;
        printLog`Drag direction ${direction}`;
        switch (direction) {
        case "up":
            dragInfo = i18n('Drag up');
            root.gestureDisplayName = dragInfo;
            runAction(mouseDragUpAction, mouseDragUpCommand, mouseDragUpAppUrl);
            break;
        case "down":
            dragInfo = i18n('Drag down');
            root.gestureDisplayName = dragInfo;
            runAction(mouseDragDownAction, mouseDragDownCommand, mouseDragDownAppUrl);
            break;
        case "left":
            dragInfo = i18n('Drag left');
            root.gestureDisplayName = dragInfo;
            runAction(mouseDragLeftAction, mouseDragLeftCommand, mouseDragLeftAppUrl);
            break;
        case "right":
            dragInfo = i18n('Drag right');
            root.gestureDisplayName = dragInfo;
            runAction(mouseDragRightAction, mouseDragRightCommand, mouseDragRightAppUrl);
            break;
        default:
            dragInfo = '';
        }
    }

    property Component pointHandlerComponent: PointHandler {
        target: null
        cursorShape: (active && dragging) ? Qt.ClosedHandCursor : Qt.ArrowCursor
        onActiveChanged: {
            if (active) {
                dragging = true;
                startPos = this.parent.mapToGlobal(point.pressPosition.x, point.pressPosition.y);
                localStartPos = this.parent.mapFromGlobal(startPos.x, startPos.y);
                printLog`Drag start: ${startPos}`;
            } else {
                if (isWayland)
                    return;
                printLog`onActiveChanged`;
                if (dragging) {
                    printLog`(active && dragging)`;
                    endPos = dragHandler.parent.mapToGlobal(point.position.x, point.position.y);
                    const distance = getDistance(startPos, endPos);
                    if (!tapHandler.pressed && distance >= minDragDistance) {
                        const dragDirection = getDragDirection(startPos, endPos);
                        runDragAction(dragDirection);
                    }
                }
            }
        }

        onPointChanged: {
            if (active && dragging) {
                endPos = this.parent.mapToGlobal(point.position.x, point.position.y);
                const distance = getDistance(startPos, endPos);
                root.overPanel = distance <= minDragDistance;
                if ((!tapHandler.pressed || isContinuous) && distance >= minDragDistance) {
                    const dragDirection = getDragDirection(startPos, endPos);
                    // we can't do a drag out of the panel on X11,
                    // fallback to onActiveChanged == false (mouse released) above
                    if (!isWayland && ((horizontal && ["up", "down"].includes(dragDirection)) || (!horizontal && ["left", "right"].includes(dragDirection)))) {
                        return;
                    }
                    runDragAction(dragDirection);
                    startPos = endPos;
                    if (!isContinuous)
                        dragging = false;
                }
            }
        }
    }

    Timer {
        id: singleTapTimer
        interval: doubleClickAllowed ? 300 : 3
        onTriggered: {
            btn = i18n('Single clicked');
            if (mouseButton === Qt.MiddleButton) {
                // printLog`Middle button pressed`;
                root.gestureDisplayName = i18n('Middle button pressed');
                runAction(middleClickAction, middleClickCommand, middleClickAppUrl);
            } else {
                // printLog`Left button pressed`;
                root.gestureDisplayName = i18n('Left button pressed');
                runAction(singleClickAction, singleClickCommand, singleClickAppUrl);
            }
        }
    }

    TapHandler {
        id: tapHandler
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton
        onTapped: (eventPoint, button) => {
            dragInfo = '';
            hideTooltip = true;
            if (!singleTapTimer.running) {
                mouseButton = button;
                singleTapTimer.start();
            }
        }

        onDoubleTapped: {
            if (!doubleClickAllowed) {
                return;
            }
            singleTapTimer.stop();
            // printLog`Double tap detected!`;
            btn = i18n('Double clicked');
            root.gestureDisplayName = btn;
            runAction(doubleClickAction, doubleClickCommand, doubleClickAppUrl);
        }

        onLongPressed: {
            // printLog`Long press detected!`;
            btn = "Long press";
            root.gestureDisplayName = btn;
            runAction(pressHoldAction, pressHoldCommand, pressHoldAppUrl);
            target = null;
            enabled = root;
        }
    }

    WheelHandler {
        property int wheelDelta: 0
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
        onWheel: event => {
            // TODO: Different sensitivity per device type
            const delta = (event.inverted ? -1 : 1) * (event.angleDelta.y ? event.angleDelta.y : -event.angleDelta.x);
            wheelDelta += delta;
            while (wheelDelta >= scrollSensitivity) {
                wheelDelta -= scrollSensitivity;
                printLog`WHEEL UP`;
                btn = i18n('Wheel up');
                root.gestureDisplayName = btn;
                runAction(mouseWheelUpAction, mouseWheelUpCommand, mouseWheelUpAppUrl);
            }

            while (wheelDelta <= -scrollSensitivity) {
                wheelDelta += scrollSensitivity;
                printLog`WHEEL DOWN`;
                btn = i18n('Wheel down');
                root.gestureDisplayName = btn;
                runAction(mouseWheelDownAction, mouseWheelDownCommand, mouseWheelDownAppUrl);
            }
        }
    }

    Component.onCompleted: {
        dragHandler = pointHandlerComponent.createObject(root);
        plasmoid.configuration.screenWidth = horizontal ? screenGeometry.width : screenGeometry.height;
    }

    onHorizontalChanged: {
        plasmoid.configuration.screenWidth = horizontal ? screenGeometry.width : screenGeometry.height;
    }
}
