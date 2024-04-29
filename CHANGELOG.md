# Changelog

## v1.6.0 (28-04-2024) - Bugfix Release

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
