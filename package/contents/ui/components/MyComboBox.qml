import QtQuick 2.0
import QtQuick.Controls 2.15

ComboBox {
    id: myComboBox

    property string configValue: ""
    property string configName: ""

    // Limit expanded combobox height
    popup.height: 300

    onCurrentIndexChanged: {
        configValue = model.get(currentIndex)["ActionName"] + "," + model.get(currentIndex)["component"];
    }

    // Select active action by saved name
    Component.onCompleted: {
        var index = 0
        for (var i= 0; i < model.count; i++) {
            if (model.get(i)["ActionName"]===plasmoid.configuration[configName].split(",")[0]){
                index = i;
                break;
            }
        }
        currentIndex = index;
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

