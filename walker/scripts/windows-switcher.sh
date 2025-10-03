#!/bin/bash

# Get window list from hyprctl and parse windows
declare -A windows

while IFS= read -r line; do
  if [[ $line =~ ^Window\ ([a-f0-9]+)\ -\>\ (.+):$ ]]; then
    address="${BASH_REMATCH[1]}"
    title="${BASH_REMATCH[2]}"
    windows["$title"]="$address"
  fi
done < <(hyprctl clients)

# Show titles in dmenu and get selection
selected_title=$(printf '%s\n' "${!windows[@]}" | walker -d -p "Window:")

# If something was selected, focus the window
if [[ -n "$selected_title" ]]; then
  address="${windows[$selected_title]}"
  hyprctl dispatch focuswindow "address:0x$address"
fi
