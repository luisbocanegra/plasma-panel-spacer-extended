import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kcmutils as KCM
import org.kde.kirigami as Kirigami
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasma5support as P5Support
import "components" as Components

KCM.SimpleKCM {
    id: root
    property alias cfg_showTooltip: showTooltip.checked
    property alias cfg_scrollSensitivity: scrollSensitivity.value
    property alias cfg_isContinuous: isContinuous.checked
    property alias cfg_customDragDistanceEnabled: customDragDistanceEnabled.checked
    property alias cfg_customDragDistance: customDragDistance.value
    property int cfg_notificationType

    ColumnLayout {
        Kirigami.FormLayout {
            Layout.alignment: Qt.AlignTop

            RowLayout {
                Kirigami.FormData.label: i18n("Show tooltip:")

                CheckBox {
                    id: showTooltip
                }
                Kirigami.ContextualHelpButton {
                    toolTipText: i18n("Show list of actions when hovering the spacer")
                }
            }

            RowLayout {
                Kirigami.FormData.label: i18n("Scroll threshold:")
                SpinBox {
                    id: scrollSensitivity
                    from: 1
                    to: 10000
                }
                Kirigami.ContextualHelpButton {
                    toolTipText: "Higher values may help reducing repeated scrolling events with some input devices"
                }
            }

            RowLayout {
                Kirigami.FormData.label: i18n("Continuous drag:")

                CheckBox {
                    id: isContinuous
                }
                Kirigami.ContextualHelpButton {
                    toolTipText: "Keep dragging to chain actions without releasing the mouse/finger"
                }
            }

            RowLayout {
                Kirigami.FormData.label: i18n("Custom drag distance:")
                CheckBox {
                    id: customDragDistanceEnabled
                }
                Kirigami.ContextualHelpButton {
                    toolTipText: i18n("Set the minimum drag distance (in pixels) to trigger the actions. By default, the distance is the same as the panel thickness.")
                }
                SpinBox {
                    id: customDragDistance
                    enabled: root.cfg_customDragDistanceEnabled
                    from: 1
                    to: 9999
                }
            }

            Kirigami.Separator {
                Kirigami.FormData.isSection: true
                Kirigami.FormData.label: "Actions visual feedback"
            }

            RadioButton {
                Kirigami.FormData.label: i18n("Feedback type:")
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
        }
    }
}
