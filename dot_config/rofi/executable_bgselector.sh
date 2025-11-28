#!/usr/bin/env bash

wall_dir="$HOME/Wallpapers"
cache_dir="$HOME/.cache/bgselector"

mkdir -p "$wall_dir"
mkdir -p "$cache_dir"

# Generate thumbnails
find "$wall_dir" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) | while read -r imagen; do
	filename="$(basename "$imagen")"
	thumb="$cache_dir/$filename"
	if [ ! -f "$thumb" ]; then
		magick convert -strip "$imagen" -thumbnail x540^ -gravity center -extent 262x540 "$thumb"
	fi
done

# Count wallpapers and compute window width (max 7 * 230px)
num_wallpapers=$(find "$wall_dir" -maxdepth 1 -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) | wc -l)
max_columns=7
if [ "$num_wallpapers" -gt "$max_columns" ]; then
	num_wallpapers=$max_columns
fi
window_width=$(( num_wallpapers * 230 ))

# Run Rofi with dynamic width
wall_selection=$(ls "$wall_dir" | while read -r A; do
	echo -en "$A\x00icon\x1f$cache_dir/$A\n"
done | withbg rofi \
	-dmenu \
	-config "$HOME/.config/rofi/bgselector.rasi" \
	-theme-str "window { width: ${window_width}px; }")

# Set wallpaper and update waybar color
if [ -n "$wall_selection" ]; then
	omarchy-set-wallpaper "$wall_dir/$wall_selection"
	exit 0
else
	exit 1
fi

