#!/usr/bin/env bash
for comp in $(gdbus call --session --dest org.kde.kglobalaccel --object-path /kglobalaccel --method org.kde.KGlobalAccel.allComponents | sed -e "s|objectpath||g;s/[](\)',[]//g"); do
  shortcuts=$(gdbus call --session --dest org.kde.kglobalaccel --object-path "$comp" --method org.kde.kglobalaccel.Component.shortcutNames | sed -e "s|objectpath||g;s/[](\)'[]//g")
  IFS="," read -r -a shortcuts_array <<<"$shortcuts"
  for shortcut in "${shortcuts_array[@]}"; do
    echo "$comp,$(sed 's|^ ||' <<<$shortcut)"
  done
done
