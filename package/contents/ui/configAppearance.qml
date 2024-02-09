import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM

KCM.SimpleKCM {
    id: root
    property alias cfg_showHoverBg: showHoverBg.checked
    property alias cfg_hoverBgRadius: hoverBgRadius.value
    property alias cfg_bgFillPanel: bgFillPanel.checked

    signal configurationChanged

    Kirigami.FormLayout {
        id: generalPage
        Layout.alignment: Qt.AlignTop
        
        CheckBox {
            id: showHoverBg
            Kirigami.FormData.label: i18n("Highlight spacer background when hovering it:")
            // text: "Highlight spacer background when hovering it"
            checked: cfg_showHoverBg

            onCheckedChanged: {
                cfg_showHoverBg = checked
            }
        }

        SpinBox {
            id: hoverBgRadius
            Kirigami.FormData.label: i18n("Highlight radius")
            value: cfg_hoverBgRadius
            from: 0
            to: 99
            stepSize: 1
            enabled: showHoverBg.checked
            onValueChanged: {
                cfg_hoverBgRadius = value
            }
        }

        CheckBox {
            id: bgFillPanel
            Kirigami.FormData.label: i18n("Highlight fills panel")
            checked: cfg_bgFillPanel
            enabled: showHoverBg.checked
            onCheckedChanged: {
                cfg_bgFillPanel = checked
            }
        }
    }
}