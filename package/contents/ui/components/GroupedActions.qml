import QtQuick 2.15
import QtQuick.Controls 2.15 as QQControls2
import QtQuick.Layouts 1.15 as QQLayouts1
// import org.kde.kirigami 2.4 as Kirigami
import org.kde.kirigami 2.20 as Kirigami
import QtQuick.Dialogs 1.3
import org.kde.plasma.private.quicklaunch 1.0
import "."

QQLayouts1.ColumnLayout {
    QQLayouts1.Layout.fillWidth: true
    QQLayouts1.Layout.fillHeight: true
    id: groupedActions
    property var confInternalName: ""
    property var modelData: []
    property var sectionLabel: ""
    property alias configValue: actionCombo.configValue
    property alias commandValue: internalValue.value
    property alias applicationUrlValue: btnAddLauncher.applicationUrl
    
    Item { implicitHeight: 4}

    Item {
        // HACK: Workaround for the command TextArea being marqued as changed when focused
        // requesting a confirmation that isnt actually needed, so store its value
        // here and update it only when textarea singals onTextChanged
        // there is probably a simpler way or something I've missed...
        id: internalValue
        property string value:""
        // onValueChanged: console.log("internal value changed to:",value)
        Component.onCompleted: {
            commandTextArea.text = value
        }
    }

    QQLayouts1.RowLayout {
        QQControls2.Label {
            id:label1
            text: sectionLabel+":"
            QQLayouts1.Layout.preferredWidth: 95
        }

        MyComboBox {
            id: actionCombo
            QQLayouts1.Layout.fillWidth: true
            model: modelData
            textRole: "label"
            configName: confInternalName
        }
    }

    // Command area
    QQLayouts1.RowLayout {
        Item { implicitWidth: 95}
        visible: modelData.get(actionCombo.currentIndex)["component"] == "custom_command"

        QQControls2.TextArea {
            wrapMode: QQControls2.TextArea.Wrap
            topPadding: activeFocus?6:10
            bottomPadding: activeFocus?22:10
            leftPadding: 10
            rightPadding: 10
            id: commandTextArea
            QQLayouts1.Layout.fillWidth: true
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
                opacity: parent.activeFocus?.6:0
            }
        }

        QQControls2.Button {
            id:btnCmdCopy
            icon.name: "edit-copy"
            onClicked: {
                if (commandTextArea.text.length > 0){
                    commandTextArea.selectAll()
                    commandTextArea.copy()
                }
            }
        }

        QQControls2.Button {
            id:btnCmdPaste
            icon.name: "edit-paste"
            onClicked: {
                commandTextArea.text=""
                commandTextArea.paste()
                internalValue.value = commandTextArea.text
            }
        }

        QQControls2.Button {
            id: btnExecutable
            icon.name: "document-open"
            QQControls2.ToolTip.delay: 1000
            QQControls2.ToolTip.visible: hovered
            QQControls2.ToolTip.text: "Pick a executable file"
            onClicked: {
                fileDialogExec.open()
            }
        }

        QQControls2.Button {
            id:btnCmdClean
            icon.name: "document-cleanup"
            onClicked: commandTextArea.text = ""
        }
    }

    // App selection
    Logic {
        id: logic
        onLauncherAdded: {
            var launcher = logic.launcherData(url)
            console.log("APP:",url)
            btnAddLauncher.text = launcher.applicationName + " - Tap to change"
            btnAddLauncher.applicationUrl = url
            btnAddLauncher.icon.name = launcher.iconName || "fork"

            hiddenAppText.text = url
        }
    }

    // Update button app name and icon
    function updateAppButton(appVal)
    {
        if (appVal !== ""){
            var launcher = logic.launcherData(appVal)
            btnAddLauncher.text = launcher.applicationName + " - Tap to change"
            btnAddLauncher.icon.name = launcher.iconName || "fork"
        } else {
            btnAddLauncher.text = "Choose an Application"
            btnAddLauncher.icon.name = "application-default-symbolic"
        }
    }

    
    QQLayouts1.RowLayout {
        Item { implicitWidth: 95 }
        visible: modelData.get(actionCombo.currentIndex)["component"] == "launch_application"

        QQControls2.Button {
            id: btnAddLauncher
            property string applicationUrl: ""

            onClicked: {
                logic.addLauncher()
            }

            Component.onCompleted: {
                updateAppButton(applicationUrlValue)
                hiddenAppText.text = applicationUrlValue
            }
        }

        QQControls2.TextArea {
            id: hiddenAppText
            topPadding: 10
            bottomPadding: 10
            leftPadding: 10
            rightPadding: 10
            placeholderText: qsTr("Enter URL or pick a file")
            QQLayouts1.Layout.fillWidth: true
            onTextChanged: {
                updateAppButton(text)
                btnAddLauncher.applicationUrl = hiddenAppText.text
            }
        }

        QQControls2.Button {
            id:btnAppCopy
            icon.name: "edit-copy"
            onClicked: {
                if (hiddenAppText.text.length > 0) {
                    hiddenAppText.selectAll()
                    hiddenAppText.copy()
                }
            }
        }

        QQControls2.Button {
            id:btnAppPaste
            icon.name: "edit-paste"
            onClicked: {
                hiddenAppText.text=""
                hiddenAppText.paste()
                btnAddLauncher.applicationUrl = hiddenAppText.text
            }
        }
        
        QQControls2.Button {
            id: btnUrl
            icon.name: "document-open"
            QQControls2.ToolTip.delay: 1000
            QQControls2.ToolTip.visible: hovered
            QQControls2.ToolTip.text: "Pick a file"
            onClicked: {
                fileDialogUrl.open()
            }
        }

        QQControls2.Button {
            id:btnUrlClean
            icon.name: "document-cleanup"
            onClicked: {
                btnAddLauncher.applicationUrl = ""
                btnAddLauncher.text = "Choose an Application"
                hiddenAppText.text=""
            }
        }
    }

    FileDialog {
        id: fileDialogExec
        onAccepted: commandTextArea.text = fileDialogExec.fileUrl.toString().replace("file://","")
    }

    FileDialog {
        id: fileDialogUrl
        onAccepted: {
            // btnAddLauncher.applicationUrl = fileDialogExec.fileUrl.toString()
            // updateAppButton(applicationUrlValue)
            hiddenAppText.text = fileDialogUrl.fileUrl.toString()
        }
    }
    Item { implicitHeight: 4}

    // Separator
    Rectangle {
        QQLayouts1.Layout.fillWidth: true
        height: 1
        color: Kirigami.ColorUtils.linearInterpolation(Kirigami.Theme.backgroundColor, Kirigami.Theme.textColor, 0.15)
    }
}
