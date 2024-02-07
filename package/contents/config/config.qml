import QtQuick 2.0
import org.kde.plasma.configuration 2.0

ConfigModel {
    ConfigCategory {
        name: i18n("Behavior")
        icon: "preferences-desktop-mouse"
        source: "configActions.qml"
    }

    ConfigCategory {
        name: i18n("Appearance")
        icon: "preferences-desktop-color"
        source: "configAppearance.qml"
    }

    ConfigCategory {
        name: i18n("Troubleshoot")
        icon: "tools-report-bug"
        source: "configDebugging.qml"
    }
}
