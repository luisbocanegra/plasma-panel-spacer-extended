import QtQuick

Item {
    id: root
    property bool pluginFound: false
    property var logic

    signal launcherAdded(url: string)

    function addLauncher() {
        logic.addLauncher();
    }

    function launcherData(url) {
        return logic.launcherData(url);
    }

    function openUrl(url) {
        logic.openUrl(url);
    }

    Component.onCompleted: {
        let modules = ["luisbocanegra.panelspacer.extended.quicklaunch", "org.kde.plasma.private.quicklaunch"];

        for (let module of modules) {
            console.log("Trying to load", module);
            try {
                logic = Qt.createQmlObject(`import ${module}; Logic {}`, root);
                pluginFound = true;
                logic.launcherAdded.connect(root.launcherAdded);
                break;
            } catch (e) {
                console.warn("Couldn't to load", module);
            }
        }
    }
}
