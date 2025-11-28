#!/bin/bash

EWW_CMD="eww -c $HOME/.config/eww"
TIMEOUT_CMD="$HOME/.config/eww/scripts/ewwtimeout.sh"

nmcli monitor | while read -r line; do
    # Trigger Popup on meaningful changes (2 seconds)
    # We filter out generic scanning lines to avoid spam
    if echo "$line" | grep -q "is now the primary connection"; then
        STATE="Enabled"
        SSID=$(echo "$line" | cut -d "'" -f2)
    elif echo "$line" | grep -q "disconnected"; then
        if [ "$(eww get wifi_state)" = "Disconnected" ]; then
            continue
        fi
        STATE="Disconnected"
        SSID=""
    else
        continue
    fi
    
    echo "Update $STATE $SSID"
    # Update variables
    $EWW_CMD update wifi_state="$STATE" wifi_ssid="$SSID"
    $TIMEOUT_CMD network_popup 2 2>/dev/null 1>&2 &
done
