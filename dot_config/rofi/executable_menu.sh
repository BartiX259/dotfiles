#!/usr/bin/env bash

# Configuration
THEME="$HOME/.config/rofi/applet.rasi"
JSON_FILE="$HOME/.config/rofi/menu.json"
# Ensure this matches your installed font name (check with: fc-list | grep Material)
ICON_FONT="Material Symbols Rounded"

# 1. DETERMINE INPUT SOURCE
if [ -p /dev/stdin ]; then
    INPUT_JSON="$(cat)"
else
    INPUT_JSON="$(cat "$JSON_FILE")"
fi
#
# 1.5 HANDLE ARGUMENTS (Jump to Submenu)
# If an argument is passed (e.g. "Power Menu"), filter the JSON
if [[ -n "$1" ]]; then
    TARGET="$1"
    
    # extract the 'submenu' of the item where 'label' matches the argument
    SUBMENU_MATCH=$(echo "$INPUT_JSON" | jq -c --arg name "$TARGET" \
        '.[] | select(.label == $name) | .submenu')

    # If a valid submenu array was found
    if [[ "$SUBMENU_MATCH" != "null" && -n "$SUBMENU_MATCH" ]]; then
        INPUT_JSON="$SUBMENU_MATCH"
        PROMPT="$TARGET"
    else
        echo "Error: Submenu '$TARGET' not found." >&2
        exit 1
    fi
fi

# 2. GENERATE MENU LIST
# We wrap the icon in a span with the specific font family
ROFI_LIST=$(echo "$INPUT_JSON" | jq -r --arg font "$ICON_FONT" \
    '.[] | "<span font_family=\"\($font)\" size=\"130%\" rise=\"-4000\">\(.icon)</span>  \(.label)"')

# 3. SHOW ROFI
# We count lines to set height dynamically
LINE_COUNT=$(echo "$ROFI_LIST" | wc -l)

# We use '-format i' to return the index (0, 1, 2) of the selection
# We use '-markup-rows' to render the span tags
CHOSEN_INDEX=$(echo "$ROFI_LIST" | withbg rofi -dmenu \
    -i \
    -markup-rows \
    -format i \
    -theme "$THEME" \
    -theme-str "listview { lines: $LINE_COUNT; }" \
    -p "System")

# Exit if nothing selected
[[ -z "$CHOSEN_INDEX" ]] && exit 0

# 4. PARSE SELECTION
# Select the object directly by index
SELECTION_JSON=$(echo "$INPUT_JSON" | jq -r ".[$CHOSEN_INDEX]")

# 5. EXECUTE LOGIC
ACTION=$(echo "$SELECTION_JSON" | jq -r '.action')
SUBMENU=$(echo "$SELECTION_JSON" | jq -c '.submenu')

if [[ "$ACTION" != "null" ]]; then
    eval "$ACTION" &
    exit 0
elif [[ "$SUBMENU" != "null" ]]; then
    echo "$SUBMENU" | "$0"
fi
