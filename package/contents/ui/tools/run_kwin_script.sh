#!/bin/env bash

# SCRIPT_FILE="/home/luis/projects/plasma-panel-spacer-extended/package/contents/ui/tools/focusTopWindow.js"
# SCRIPT_NAME="focusTopWindow"
SCRIPT_NAME="$1"
SCRIPT_FILE="$2"
DEBUG_ENABLED="$3"
QDBUS_EXEC="$4"

toggle_debug() {
  current_debug="$(sed -n 1p "$SCRIPT_FILE" | awk '{print $NF}')"
  if [[ -n $current_debug ]] && [[ $DEBUG_ENABLED != "$current_debug" ]]; then
    search="const enableDebug ="
    sed -i "s/^$search .*$/$search $DEBUG_ENABLED/g" "$SCRIPT_FILE"
  fi
}
toggle_debug

# reload the script
$QDBUS_EXEC org.kde.KWin /Scripting org.kde.kwin.Scripting.unloadScript "$SCRIPT_NAME"
script_id=$($QDBUS_EXEC org.kde.KWin /Scripting org.kde.kwin.Scripting.loadScript "${SCRIPT_FILE}" "$SCRIPT_NAME")

# run the script
$QDBUS_EXEC org.kde.KWin /Scripting/Script"$script_id" org.kde.kwin.Script.run
$QDBUS_EXEC org.kde.KWin /Scripting/Script"$script_id" org.kde.kwin.Script.stop
