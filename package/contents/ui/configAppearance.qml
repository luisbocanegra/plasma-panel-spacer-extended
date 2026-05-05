import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM
import "components/"

KCM.SimpleKCM {
    id: root
    property alias cfg_showHoverBg: showHoverBg.checked
    property alias cfg_hoverBgRadius: hoverBgRadius.value
    property alias cfg_bgFillPanel: bgFillPanel.checked
    property alias cfg_length: fixedLength.value
    property alias cfg_alwaysHighlighted: alwaysHighlighted.checked
    property int cfg_screenWidth
    property alias cfg_expanding: expanding.checked
    property alias cfg_hideInFitContent: hideInFitContent.checked
    property alias cfg_icon: iconSelector.customIcon
    property alias cfg_actionIconFeedback: actionIconFeedback.checked
    property int cfg_notificationType

    signal configurationChanged

    Kirigami.FormLayout {
        id: generalPage
        Layout.alignment: Qt.AlignTop

        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: "Visual feedback"
        }

        RowLayout {
            Kirigami.FormData.label: i18n("Gesture icons:")
            CheckBox {
                id: actionIconFeedback
            }
            Label {
                text: i18n("Idle icon:")
            }
            IconSelector {
                id: iconSelector
            }
        }

        RadioButton {
            Kirigami.FormData.label: i18n("Action notification:")
            text: i18n("Disable")
            ButtonGroup.group: notificationBtnGroup
            checked: root.cfg_notificationType === index
            property int index: 0
        }
        RadioButton {
            text: i18n("Notification")
            ButtonGroup.group: notificationBtnGroup
            checked: root.cfg_notificationType === index
            property int index: 1
        }
        RadioButton {
            text: i18n("On-screen display")
            ButtonGroup.group: notificationBtnGroup
            checked: root.cfg_notificationType === index
            property int index: 2
        }

        ButtonGroup {
            id: notificationBtnGroup
            onCheckedButtonChanged: {
                if (checkedButton) {
                    root.cfg_notificationType = checkedButton.index;
                }
            }
        }

        CheckBox {
            id: alwaysHighlighted
            Kirigami.FormData.label: i18n("Highlight:")
            checked: cfg_alwaysHighlighted

            onCheckedChanged: {
                cfg_alwaysHighlighted = checked;
            }
        }

        CheckBox {
            id: showHoverBg
            text: alwaysHighlighted.checked ? i18n("Increase on hover") : i18n("On hover")
            checked: cfg_showHoverBg

            onCheckedChanged: {
                cfg_showHoverBg = checked;
            }
        }

        CheckBox {
            id: bgFillPanel
            text: i18n("Fill panel thickness")
            checked: cfg_bgFillPanel
            enabled: showHoverBg.checked
            onCheckedChanged: {
                cfg_bgFillPanel = checked;
            }
        }

        RowLayout {
            Label {
                text: i18n("Radius:")
                enabled: showHoverBg.checked
            }
            SpinBox {
                id: hoverBgRadius
                value: cfg_hoverBgRadius
                from: 0
                to: 99
                stepSize: 1
                enabled: showHoverBg.checked
                onValueChanged: {
                    cfg_hoverBgRadius = value;
                }
            }
        }

        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: "Size"
        }

        CheckBox {
            id: expanding
            Kirigami.FormData.label: i18n("Flexible size:")
            Layout.alignment: Qt.AlignTop
        }
        Label {
            id: expandingLabel
            text: i18n("To avoid sizing bugs, flexible size is automatically disabled when using when the Panel width is set to Fit content, see <a href=\"%1\">#91</a> and <a href=\"%2\">BUG:495378</a>.", "https://github.com/luisbocanegra/plasma-panel-spacer-extended/issues/91", "https://bugs.kde.org/show_bug.cgi?id=495378")
            font: Kirigami.Theme.smallFont
            wrapMode: Label.Wrap
            onLinkActivated: link => Qt.openUrlExternally(link)
            Layout.maximumWidth: 400
            Layout.topMargin: Kirigami.Units.smallSpacing
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
        }

        CheckBox {
            id: hideInFitContent
            Kirigami.FormData.label: i18n("Hide in fit content panel:")
            enabled: showHoverBg.checked
            Layout.alignment: Qt.AlignTop
        }
        Label {
            text: i18n("This can be used in conjunction with <a href=\"%1\" >Panel Colorizer</a> to keep the other widgets centered in <strong>Fill Width</strong> mode but hide the widget when the panel switches back to <strong>Fit Content</strong> mode.", "https://github.com/luisbocanegra/plasma-panel-colorizer")
            font: Kirigami.Theme.smallFont
            wrapMode: Label.Wrap
            onLinkActivated: link => Qt.openUrlExternally(link)
            Layout.maximumWidth: 400
            Layout.topMargin: Kirigami.Units.smallSpacing
        }
    }
}
