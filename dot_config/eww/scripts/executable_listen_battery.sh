#!/bin/bash

EWW_CMD="eww -c $HOME/.config/eww"
TIMEOUT_CMD="$HOME/.config/eww/scripts/ewwtimeout.sh"

update_battery() {
    OLD_STATUS="$(eww get battery_status)"

    for _ in {1..10}; do
        ACPI_OUTPUT=$(acpi -b)
        # Get status and clean trailing comma
        STATUS=$(echo "$ACPI_OUTPUT" | awk '{print $3}' | tr -d ',')
        # Get percent and clean symbols
        PERCENT=$(echo "$ACPI_OUTPUT" | awk '{print $4}' | tr -d '%,')

        if [[ "$STATUS" != "$OLD_STATUS" ]]; then
            $EWW_CMD update battery_status="$STATUS" battery_percent="$PERCENT"
            # Trigger Popup (2 seconds)
            $TIMEOUT_CMD battery_popup 2 2>/dev/null 1>&2 &
            break
        fi
        sleep 0.2
    done
}

udevadm monitor -us power_supply | while read -r event; do
    if echo "$event" | grep -qE "change.*BAT|change.*AC"; then
        update_battery
    fi
done
