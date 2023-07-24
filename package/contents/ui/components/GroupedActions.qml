import QtQuick 2.15
import QtQuick.Controls 2.15 as QQControls2
import QtQuick.Layouts 1.15 as QQLayouts1
import org.kde.kirigami 2.4 as Kirigami
// import org.kde.kirigami 2.20 as Kirigami
import "."

QQLayouts1.ColumnLayout {
    QQLayouts1.Layout.fillWidth: true
    id: groupedActions
    property var confInternalName: ""
    property var modelData: []
    property var sectionLabel: ""
    property alias configValue: actionCombo.configValue
    property alias commandValue: internalValue.value
    
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


    QQLayouts1.RowLayout {
        id: row
        Item { implicitWidth: label1.width}
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
            placeholderText: qsTr("Enter shell command, program or path of a script")

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
            id:btnCopy
            onClicked: {
                commandTextArea.selectAll()
                commandTextArea.copy()
                }
            icon.name: "edit-copy"
        }

        QQControls2.Button {
            onClicked: commandTextArea.text = ""
            icon.name: "document-cleanup"
        }
    }
}