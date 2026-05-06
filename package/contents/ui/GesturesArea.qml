import QtQuick
import org.kde.kirigami as Kirigami

Item {
    id: root
    anchors.fill: parent

    property bool hovered: hoverHandler.hovered
    property bool pressedReset: false
    property bool pressed: (tapHandler.pressed || dragHandler.active) && !pressedReset
    property bool customDragDistanceEnabled: false
    property int customDragDistance: 10
    property bool onDesktop: false
    property int dragDistance: {
        if (customDragDistanceEnabled) {
            return customDragDistance;
        } else if (root.onDesktop) {
            return Math.min(Screen.width, Screen.height) * 0.1;
        } else {
            return parent ? Math.min(parent.width, parent.height) : 10;
        }
    }
    property int scrollSensitivity: 120
    property bool doubleClickEnabled: true
    property int lastButton: 0
    property int tapCount: 0
    property int doubleClickInterval: 200
    property int longPressInterval: 800
    property bool isDragging: false
    property bool isContinuous: true
    property bool horizontal: false
    property bool isWayland: Qt.platform.pluginName.includes("wayland")
    property bool enableDebug: false
    property string idleIcon: ""
    property bool actionIconFeedback: false
    property bool isConfiguring: false
    readonly property string configuringIcon: isConfiguring ? "configure-symbolic" : ""

    property var localStartPos: Qt.point(0, 0)
    property var startPos: Qt.point(0, 0)
    property var endPos: Qt.point(0, 0)

    property int mouseX: hoverHandler.point.position.x
    property int mouseY: hoverHandler.point.position.y

    signal wheelUp
    signal wheelDown

    signal leftClick
    signal middleClick
    signal longPress
    signal doubleClick

    signal dragUp
    signal dragDown
    signal dragLeft
    signal dragRight

    signal gesturePerformed(string gesture)

    property string lastGesture: ""
    property bool gestureIconVisible: false
    property string gestureIcon: {
        if (!actionIconFeedback)
            return "";
        switch (lastGesture) {
        case "wheel-up":
            return "go-up";
        case "wheel-down":
            return "go-down";
        case "left-click":
            return Qt.resolvedUrl(`./icons/click.svg`);
        case "middle-click":
            return Qt.resolvedUrl(`./icons/click.svg`);
        case "double-click":
            return Qt.resolvedUrl(`./icons/double-click.svg`);
        case "long-press":
            return Qt.resolvedUrl(`./icons/long-press.svg`);
        case "drag-up":
            return "arrow-up-double-symbolic";
        case "drag-down":
            return "arrow-down-double-symbolic";
        case "drag-left":
            return "arrow-left-double-symbolic";
        case "drag-right":
            return "arrow-right-double-symbolic";
        default:
            return "";
        }
    }

    Timer {
        id: resetIcon
        interval: 500
        onTriggered: {
            root.gestureIconVisible = false;
            root.lastGesture = "";
        }
    }

    onGesturePerformed: gesture => {
        root.lastGesture = gesture;
        gestureIconVisible = true;
        resetIcon.restart();
    }

    onWheelUp: gesturePerformed("wheel-up")
    onWheelDown: gesturePerformed("wheel-down")
    onLeftClick: gesturePerformed("left-click")
    onMiddleClick: gesturePerformed("middle-click")
    onLongPress: gesturePerformed("long-press")
    onDoubleClick: gesturePerformed("double-click")
    onDragUp: gesturePerformed("drag-up")
    onDragDown: gesturePerformed("drag-down")
    onDragLeft: gesturePerformed("drag-left")
    onDragRight: gesturePerformed("drag-right")

    function getDistance(startPoint, endPoint) {
        var dx = endPoint.x - startPoint.x;
        var dy = endPoint.y - startPoint.y;
        return Math.sqrt(dx * dx + dy * dy);
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

    function runDragAction(direction) {
        switch (direction) {
        case "up":
            root.dragUp();
            break;
        case "down":
            root.dragDown();
            break;
        case "left":
            root.dragLeft();
            break;
        case "right":
            root.dragRight();
            break;
        }
    }

    function printLog(message) {
        if (enableDebug) {
            console.log('luisbocanegra.panelspacer.extended: ' + message);
        }
    }

    WheelHandler {
        property int wheelDelta: 0
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
        onWheel: event => {
            const delta = (event.inverted ? -1 : 1) * (event.angleDelta.y ? event.angleDelta.y : -event.angleDelta.x);
            wheelDelta += delta;
            while (wheelDelta >= root.scrollSensitivity) {
                wheelDelta -= root.scrollSensitivity;
                root.wheelUp();
            }

            while (wheelDelta <= -root.scrollSensitivity) {
                wheelDelta += root.scrollSensitivity;
                root.wheelDown();
            }
        }
    }

    HoverHandler {
        id: hoverHandler
        parent: root
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad | PointerDevice.TouchScreen
        onHoveredChanged: root.hovered = hovered
    }

    Timer {
        id: singleTapTimer
        interval: root.doubleClickEnabled ? root.doubleClickInterval : 0
        onTriggered: {
            if (root.tapCount === 1) {
                if (root.lastButton === Qt.LeftButton) {
                    root.leftClick();
                } else if (root.lastButton === Qt.MiddleButton) {
                    root.middleClick();
                }
            } else if (root.tapCount === 2) {
                if (root.lastButton === Qt.LeftButton) {
                    root.doubleClick();
                }
            }
            root.tapCount = 0;
        }
    }

    TapHandler {
        id: tapHandler
        parent: root
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad | PointerDevice.TouchScreen | PointerDevice.Stylus
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton
        longPressThreshold: root.longPressInterval / 1000
        onTapped: (eventPoint, button) => {
            if (button === Qt.LeftButton || button === Qt.MiddleButton) {
                root.lastButton = button;
                root.tapCount++;
                singleTapTimer.restart();
            }
        }
        onLongPressed: root.longPress()
    }

    PointHandler {
        id: dragHandler
        parent: root
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad | PointerDevice.TouchScreen | PointerDevice.Stylus
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton
        onActiveChanged: {
            if (active) {
                root.pressedReset = false;
                root.isDragging = true;
                root.startPos = parent.mapToGlobal(point.pressPosition.x, point.pressPosition.y);
                root.localStartPos = parent.mapFromGlobal(root.startPos.x, root.startPos.y);
                root.printLog(`Drag start: ${root.startPos}`);
            } else {
                if (root.isWayland) {
                    return;
                }

                if (root.isDragging) {
                    root.endPos = dragHandler.parent.mapToGlobal(point.position.x, point.position.y);
                    const distance = root.getDistance(root.startPos, root.endPos);
                    if (!tapHandler.pressed && distance >= root.dragDistance) {
                        const dragDirection = root.getDragDirection(root.startPos, root.endPos);
                        root.printLog(`Drag end: ${root.endPos}, distance: ${distance.toFixed(2)}, direction: ${dragDirection}`);
                        root.runDragAction(dragDirection);
                    }
                }
            }
        }

        onPointChanged: {
            if (active && root.isDragging) {
                root.endPos = parent.mapToGlobal(point.position.x, point.position.y);
                const distance = root.getDistance(root.startPos, root.endPos);

                if ((!tapHandler.pressed || root.isContinuous) && distance >= root.dragDistance) {
                    const dragDirection = root.getDragDirection(root.startPos, root.endPos);
                    // we can't do a drag out of the panel on X11,
                    // fallback to onActiveChanged == false (mouse released) above
                    if (!root.isWayland && ((root.horizontal && ["up", "down"].includes(dragDirection)) || (!root.horizontal && ["left", "right"].includes(dragDirection)))) {
                        return;
                    }
                    root.printLog(`Drag end: ${root.endPos}, distance: ${distance.toFixed(2)}, direction: ${dragDirection}`);
                    root.runDragAction(dragDirection);
                    root.startPos = root.endPos;
                    if (!root.isContinuous)
                        root.isDragging = false;
                }
            }
        }
    }

    onHoveredChanged: {
        if (hovered) {
            pressedReset = true;
        }
    }

    Rectangle {
        height: root.pressed && root.hovered ? 80 : 20
        width: height
        color: Kirigami.Theme.highlightColor
        radius: height / 2
        x: hoverHandler.point.position.x - width / 2
        y: hoverHandler.point.position.y - height / 2
        opacity: root.pressed && root.hovered ? 0.4 : 0
        visible: root.onDesktop

        Behavior on height {
            NumberAnimation {
                duration: 150
                easing.type: Easing.InOutQuad
            }
        }
    }

    Rectangle {
        id: dragArea
        height: (root.dragDistance ?? 0)
        width: height
        opacity: 0.5
        color: (root.enableDebug && root.pressed && root.hovered) ? "red" : "transparent"
        x: root.localStartPos.x - width / 2
        y: root.localStartPos.y - height / 2
    }

    Kirigami.Icon {
        id: gestureIcon
        source: root.gestureIcon || root.configuringIcon || root.idleIcon
        height: {
            if (root.onDesktop) {
                return 64;
            } else if (parent) {
                return Math.min(parent.width, parent.height);
            } else {
                return 20;
            }
        }
        width: height
        anchors.centerIn: root.onDesktop ? null : parent ? parent : undefined
        x: root.onDesktop ? hoverHandler.point.position.x - width / 2 : 0
        y: root.onDesktop ? hoverHandler.point.position.y - height / 2 : 0
        opacity: (root.gestureIconVisible || root.configuringIcon || root.idleIcon) ? 1 : 0
        Behavior on opacity {
            NumberAnimation {
                duration: Kirigami.Units.longDuration
                easing.type: Easing.InOutQuad
            }
        }
    }
}
