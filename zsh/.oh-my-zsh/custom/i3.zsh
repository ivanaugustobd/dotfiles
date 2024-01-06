# Aliases
alias i3-reload="i3-msg reload"
alias i3-live-reload="watchman watch ~/.config/i3/ && watchman -- trigger ~/.config/i3/ i3-live-reload 'config' -- i3-msg 'restart'; watchman watch ~/.config/i3/config.d/ && watchman -- trigger ~/.config/i3/config.d/ i3-live-reload-configd '*.conf' -- i3-msg 'restart'"

# Functions
i3-config() {
  local CONFIG_PATH=~/.config/i3/config
  [ ! -z "$1" ] && CONFIG_PATH="${CONFIG_PATH}.d/${1}.conf"
  vim "$CONFIG_PATH"
}
