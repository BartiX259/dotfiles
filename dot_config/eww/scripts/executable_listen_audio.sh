#!/bin/bash

EWW_CMD="eww -c $HOME/.config/eww"
TIMEOUT_CMD="ewwtimeout"

get_sink_state() {
  local vol mute is_headphone
  vol=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '[0-9]+(?=%)' | head -n 1)
  mute=$(pactl get-sink-mute @DEFAULT_SINK@ | grep -q 'yes' && echo 'muted' || echo 'unmuted')
  is_headphone=$(amixer get Headphone | grep -q 'off' && echo 'no' || echo 'yes')
  echo "$vol|$mute|$is_headphone"
}

get_source_state() {
  local vol mute
  vol=$(pactl get-source-volume @DEFAULT_SOURCE@ | grep -Po '[0-9]+(?=%)' | head -n 1)
  mute=$(pactl get-source-mute @DEFAULT_SOURCE@ | grep -q 'yes' && echo 'muted' || echo 'unmuted')
  echo "$vol|$mute"
}

update_sink() {
  local vol mute is_headphone
  IFS="|" read -r vol mute is_headphone <<<"$(get_sink_state)"
  $EWW_CMD update volume=$vol speaker_mute=$mute is_headphone=$is_headphone
  # Trigger Volume Popup
  $TIMEOUT_CMD volume_popup 1 &
}

update_source() {
  local vol mute
  IFS="|" read -r vol mute <<<"$(get_source_state)"
  $EWW_CMD update mic_mute=$mute
  # Trigger Mic Popup
  $TIMEOUT_CMD mic_popup 1 &
}

# Initialize states
last_sink_state=$(get_sink_state)
last_source_state=$(get_source_state)

pactl subscribe | while read -r event; do
  if echo "$event" | grep -q "Event 'change' on sink"; then
    new_state=$(get_sink_state)
    echo $new_state
    if [ "$new_state" != "$last_sink_state" ]; then
      update_sink
      last_sink_state=$new_state
    fi
  elif echo "$event" | grep -q "Event 'change' on source"; then
    new_state=$(get_source_state)
    if [ "$new_state" != "$last_source_state" ]; then
      update_source
      last_source_state=$new_state
    fi
  fi
done
