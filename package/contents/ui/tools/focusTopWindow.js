const enableDebug = true
function printLog(strings, ...values) {
  if (enableDebug) {
    let str = 'PPSE: ';
    strings.forEach((string, i) => {
      str += string + (values[i] !== undefined ? values[i] : '');
    });
    console.log(str);
  }
}
const windows = workspace.windowList();
printLog`PPSE: Focusing top window...\n`
var topWindow
let stackPosition = -1


var currentScreen = workspace.screenAt(workspace.cursorPos)
// TODO is this needed at all if workspace.activeScreen should always have the screen with cursor?
printLog`active screen: ${workspace.activeScreen.name} current: ${currentScreen.name}`
for (var i = 0; i < windows.length; i++) {
  if (windows[i].output === workspace.activeScreen && !windows[i].desktopWindow && windows[i].normalWindow && !windows[i].minimized && windows[i].moveable && !windows[i].hidden) {
    if (windows[i].stackingOrder > stackPosition) {
      topWindow = windows[i]
    }
    stackPosition = windows[i].stackingOrder
  }
}
workspace.activeWindow = topWindow
resut = ("Top: " + topWindow.caption + "|" + topWindow.resourceName + "|" + topWindow.resourceClass + "|" + topWindow.stackingOrder + "|" + topWindow.output.name)
printLog`${resut}`
