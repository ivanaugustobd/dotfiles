_zsh-load-env-vars() {
  local ENV_FILE=~/.zsh_env
  if [ -e "$ENV_FILE" ]; then source "$ENV_FILE"; fi
}

_zsh-load-env-vars
