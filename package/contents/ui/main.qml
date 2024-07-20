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
    property var activeTask: null
    property var activeProps: {"name":"", "title":"", "id":""}
    property var abstractTasksModel: TaskManager.AbstractTasksModel
    property var isMaximized: abstractTasksModel.IsMaximized
    property var isActive: abstractTasksModel.IsActive
    property var isWindow: abstractTasksModel.IsWindow

    property var isFullScreen: abstractTasksModel.IsFullScreen
    property var isMinimized: abstractTasksModel.IsMinimized
    property bool noWindowActive: true
    property bool currentWindowMaximized: false
    property bool isActiveWindowPinned: false
    property var startPos: { "x": 0, "y": 0 }
    property var endPos: { "x": 0, "y": 0 }
    property var localStartPos: dragHandler.parent.mapFromGlobal(startPos.x, startPos.y)
    property var dragHandler
    property bool pressed: dragHandler.active || tapHandler.pressed
    property bool dragging: false
    property bool wasDoubleClicked: false
    // TODO make distance configurable instead??
    property int minDragDistance: horizontal ? root.height : root.width
    property var mouseButton: undefined

    property string toolsDir: Qt.resolvedUrl("./tools").toString().substring(7) + "/"
    property string scriptUtil: toolsDir+"run_kwin_script.sh"
    // property string kwinScriptUtil: "sh "+toolsDir + scriptUtil + " '"+focusTopScriptName+"' '"+focusTopScriptFile+"'"

    function getKwinScriptCommand(scriptName) {
        const scriptFile = toolsDir + scriptName + ".js"
        const kwinCommand = "sh '" + scriptUtil + "' '"+ scriptName + "' '" + scriptFile + "' " + enableDebug
        return kwinCommand
    }

    property var requiresFocus: [
        "kwin,ExposeClass",
        "kwin,Decrease Opacity",
        "kwin,Increase Opacity",
        "kwin,InvertWindow",
        "kwin,Kill Window",
        "kwin,Setup Window Shortcut",
        "kwin,Switch Window Down",
        "kwin,Switch Window Left",
        "kwin,Switch Window Right",
        "kwin,Switch Window Up",
        "kwin,Toggle Window Raise/Lower",
        "kwin,Walk Through Windows of Current Application",
        "kwin,Window Above Other Windows",
        "kwin,Window Below Other Windows",
        "kwin,Window Close",
        "kwin,Window Fullscreen",
        "kwin,Window Grow",
        "kwin,Window Lower",
        "kwin,Window Maximize",
        "kwin,Window Minimize",
        "kwin,Window Move",
        "kwin,Window No Border",
        "kwin,Window On All Desktops",
        "kwin,Window One Desktop",
        "kwin,Window One Screen",
        "kwin,Window Operations Menu",
        "kwin,Window Pack",
        "kwin,Window Quick Tile",
        "kwin,Window Raise",
        "kwin,Window Resize",
        "kwin,Window Shade",
        "kwin,Window Shrink",
        "kwin,Window to"
    ]

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
            updateWindowsinfo()
        }
        // onDataChanged: {
        //     updateWindowsinfo()
        // }
        // onCountChanged: {
        //     updateWindowsinfo()
        // }
    }

    function updateWindowsinfo() {
        for (var i = 0; i < tasksModel.count; i++) {
            const currentTask = tasksModel.index(i, 0)
            if (currentTask === undefined) continue
            if (tasksModel.data(currentTask, isWindow)) {
                if (tasksModel.data(currentTask, isActive)) activeTask = currentTask
            }
        }
        if (activeTask) {
            activeProps.name = tasksModel.data(activeTask, abstractTasksModel.AppName)
            activeProps.id = tasksModel.data(activeTask, abstractTasksModel.WinIdList)
            activeProps.title = tasksModel.data(activeTask, abstractTasksModel.display)
            printLog`Active task: Name: ${activeProps.name} Title: ${activeProps.title} Id: ${activeProps.id}`
        }
    }

    function dumpProps(obj) {
        console.error("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
        for (var k of Object.keys(obj)) {
            const val = obj[k]
            // if (typeof val === 'function') continue
            if (k === 'metaData') continue
            print(k + "=" + val + "\n")
        }
    }

    function activeTaskExists() {
        return activeTask.display !== undefined
    }

    function activateLastWindow() {
        printLog`Trying to activate last window...`
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
            var shortcutCommand = 'gdbus call --session --dest org.kde.kglobalaccel --object-path /component/'+component+' --method org.kde.kglobalaccel.Component.invokeShortcut '+'\"'+actionNme+'\"'
            var kwinCommand = "true"
            if (requiresFocus.includes(component + "," + actionNme)) {
                activateLastWindow()
                kwinCommand = getKwinScriptCommand("focusTopWindow", shortcutCommand)
            }
            printLog `RUNNING_SHORTCUT: ${kwinCommand+";"+shortcutCommand}`
            executable.exec(kwinCommand+";"+shortcutCommand);
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
        color: (enableDebug && pressed && hoverHandler.hovered) ? "red" : "transparent"
    }

    HoverHandler {
        id: hoverHandler
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
        onHoveredChanged: {
            if (hovered) {
                hideTooltip = false
                info = "In " + Plasmoid.configuration.length +"|"+ optimalSize
            } else {
                info = qsTr('Out (pressed=') + pressed + ') ' + Plasmoid.configuration.length +"|"+ optimalSize
            }
        }
    }

    onWidthChanged: {
        localStartPos = dragHandler.parent.mapFromGlobal(startPos.x, startPos.y)
    }

    onHeightChanged: {
        localStartPos = dragHandler.parent.mapFromGlobal(startPos.x, startPos.y)
    }

    onLocalStartPosChanged: {
        dragArea.x = localStartPos.x - (dragArea.width / 2)
        dragArea.y = localStartPos.y - (dragArea.height / 2)
    }

    function runDragAction() {
        btn = ''
        dragging = false
        printLog `Drag end: ${endPos}`
        const dragDirection = getDragDirection(startPos, endPos)
        printLog `Drag direction ${dragDirection}`
        switch (dragDirection) {
            case "up":
                dragInfo = qsTr('Drag up')
                runAction(mouseDragUpAction, mouseDragUpCommand, mouseDragUpAppUrl)
                break
            case "down":
                dragInfo = qsTr('Drag down')
                runAction(mouseDragDownAction, mouseDragDownCommand, mouseDragDownAppUrl)
                break
            case "left":
                dragInfo = qsTr('Drag left')
                runAction(mouseDragLeftAction, mouseDragLeftCommand, mouseDragLeftAppUrl)
                break
            case "right":
                dragInfo = qsTr('Drag right')
                runAction(mouseDragRightAction, mouseDragRightCommand, mouseDragRightAppUrl)
                break
            default:
                dragInfo = ''
        }
    }

    property Component pointHandlerComponent: PointHandler {
        target: null
        cursorShape: (active && dragging) ? Qt.ClosedHandCursor : Qt.ArrowCursor
        onActiveChanged: {
            if (active) {
                dragging = true
                startPos = this.parent.mapToGlobal(point.pressPosition.x, point.pressPosition.y)
                localStartPos = this.parent.mapFromGlobal(startPos.x, startPos.y)
                printLog `Drag start: ${startPos}`
            }
        }

        onPointChanged: {
            if (active && dragging) {
                endPos = this.parent.mapToGlobal(point.position.x, point.position.y)
                const distance = getDistance(startPos, endPos)
                if (!tapHandler.pressed && distance >= minDragDistance) {
                    runDragAction()
                }
            }
        }
    }

    property Component dragHandlerComponent: DragHandler {
        target: null
        cursorShape: (active && dragging) ? Qt.ClosedHandCursor : Qt.ArrowCursor
        acceptedDevices: PointerDevice.AllDevices
        grabPermissions: PointerHandler.ApprovesCancellation
        onActiveChanged: {
            if (active) {
                dragging = true
                startPos = dragHandler.parent.mapToGlobal(persistentTranslation.x, persistentTranslation.y)
                localStartPos = dragHandler.parent.mapFromGlobal(startPos.x, startPos.y)
                printLog `Drag start: ${startPos}`
            }
        }

        onGrabChanged: {
            printLog `onGrabChanged`
            if (dragging) {
                printLog `(active && dragging)`
                endPos = dragHandler.parent.mapToGlobal(persistentTranslation.x, persistentTranslation.y)
                const distance = getDistance(startPos, endPos)
                if (!tapHandler.pressed && distance >= minDragDistance) {
                    runDragAction()
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
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton
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
        property int wheelDelta: 0
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
        onWheel: (event) => {
            // TODO: Different sensitivity per device type
            const delta = (event.inverted ? -1 : 1) * (event.angleDelta.y ? event.angleDelta.y : -event.angleDelta.x);
            wheelDelta += delta;
            while (wheelDelta >= scrollSensitivity) {
                wheelDelta -= scrollSensitivity;
                printLog `WHEEL UP`
                btn = qsTr('Wheel up')
                runAction(mouseWheelUpAction,mouseWheelUpCommand,mouseWheelUpAppUrl)
            }

            while (wheelDelta <= -scrollSensitivity) {
                wheelDelta += scrollSensitivity;
                printLog `WHEEL DOWN`
                btn = qsTr('Wheel down')
                runAction(mouseWheelDownAction,mouseWheelDownCommand,mouseWheelDownAppUrl)
            }
        }
    }

    Component.onCompleted: {
        if (Qt.platform.pluginName.includes("wayland")){
            dragHandler = pointHandlerComponent.createObject(root)
        } else {
            dragHandler = dragHandlerComponent.createObject(root)
        }
        plasmoid.configuration.screenWidth = horizontal ? screenGeometry.width : screenGeometry.height
    }

    onHorizontalChanged: {
        plasmoid.configuration.screenWidth = horizontal ? screenGeometry.width : screenGeometry.height
    }
}
