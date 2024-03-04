# Panel Spacer Extended

Plasma panel spacer with mouse actions

An attempt to bring [Latte Dock](https://github.com/KDE/latte-dock)'s window actions (and more!) to the default plasma panel

[Demo](https://github.com/luisbocanegra/plasma-panel-spacer-extended/assets/15076387/13aad327-9b03-49a1-bb16-6b035dad8a9e)

<details>
    <summary>Screenshots</summary>
<img src="https://github.com/luisbocanegra/plasma-panel-spacer-extended/assets/15076387/3767c2b8-cf27-4034-a08a-a994fb68f2c3" alt="widget actions config">
</details>

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
    * [ ] Hold duration
* [x] Actions
  * [x] Run any keyboard shortcut (detects all available org.kde.kglobalaccel shortcuts from system)
  * [x] Run custom commands
  * [x] Launch Applications/Urls/Files
* [ ] Sync configuration across widget instances
* [ ] Quick disable/reset defaults
* [ ] Popup/Notification showing shortcut being run
* [x] Panel visual feedback

## Installing

> [!IMPORTANT]
> Development has switched to Plasma 6, PRs to backport changes to Plasma 5 version are welcomed

Install from KDE Store or use `Get new widgets..`

* [Plasma 5](https://store.kde.org/p/2064339) version v1.4.0

* [Plasma 6](https://store.kde.org/p/2128047)

### Manual install

* Install dependencies (please let me know if I missed something)

  ```txt
    cmake extra-cmake-modules plasma-framework kdeplasma-addons
  ```

* Install the plasmoid

  ```sh
  ./install.sh
  ```

## How does it work?

1. Runs `qdbus org.kde.kglobalaccel /component/$COMPONENT org.kde.kglobalaccel.Component.invokeShortcut "ACTION NAME"` for shortcut
2. App/URL/File actions depend on `kdeplasma-addons`

## Credits & Resources

* Based on (but not forked from) [plasma-workspace/applets/panelspacer](https://invent.kde.org/plasma/plasma-workspace/-/tree/master/applets/panelspacer)
* [plasma-active-window-control](https://invent.kde.org/plasma/plasma-active-window-control)
* [plasmoid-spacer-as-pager](https://github.com/eatsu/plasmoid-spacer-as-pager) for the changes that eliminate the need of built code
* [kdeplasma-addons/applets/quicklaunch](https://invent.kde.org/plasma/kdeplasma-addons/-/tree/master/applets/quicklaunch) for the implementation of the Application Chooser and Launcher this project makes use of
