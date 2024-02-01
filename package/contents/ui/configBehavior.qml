import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM

KCM.SimpleKCM {
    id: root
    property alias cfg_showTooltip: showTooltip.checked

    signal configurationChanged

    Kirigami.FormLayout {
        id: generalPage
        Layout.alignment: Qt.AlignTop
        
        CheckBox {
            id: showTooltip
            Kirigami.FormData.label: i18n("General:")
            text: "Show list of actions when hovering the spacer"
            checked: cfg_showTooltip

            onCheckedChanged: {
                cfg_showTooltip = checked
            }
        }
    }
}
