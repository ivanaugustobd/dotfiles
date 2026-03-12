#!/usr/bin/env bash

if [ ! -f ~/.cache/wal/colors ]; then
    echo "Error: ~/.cache/wal/colors not found! Run 'wal -i your_wallpaper.jpg' first."
    exit 1
fi

mapfile -t colors < ~/.cache/wal/colors

# Use common pywal assignments (adjust indices if your scheme looks off)
background_base_color="${colors[0]}"                       # Darkest background
foreground_text_color="${colors[15]}"                     # Light text (clock/date/status)
idle_ring_base_color="${colors[3]}"                    # Idle ring accent
keypress_highlight_base_color="${colors[4]}"           # Keypress highlight accent
verifying_ring_base_color="${colors[6]}"               # Verifying state ring accent
wrong_state_base_color="${colors[2]}"                  # Wrong/backspace accent
backspace_highlight_base_color="$wrong_state_base_color"
inside_indicator_base_color="${colors[8]:-${background_base_color}}"  # Inside fill
line_transparent_color="00000000"

# Strip # from all colors once (pywal includes it)
strip_hash() { echo "${1#\#}"; }

background_base_hex=$(strip_hash "$background_base_color")
foreground_text_hex=$(strip_hash "$foreground_text_color")
idle_ring_hex=$(strip_hash "$idle_ring_base_color")
keypress_highlight_hex=$(strip_hash "$keypress_highlight_base_color")
verifying_ring_hex=$(strip_hash "$verifying_ring_base_color")
wrong_state_hex=$(strip_hash "$wrong_state_base_color")
backspace_highlight_hex=$(strip_hash "$backspace_highlight_base_color")
inside_indicator_hex=$(strip_hash "$inside_indicator_base_color")

# Now append alpha only where needed (for rings/inside)
inside_indicator_color="${inside_indicator_hex}88"     # ~53% opacity
idle_ring_color="${idle_ring_hex}"
keypress_highlight_color="${keypress_highlight_hex}"
verifying_ring_color="${verifying_ring_hex}"
wrong_state_color="${wrong_state_hex}"
inside_verifying_color="${verifying_ring_hex}22"
inside_wrong_color="${wrong_state_hex}22"
backspace_highlight_color="${backspace_highlight_hex}bb"

# Launch with NO # prefix on ANY color option
i3lock \
  --nofork \
  --color="$background_base_hex" \
  --inside-color="${inside_indicator_color}" \
  --ring-color="${idle_ring_color}" \
  --line-color="${line_transparent_color}" \
  --separator-color="${idle_ring_color}" \
  --insidever-color="${inside_verifying_color}" \
  --ringver-color="${verifying_ring_color}" \
  --insidewrong-color="${inside_wrong_color}" \
  --ringwrong-color="${wrong_state_color}" \
  --verif-color="${foreground_text_hex}" \
  --wrong-color="${wrong_state_color}" \
  --time-color="${foreground_text_hex}" \
  --date-color="${foreground_text_hex}" \
  --layout-color="${foreground_text_hex}" \
  --keyhl-color="${keypress_highlight_color}" \
  --bshl-color="${backspace_highlight_color}" \
  --blur 5 \
  --clock \
  --indicator \
  --radius=120 \
  --ring-width=8 \
  --date-str="%a, %d %b" \
  --time-str="%H:%M" \
  --noinput-text="" \
  --wrong-text="Get Out!" \
  --verif-text="Verifying..."
