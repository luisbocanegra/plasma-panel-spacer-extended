import QtQuick 2.15
import QtQuick.Controls 2.15

import org.kde.iconthemes as KIconThemes
import org.kde.kirigami as Kirigami

Button {
    id: root
    hoverEnabled: true
    property string customIcon: ""
    ToolTip.delay: Kirigami.Units.toolTipDelay
    ToolTip.text: i18nc("@info:tooltip", "Icon name is \"%1\"", root.customIcon)
    ToolTip.visible: root.hovered && root.customIcon.length > 0

    KIconThemes.IconDialog {
        id: iconDialog
        onIconNameChanged: {
            root.customIcon = iconName;
        }
    }

    onPressed: iconMenu.opened ? iconMenu.close() : iconMenu.open()

    Kirigami.Icon {
        anchors.centerIn: parent
        width: parent.width
        height: width
        source: root.customIcon
    }

    Menu {
        id: iconMenu

        // Appear below the button
        y: parent.height

        MenuItem {
            text: i18nc("@item:inmenu Open icon chooser dialog", "Choose…")
            icon.name: "document-open-folder"
            Accessible.description: i18nc("@info:whatsthis", "Choose an icon")
            onClicked: iconDialog.open()
        }
        MenuItem {
            text: i18nc("@item:inmenu Reset icon to default", "Reset to default icon")
            icon.name: "edit-clear"
            enabled: root.customIcon !== ""
            onClicked: root.customIcon = ""
        }
        MenuItem {
            text: i18nc("@action:inmenu", "Remove icon")
            icon.name: "delete"
            enabled: root.customIcon !== ""
            onClicked: root.customIcon = ""
        }
    }
}
