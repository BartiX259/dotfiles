#!/bin/bash

EWW_CMD="eww -c $HOME/.config/eww"

update_brightness() {
    PERCENT=$(awk "BEGIN {print int($(brightnessctl g) * 100 / $(brightnessctl m))}")
    $EWW_CMD update brightness_percent=$PERCENT
    # Also trigger the popup
    $HOME/.config/eww/scripts/ewwtimeout.sh brightness_popup 1 2>/dev/null 1>&2 &
}

udevadm monitor -us backlight | while read -r event; do
    # Filter for the actual device events to avoid duplicates
    if echo "$event" | grep -q "change"; then
        update_brightness
    fi
done
