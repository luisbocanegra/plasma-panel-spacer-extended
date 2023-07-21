import QtQuick 2.15
import QtQuick.Controls 2.15 as QQControls2
import QtQuick.Controls 1.4 as QQCcontrols1
import QtQuick.Layouts 1.15 as QQLayouts1
import org.kde.kirigami 2.4 as Kirigami
import org.kde.plasma.core 2.0 as PlasmaCore
import "components" as Components


QQLayouts1.ColumnLayout {
    id: root

    property alias cfg_doubleClickAction: doubleClick.configValue
    property alias cfg_mouseWheelActionUp: wheelUp.configValue
    property alias cfg_mouseWheelActionDown: wheelDown.configValue
    property alias cfg_mouseDragActionUp: dragUp.configValue
    property alias cfg_mouseDragActionDown: dragDown.configValue
    property alias cfg_mouseDragActionLeft: dragLeft.configValue
    property alias cfg_mouseDragActionRight: dragRight.configValue
    property alias cfg_pressHoldAction: pressHold.configValue

    // TODO: Automate this to fetch available shortcuts
    // TODO: Probably some filtering/tagging for dangerous shortcuts
    ListModel {
        id: windowActionsComboModel
        ListElement {
                label: qsTr("Disabled")
                ActionName: "Disabled"
                component: "none"
                actionId: 0
            }
        ListElement {
                label: qsTr("Maximize active window")
                ActionName: "Window Maximize Only"
                component: "kwin"
                actionId: 1
            }
        ListElement {
                label: qsTr("Unmaximize active window")
                ActionName: "Window Unmaximize Only"
                component: "kwin"
                actionId: 2
            }
        ListElement {
                label: qsTr("Maximize active window (toggle)")
                ActionName: "Window Maximize"
                component: "kwin"
                actionId: 3
            }
        ListElement {
                label: qsTr("Close active window")
                ActionName: "Window Close"
                component: "kwin"
                actionId: 4
            }
        ListElement {
                label: qsTr("Move active window")
                ActionName: "Window Move"
                component: "kwin"
                actionId: 5
            }
        ListElement {
                label: qsTr("Minimize active window")
                ActionName: "Window Minimize"
                component: "kwin"
                actionId: 6
            }
        ListElement {
                label: qsTr("Show Window Operations Menu")
                ActionName: "Window Operations Menu"
                component: "kwin"
                actionId: 7
            }
        ListElement {
                label: qsTr("Fullscreen active window")
                ActionName: "Window Fullscreen"
                component: "kwin"
                actionId: 8
            }
        ListElement {
                label: qsTr("Minimize all windows")
                ActionName: "MinimizeAll"
                component: "kwin"
                actionId: 9
            }
        ListElement {
                label: qsTr("Show Desktop Grid")
                ActionName: "ShowDesktopGrid"
                component: "kwin"
                actionId: 10
            }
        ListElement {
                label: qsTr("Show Desktop")
                ActionName: "Show Desktop"
                component: "kwin"
                actionId: 11
            }
        ListElement {
                label: qsTr("Show Overview")
                ActionName: "Overview"
                component: "kwin"
                actionId: 12
            }
        ListElement {
                label: qsTr("Present windows of active Application (all desktops)")
                ActionName: "ExposeClass"
                component: "kwin"
                actionId: 13
            }
        ListElement {
                label: qsTr("Present windows of active Application (current desktop)")
                ActionName: "ExposeClassCurrentDesktop"
                component: "kwin"
                actionId: 14
            }
        ListElement {
                label: qsTr("Present all windows (all desktops)")
                ActionName: "ExposeAll"
                component: "kwin"
                actionId: 15
            }
        ListElement {
                label: qsTr("Present all windows (current desktop)")
                ActionName: "Expose"
                component: "kwin"
                actionId: 16
            }
        ListElement {
                label: qsTr("Walk Through Windows")
                ActionName: "Walk Through Windows"
                component: "kwin"
                actionId: 17
            }
        ListElement {
                label: qsTr("Walk Through Windows (Reverse)")
                ActionName: "Walk Through Windows (Reverse)"
                component: "kwin"
                actionId: 18
            }
        ListElement {
                label: qsTr("Walk Through Windows Alternative")
                ActionName: "Walk Through Windows Alternative"
                component: "kwin"
                actionId: 19
            }
        ListElement {
                label: qsTr("Walk Through Windows Alternative (Reverse)")
                ActionName: "Walk Through Windows Alternative (Reverse)"
                component: "kwin"
                actionId: 20
            }
        ListElement {
                label: qsTr("Walk Through Windows of Current Application")
                ActionName: "Walk Through Windows of Current Application"
                component: "kwin"
                actionId: 21
            }
        ListElement {
                label: qsTr("Walk Through Windows of Current Application (Reverse)")
                ActionName: "Walk Through Windows of Current Application (Reverse)"
                component: "kwin"
                actionId: 22
            }
        ListElement {
                label: qsTr("Walk Through Windows of Current Application Alternative")
                ActionName: "Walk Through Windows of Current Application Alternative"
                component: "kwin"
                actionId: 23
            }
        ListElement {
                label: qsTr("Walk Through Windows of Current Application Alternative (Reverse)")
                ActionName: "Walk Through Windows of Current Application Alternative (Reverse)"
                component: "kwin"
                actionId: 24
            }
        ListElement {
                label: qsTr("Switch One Desktop Up")
                ActionName: "Switch One Desktop Up"
                component: "kwin"
                actionId: 25
            }
        ListElement {
                label: qsTr("Switch One Desktop Down")
                ActionName: "Switch One Desktop Down"
                component: "kwin"
                actionId: 26
            }
        ListElement {
                label: qsTr("Switch One Desktop to the Left")
                ActionName: "Switch One Desktop to the Left"
                component: "kwin"
                actionId: 27
            }
        ListElement {
                label: qsTr("Switch One Desktop to the Right")
                ActionName: "Switch One Desktop to the Right"
                component: "kwin"
                actionId: 28
            }
        ListElement {
                label: qsTr("Switch to Previous Desktop")
                ActionName: "Switch to Previous Desktop"
                component: "kwin"
                actionId: 29
            }
        ListElement {
                label: qsTr("Switch to Next Desktop")
                ActionName: "Switch to Next Desktop"
                component: "kwin"
                actionId: 30
            }
        ListElement {
                label: qsTr("Walk Through Desktops")
                ActionName: "Walk Through Desktops"
                component: "kwin"
                actionId: 31
            }
        ListElement {
                label: qsTr("Window One Desktop Up")
                ActionName: "Window One Desktop Up"
                component: "kwin"
                actionId: 32
            }
        ListElement {
                label: qsTr("Window One Desktop Down")
                ActionName: "Window One Desktop Down"
                component: "kwin"
                actionId: 33
            }
        ListElement {
                label: qsTr("Window One Desktop to the Left")
                ActionName: "Window One Desktop to the Left"
                component: "kwin"
                actionId: 34
            }
        ListElement {
                label: qsTr("Window One Desktop to the Right")
                ActionName: "Window One Desktop to the Right"
                component: "kwin"
                actionId: 35
            }
        ListElement {
                label: qsTr("Window to Next Desktop")
                ActionName: "Window to Next Desktop"
                component: "kwin"
                actionId: 36
            }
        ListElement {
                label: qsTr("Window to Previous Desktop")
                ActionName: "Window to Previous Desktop"
                component: "kwin"
                actionId: 37
            }
        ListElement {
                label: qsTr("Kill Window")
                ActionName: "Kill Window"
                component: "kwin"
                actionId: 38
            }
    }
    
    signal configurationChanged

    Kirigami.FormLayout {
        id: generalPage
        QQLayouts1.Layout.alignment: Qt.AlignTop
        // wideMode: false

        Kirigami.Separator {
            Kirigami.FormData.label: i18n("Actions")
            Kirigami.FormData.isSection: true
        }

        Components.MyComboBox {
            id: doubleClick
            Kirigami.FormData.label: i18n("Double click:")
            model: windowActionsComboModel
            textRole: "label"
            configName: "doubleClickAction"
        }

        Components.MyComboBox {
            id: wheelUp
            Kirigami.FormData.label: i18n("Wheel Up:")
            model: windowActionsComboModel
            textRole: "label"
            configName: "mouseWheelActionUp"
        }

        Components.MyComboBox {
            id: wheelDown
            Kirigami.FormData.label: i18n("Wheel Down:")
            model: windowActionsComboModel
            textRole: "label"
            configName: "mouseWheelActionDown"
        }

        Components.MyComboBox {
            id: dragUp
            Kirigami.FormData.label: i18n("Mouse drag up:")
            model: windowActionsComboModel
            textRole: "label"
            configName: "mouseDragActionUp"
        }

        Components.MyComboBox {
            id: dragDown
            Kirigami.FormData.label: i18n("Mouse drag down:")
            model: windowActionsComboModel
            textRole: "label"
            configName: "mouseDragActionDown"
        }

        Components.MyComboBox {
            id: dragLeft
            Kirigami.FormData.label: i18n("Mouse drag left:")
            model: windowActionsComboModel
            textRole: "label"
            configName: "mouseDragActionLeft"
        }

        Components.MyComboBox {
            id: dragRight
            Kirigami.FormData.label: i18n("Mouse drag right:")
            model: windowActionsComboModel
            textRole: "label"
            configName: "mouseDragActionRight"
        }

        Components.MyComboBox {
            id: pressHold
            Kirigami.FormData.label: i18n("Long press:")
            model: windowActionsComboModel
            textRole: "label"
            configName: "pressHoldAction"
        }
    }
    // Component.onCompleted: {
    //     for (var i= 0; i < windowActionsComboModel.count; i++) {
    //         console.log(windowActionsComboModel.get(i)["label"]);
    //     }
    // }
}
