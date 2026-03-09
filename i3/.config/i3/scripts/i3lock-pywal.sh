#!/usr/bin/env bash

# Debug: Show if file exists and first few colors
if [ ! -f ~/.cache/wal/colors ]; then
    echo "Error: ~/.cache/wal/colors not found! Run 'wal -i your_wallpaper.jpg' first."
    exit 1
fi

mapfile -t colors < ~/.cache/wal/colors
#echo "Debug: Loaded colors (first 5 + last): ${colors[0]} ${colors[1]} ${colors[4]} ${colors[8]} ${colors[15]}"

# Use common pywal assignments (adjust indices if your scheme looks off)
bg="${colors[0]}"          # Darkest bg
fg="${colors[15]}"         # Lightest for text/clock/date
ring="${colors[4]}"        # Prominent accent for ring
keyhl="${colors[5]}"       # Keypress highlight
bshl="${colors[1]}"        # Backspace/wrong highlight
inside="${colors[8]:-${bg}}"  # Inside ring (fallback to bg)

# Strip # from all colors once (pywal includes it)
strip_hash() { echo "${1#\#}"; }

bg_hex=$(strip_hash "$bg")
fg_hex=$(strip_hash "$fg")
ring_hex=$(strip_hash "$ring")
keyhl_hex=$(strip_hash "$keyhl")
bshl_hex=$(strip_hash "$bshl")
inside_hex=$(strip_hash "$inside")

# Now append alpha only where needed (for rings/inside)
inside_rrggbbaa="${inside_hex}88"     # ~53% opacity
ring_rrggbbaa="${ring_hex}ff"         # full opacity
keyhl_rrggbbaa="${keyhl_hex}bb"
bshl_rrggbbaa="${bshl_hex}bb"

#echo "Debug: Using bg=$bg_hex, fg=$fg_hex, ring=$ring_hex, inside=$inside_hex"

# Launch with NO # prefix on ANY color option
i3lock \
  --nofork \
  --color="$bg_hex" \
  --inside-color="${inside_rrggbbaa}" \
  --ring-color="${ring_rrggbbaa}" \
  --line-color="00000000" \
  --separator-color="${ring_rrggbbaa}" \
  --insidever-color="ffffff22" \
  --ringver-color="${ring_rrggbbaa}" \
  --insidewrong-color="88000022" \
  --ringwrong-color="${bshl_rrggbbaa}" \
  --verif-color="${fg_hex}" \
  --wrong-color="${fg_hex}" \
  --time-color="${fg_hex}" \
  --date-color="${fg_hex}" \
  --layout-color="${fg_hex}" \
  --keyhl-color="${keyhl_rrggbbaa}" \
  --bshl-color="${bshl_rrggbbaa}" \
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
