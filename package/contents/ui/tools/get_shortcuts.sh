#!/usr/bin/env bash
QDBUS_EXEC="$1"
for comp in $($QDBUS_EXEC org.kde.kglobalaccel | grep '/component/'); do
  IFS=$'\n'
  for shortcut in $($QDBUS_EXEC org.kde.kglobalaccel $comp org.kde.kglobalaccel.Component.shortcutNames); do
    echo $comp,$shortcut
  done
done
