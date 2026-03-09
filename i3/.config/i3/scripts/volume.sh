#!/bin/bash

# You can call this script like this:
# $./volume.sh up
# $./volume.sh down
# $./volume.sh mute

for required_cmd in wpctl dunstify; do
  if ! command -v "$required_cmd" >/dev/null 2>&1; then
    echo "Error: required command '$required_cmd' not found" >&2
    exit 127
  fi
done

function get_volume {
  wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{ printf "%d\n", $2 * 100 }'
}

function is_mute {
  wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q '\[MUTED\]'
}

function show_current_volume {
  volume=$(get_volume)
  # Make the bar with the special character ─ (it's not dash -)
  # https://en.wikipedia.org/wiki/Box-drawing_character
  #bar=$(seq -s "─" $(($volume/5)) | sed 's/[0-9]//g')
  if [ "$volume" -eq "0" ]; then
    icon_name="audio-volume-muted-symbolic"
    dunstify -i "$icon_name" -r 900 -t 2000 Muted
    exit 0
  else
    if [ "$volume" -lt "30" ]; then
      icon_name="audio-volume-low-symbolic"
    else
      if [ "$volume" -lt "70" ]; then
        icon_name="audio-volume-medium-symbolic"
      else
        icon_name="audio-volume-high-symbolic"
      fi
    fi
  fi

  # Send the notification
  dunstify -i "$icon_name" -r 900 -t 2000 -h int:value:"$volume" Volume
}

case $1 in
  up)
    wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+ > /dev/null
    show_current_volume
    ;;
  down)
    wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- > /dev/null
    show_current_volume
    ;;
  mute)
    # Toggle mute
    wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    if is_mute; then
      dunstify -i "audio-volume-muted-symbolic" -r 900 -t 2000 Mute
    else
      show_current_volume
    fi
    ;;
  *)
    echo "Usage: $0 {up|down|mute}" >&2
    exit 2
    ;;
esac
