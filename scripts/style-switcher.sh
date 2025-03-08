#!/usr/bin/env bash

WAYBAR_STYLE_DIR="$HOME/.config/waybar/styles"
WAYBAR_STYLE_FILE="$HOME/.config/waybar/style.css"

# CURRENT_THEME_FILE="$HOME/.config/waybar/themes/current-theme"
CURRENT_STYLE_FILE="$HOME/.config/waybar/styles/current-style"

for dir in "$WAYBAR_STYLE_DIR"; do
  [[ ! -d "$dir" ]] && echo "Error: $dir not found" && exit 1
done

# Get all styles
waybar_style=("$WAYBAR_STYLE_DIR"/*.css)

if [ ${#waybar_style[@]} -eq 0 ]; then
  echo "Error: No styles found in one of the directories"
  exit 1
fi

# Get the current style
current_style=$(cat "$CURRENT_STYLE_FILE" 2>/dev/null || echo "")

# Find the index of the current style
next_style_index=0
for i in "${!waybar_style[@]}"; do
  [[ "${waybar_style[$i]}" == "$current_style" ]] && next_style_index=$(((i + 1) % ${#waybar_style[@]})) && break
done

# Get the new style
new_waybar_style="${waybar_style[$next_style_index]}"

# Save the new style
echo "$new_waybar_style" >"$CURRENT_STYLE_FILE"

declare -A style_files=(
  ["$new_waybar_style"]="$WAYBAR_STYLE_FILE"
)

for src in "${!style_files[@]}"; do
  cp "$src" "${style_files[$src]}"
done

# Restart Waybar to apply changes
killall waybar || true
nohup waybar --config "$HOME/.config/waybar/config.jsonc" --style "$HOME/.config/waybar/style.css" >/dev/null 2>&1 &
