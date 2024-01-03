# Vars
export EDITOR=vim
export ELECTRON_TRASH=gio
export PHP_CS_FIXER_IGNORE_ENV=1
export VISUAL=vim
export VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/nvidia_icd.json
#export TERM=xterm

# Load extra info from an external env file
_zsh-load-env-vars() {
  local ENV_FILE=~/.env.zsh
  if [ -e "$ENV_FILE" ]; then source "$ENV_FILE"; fi
}

_zsh-load-env-vars
