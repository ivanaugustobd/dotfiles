# Vars
export EDITOR=vim
export VISUAL=vim
#export TERM=xterm

# Load extra info from an external env file
_zsh-load-env-vars() {
  local ENV_FILE=~/.env.zsh
  if [ -e "$ENV_FILE" ]; then source "$ENV_FILE"; fi
}

_zsh-load-env-vars
