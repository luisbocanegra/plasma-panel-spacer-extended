#!/bin/env bash

# load the script
echo "running"
# SCRIPT_FILE="/home/luis/projects/plasma-panel-spacer-extended/package/contents/ui/tools/focusTopWindow.js"
# SCRIPT_NAME="focusTopWindow"
SCRIPT_NAME="$1"
SCRIPT_FILE="$2"
qdbus org.kde.KWin /Scripting org.kde.kwin.Scripting.unloadScript "$SCRIPT_NAME"
script_id=$(qdbus org.kde.KWin /Scripting org.kde.kwin.Scripting.loadScript "${SCRIPT_FILE}" "$SCRIPT_NAME")

# run
qdbus org.kde.KWin /Scripting/Script"$script_id" org.kde.kwin.Script.run
qdbus org.kde.KWin /Scripting/Script"$script_id" org.kde.kwin.Script.stop
