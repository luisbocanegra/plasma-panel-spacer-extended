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
            }
        ListElement {
                label: qsTr("Maximize active window")
                ActionName: "Window Maximize"
                component: "kwin"
            }
        ListElement {
                label: qsTr("Unmaximize active window")
                ActionName: "Window Maximize"
                component: "kwin"
            }
        ListElement {
                label: qsTr("Maximize active window (toggle)")
                ActionName: "Window Maximize"
                component: "kwin"
            }
        ListElement {
                label: qsTr("Close active window")
                ActionName: "Window Close"
                component: "kwin"
            }
        ListElement {
                label: qsTr("Move active window")
                ActionName: "Window Move"
                component: "kwin"
            }
        ListElement {
                label: qsTr("Minimize active window")
                ActionName: "Window Minimize"
                component: "kwin"
            }
        ListElement {
                label: qsTr("Show Window Operations Menu")
                ActionName: "Window Operations Menu"
                component: "kwin"
            }
        ListElement {
                label: qsTr("Fullscreen active window")
                ActionName: "Window Fullscreen"
                component: "kwin"
            }
        ListElement {
                label: qsTr("Minimize all windows")
                ActionName: "MinimizeAll"
                component: "kwin"
            }
        ListElement {
                label: qsTr("Show Desktop Grid")
                ActionName: "ShowDesktopGrid"
                component: "kwin"
            }
        ListElement {
                label: qsTr("Show Desktop")
                ActionName: "Show Desktop"
                component: "kwin"
            }
        ListElement {
                label: qsTr("Show Overview")
                ActionName: "Overview"
                component: "kwin"
            }
        ListElement {
                label: qsTr("Present windows of active Application (all desktops)")
                ActionName: "ExposeClass"
                component: "kwin"
            }
        ListElement {
                label: qsTr("Present windows of active Application (current desktop)")
                ActionName: "ExposeClassCurrentDesktop"
                component: "kwin"
            }
        ListElement {
                label: qsTr("Present all windows (all desktops)")
                ActionName: "ExposeAll"
                component: "kwin"
            }
        ListElement {
                label: qsTr("Present all windows (current desktop)")
                ActionName: "Expose"
                component: "kwin"
            }
        ListElement {
                label: qsTr("Walk Through Windows")
                ActionName: "Walk Through Windows"
                component: "kwin"
            }
        ListElement {
                label: qsTr("Walk Through Windows (Reverse)")
                ActionName: "Walk Through Windows (Reverse)"
                component: "kwin"
            }
        ListElement {
                label: qsTr("Walk Through Windows Alternative")
                ActionName: "Walk Through Windows Alternative"
                component: "kwin"
            }
        ListElement {
                label: qsTr("Walk Through Windows Alternative (Reverse)")
                ActionName: "Walk Through Windows Alternative (Reverse)"
                component: "kwin"
            }
        ListElement {
                label: qsTr("Walk Through Windows of Current Application")
                ActionName: "Walk Through Windows of Current Application"
                component: "kwin"
            }
        ListElement {
                label: qsTr("Walk Through Windows of Current Application (Reverse)")
                ActionName: "Walk Through Windows of Current Application (Reverse)"
                component: "kwin"
            }
        ListElement {
                label: qsTr("Walk Through Windows of Current Application Alternative")
                ActionName: "Walk Through Windows of Current Application Alternative"
                component: "kwin"
            }
        ListElement {
                label: qsTr("Walk Through Windows of Current Application Alternative (Reverse)")
                ActionName: "Walk Through Windows of Current Application Alternative (Reverse)"
                component: "kwin"
            }
        ListElement {
                label: qsTr("Switch One Desktop Up")
                ActionName: "Switch One Desktop Up"
                component: "kwin"
            }
        ListElement {
                label: qsTr("Switch One Desktop Down")
                ActionName: "Switch One Desktop Down"
                component: "kwin"
            }
        ListElement {
                label: qsTr("Switch One Desktop to the Left")
                ActionName: "Switch One Desktop to the Left"
                component: "kwin"
            }
        ListElement {
                label: qsTr("Switch One Desktop to the Right")
                ActionName: "Switch One Desktop to the Right"
                component: "kwin"
            }
        ListElement {
                label: qsTr("Switch to Previous Desktop")
                ActionName: "Switch to Previous Desktop"
                component: "kwin"
            }
        ListElement {
                label: qsTr("Switch to Next Desktop")
                ActionName: "Switch to Next Desktop"
                component: "kwin"
            }
        ListElement {
                label: qsTr("Walk Through Desktops")
                ActionName: "Walk Through Desktops"
                component: "kwin"
            }
        ListElement {
                label: qsTr("Window One Desktop Up")
                ActionName: "Window One Desktop Up"
                component: "kwin"
            }
        ListElement {
                label: qsTr("Window One Desktop Down")
                ActionName: "Window One Desktop Down"
                component: "kwin"
            }
        ListElement {
                label: qsTr("Window One Desktop to the Left")
                ActionName: "Window One Desktop to the Left"
                component: "kwin"
            }
        ListElement {
                label: qsTr("Window One Desktop to the Right")
                ActionName: "Window One Desktop to the Right"
                component: "kwin"
            }
        ListElement {
                label: qsTr("Window to Next Desktop")
                ActionName: "Window to Next Desktop"
                component: "kwin"
            }
        ListElement {
                label: qsTr("Kill Window")
                ActionName: "Kill Window"
                component: "kwin"
            }
        ListElement {
                label: qsTr("Window to Previous Desktop")
                ActionName: "Window to Previous Desktop"
                component: "kwin"
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
}
