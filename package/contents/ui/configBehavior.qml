import QtQuick 2.15
import QtQuick.Controls 2.15 as QQControls2
import QtQuick.Controls 1.4 as QQCcontrols1
import QtQuick.Layouts 1.15 as QQLayouts1
import org.kde.kirigami 2.4 as Kirigami
import org.kde.plasma.core 2.0 as PlasmaCore

QQLayouts1.ColumnLayout {
    id: root
    property alias cfg_showTooltip: showTooltip.checked

    signal configurationChanged

    Kirigami.FormLayout {
        id: generalPage
        QQLayouts1.Layout.alignment: Qt.AlignTop
        
        QQControls2.CheckBox {
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
