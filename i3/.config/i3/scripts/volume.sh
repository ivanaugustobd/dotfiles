#!/bin/bash

# You can call this script like this:
# $./volume.sh up
# $./volume.sh down
# $./volume.sh mute

function get_volume {
  #amixer -D pulse get Master | grep '%' | head -n 1 | cut -d '[' -f 2 | cut -d '%' -f 1
  echo "scale=0; $(wpctl get-volume @DEFAULT_AUDIO_SINK@ | cut -d' ' -f2) * 100 / 1" | bc
}

function is_mute {
  #amixer -D pulse get Master | grep '%' | grep -oE '[^ ]+$' | grep off > /dev/null
  wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -i muted > /dev/null
}

function send_notification {
  DIR=$(dirname "$0")
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
    # Set the volume on (if it was muted)
    # amixer -D pulse set Master on > /dev/null
    # Up the volume (+ 5%)
    # amixer -D pulse sset Master 5%+ > /dev/null
    if [ "$(get_volume)" -lt "100" ]; then
      pactl set-sink-volume @DEFAULT_SINK@ +5% > /dev/null
    else
      pactl set-sink-volume @DEFAULT_SINK@ 100% > /dev/null
    fi
    send_notification
    ;;
  down)
    #amixer -D pulse set Master on > /dev/null
    #amixer -D pulse sset Master 5%- > /dev/null
    pactl set-sink-volume @DEFAULT_SINK@ -5% > /dev/null
    send_notification
    ;;
  mute)
    # Toggle mute
    wpctl set-mute @DEFAULT_SINK@ toggle
    if is_mute; then
      DIR=$(dirname "$0")
      dunstify -i "audio-volume-muted-symbolic" -r 900 -t 2000 Mute
    else
      send_notification
    fi
    ;;
esac
