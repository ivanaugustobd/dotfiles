#!/usr/bin/env bash

set -euo pipefail

workspace='10: system'
class='^btop$'

exec ~/.config/i3/scripts/focus-or-launch.sh \
  --workspace "$workspace" \
  --match class="$class" \
  -- kitty --class btop --title btop btop
