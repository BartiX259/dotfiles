export SHELL=/bin/bash

EWW_CMD="eww -c $HOME/.config/eww"
TIMEOUT_CMD="ewwtimeout"

update_battery() {
  OLD_STATUS="$(eww get battery_status)"

  for _ in {1..10}; do
    ACPI_OUTPUT=$(acpi -b | head -n1)

    STATUS=$(echo "$ACPI_OUTPUT" | sed 's/^.*: //; s/,.*//')
    PERCENT=$(echo "$ACPI_OUTPUT" | awk -F',' '{print $2}' | tr -d ' %')

    if [[ "$STATUS" == "Not charging" ]]; then
      STATUS="Full"
    fi

    if [[ "$STATUS" != "$OLD_STATUS" ]]; then
      echo "SET $STATUS"
      $EWW_CMD update battery_status="$STATUS" battery_percent="$PERCENT"
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
