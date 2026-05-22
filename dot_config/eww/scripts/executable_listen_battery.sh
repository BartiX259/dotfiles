#!/bin/bash

update_battery() {
  OLD_STATUS="$(eww get battery_status)"

  for i in {1..10}; do
    ACPI_OUTPUT=$(acpi -b | head -n1)

    STATUS=$(echo "$ACPI_OUTPUT" | sed 's/^.*: //; s/,.*//')
    PERCENT=$(echo "$ACPI_OUTPUT" | awk -F',' '{print $2}' | tr -d ' %')

    if [[ "$STATUS" != "$OLD_STATUS" ]]; then
      echo "SET $STATUS"
      eww -c $HOME/.config/eww update battery_status="$STATUS" battery_percent="$PERCENT"
      ewwtimeout battery_popup 2 2>/dev/null 1>&2 &
      break
    fi
    sleep "0.$i"
  done
}

udevadm monitor -us power_supply | while read -r event; do
  if echo "$event" | grep -qE "change.*BAT|change.*AC"; then
    update_battery
  fi
done
