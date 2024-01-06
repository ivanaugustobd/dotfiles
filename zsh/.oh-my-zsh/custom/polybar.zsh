# Aliases
alias polybar-reload="polybar-msg cmd restart"
alias polybar-live-reload="watchman watch ~/.config/polybar/ && watchman -- trigger ~/.config/polybar polybar-live-reload '*.ini' -- bash -c 'polybar-msg cmd restart'"
