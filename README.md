<div align="center">

# Panel Spacer Extended

[![nixpkgs unstable package](https://repology.org/badge/version-for-repo/nix_unstable/plasma-panel-spacer-extended.svg?header=nixpkgs%20unstable)](https://repology.org/project/plasma-panel-spacer-extended/versions)
[![Dynamic JSON Badge](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fraw.githubusercontent.com%2Fluisbocanegra%2Fplasma-panel-spacer-extended%2Fmain%2Fpackage%2Fmetadata.json&query=KPlugin.Version&style=for-the-badge&color=1f425f&labelColor=2d333b&logo=kde&label=KDE%20Store)](https://store.kde.org/p/2128047)
[![Liberapay](https://img.shields.io/liberapay/patrons/luisbocanegra?style=for-the-badge&logo=liberapay&logoColor=%23F6C814&labelColor=%232D333B&label=supporters)](https://liberapay.com/luisbocanegra/)

</div>

Spacer with Mouse gestures for the KDE Plasma Panel featuring Latte Dock/Gnome/Unity drag window gesture. Run any shortcut, command, application or URL/file with up to ten configurable mouse actions!

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
    * [x] Min wheel steps
  * [x] Mouse drag (four axis)
    * [ ] Min track distance
  * [x] Long press
    * [ ] Hold duration
* [x] Actions
  * [x] Run any keyboard shortcut (detects all available shortcuts in **System Settings** > **Shortcuts**)
  * [x] Run custom commands
  * [x] Launch Applications/Urls/Files
* [ ] Sync configuration across widget instances
* [ ] Quick disable/reset defaults
* [ ] Popup/Notification showing shortcut being run
* [x] Panel visual feedback

## Installing

> [!IMPORTANT]
> Development has switched to Plasma 6, PRs to backport changes to Plasma 5 version are welcomed

### Arch Linux

[aur/plasma6-applets-panel-spacer-extended](https://aur.archlinux.org/packages/plasma6-applets-panel-spacer-extended) use your preferred AUR helper (e.g `yay -S plasma6-applets-panel-spacer-extended`)

### KDE Store

* [Plasma 5](https://store.kde.org/p/2064339) version v1.4.0

* [Plasma 6](https://store.kde.org/p/2128047)

1. **Right click on the Panel** > **Add Widgets** > **Get New Widgets** > **Download New Plasma Widgets**
2. **Search** for "**Panel Spacer Extended**", install and add to your panel(s).
3. Click on **Add new videos** pick your video(s) and apply.

### Nix package

For those using NixOS or the Nix package manager, there is a package available in nixpkgs.

To install the widget use one of these methods:

- NixOS

  ```nix
  environment.systemPackages = [
    pkgs.plasma-panel-spacer-extended
  ];
  ```

- [Home-manager](https://github.com/nix-community/home-manager)

  ```nix
  home.packages = [
    pkgs.plasma-panel-spacer-extended
  ];
  ```

- [Plasma-manager](https://github.com/nix-community/plasma-manager): If the widget gets added to a panel it will automatically be installed

- Other distros using Nix package manager

  ```sh
  # without flakes:
  nix-env -iA nixpkgs.plasma-panel-spacer-extended
  # with flakes:
  nix profile install nixpkgs#plasma-panel-spacer-extended
  ```

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

1. Runs `calls dbus method org.kde.kglobalaccel /component/$COMPONENT org.kde.kglobalaccel.Component.invokeShortcut "ACTION NAME"` for shortcuts
2. App/URL/File actions depend on `kdeplasma-addons`

## Support the development

If you like the project you can

[!["Buy Me A Coffee"](https://img.shields.io/badge/Buy%20me%20a%20coffe-supporter?logo=buymeacoffee&logoColor=%23282828&labelColor=%23FF803F&color=%23FF803F)](https://www.buymeacoffee.com/luisbocanegra) [![Liberapay](https://img.shields.io/badge/Become%20a%20supporter-supporter?logo=liberapay&logoColor=%23282828&labelColor=%23F6C814&color=%23F6C814)](https://liberapay.com/luisbocanegra/)

## Credits & Resources

* Based on (but not forked from) [plasma-workspace/applets/panelspacer](https://invent.kde.org/plasma/plasma-workspace/-/tree/master/applets/panelspacer)
* [plasma-active-window-control](https://invent.kde.org/plasma/plasma-active-window-control)
* [plasmoid-spacer-as-pager](https://github.com/eatsu/plasmoid-spacer-as-pager) for the changes that eliminated the need of compiled C++ plugin
* [kdeplasma-addons/applets/quicklaunch](https://invent.kde.org/plasma/kdeplasma-addons/-/tree/master/applets/quicklaunch) for the implementation of the Application Chooser and Launcher this project makes use of
* [jinliu/kdotool](https://github.com/jinliu/kdotool) for loading and reading KWin script output inspiration
