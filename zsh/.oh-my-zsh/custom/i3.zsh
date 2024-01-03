# Aliases
alias i3-reload="i3-msg reload"

# Functions
i3-config() {
  local CONFIG_PATH=~/.config/i3/config
  [ ! -z "$1" ] && CONFIG_PATH="${CONFIG_PATH}.d/${1}.conf"
  vim "$CONFIG_PATH"
}
