import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kcmutils as KCM
import org.kde.kirigami as Kirigami

KCM.SimpleKCM {
    id: root
    property alias cfg_showTooltip: showTooltip.checked
    property alias cfg_scrollSensitivity: scrollSensitivity.value
    property alias cfg_isContinuous: isContinuous.checked
    property alias cfg_customDragDistanceEnabled: customDragDistanceEnabled.checked
    property alias cfg_customDragDistance: customDragDistance.value
    property alias cfg_gesturesOnDesktop: gesturesOnDesktop.checked
    property alias cfg_customDoubleClickDelayEnabled: customDoubleClickDelayEnabled.checked
    property alias cfg_customDoubleClickDelay: customDoubleClickDelay.value
    property alias cfg_customLongPressDelayEnabled: customLongPressDelayEnabled.checked
    property alias cfg_customLongPressDelay: customLongPressDelay.value

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
                Kirigami.FormData.label: i18n("Custom double-click interval (ms):")
                CheckBox {
                    id: customDoubleClickDelayEnabled
                }
                SpinBox {
                    id: customDoubleClickDelay
                    enabled: root.cfg_customDoubleClickDelayEnabled
                    from: 100
                    to: 1000
                    stepSize: 100
                }
            }

            RowLayout {
                Kirigami.FormData.label: i18n("Custom long-click interval (ms):")
                CheckBox {
                    id: customLongPressDelayEnabled
                }
                SpinBox {
                    id: customLongPressDelay
                    enabled: root.cfg_customLongPressDelayEnabled
                    from: 100
                    to: 2000
                    stepSize: 100
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
                    toolTipText: i18n("Set the minimum drag distance (in pixels) to trigger the actions. By default, the distance is the same as the panel thickness, or 10% of the smaller screen dimension when placed on the desktop.")
                }
                SpinBox {
                    id: customDragDistance
                    enabled: root.cfg_customDragDistanceEnabled
                    from: 1
                    to: 9999
                }
            }

            RowLayout {
                Kirigami.FormData.label: i18n("Enable gestures on desktop:")
                CheckBox {
                    id: gesturesOnDesktop
                }
                Kirigami.ContextualHelpButton {
                    toolTipText: i18n("When the widget is placed on the desktop, gestures will work anywhere on the desktop instead of just on the widget area.<br><b>Note:</b> This option will not work when the desktop layout is set to 'Folder View', to switch to 'Desktop' layout, right-click on the desktop, choose 'Desktop and Wallpaper', and set 'Layout' to 'Desktop'.")
                }
            }
        }
    }
}
