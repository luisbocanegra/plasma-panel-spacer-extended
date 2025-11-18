import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kitemmodels

ColumnLayout {
    id: root

    property string configValue: ""
    property string configName: ""
    property string componentValue: ""
    property string customName
    property string customIcon

    property bool itemClicked: false
    property bool showList: false
    property bool showCustomIcon

    RowLayout {
        Layout.preferredWidth: 450
        Kirigami.Icon {
            Layout.preferredHeight: 16
            Layout.preferredWidth: 16
            source: root.customIcon
            visible: source !== "" && root.showCustomIcon
        }
        Label {
            property var component: configValue.split(",")[0]
            property var action: configValue.split(",")[1]
            text: {
                let name = "";

                if (!["Disabled", "custom_command", "launch_application"].includes(component)) {
                    name = component + " - " + action;
                } else {
                    name = action;
                }

                if (root.customName) {
                    name = `${root.customName} (${name})`;
                }

                return name;
            }
            wrapMode: Text.Wrap
            Layout.fillWidth: true
        }
        Button {
            id: expandBtn
            icon.name: "edit-symbolic"
            checkable: true
            checked: showList
            onClicked: {
                showList = !showList;
                if (showList) {
                    searchField.text = "";
                    searchField.forceActiveFocus();
                }
            }
        }
    }

    TextField {
        id: searchField
        visible: showList
        Layout.fillWidth: true
        focus: true
        onTextChanged: {
            shortcutsListFiltered.setFilterFixedString(text);
        }
        placeholderText: "Search actions..."
    }

    function dumpProps(obj) {
        console.error("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
        for (var k of Object.keys(obj)) {
            const val = obj[k];
            // if (typeof val === 'function') continue
            if (k === 'metaData')
                continue;
            print(k + "=" + val + "\n");
        }
    }

    Kirigami.AbstractCard {
        visible: showList
        Layout.fillWidth: true
        Layout.preferredHeight: Math.min(contentItem.implicitHeight + 20, 300)
        Layout.maximumHeight: 300
        contentItem: ScrollView {
            Layout.fillWidth: true
            ListView {
                id: listView
                model: shortcutsListFiltered
                Layout.fillHeight: true
                reuseItems: true
                clip: true
                focus: true
                activeFocusOnTab: true
                keyNavigationEnabled: true
                delegate: ItemDelegate {
                    property ListView listView: ListView.view
                    width: listView.width
                    text: label
                    onClicked: {
                        componentValue = component;
                        configValue = component + "," + shortcutName;
                        showList = false;
                    }
                    Rectangle {
                        color: index & 1 ? "transparent" : Kirigami.Theme.alternateBackgroundColor
                        anchors.fill: parent
                        z: -2
                    }
                }
                highlight: Item {}
                highlightMoveDuration: 0
                highlightResizeDuration: 0

                Connections {
                    target: listView.model
                    function onDataChanged() {
                        updateCombo();
                    }
                }
            }
        }
    }

    KSortFilterProxyModel {
        id: shortcutsListFiltered
        sourceModel: actionsModel.actions
        filterRoleName: "label"
        filterRowCallback: (sourceRow, sourceParent) => {
            return sourceModel.data(sourceModel.index(sourceRow, 0, sourceParent), filterRole).toLowerCase().includes(searchField.text.toLowerCase());
        }
    }
}
