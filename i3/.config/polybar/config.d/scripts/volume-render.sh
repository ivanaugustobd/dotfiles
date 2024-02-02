#!/bin/bash
# shellcheck disable=SC2016

NODE_TYPE="$1"
case "$NODE_TYPE" in
  input) DEVICE_PATTERN=source ;;
  output) DEVICE_PATTERN=sink ;;
esac

# shellcheck source=/home/codeslicer/.cache/wal/colors.sh
[ -e ~/.cache/wal/colors.sh ] && source ~/.cache/wal/colors.sh
ICON_COLOR="${color1:-#bd93f9}"

is_muted() {
  pulseaudio-control \
    --node-type "$NODE_TYPE" \
    --format '${IS_MUTED}' \
    output | grep -i yes > /dev/null
}

render() {
  local FORMAT
  is_muted && FORMAT="%{F$ICON_COLOR}\$NODE_NICKNAME%{F-} %{F#707880}\${VOL_LEVEL}%%{F-}" ||
    FORMAT="%{F$ICON_COLOR}\$NODE_NICKNAME%{F-} \${VOL_LEVEL}%"

  pulseaudio-control \
    --node-type "$NODE_TYPE" \
    --format "$FORMAT" \
    --node-nickname "alsa_input.usb-C-Media_Electronics_Inc._USB_PnP_Sound_Device-00.analog-mono: " \
    --node-nickname "alsa_input.usb-046d_HD_Pro_Webcam_C920_9BC59F2F-02.analog-stereo: 󰖠" \
    --node-nickname "alsa_output.*.analog-stereo: 󰓃" \
    --node-nickname "alsa_output.*.hdmi-stereo*: 󰽟" \
    --node-nickname "bluez_output.*: 󰋋" \
    output
}

# initial state
render

# listen for changes
pactl subscribe 2> /dev/null | grep --line-buffered -e "on \(card\|$DEVICE_PATTERN\|server\)" | {
  while read -r; do render; done
}
