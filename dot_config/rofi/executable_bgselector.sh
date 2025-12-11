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

mesg="<b>enter</b>: set   <b>d</b>: delete"
if [ $num_wallpapers -gt 1 ]; then
  mesg="$mesg   <b>c</b>: clear cache"
fi

# Run Rofi with dynamic width
wall_selection=$(ls "$wall_dir" | while read -r A; do
	echo -en "$A\x00icon\x1f$cache_dir/$A\n"
done | withbg rofi \
	-dmenu \
	-kb-custom-1 "d" \
  -kb-custom-2 "c" \
  -mesg "$mesg" \
	-config "$HOME/.config/rofi/bgselector.rasi" \
	-theme-str "window { width: ${window_width}px; }")

rofi_exit_code=$?

if [ -z "$wall_selection" ]; then
    exit 1
fi

if [ "$rofi_exit_code" -eq 0 ]; then
  # Set wallpaper
	omarchy-set-wallpaper "$wall_dir/$wall_selection"
	exit 0
elif [ "$rofi_exit_code" -eq 10 ]; then
  # Delete wallpaper
  rm "$wall_dir/$wall_selection"
  rm -f "$cache_dir/$wall_selection"
  exec "$0"
elif [ "$rofi_exit_code" -eq 11 ]; then
  # Clear cache
  rm -f "$cache_dir"/*
  exec "$0"
else
	exit 1
fi

