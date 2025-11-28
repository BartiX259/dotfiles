#!/bin/bash

EWW_CMD="eww -c $HOME/.config/eww"

## -----------------------------------------------------
## Initial Values
## -----------------------------------------------------

# Audio (Speaker)
$EWW_CMD update volume=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '[0-9]+(?=%)' | head -n 1)
$EWW_CMD update speaker_mute=$(pactl get-sink-mute @DEFAULT_SINK@ | grep -q 'yes' && echo 'muted' || echo 'unmuted')

# Audio (Mic)
$EWW_CMD update mic_mute=$(pactl get-source-mute @DEFAULT_SOURCE@ | grep -q 'yes' && echo 'muted' || echo 'unmuted')

# Brightness
$EWW_CMD update brightness_percent=$(awk "BEGIN {print int($(brightnessctl g) * 100 / $(brightnessctl m))}")

# Battery
ACPI_OUTPUT=$(acpi -b)
if [ -n "$ACPI_OUTPUT" ]; then
    $EWW_CMD update battery_status=$(echo "$ACPI_OUTPUT" | awk '{print $3}' | tr -d ',')
    $EWW_CMD update battery_percent=$(echo "$ACPI_OUTPUT" | awk '{print $4}' | tr -d '%,')
fi

# Wifi
state=$(nmcli r wifi)
$EWW_CMD update wifi_state="$(echo $state | cut -c1 | tr '[:lower:]' '[:upper:]')$(echo $state | cut -c2-)"
$EWW_CMD update wifi_ssid="$(nmcli -t -f ACTIVE,SSID dev wifi | grep -E '^yes' | cut -d':' -f2 || echo '')"

## -----------------------------------------------------
## Listeners
## -----------------------------------------------------
pkill -f 'listen_audio.sh'
pkill -f 'listen_wifi.sh'
pkill -f 'listen_brightness.sh'
pkill -f 'listen_battery.sh'

~/.config/eww/scripts/listen_audio.sh &
~/.config/eww/scripts/listen_wifi.sh &
~/.config/eww/scripts/listen_brightness.sh &
~/.config/eww/scripts/listen_battery.sh &
