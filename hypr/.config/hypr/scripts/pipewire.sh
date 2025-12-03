#!/bin/bash

# PipeWire control script for Waybar (modern wpctl output compatible)

get_default_sink() {
  wpctl status | awk '/\*.*Audio Sink/ {print $2}' | tr -d '.'
}

get_default_source() {
  wpctl status | awk '/\*.*Audio Source/ {print $2}' | tr -d '.'
}

get_all_sinks() {
  wpctl status | awk '/Audio Sink/ {print $2}' | tr -d '.'
}

SINK=$(get_default_sink)
SOURCE=$(get_default_source)

case "$1" in
  up)
    wpctl set-volume "$SINK" 5%+
    ;;
  down)
    wpctl set-volume "$SINK" 5%-
    ;;
  mute)
    wpctl set-mute "$SINK" toggle
    ;;
  micmute)
    wpctl set-mute "$SOURCE" toggle
    ;;
  toggle-sink)
    SINKS=($(get_all_sinks))
    COUNT=${#SINKS[@]}

    for i in "${!SINKS[@]}"; do
      if [[ "${SINKS[$i]}" == "$SINK" ]]; then
        NEXT=$(( (i + 1) % COUNT ))
        wpctl set-default "${SINKS[$NEXT]}"
        exit 0
      fi
    done
    ;;
  get)
    VOL=$(wpctl get-volume "$SINK" | awk '{print int($2 * 100)}')
    MUTE=$(wpctl get-volume "$SINK" | grep -o "MUTED")

    if [[ $MUTE == "MUTED" ]]; then
      ICON=""
    elif (( VOL < 33 )); then
      ICON=""
    elif (( VOL < 66 )); then
      ICON=""
    else
      ICON=""
    fi

    echo "{\"text\": \"$ICON $VOL%\"}"
    ;;
  *)
    echo "Usage: $0 {up|down|mute|micmute|toggle-sink|get}"
    exit 1
    ;;
esac
