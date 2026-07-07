#!/usr/bin/env bash

set -euo pipefail

workspace=''
declare -a match_groups=()

usage() {
  cat <<'EOF'
Usage:
  focus-or-launch.sh --workspace WORKSPACE --match key=regex [key=regex ...] [--match ...] -- command [args...]

Supported match keys:
  class
  title
EOF
}

while (($#)); do
  case "$1" in
    --workspace)
      workspace="${2:-}"
      shift 2
      ;;
    --match)
      shift

      if (($# == 0)); then
        usage >&2
        exit 1
      fi

      group=''
      while (($#)); do
        case "$1" in
          --|--workspace|--match)
            break
            ;;
          class=*|title=*)
            if [[ -n "$group" ]]; then
              group+=';'
            fi
            group+="$1"
            shift
            ;;
          *)
            usage >&2
            exit 1
            ;;
        esac
      done

      if [[ -z "$group" ]]; then
        usage >&2
        exit 1
      fi

      match_groups+=("$group")
      ;;
    --)
      shift
      break
      ;;
    *)
      usage >&2
      exit 1
      ;;
  esac
done

if [[ -z "$workspace" ]] || ((${#match_groups[@]} == 0)) || (($# == 0)); then
  usage >&2
  exit 1
fi

criteria_matches=()
for group in "${match_groups[@]}"; do
  class=''
  title=''

  IFS=';' read -r -a parts <<<"$group"
  for part in "${parts[@]}"; do
    case "$part" in
      class=*)
        class="${part#class=}"
        ;;
      title=*)
        title="${part#title=}"
        ;;
    esac
  done

  jq_filter='true'
  criteria='['
  if [[ -n "$class" ]]; then
    jq_filter+=' and (.window_properties?.class? | test($class))'
    criteria+="class=\"$class\""
  fi
  if [[ -n "$title" ]]; then
    jq_filter+=' and (.name? | test($title))'
    if [[ "$criteria" != '[' ]]; then
      criteria+=' '
    fi
    criteria+="title=\"$title\""
  fi
  criteria+=']'

  if i3-msg -t get_tree | jq -e \
    --arg class "$class" \
    --arg title "$title" \
    ".. | objects | select(.window? and $jq_filter)" >/dev/null; then
    criteria_matches+=("$criteria")
  fi
done

if ((${#criteria_matches[@]} > 0)); then
  i3-msg "workspace \"$workspace\"" >/dev/null

  for criteria in "${criteria_matches[@]}"; do
    if i3-msg "$criteria focus" >/dev/null; then
      exit 0
    fi
  done
fi

i3-msg "workspace \"$workspace\"" >/dev/null
exec "$@"
