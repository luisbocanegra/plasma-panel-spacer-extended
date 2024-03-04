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
    property alias cfg_length: fixedLength.value
    property int cfg_screenWidth

    signal configurationChanged

    Kirigami.FormLayout {
        id: generalPage
        Layout.alignment: Qt.AlignTop

        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: "Hover effet"
        }
        
        CheckBox {
            id: showHoverBg
            Kirigami.FormData.label: i18n("Highlight spacer background:")
            // text: "Highlight spacer background when hovering it"
            checked: cfg_showHoverBg

            onCheckedChanged: {
                cfg_showHoverBg = checked
            }
        }

        SpinBox {
            id: hoverBgRadius
            Kirigami.FormData.label: i18n("Highlight radius:")
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
            Kirigami.FormData.label: i18n("Highlight fills panel:")
            checked: cfg_bgFillPanel
            enabled: showHoverBg.checked
            onCheckedChanged: {
                cfg_bgFillPanel = checked
            }
        }

        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: "Fixed size mode"
        }

        SpinBox {
            id: fixedLength
            Kirigami.FormData.label: i18n("Length:")
            value: length
            from: 0
            to: cfg_screenWidth
            stepSize: 1
            onValueChanged: {
                cfg_length = value
            }
        }
    }
}
