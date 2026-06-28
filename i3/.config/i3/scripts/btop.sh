#!/usr/bin/env bash

set -euo pipefail

workspace='10: system'
class='btop'

if i3-msg -t get_tree | jq -e --arg class "$class" '
  .. | objects | select(.window_properties?.class? == $class)
' >/dev/null; then
  i3-msg "workspace \"$workspace\"; [class=\"^${class}$\"] focus" >/dev/null
else
  i3-msg "workspace \"$workspace\"" >/dev/null
  exec kitty --class "$class" --title "$class" btop
fi
