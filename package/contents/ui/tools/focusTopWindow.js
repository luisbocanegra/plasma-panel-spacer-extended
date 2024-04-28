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
var topWindow = {}
let stackPosition = -1
let cursorPos = workspace.cursorPos
var currentScreen = workspace.screenAt(cursorPos)
var currentDesktop = workspace.currentDesktop
printLog`cursor: x:${cursorPos.x} y:${cursorPos.x} screen:${currentScreen.name}`
printLog`active screen: ${workspace.activeScreen.name} current: ${currentScreen.name}`
for (var i = 0; i < windows.length; i++) {
  let window = windows[i]
  if (window.output === currentScreen
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
if (Object.keys(topWindow).length !== 0) {
  workspace.activeWindow = topWindow
  const resut = ("Top: " + topWindow.caption + "|" + topWindow.resourceName + "|" + topWindow.resourceClass + "|" + topWindow.stackingOrder + "|" + topWindow.output.name)
  printLog`${resut}`
} else {
  printLog`No window to activate was found`
}
// printLog`${JSON.stringify(topWindow, null, 2)}`

