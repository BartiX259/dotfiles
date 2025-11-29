#!/bin/sh
eww update time="$(date '+%A %d.%m %H:%M')"
~/.config/eww/scripts/ewwtimeout.sh time_popup $1
