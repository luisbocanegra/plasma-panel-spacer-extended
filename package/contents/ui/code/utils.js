function truncateString(str, n) {
    if (str.length > n) {
        return str.slice(0, n) + "...";
    } else {
        return str;
    }
}

function delay(interval, callback, parentItem) {
    let timer = Qt.createQmlObject("import QtQuick; Timer {}", parentItem);
    timer.interval = interval;
    timer.repeat = false;
    timer.triggered.connect(callback);
    timer.triggered.connect(function release() {
        timer.triggered.disconnect(callback);
        timer.triggered.disconnect(release);
        timer.destroy();
    });
    timer.start();
}
