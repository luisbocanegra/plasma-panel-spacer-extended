import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
// import org.kde.kirigami 2.4 as Kirigami
import org.kde.kirigami as Kirigami
import QtQuick.Dialogs
import "."
import "../"

ColumnLayout {
    id: root
    Layout.preferredWidth: 450
    property var confInternalName: ""
    property ListModel modelData
    property var sectionLabel: ""
    property alias configValue: actionCombo.configValue
    property alias commandValue: internalValue.value
    property alias applicationUrlValue: btnAddLauncher.applicationUrl
    property bool showSeparator: true
    property bool isLoading: true

    Item {
        implicitHeight: 4
    }

    Item {
        // HACK: Workaround for the command TextArea being marked as changed when focused
        // requesting a confirmation that isn't actually needed, so store its value
        // here and update it only when textarea signals onTextChanged
        // there is probably a simpler way or something I've missed...
        id: internalValue
        property string value: ""
        // onValueChanged: console.log("internal value changed to:",value)
        Component.onCompleted: {
            commandTextArea.text = value;
        }
    }

    FilterListView {
        id: actionCombo
        Layout.fillWidth: true
        configName: root.confInternalName
        componentValue: configValue.split(",")[0]
    }

    // Command area
    TextArea {
        id: commandTextArea
        visible: actionCombo.componentValue == "custom_command"
        wrapMode: TextArea.Wrap
        selectByMouse: true
        placeholderText: qsTr("Enter shell command or pick a executable")
        onTextChanged: internalValue.value = text
        persistentSelection: false
        // cursor position
        property int cursorLine: 1 + text.substring(0, cursorPosition).split("\n").length - 1
        property int cursorColumn: cursorPosition - text.lastIndexOf("\n", cursorPosition - 1)
        Text {
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            horizontalAlignment: Text.AlignRight
            text: commandTextArea.cursorLine + ", " + commandTextArea.cursorColumn
            color: Kirigami.Theme.textColor
            anchors.rightMargin: 8
            anchors.bottomMargin: 5
            opacity: parent.activeFocus ? .6 : 0
        }
        Layout.fillWidth: true
        Kirigami.SpellCheck.enabled: false
    }
    RowLayout {
        visible: actionCombo.componentValue == "custom_command"
        Item {
            Layout.fillWidth: true
        }
        Button {
            id: btnCmdCopy
            icon.name: "edit-copy"
            onClicked: {
                if (commandTextArea.text.length > 0) {
                    commandTextArea.selectAll();
                    commandTextArea.copy();
                }
            }
        }

        Button {
            id: btnCmdPaste
            icon.name: "edit-paste"
            onClicked: {
                commandTextArea.text = "";
                commandTextArea.paste();
                internalValue.value = commandTextArea.text;
            }
        }

        Button {
            id: btnExecutable
            icon.name: "document-open"
            ToolTip.delay: 1000
            ToolTip.visible: hovered
            ToolTip.text: "Pick a executable file"
            onClicked: {
                fileDialogExec.open();
            }
        }

        Button {
            id: btnCmdClean
            icon.name: "document-cleanup"
            onClicked: commandTextArea.text = ""
        }
    }

    QuickLaunch {
        id: quickLaunch
        onLauncherAdded: url => {
            var launcher = quickLaunch.launcherData(url);
            console.log("APP:", url);
            btnAddLauncher.text = launcher.applicationName + " - Tap to change";
            btnAddLauncher.applicationUrl = url;
            btnAddLauncher.icon.name = launcher.iconName || "fork";
            hiddenAppText.text = url;
        }
        onLogicChanged: {
            if (logic) {
                root.updateAppButton(root.applicationUrlValue);
            }
        }
        visible: false
    }

    // Update button app name and icon
    function updateAppButton(url) {
        if (!quickLaunch.logic) {
            return;
        }
        if (url !== "") {
            var launcher = quickLaunch.launcherData(url);
            btnAddLauncher.text = launcher.applicationName + " - Tap to change";
            btnAddLauncher.icon.name = launcher.iconName || "fork";
        } else {
            btnAddLauncher.text = "Choose an Application";
            btnAddLauncher.icon.name = "application-default-symbolic";
        }
    }

    ColumnLayout {
        visible: actionCombo.componentValue == "launch_application"

        Label {
            text: i18n("C++ plugin not found, install it to launch applications on Plasma 6.5 or newer. <a href=\"https://google.com\">Install instructions TODO</a>")
            wrapMode: Label.Wrap
            Layout.fillWidth: true
            color: Kirigami.Theme.neutralTextColor
            onLinkActivated: link => Qt.openUrlExternally(link)
            HoverHandler {
                cursorShape: Qt.PointingHandCursor
            }
            visible: !quickLaunch.pluginFound
        }

        Button {
            id: btnAddLauncher
            visible: quickLaunch.pluginFound
            Layout.fillWidth: true
            property string applicationUrl: ""

            onClicked: {
                quickLaunch.addLauncher();
            }

            Component.onCompleted: {
                hiddenAppText.text = root.applicationUrlValue;
            }
        }

        TextField {
            id: hiddenAppText
            visible: quickLaunch.pluginFound
            placeholderText: qsTr("Enter URL or pick a file")
            Layout.fillWidth: true
            onTextChanged: {
                root.updateAppButton(text);
                btnAddLauncher.applicationUrl = hiddenAppText.text;
            }
        }

        RowLayout {
            visible: quickLaunch.pluginFound
            Item {
                Layout.fillWidth: true
            }
            Button {
                id: btnAppCopy
                icon.name: "edit-copy"
                onClicked: {
                    if (hiddenAppText.text.length > 0) {
                        hiddenAppText.selectAll();
                        hiddenAppText.copy();
                    }
                }
            }

            Button {
                id: btnAppPaste
                icon.name: "edit-paste"
                onClicked: {
                    hiddenAppText.text = "";
                    hiddenAppText.paste();
                    btnAddLauncher.applicationUrl = hiddenAppText.text;
                }
            }

            Button {
                id: btnUrl
                icon.name: "document-open"
                ToolTip.delay: 1000
                ToolTip.visible: hovered
                ToolTip.text: "Pick a file"
                onClicked: {
                    fileDialogUrl.open();
                }
            }

            Button {
                id: btnUrlClean
                icon.name: "document-cleanup"
                onClicked: {
                    btnAddLauncher.applicationUrl = "";
                    btnAddLauncher.text = "Choose an Application";
                    hiddenAppText.text = "";
                }
            }
        }
    }

    FileDialog {
        id: fileDialogExec
        onAccepted: commandTextArea.text = fileDialogExec.fileUrl.toString().replace("file://", "")
    }

    FileDialog {
        id: fileDialogUrl
        onAccepted: {
            hiddenAppText.text = fileDialogUrl.fileUrl.toString();
        }
    }
    Item {
        implicitHeight: 4
    }

    // Separator
    Rectangle {
        Layout.fillWidth: true
        height: 1
        color: Kirigami.ColorUtils.linearInterpolation(Kirigami.Theme.backgroundColor, Kirigami.Theme.textColor, 0.15)
        visible: root.showSeparator
    }
}
