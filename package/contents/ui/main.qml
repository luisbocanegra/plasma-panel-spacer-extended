/*
    SPDX-FileCopyrightText: 2014 Marco Martin <mart@kde.org>

    SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
*/
pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami
import org.kde.plasma.plasma5support as P5Support
import org.kde.plasma.components as PC3
import "code/utils.js" as Utils

PlasmoidItem {
    id: root
    property var logic: null
    property bool horizontal: Plasmoid.formFactor !== PlasmaCore.Types.Vertical
    property bool inEditMode: Plasmoid.containment?.corona?.editMode ?? false
    property bool pressed: desktopGesturesItem?.pressed ?? false
    property bool dragging: desktopGesturesItem?.isDragging ?? false
    property bool hovered: desktopGesturesItem?.hovered ?? false

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

    property var singleClickAction: Plasmoid.configuration.singleClickAction.split(",")
    property var singleClickCommand: Plasmoid.configuration.singleClickCommand
    property var singleClickAppUrl: Plasmoid.configuration.singleClickAppUrl

    property var doubleClickAction: Plasmoid.configuration.doubleClickAction.split(",")
    property var doubleClickCommand: Plasmoid.configuration.doubleClickCommand
    property var doubleClickAppUrl: Plasmoid.configuration.doubleClickAppUrl

    property var middleClickAction: Plasmoid.configuration.middleClickAction.split(",")
    property var middleClickCommand: Plasmoid.configuration.middleClickCommand
    property var middleClickAppUrl: Plasmoid.configuration.middleClickAppUrl

    property var mouseWheelUpAction: Plasmoid.configuration.mouseWheelUpAction.split(",")
    property var mouseWheelUpCommand: Plasmoid.configuration.mouseWheelUpCommand
    property var mouseWheelUpAppUrl: Plasmoid.configuration.mouseWheelUpAppUrl

    property var mouseWheelDownAction: Plasmoid.configuration.mouseWheelDownAction.split(",")
    property var mouseWheelDownCommand: Plasmoid.configuration.mouseWheelDownCommand
    property var mouseWheelDownAppUrl: Plasmoid.configuration.mouseWheelDownAppUrl

    property var mouseDragDownAction: Plasmoid.configuration.mouseDragDownAction.split(",")
    property var mouseDragDownCommand: Plasmoid.configuration.mouseDragDownCommand
    property var mouseDragDownAppUrl: Plasmoid.configuration.mouseDragDownAppUrl

    property var mouseDragUpAction: Plasmoid.configuration.mouseDragUpAction.split(",")
    property var mouseDragUpCommand: Plasmoid.configuration.mouseDragUpCommand
    property var mouseDragUpAppUrl: Plasmoid.configuration.mouseDragUpAppUrl

    property var mouseDragLeftAction: Plasmoid.configuration.mouseDragLeftAction.split(",")
    property var mouseDragLeftCommand: Plasmoid.configuration.mouseDragLeftCommand
    property var mouseDragLeftAppUrl: Plasmoid.configuration.mouseDragLeftAppUrl

    property var mouseDragRightAction: Plasmoid.configuration.mouseDragRightAction.split(",")
    property var mouseDragRightCommand: Plasmoid.configuration.mouseDragRightCommand
    property var mouseDragRightAppUrl: Plasmoid.configuration.mouseDragRightAppUrl

    property var pressHoldAction: Plasmoid.configuration.pressHoldAction.split(",")
    property var pressHoldCommand: Plasmoid.configuration.pressHoldCommand
    property var pressHoldAppUrl: Plasmoid.configuration.pressHoldAppUrl

    property bool enableDebug: Plasmoid.configuration.enableDebug
    property bool showTooltip: Plasmoid.configuration.showTooltip
    property bool hideTooltip: false
    property bool hideWidget: Plasmoid.configuration.hideWidget
    property bool showHoverBg: Plasmoid.configuration.showHoverBg
    property int hoverBgRadius: Plasmoid.configuration.hoverBgRadius
    property bool isContinuous: Plasmoid.configuration.isContinuous

    property bool bgFillPanel: Plasmoid.configuration.bgFillPanel
    Plasmoid.constraintHints: bgFillPanel ? Plasmoid.CanFillArea : Plasmoid.NoHint

    property bool overPanel: false
    property string gestureDisplayName
    property string actionDisplayText

    property var panelView: null
    property bool expanding: Plasmoid.configuration.expanding && panelLengthMode !== 1
    property int panelLengthMode: panelView?.lengthMode ?? 0
    readonly property bool hideInFitContent: Plasmoid.configuration.hideInFitContent

    property bool onDesktop: Plasmoid.location === PlasmaCore.Types.Floating
    property bool gesturesOnDesktop: Plasmoid.configuration.gesturesOnDesktop
    property var wallpaperItem: containmentItem?.wallpaperGraphicsObject ?? null
    property var wallpaperPluginName: wallpaperItem?.pluginName ?? null
    property var containmentPluginName: containmentItem?.pluginName ?? null
    property var containmentItem: Plasmoid.containment ?? null

    property Component desktopComponent: GesturesArea {
        anchors.fill: parent
        customDragDistanceEnabled: Plasmoid.configuration.customDragDistanceEnabled
        customDragDistance: Plasmoid.configuration.customDragDistance
        enableDebug: Plasmoid.configuration.enableDebug
        isContinuous: Plasmoid.configuration.isContinuous
        horizontal: root.horizontal
        doubleClickEnabled: root.doubleClickAction[0] !== "Disabled"
        scrollSensitivity: Plasmoid.configuration.scrollSensitivity
        onDesktop: root.onDesktop && root.gesturesOnDesktop
        idleIcon: Plasmoid.configuration.icon
        isConfiguring: Plasmoid.userConfiguring
        doubleClickInterval: Plasmoid.configuration.customDoubleClickDelayEnabled ? Plasmoid.configuration.customDoubleClickDelay : Qt.styleHints.mouseDoubleClickInterval
        longPressInterval: Plasmoid.configuration.customLongPressDelayEnabled ? Plasmoid.configuration.customLongPressDelay : Qt.styleHints.mousePressAndHoldInterval
        onGesturePerformed: gesture => {
            root.gesture = gesture;
            printLog(`gesture: ${gesture}`);
        }
        actionIconFeedback: Plasmoid.configuration.actionIconFeedback
        onLeftClick: {
            root.runAction(root.singleClickAction, root.singleClickCommand, root.singleClickAppUrl);
        }
        onMiddleClick: {
            root.runAction(root.middleClickAction, root.middleClickCommand, root.middleClickAppUrl);
        }
        onLongPress: {
            root.runAction(root.pressHoldAction, root.pressHoldCommand, root.pressHoldAppUrl);
        }
        onDoubleClick: {
            root.runAction(root.doubleClickAction, root.doubleClickCommand, root.doubleClickAppUrl);
        }
        onWheelUp: {
            root.runAction(root.mouseWheelUpAction, root.mouseWheelUpCommand, root.mouseWheelUpAppUrl);
        }
        onWheelDown: {
            root.runAction(root.mouseWheelDownAction, root.mouseWheelDownCommand, root.mouseWheelDownAppUrl);
        }
        onDragUp: {
            root.runAction(root.mouseDragUpAction, root.mouseDragUpCommand, root.mouseDragUpAppUrl);
            root.dragInfo = "up";
        }
        onDragDown: {
            root.runAction(root.mouseDragDownAction, root.mouseDragDownCommand, root.mouseDragDownAppUrl);
            root.dragInfo = "down";
        }
        onDragLeft: {
            root.runAction(root.mouseDragLeftAction, root.mouseDragLeftCommand, root.mouseDragLeftAppUrl);
            root.dragInfo = "left";
        }
        onDragRight: {
            root.runAction(root.mouseDragRightAction, root.mouseDragRightCommand, root.mouseDragRightAppUrl);
            root.dragInfo = "right";
        }

        PlasmaCore.ToolTipArea {
            anchors.fill: parent
            mainItem: Tooltip {}
            active: root.hovered && !root.pressed && !root.dragging
            visible: root.showTooltip && !root.onDesktop
        }
    }

    property var desktopGesturesItem: null

    function createGesturesItem() {
        if (onDesktop && gesturesOnDesktop && wallpaperItem) {
            desktopGesturesItem = desktopComponent.createObject(wallpaperItem, {});
            return;
        }

        desktopGesturesItem = desktopComponent.createObject(root, {});
    }

    function cleanGesturesItem() {
        if (desktopGesturesItem) {
            desktopGesturesItem.destroy();
            desktopGesturesItem = null;
        }
    }

    function reload() {
        if (!wallpaperPluginName || !containmentPluginName)
            return;
        cleanGesturesItem();
        // callLater so createGesturesItem runs after effects are destroyed
        Qt.callLater(createGesturesItem);
    }

    onWallpaperPluginNameChanged: {
        reload();
    }
    onContainmentPluginNameChanged: {
        reload();
    }

    Item {
        onWindowChanged: window => {
            root.panelView = window;
        }
    }

    Layout.fillWidth: expanding
    Layout.fillHeight: expanding

    Plasmoid.status: (hideInFitContent && panelLengthMode === 1) ? PlasmaCore.Types.HiddenStatus : PlasmaCore.Types.ActiveStatus

    Layout.minimumWidth: Plasmoid.containment.corona?.editMode ? Kirigami.Units.gridUnit * 2 : 1
    Layout.minimumHeight: Plasmoid.containment.corona?.editMode ? Kirigami.Units.gridUnit * 2 : 1
    Layout.preferredWidth: {
        if (Plasmoid.containment?.corona?.editMode) {
            return root.horizontal ? root.height : root.width;
        }
        return horizontal ? (expanding ? optimalSize : Plasmoid.configuration.length) : 0;
    }
    Layout.preferredHeight: {
        if (Plasmoid.containment.corona?.editMode) {
            return root.horizontal ? root.height : root.width;
        }
        return horizontal ? 0 : (expanding ? optimalSize : Plasmoid.configuration.length);
    }

    preferredRepresentation: fullRepresentation

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

    TasksModel {
        id: tasksModel
    }

    P5Support.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []
        onNewData: function (source) {
            disconnectSource(source);
        }

        function exec(cmd) {
            executable.connectSource(cmd);
        }
    }

    property int notificationCount: 0

    Timer {
        id: countReset
        interval: 1000
        onTriggered: root.notificationCount = 0
    }

    function notify(title, text) {
        let cmd;
        if (Plasmoid.configuration.notificationType === 1) {
            // avoid hitting org.freedesktop.Notifications.Error.ExcessNotificationGeneration
            notificationCount += 1;
            title = `${title} ${notificationCount}`;
            cmd = `gdbus call --session --dest org.freedesktop.Notifications --object-path /org/freedesktop/Notifications --method org.freedesktop.Notifications.Notify "${Plasmoid.metaData.name}" 0 "" "${title}" '${text}' "[]" {} 1000`;
        } else if (Plasmoid.configuration.notificationType === 2) {
            cmd = `gdbus call --session --dest org.kde.plasmashell --object-path /org/kde/osdService --method org.kde.osdService.showText plasmashell '${title} • ${text}'`;
        } else {
            return;
        }
        Utils.delay(100, () => executable.exec(cmd), root);
        countReset.restart();
    }

    function runAction(action, command, application) {
        if (stopContinuousDrag(action) && root.dragInfo !== "")
            return;
        printLog(`RUNNING_ACTION: ${action}`);
        var component = action[0];
        var actionNme = action[1];
        if (actionNme != "Disabled") {
            // custom command
            if (component == "custom_command") {
                // make each command unique to allow rapid calls to finish
                // https://github.com/luisbocanegra/plasma-panel-spacer-extended/issues/83
                var commandFormatted = `ms=${Date.now()};`;
                var commandLines = command.split('\n');
                for (let i = 0; i < commandLines.length; i++) {
                    commandFormatted += commandLines[i] + (commandLines[i].endsWith(";") ? " " : "; ");
                }
                printLog(`RUNNING_CUSTOM_COMMAND: ${command}`);
                notify(gestureDisplayName, command);
                executable.exec(commandFormatted);
                return;
            }

            if (component == "launch_application") {
                if (application !== "") {
                    printLog(`LAUNCHING_APPLICATION_URL: ${application}`);
                    notify(gestureDisplayName, `Opening ${application}`);
                    quickLaunch.openUrl(application);
                }
                return;
            }

            if (actionNme == "Window Maximize Only") {
                notify(gestureDisplayName, actionNme);
                tasksModel.setMaximized(true);
                return;
            }
            if (actionNme == "Window Unmaximize Only") {
                notify(gestureDisplayName, actionNme);
                tasksModel.setMaximized(false);
                return;
            }
            const shortcutCommand = 'gdbus call --session --dest org.kde.kglobalaccel --object-path /component/' + component + ' --method org.kde.kglobalaccel.Component.invokeShortcut ' + '\"' + actionNme + '\"';
            let preCmd = "true";
            if (requiresFocus.includes(component + "," + actionNme)) {
                tasksModel.activateLastWindow();
                preCmd = kwinCommand;
            }
            printLog(`RUNNING_SHORTCUT: ${preCmd + ";" + shortcutCommand}`);
            notify(gestureDisplayName, `${component} • ${actionNme}`);
            executable.exec(preCmd + ";" + shortcutCommand);
        }
        // end the drag for these
        if (stopContinuousDrag(action)) {
            dragging = false;
        }
    }

    function printLog(message) {
        if (enableDebug) {
            console.log(Plasmoid.pluginName + " S:" + root.screen + " ID:" + Plasmoid.id + " " + String(message));
        }
    }

    // Search the actual gridLayout of the panel
    property Item panelLayout: {
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

    readonly property PlasmaCore.Action expandingAction: PlasmaCore.Action {
        text: root.expanding ? i18n("Set fixed size") : i18n("Set flexible size")
        icon.name: "distribute-horizontal-x"
        onTriggered: {
            Plasmoid.configuration.expanding = !Plasmoid.configuration.expanding;
            Plasmoid.configuration.writeConfig();
        }
    }
    PlasmaCore.Action {
        id: configureAction
        objectName: "PSECustomMenuAction"
        text: i18n("Configure %1", Plasmoid.metaData.name)
        icon.name: 'configure'
        onTriggered: Plasmoid.internalAction("configure").trigger()
    }
    PlasmaCore.Action {
        id: separatorAction
        objectName: "PSECustomMenuAction"
        isSeparator: true
    }
    PlasmaCore.Action {
        id: hideWidgetAction
        text: Plasmoid.configuration.hideWidget ? i18n("Show widget") : i18n("Hide widget")
        icon.name: "visibility-symbolic"
        onTriggered: {
            Plasmoid.configuration.hideWidget = !Plasmoid.configuration.hideWidget;
            Plasmoid.configuration.writeConfig();
        }
        visible: root.onDesktop
    }
    property bool contextualActionsEnabled: Plasmoid.configuration.contextualActionsEnabled
    property string contextMenuActions: Plasmoid.configuration.contextMenuActions

    Component {
        id: actionComponent
        PlasmaCore.Action {
            property string actionIcon
            property var callback
            property bool canDestroy: true
            objectName: "PSECustomMenuAction"
            icon.name: actionIcon
            onTriggered: {
                if (callback && typeof callback === "function") {
                    callback();
                }
            }
        }
    }

    Plasmoid.contextualActions: [hideWidgetAction]
    Plasmoid.backgroundHints: {
        if (root.inEditMode || !root.hideWidget) {
            return PlasmaCore.Types.DefaultBackground;
        } else {
            return PlasmaCore.Types.NoBackground;
        }
    }

    function removeContextualActions(contextMenuItem) {
        if (!contextMenuItem && "contextualActions" in contextMenuItem)
            return;
        contextMenuItem.contextualActions = contextMenuItem.contextualActions.filter(item => {
            if (item && item.objectName === "PSECustomMenuAction") {
                if ("canDestroy" in item)
                    item.destroy();
                return false;
            }
            return true;
        });
    }

    function addContextualActions(contextMenuItem) {
        if (inEditMode || !contextMenuItem || !contextualActionsEnabled)
            return;
        let actions = [];
        try {
            const customActions = JSON.parse(contextMenuActions).filter(act => act.enabled === true || act.enabled === undefined);

            for (let act of customActions) {
                let [component, shortcut] = act.action.split(",");
                if (shortcut === "Disabled") {
                    continue;
                }
                let actionText;
                let actionIcon;

                switch (component) {
                case "custom_command":
                    var command = act.command;

                    if (command) {
                        const formattedCmd = Utils.truncateString(command, 70).replace(/(\r\n|\n|\r)/gm, " ").replace(/\s+/g, ' ');
                        if (act.name) {
                            actionText = act.name;
                        } else {
                            actionText = "Command • " + formattedCmd;
                        }
                        actionIcon = act.icon || "scriptnew-symbolic";
                    }
                    break;
                case "launch_application":
                    if (quickLaunch.pluginFound) {
                        var launcher = quickLaunch.launcherData(act.url);
                        if (launcher) {
                            actionText = launcher.applicationName;
                            actionIcon = launcher.iconName;
                        }
                    }
                    break;
                default:
                    if (shortcut && shortcut != "Disabled") {
                        actionText = (component.charAt(0).toUpperCase() + component.substring(1)).replace(/-|_/g, " ") + " • " + shortcut.replace(/-|_/g, " ");
                        actionIcon = "input-keyboard-symbolic";
                    }
                }

                if (!actionText) {
                    continue;
                }

                let action = actionComponent.createObject(root, {
                    text: actionText || "Unknown",
                    actionIcon: actionIcon || "",
                    callback: () => runAction([component, shortcut], act.command, act.url)
                });
                actions.push(action);
            }
        } catch (e) {
            console.log("Error loading contextMenuActions:", e);
        }
        if (actions.length > 0 && !onDesktop) {
            actions.push(separatorAction);
        }
        if (!onDesktop) {
            actions.push(expandingAction);
        }

        if (onDesktop && gesturesOnDesktop) {
            actions.push(configureAction);
        }

        contextMenuItem.contextualActions = [...contextMenuItem.contextualActions, ...actions];
    }

    function updateContextualActions(enable = true) {
        removeContextualActions(Plasmoid);
        removeContextualActions(containmentItem);
        if (!enable) {
            return;
        }
        if (onDesktop && gesturesOnDesktop) {
            removeContextualActions(Plasmoid);
            addContextualActions(containmentItem);
        } else {
            removeContextualActions(containmentItem);
            addContextualActions(Plasmoid);
        }
    }

    property real optimalSize: {
        if (!panelLayout || !expanding)
            return Plasmoid.configuration.length;
        let expandingSpacers = 0;
        let thisSpacerIndex = null;
        let sizeHints = [0];
        // Children order is guaranteed to be the same as the visual order of items in the layout
        for (const child of panelLayout.children) {
            if (!child.visible) {
                continue;
            }

            if (child.applet?.Plasmoid?.pluginName === 'luisbocanegra.panelspacer.extended' && child.applet.expanding) {
                if (child.applet.Plasmoid === Plasmoid) {
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

    property string gesture: ""
    property string dragInfo: ""
    Rectangle {
        id: widgetBg
        anchors.fill: parent
        color: Kirigami.Theme.highlightColor
        visible: !root.hideWidget || root.inEditMode
        opacity: {
            if (Plasmoid.containment.corona?.editMode) {
                return 1;
            } else if (root.pressed && root.showHoverBg && root.hovered) {
                return 0.6;
            } else if (root.showHoverBg && root.hovered) {
                return 0.3;
            } else if (Plasmoid.configuration.alwaysHighlighted) {
                return 0.15;
            } else {
                return 0;
            }
        }
        radius: root.hoverBgRadius

        Behavior on opacity {
            NumberAnimation {
                id: animator
                duration: Kirigami.Units.longDuration
                easing.type: Plasmoid.containment.corona?.editMode ? Easing.InCubic : Easing.OutCubic
            }
        }
    }

    PC3.Label {
        anchors.centerIn: parent
        visible: !root.hideWidget && !root.inEditMode && root.enableDebug
        font: Kirigami.Theme.smallFont
        text: {
            let out = "";
            if (root.enableDebug) {
                if (root.hovered) {
                    out = "In ";
                } else {
                    out = "Out ";
                }
                out += `(pr=${root.pressed} ho=${root.hovered} gesture=${root.gesture}) ${Plasmoid.configuration.length}|${root.optimalSize.toFixed(2)}`;
            }
            return out;
        }
        rotation: root.horizontal ? 0 : 270
    }

    PlasmaCore.ToolTipArea {
        anchors.fill: parent
        mainItem: Tooltip {}
        visible: root.showTooltip && root.onDesktop
    }

    QuickLaunch {
        id: quickLaunch
        onPluginFoundChanged: {
            if (pluginFound) {
                root.updateContextualActions();
            }
        }
    }

    onHoveredChanged: {
        root.dragInfo = "";
    }
    onContextMenuActionsChanged: Qt.callLater(updateContextualActions)
    onContainmentItemChanged: Qt.callLater(updateContextualActions)
    onContextualActionsEnabledChanged: Qt.callLater(updateContextualActions)
    onInEditModeChanged: {
        if (!inEditMode) {
            updateContextualActions();
        }
    }
    onGesturesOnDesktopChanged: {
        reload();
        updateContextualActions();
    }
    onOnDesktopChanged: {
        reload();
        updateContextualActions();
    }

    Component.onCompleted: {
        Plasmoid.configuration.screenWidth = horizontal ? screenGeometry.width : screenGeometry.height;
        createGesturesItem();
    }

    Connections {
        target: Qt.application
        function onAboutToQuit() {
            root.cleanGesturesItem();
            root.updateContextualActions(false);
        }
    }

    Component.onDestruction: {
        cleanGesturesItem();
        updateContextualActions(false);
    }

    onHorizontalChanged: {
        Plasmoid.configuration.screenWidth = horizontal ? screenGeometry.width : screenGeometry.height;
    }
}
