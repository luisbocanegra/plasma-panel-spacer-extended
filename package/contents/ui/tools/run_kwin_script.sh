#!/bin/env bash

# SCRIPT_FILE="/home/luis/projects/plasma-panel-spacer-extended/package/contents/ui/tools/focusTopWindow.js"
# SCRIPT_NAME="focusTopWindow"
SCRIPT_NAME="$1"
SCRIPT_FILE="$2"
DEBUG_ENABLED="$3"

toggle_debug() {
  current_debug="$(sed -n 1p "$SCRIPT_FILE" | awk '{print $NF}')"
  if [[ -n $current_debug ]] && [[ $DEBUG_ENABLED != "$current_debug" ]]; then
    search="const enableDebug ="
    sed -i "s/^$search .*$/$search $DEBUG_ENABLED/g" "$SCRIPT_FILE"
  fi
}
toggle_debug

# reload the script
gdbus call --session --dest org.kde.KWin --object-path /Scripting --method org.kde.kwin.Scripting.unloadScript "$SCRIPT_NAME"
script_id=$(gdbus call --session --dest org.kde.KWin --object-path /Scripting --method org.kde.kwin.Scripting.loadScript "${SCRIPT_FILE}" "$SCRIPT_NAME" | sed -e "s|objectpath||g;s/[](\)',[]//g")

# run the script
gdbus call --session --dest org.kde.KWin --object-path /Scripting/Script"$script_id" --method org.kde.kwin.Script.run
gdbus call --session --dest org.kde.KWin --object-path /Scripting/Script"$script_id" --method org.kde.kwin.Script.stop
