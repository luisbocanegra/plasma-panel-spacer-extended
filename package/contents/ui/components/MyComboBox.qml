import QtQuick 2.0
import QtQuick.Controls 2.15

ComboBox {
    id: myComboBox

    property string configValue: ""
    property string configName: ""

    onCurrentIndexChanged: {
        // Update the configValue property
        configValue = currentIndex + "," + model.get(currentIndex)["ActionName"] + "," + model.get(currentIndex)["component"];
    }

    Component.onCompleted: {
        // Initialize the currentIndex from the config
        var index = 0
        for (var i= 0; i < model.count; i++) {
            if (model.get(i)["ActionName"]===plasmoid.configuration[configName].split(",")[1]){
                index = i;
                break;
            }
        }
        currentIndex = index;
    }
}