import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kcmutils as KCM
import org.kde.kirigami as Kirigami
import "components" as Components

KCM.SimpleKCM {
    id: root
    property alias cfg_singleClickAction: singleClick.configValue
    property alias cfg_singleClickCommand: singleClick.commandValue
    property alias cfg_singleClickAppUrl: singleClick.applicationUrlValue

    property alias cfg_doubleClickAction: doubleClick.configValue
    property alias cfg_doubleClickCommand: doubleClick.commandValue
    property alias cfg_doubleClickAppUrl: doubleClick.applicationUrlValue

    property alias cfg_middleClickAction: middleClick.configValue
    property alias cfg_middleClickCommand: middleClick.commandValue
    property alias cfg_middleClickAppUrl: middleClick.applicationUrlValue

    property alias cfg_mouseWheelUpAction: wheelUp.configValue
    property alias cfg_mouseWheelUpCommand: wheelUp.commandValue
    property alias cfg_mouseWheelUpAppUrl: wheelUp.applicationUrlValue

    property alias cfg_mouseWheelDownAction: wheelDown.configValue
    property alias cfg_mouseWheelDownCommand: wheelDown.commandValue
    property alias cfg_mouseWheelDownAppUrl: wheelDown.applicationUrlValue

    property alias cfg_mouseDragUpAction: dragUp.configValue
    property alias cfg_mouseDragUpCommand: dragUp.commandValue
    property alias cfg_mouseDragUpAppUrl: dragUp.applicationUrlValue

    property alias cfg_mouseDragDownAction: dragDown.configValue
    property alias cfg_mouseDragDownCommand: dragDown.commandValue
    property alias cfg_mouseDragDownAppUrl: dragDown.applicationUrlValue

    property alias cfg_mouseDragLeftAction: dragLeft.configValue
    property alias cfg_mouseDragLeftCommand: dragLeft.commandValue
    property alias cfg_mouseDragLeftAppUrl: dragLeft.applicationUrlValue

    property alias cfg_mouseDragRightAction: dragRight.configValue
    property alias cfg_mouseDragRightCommand: dragRight.commandValue
    property alias cfg_mouseDragRightAppUrl: dragRight.applicationUrlValue

    property alias cfg_pressHoldAction: pressHold.configValue
    property alias cfg_pressHoldCommand: pressHold.commandValue
    property alias cfg_pressHoldAppUrl: pressHold.applicationUrlValue

    property bool isLoading: actionsModel.isLoading

    ActionsModel {
        id: actionsModel
    }

    Kirigami.FormLayout {

        Button {
            text: i18n("Refresh actions")
            icon.name: "view-refresh-symbolic"
            onClicked: {
                actionsModel.reloadActions();
            }
            Layout.fillWidth: true
        }
        Components.GroupedActions {
            id: singleClick
            modelData: actionsModel.model
            confInternalName: "singleClickAction"
            Kirigami.FormData.label: "Single Click:"
            isLoading: root.isLoading
        }

        Components.GroupedActions {
            id: doubleClick
            modelData: actionsModel.model
            confInternalName: "doubleClickAction"
            Kirigami.FormData.label: "Double Click:"
            isLoading: root.isLoading
        }

        Components.GroupedActions {
            id: middleClick
            modelData: actionsModel.model
            confInternalName: "middleClickAction"
            Kirigami.FormData.label: "Middle Click:"
            isLoading: root.isLoading
        }

        Components.GroupedActions {
            id: wheelUp
            modelData: actionsModel.model
            confInternalName: "mouseWheelUpAction"
            Kirigami.FormData.label: "Wheel Up:"
            isLoading: root.isLoading
        }

        Components.GroupedActions {
            id: wheelDown
            modelData: actionsModel.model
            confInternalName: "mouseWheelDownAction"
            Kirigami.FormData.label: "Wheel Down:"
            isLoading: root.isLoading
        }

        Components.GroupedActions {
            id: dragUp
            modelData: actionsModel.model
            confInternalName: "mouseDragUpAction"
            Kirigami.FormData.label: "Drag Up:"
            isLoading: root.isLoading
        }

        Components.GroupedActions {
            id: dragDown
            modelData: actionsModel.model
            confInternalName: "mouseDragDownAction"
            Kirigami.FormData.label: "Drag Down:"
            isLoading: root.isLoading
        }

        Components.GroupedActions {
            id: dragLeft
            modelData: actionsModel.model
            confInternalName: "mouseDragLeftAction"
            Kirigami.FormData.label: "Drag Left:"
            isLoading: root.isLoading
        }

        Components.GroupedActions {
            id: dragRight
            modelData: actionsModel.model
            confInternalName: "mouseDragRightAction"
            Kirigami.FormData.label: "Drag Right:"
            isLoading: root.isLoading
        }

        Components.GroupedActions {
            id: pressHold
            modelData: actionsModel.model
            confInternalName: "pressHoldAction"
            Kirigami.FormData.label: "Long press:"
            showSeparator: false
            isLoading: root.isLoading
        }
    }
}
