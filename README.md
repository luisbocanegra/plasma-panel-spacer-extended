# Panel Spacer Extended (mouse actions)

Plasma panel spacer with mouse actions

An attemp to bring [Latte Dock](https://github.com/KDE/latte-dock)'s window actions to the default plasma panel

## Some notes

* Tested only on Wayland session

## Added Features

* Maximize/unmaximize with:
  * Double click
  * Scroll wheel
* Move focused window by dragging down from the panel

## Installing

Download it from [KDE Store](https://store.kde.org/p/TODO) or use `Get New Widgets`/`Discover`

## How does it work?

1. Using code from [plasma-active-window-control](https://invent.kde.org/plasma/plasma-active-window-control) widget for:
   1. Getting current window
   2. Maximize/unmaximize active window
2. Running `qdbus org.kde.kglobalaccel /component/kwin org.kde.kglobalaccel.Component.invokeShortcut "Window Move"` on mouse drag down

## Credits & Resources

* Based on (but not forked from) [plasma-workspace/applets/panelspacer](https://invent.kde.org/plasma/plasma-workspace/-/tree/master/applets/panelspacer)
* [plasma-active-window-control](https://invent.kde.org/plasma/plasma-active-window-control)
