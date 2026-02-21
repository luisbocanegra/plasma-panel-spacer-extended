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
    property alias cfg_expanding: expanding.checked

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
                cfg_alwaysHighlighted = checked;
            }
        }

        CheckBox {
            id: showHoverBg
            Kirigami.FormData.label: alwaysHighlighted.checked ? i18n("Increase on hover:") : i18n("On hover:")
            checked: cfg_showHoverBg

            onCheckedChanged: {
                cfg_showHoverBg = checked;
            }
        }

        CheckBox {
            id: bgFillPanel
            Kirigami.FormData.label: i18n("Fill panel thickness:")
            checked: cfg_bgFillPanel
            enabled: showHoverBg.checked
            onCheckedChanged: {
                cfg_bgFillPanel = checked;
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
                cfg_hoverBgRadius = value;
            }
        }

        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: "Size"
        }

        RowLayout {
            Kirigami.FormData.label: i18n("Flexible size:")
            Kirigami.FormData.buddyFor: expanding
            spacing: Kirigami.Units.smallSpacing
            CheckBox {
                id: expanding
                Layout.alignment: Qt.AlignTop
            }
            Label {
                id: expandingLabel
                text: i18n("To avoid sizing bugs, flexible size is automatically disabled when using when the Panel width is set to Fit content, see <a href=\"%1\">#91</a> and <a href=\"%2\">BUG:495378</a>.", "https://github.com/luisbocanegra/plasma-panel-spacer-extended/issues/91", "https://bugs.kde.org/show_bug.cgi?id=495378")
                wrapMode: Label.Wrap
                Layout.preferredWidth: 350
                onLinkActivated: link => Qt.openUrlExternally(link)
                HoverHandler {
                    cursorShape: Qt.PointingHandCursor
                }
                Layout.margins: Kirigami.Units.smallSpacing
            }
        }

        SpinBox {
            id: fixedLength
            Kirigami.FormData.label: i18n("Fixed size:")
            value: length
            from: 0
            to: cfg_screenWidth
            stepSize: 1
            onValueChanged: {
                cfg_length = value;
            }
            enabled: !root.cfg_expanding
        }
    }
}
