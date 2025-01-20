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
    property alias cfg_alwaysHighlighted: alwaysHighlighted.checked
    property int cfg_screenWidth

    signal configurationChanged

    Kirigami.FormLayout {
        id: generalPage
        Layout.alignment: Qt.AlignTop

        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: "Highlight"
        }

        CheckBox {
            id: alwaysHighlighted
            Kirigami.FormData.label: i18n("Always:")
            checked: cfg_alwaysHighlighted

            onCheckedChanged: {
                cfg_alwaysHighlighted = checked
            }
        }
        
        CheckBox {
            id: showHoverBg
            Kirigami.FormData.label: alwaysHighlighted.checked ? i18n("Increase on hover:") : i18n("On hover:")
            checked: cfg_showHoverBg

            onCheckedChanged: {
                cfg_showHoverBg = checked
            }
        }

        CheckBox {
            id: bgFillPanel
            Kirigami.FormData.label: i18n("Fill panel thickness:")
            checked: cfg_bgFillPanel
            enabled: showHoverBg.checked
            onCheckedChanged: {
                cfg_bgFillPanel = checked
            }
        }

        SpinBox {
            id: hoverBgRadius
            Kirigami.FormData.label: i18n("Radius:")
            value: cfg_hoverBgRadius
            from: 0
            to: 99
            stepSize: 1
            enabled: showHoverBg.checked
            onValueChanged: {
                cfg_hoverBgRadius = value
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
