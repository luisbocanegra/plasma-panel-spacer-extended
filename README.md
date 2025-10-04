<div align="center">

# Panel Spacer Extended

[![AUR version](https://img.shields.io/aur/version/plasma6-applets-panel-spacer-extended?logo=archlinux&labelColor=2d333b&color=1f425f)](https://aur.archlinux.org/packages/plasma6-applets-panel-spacer-extended)
[![Store version](https://img.shields.io/badge/dynamic/xml?url=https%3A%2F%2Fapi.opendesktop.org%2Focs%2Fv1%2Fcontent%2Fdata%2F2128047&query=%2Focs%2Fdata%2Fcontent%2Fversion%2Ftext()&color=1f425f&labelColor=2d333b&logo=kde&label=KDE%20Store)](https://store.kde.org/p/2128047)
[![nixpkgs unstable package](https://repology.org/badge/version-for-repo/nix_unstable/plasma-panel-spacer-extended.svg?header=nixpkgs%20unstable)](https://repology.org/project/plasma-panel-spacer-extended/versions)
[![Matrix](https://img.shields.io/matrix/kde-plasma-panel-spacer-extended%3Amatrix.org?logo=matrix&label=Matrix&labelColor=black)](https://matrix.to/#/#kde-plasma-panel-spacer-extended:matrix.org)

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
* [x] Popup/Notification showing shortcut being run
* [x] Panel visual feedback

## Installing

### Arch Linux

<https://aur.archlinux.org/packages/plasma6-applets-panel-spacer-extended>

```sh
yay -S plasma6-applets-panel-spacer-extended
```

### Nix package

For those using NixOS or the Nix package manager, there is a package available in nixpkgs.

To install the widget use one of these methods:

* NixOS

  ```nix
  environment.systemPackages = [
    pkgs.plasma-panel-spacer-extended
  ];
  ```

* [Home-manager](https://github.com/nix-community/home-manager)

  ```nix
  home.packages = [
    pkgs.plasma-panel-spacer-extended
  ];
  ```

* [Plasma-manager](https://github.com/nix-community/plasma-manager): If the widget gets added to a panel it will automatically be installed

* Other distros using Nix package manager

  ```sh
  # without flakes:
  nix-env -iA nixpkgs.plasma-panel-spacer-extended
  # with flakes:
  nix profile install nixpkgs#plasma-panel-spacer-extended
  ```

### KDE Store

* [Plasma 5](https://store.kde.org/p/2064339) version v1.4.0

* [Plasma 6](https://store.kde.org/p/2128047)

1. **Right click on the Panel** > **Add Widgets** > **Get New Widgets** > **Download New Plasma Widgets**
2. **Search** for "**Panel Spacer Extended**" and install it.

### Install from source

1. Install dependencies (please let me know if I missed something) or their equivalent for your distribution

    ```sh
      # Arch Linux
      sudo pacman -S git gcc cmake extra-cmake-modules libplasma kdeplasma-addons
      # Fedora
      sudo dnf install git gcc-c++ cmake extra-cmake-modules libplasma-devel kdeplasma-addons
      # Kubuntu
      sudo apt install git build-essential cmake extra-cmake-modules libplasma-dev kdeplasma-addons
    ```

    *NOTE: `kdeplasma-addons` is a runtime dependency*

2. Clone and install

    ```sh
    git clone https://github.com/luisbocanegra/plasma-panel-spacer-extended
    cd plasma-panel-spacer-extended
    ./install.sh
    ```

## How to use

1. Add the widget to your panel(s)
2. If you have default plasma spacer on the same panel remove it and only use the same spacer type (built-in or extended) if you have more than one.
3. Done, now you can use the default actions or customize them to your liking.

## How does it work?

1. Runs `calls dbus method org.kde.kglobalaccel /component/$COMPONENT org.kde.kglobalaccel.Component.invokeShortcut "ACTION NAME"` for shortcuts
2. App/URL/File actions depend on `kdeplasma-addons`

## Support the development ❤️

If you like what I do consider donating/sponsoring this and [my other open source work](https://github.com/luisbocanegra?tab=repositories&q=&type=source)

[![GitHub Sponsors](https://img.shields.io/badge/GitHub_Sponsors-supporter?logo=githubsponsors&color=%2329313C)](https://github.com/sponsors/luisbocanegra) [![Ko-fi](https://img.shields.io/badge/Ko--fi-supporter?logo=ko-fi&logoColor=%23ffffff&color=%23467BEB)](https://ko-fi.com/luisbocanegra) [!["Buy Me A Coffee"](https://img.shields.io/badge/Buy%20Me%20a%20Coffe-supporter?logo=buymeacoffee&logoColor=%23282828&color=%23FF803F)](https://www.buymeacoffee.com/luisbocanegra) [![Liberapay](https://img.shields.io/badge/Liberapay-supporter?logo=liberapay&logoColor=%23282828&color=%23F6C814)](https://liberapay.com/luisbocanegra/) [![PayPal](https://img.shields.io/badge/PayPal-supporter?logo=paypal&logoColor=%23ffffff&color=%23003087)](https://www.paypal.com/donate/?hosted_button_id=Y5TMH3Z4YZRDA)

## Credits & Resources

* Based on (but not forked from) [plasma-workspace/applets/panelspacer](https://invent.kde.org/plasma/plasma-workspace/-/tree/master/applets/panelspacer)
* [plasma-active-window-control](https://invent.kde.org/plasma/plasma-active-window-control)
* [plasmoid-spacer-as-pager](https://github.com/eatsu/plasmoid-spacer-as-pager) for the changes that eliminated the need of compiled C++ plugin
* [kdeplasma-addons/applets/quicklaunch](https://invent.kde.org/plasma/kdeplasma-addons/-/tree/master/applets/quicklaunch) for the implementation of the Application Chooser and Launcher this project makes use of
* [jinliu/kdotool](https://github.com/jinliu/kdotool) for loading and reading KWin script output inspiration
