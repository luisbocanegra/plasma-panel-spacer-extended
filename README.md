# Panel Spacer Extended

Plasma panel spacer with mouse actions

An attempt to bring [Latte Dock](https://github.com/KDE/latte-dock)'s window actions to the default plasma panel

[Demo](https://github.com/luisbocanegra/plasma-panel-spacer-extended/assets/15076387/13aad327-9b03-49a1-bb16-6b035dad8a9e)

## Some notes

* Tested only with Wayland session
* ⚠️ **Requires compiling (see [Installing](#installing))**

## Current and *planned* features

* [x] Maximize/unmaximize with:
  * [x] Left button double click
  * [x] Scroll wheel
* [x] Drag the active window by dragging down with left button from the panel
* Dragging requres releasing the the mouse, cursor should then attach itself to the active window
* [ ] Behavior configuration per widget (or global if possible??)

## Installing

* Install dependencies (please let me know if i missed something)

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
2. Running `qdbus org.kde.kglobalaccel /component/kwin org.kde.kglobalaccel.Component.invokeShortcut "Window Move"` on mouse drag down

## Credits & Resources

* Based on (but not forked from) [plasma-workspace/applets/panelspacer](https://invent.kde.org/plasma/plasma-workspace/-/tree/master/applets/panelspacer)
* [plasma-active-window-control](https://invent.kde.org/plasma/plasma-active-window-control)
