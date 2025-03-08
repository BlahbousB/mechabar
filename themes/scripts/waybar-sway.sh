#!/bin/bash
killall waybar

if pgrep -x "sway" > /dev/null; then
  sed -i "s/\bhyprland\b/sway/g" ~/.config/waybar/config.jsonc
  echo "complete"
fi

exec waybar -c ~/.config/waybar/config.jsonc
