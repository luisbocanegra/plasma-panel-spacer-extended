import QtQuick 2.15
import QtQuick.Controls 2.15 as QQControls2
import QtQuick.Layouts 1.15 as QQLayouts1
import org.kde.kirigami 2.4 as Kirigami

QQLayouts1.ColumnLayout {
    id: root
    property alias cfg_enableDebug: enableDebug.checked

    signal configurationChanged

    Kirigami.FormLayout {
        id: generalPage
        QQLayouts1.Layout.alignment: Qt.AlignTop
        // wideMode: false

        Kirigami.Separator {
            Kirigami.FormData.label: i18n("Logging")
            Kirigami.FormData.isSection: true
        }

        QQLayouts1.ColumnLayout {
            QQControls2.CheckBox {
                id: enableDebug
                text: "Show console debug messages"
                checked: cfg_enableDebug

                onCheckedChanged: {
                    cfg_enableDebug = checked
                }
            }
        }
    }
}

