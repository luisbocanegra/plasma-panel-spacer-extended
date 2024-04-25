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
printLog`Focusing top window...\n`
var topWindow
let stackPosition = -1
// TODO is this needed at all if workspace.activeScreen should always have the screen with cursor?
var currentScreen = workspace.screenAt(workspace.cursorPos)
var currentDesktop = workspace.currentDesktop
printLog`active screen: ${workspace.activeScreen.name} current: ${currentScreen.name}`
for (var i = 0; i < windows.length; i++) {
  let window = windows[i]
  if (window.output === workspace.activeScreen
    && (window.onAllDesktops || window.desktops.includes(currentDesktop))
    && !window.desktopWindow
    && window.normalWindow
    && !window.minimized
    && !window.hidden
  ) {
    if (window.active) {
      topWindow = window
      break
    }
    if (window.stackingOrder > stackPosition) {
      topWindow = window
    }
    stackPosition = window.stackingOrder
  }
}
workspace.activeWindow = topWindow
const resut = ("Top: " + topWindow.caption + "|" + topWindow.resourceName + "|" + topWindow.resourceClass + "|" + topWindow.stackingOrder + "|" + topWindow.output.name)
printLog`${resut}`
