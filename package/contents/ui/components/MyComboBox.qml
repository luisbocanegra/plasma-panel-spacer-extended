import QtQuick 2.0
import QtQuick.Controls 2.15

ComboBox {
    id: myComboBox

    property string configValue: ""
    property string configName: ""

    property bool isLoading: true

    onCurrentIndexChanged: {
        configValue = model.get(currentIndex)["component"] + "," + model.get(currentIndex)["shortcutName"];
    }

    function updateCombo()
    {
        var index = 0
        for (var i= 0; i < model.count; i++) {
            const shortcut = model.get(i)["component"] + "," + model.get(i)["shortcutName"]
            if (shortcut === plasmoid.configuration[configName]){
                index = i;
                break;
            }
        }
        currentIndex = index;
    }

    // Component.onCompleted: {
    //     updateCombo()
    // }

    onIsLoadingChanged: {
        updateCombo()
    }

    // HACK: Prevent starting scrolling on collapsed combobox
    // for the sole reason there are so many
    // IDEA: Scroll parent or use another kind of collapsed view instead??
    MouseArea {
        anchors.fill: myComboBox
        hoverEnabled: true

        onWheel: {
            // Do nothing :)
        }

        onClicked: {
            myComboBox.popup.open()
        }
    }
}

