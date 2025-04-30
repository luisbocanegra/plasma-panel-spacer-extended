# Changelog

## [1.10.1](https://github.com/luisbocanegra/plasma-panel-spacer-extended/compare/v1.10.0...v1.10.1) (2025-04-30)


### Bug Fixes

* window actions with touch input when cursor is in another screen ([7bc5f91](https://github.com/luisbocanegra/plasma-panel-spacer-extended/commit/7bc5f9107596931054138940b2c80873f9c53c56))

## [1.10.0](https://github.com/luisbocanegra/plasma-panel-spacer-extended/compare/v1.9.0...v1.10.0) (2025-01-20)


### Features

* option for persistent highlight effect ([977ec65](https://github.com/luisbocanegra/plasma-panel-spacer-extended/commit/977ec65d17df64443017f5b22856bce49a554b74))


### Bug Fixes

* find and resize with containment ([1074478](https://github.com/luisbocanegra/plasma-panel-spacer-extended/commit/107447818ef2fc3a308bc06afb98d2bb8c0de76b))
* handle panel-colorizer modification of widget and panel margins ([95c78ef](https://github.com/luisbocanegra/plasma-panel-spacer-extended/commit/95c78efd867f956ab9a69dc552515febc3d98927))
* stuck pressed effect after dragging ([2b90001](https://github.com/luisbocanegra/plasma-panel-spacer-extended/commit/2b9000157ab934cb542c18620aa8d643e6df94a5))
* update last active window on count change ([01a1667](https://github.com/luisbocanegra/plasma-panel-spacer-extended/commit/01a16677aa49ed9975d46f2eb02095a8a192bc9b)), closes [#41](https://github.com/luisbocanegra/plasma-panel-spacer-extended/issues/41)
* Use Qt.callLater as an attempt to prevent a plasma crash ([46a12d9](https://github.com/luisbocanegra/plasma-panel-spacer-extended/commit/46a12d946b6cc801a3bd97823032ffe3bcd88e6c))

## [1.9.0](https://github.com/luisbocanegra/plasma-panel-spacer-extended/compare/v1.8.3...v1.9.0) (2024-09-08)


### Features

* block continuous drag for some actions ([354ce85](https://github.com/luisbocanegra/plasma-panel-spacer-extended/commit/354ce85bb4d082d3d9ff226d4c6d04896a7086e4))
* continuous drag and remove delay if double click is disabled ([4a578c9](https://github.com/luisbocanegra/plasma-panel-spacer-extended/commit/4a578c90dd264916a4e4cac1ab127bec846d837e))
* update continuous drag wording ([0c27063](https://github.com/luisbocanegra/plasma-panel-spacer-extended/commit/0c2706395d7c69395b5b387fc30726d62c2fa8da))


### Bug Fixes

* avoid crashing/freezing kwin when dragging a window on X11 ([f9bc677](https://github.com/luisbocanegra/plasma-panel-spacer-extended/commit/f9bc677a83f727351bd780a5a1e069b1539c1070))
* restore missing disabled, custom command and app/url actions ([1750297](https://github.com/luisbocanegra/plasma-panel-spacer-extended/commit/17502971d4bb61b6634f6e88f3c8bfd01ac1efbd))

## v1.8.3 (30-07-2024) Switch to gdbus

### Fixes

- Get shortcuts using separate bash script (fixes [#40](https://github.com/luisbocanegra/plasma-panel-spacer-extended/issues/40))
- Port from qdbus to gdbus command (fixes [#40](https://github.com/luisbocanegra/plasma-panel-spacer-extended/issues/40))

## v1.8.2 (29-05-2024) Fix X11 window dragging

### Fixes

- Fixed broken window dragging in X11 session (works just like it did in earlier versions Drag + Release to grab and Click to drop). Wayland stays the same (Drag + Release to drop) [#32](https://github.com/luisbocanegra/plasma-panel-spacer-extended/issues/32)

## v1.8.1 (28-05-2024) Bugfix Release

### Fixes

- Fix weird Plasma freeze when selecting command action from settings

## v1.8.0 (25-05-2024) Search actions

### Improvements

- Type to search actions (replaces the giant ugly combobox) https://github.com/luisbocanegra/plasma-panel-spacer-extended/issues/35

### Fixes

- Fix the annoying **Apply Settings** popup https://github.com/luisbocanegra/plasma-panel-spacer-extended/issues/35
- Fit content in window and change some widths https://github.com/luisbocanegra/plasma-panel-spacer-extended/issues/35

## v1.7.0 (20-05-2024)

### Improvements

- Scroll gesture sensitivity
- Tooltip improvements
  - Don't show disabled gestures in tooltip https://github.com/luisbocanegra/plasma-panel-spacer-extended/issues/31
  - Wrap instead of eliding action name
  - Replace dashes and underscores from component and shortcut names

### Other

- Tooltip is now shorter
- Changed default hover radius to 5px and qdbus excecutable name (qdbus6)
- Toggle debug in KWin script

## v1.6.1 (28-04-2024) - Bugfix Release

### Bug fixes

- Fixed wrong cursor shape when hovering the panel
- Fixed middle click not being recognized
- Fixed dragging axis detection while spacer length changes
- If present, select the active window in the current screen
- Activate last active window on each screen for window actions

### Other

- Tooltip is now shorter
- Changed default hover radius to 5px and qdbus excecutable name (qdbus6)
- Toggle debug in KWin script

## v1.6.0 (18-04-2024) - Preset management & auto-loading

### Improvements

- Switched drag & drop instead of drag and click to drop
- Drag top window on current screen instead of active window (same for all other window related shortcuts)

## v1.5.4 (07-03-2024) - Fix tooltip visibility

- Fixed list of actions tooltip visibility option

## v1.5.3 (06-03-2024) - Fixed centering

- Fixed centering a widget between two spacers not centering that widget relative to the panel #15

## v1.5.2 (04-03-2024) - Fix very short length

- Increased maximum fixed width to screen width/height

## v1.5.1 (17-02-2024) - Fixed manual length

- Added config option to set fixed length (0fd2335) fixes #14

## v1.5.0 (07-02-2024) - Initial plasma 6 update

- Port to KF6/Plasma6
- Option for custom qdbus executable name
- Pull shortcuts from system
- Avoid triggering multiple gestures a the same time
- Update mouse cursor on pressed
- Hover highlight customization

## v1.4.0 (27-07-2023) - Launch Applications and files

- Add support for launching a program/url/file #6
- Show list of actions when hovering the spacer #7

## v1.3.1 (24-07-2023) - Fix broken icons

Use more standard icons

## v1.3.1 (24-07-2023) - Custom commands support

- Add support for running custom commands in #5
- Add troubleshooting settings page

## v1.2.1 (22-07-2023) - No compiling needed

- Remove need for compiled plugin
- Update install script to install as user

## v1.2.0 (21-07-2023) - How many buttons do you need? yes

- Add widget configuration
- Add more desktop/window actions #2
- Make it configurable per mouse button #2
- Add single and middle click actions

## v1.1.1 (19-07-2023) - (beta release)

- Maximize/unmaximize with:
  - Left button double click
  - Scroll wheel
- Drag the active window by dragging down with left button from the panel
- This is the first release under a different name, now requires compiling extra code to fully work [instructions here](https://github.com/luisbocanegra/plasma-panel-spacer-extended#installing)
