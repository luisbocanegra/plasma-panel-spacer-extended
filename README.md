# Panel Spacer Extended

Plasma panel spacer with mouse actions

An attempt to bring [Latte Dock](https://github.com/KDE/latte-dock)'s window actions (and more!) to the default plasma panel

[Demo](https://github.com/luisbocanegra/plasma-panel-spacer-extended/assets/15076387/13aad327-9b03-49a1-bb16-6b035dad8a9e)

<details>
    <summary>Screenshots</summary>
<img src="https://github.com/luisbocanegra/plasma-panel-spacer-extended/assets/15076387/99e684d5-4817-4a57-aa21-1d7c804e4ff8" alt="widget actions config">
</details>

## Some notes

* Tested only with Wayland session
* ⚠ **Requires compiling (see [Installing](#installing))**

## Current and *planned* features

* [X] Mouse actions
  * [x] Single click
  * [x] Double click
  * [x] Middle click
  * [x] Mouse wheel up/down
    * [ ] Min wheel steps
  * [x] Mouse drag (four axis)
    * [ ] Min track distance
  * [x] Long press
    * [ ] Hold hold duration
* [x] Lots of actions from kwin shortcuts

  <details>
    <summary>Expand</summary>

  * Disabled
  * Maximize active window
  * Unmaximize active window
  * Maximize active window (toggle)
  * Close active window
  * Move active window
  * Minimize active window
  * Show Window Operations Menu
  * Fullscreen active window
  * Minimize all windows
  * Show Desktop Grid
  * Show Desktop
  * Show Overview
  * Present windows of active Application (all desktops)
  * Present windows of active Application (current desktop)
  * Present all windows (all desktops)
  * Present all windows (current desktop)
  * Walk Through Windows
  * Walk Through Windows (Reverse)
  * Walk Through Windows Alternative
  * Walk Through Windows Alternative (Reverse)
  * Walk Through Windows of Current Application
  * Walk Through Windows of Current Application (Reverse)
  * Walk Through Windows of Current Application Alternative
  * Walk Through Windows of Current Application Alternative (Reverse)
  * Switch One Desktop Up
  * Switch One Desktop Down
  * Switch One Desktop to the Left
  * Switch One Desktop to the Right
  * Switch to Previous Desktop
  * Switch to Next Desktop
  * Walk Through Desktops
  * Window One Desktop Up
  * Window One Desktop Down
  * Window One Desktop to the Left
  * Window One Desktop to the Right
  * Window to Next Desktop
  * Window to Previous Desktop
  * Kill Window
  </details>

* [x] Behavior configuration per widget
  * [ ] global if possible??
* [ ] Better default config currently:
* [ ] Automatically detect all avilable org.kde.kglobalaccel component shortcuts
* [ ] Quick disable/reset defaults

### Default actions

* Single click `Overview`
* Double click `Window Maximize (toggle)`
* Middle click `Show desktop`
* Wheel Up `Switch to Previous Desktop`
* Wheel Down `Switch to Next Desktop`
* Drag Up `Window Move`
* Drag Down `Window Move`
* Drag Left `Window One Desktop to the Left`
* Drag Right `Window One Desktop to the Right`
* Long Press `Present windows`

## Installing

* Install dependencies (please let me know if I missed something)

  ```txt
    cmake extra-cmake-modules ki18n plasma-framework
  ```

* If installed widget from KDE Store:
  
  Build and install the required plugin only
  
  ```sh
  ./install-plugin-only.sh
  ```

* Otherwise, build/install everything:

  ```sh
  ./install.sh
  ```

### Why building is needed and not just the plasmoid?

* Installing Just the plasmoid with a differend `id` won't work as this widget access some special properties of the panel, which are only avilable to the default applet, having them in other panel requires building the qt plugin too
* Just installing in `./local` without renaming would work but I then there is no way to remove the updated verision from UI and I don't think widgets that mask other widgets are a good idea, nothing stops you from doing it though :)

## How does it work?

1. Using code from [plasma-active-window-control](https://invent.kde.org/plasma/plasma-active-window-control) widget for:
   1. Getting current window
   2. Maximize/unmaximize active window
2. Runs `qdbus org.kde.kglobalaccel /component/kwin org.kde.kglobalaccel.Component.invokeShortcut "ACTION NAME"` for all other actions

## Credits & Resources

* Based on (but not forked from) [plasma-workspace/applets/panelspacer](https://invent.kde.org/plasma/plasma-workspace/-/tree/master/applets/panelspacer)
* [plasma-active-window-control](https://invent.kde.org/plasma/plasma-active-window-control)
