# ssh
alias s-key-copy="cat ~/.ssh/id_rsa.pub | xclip -sel clip"

s() {
  if t status | grep stopped 1> /dev/null; then
    t up
  fi

  ssh "$@"

  if ! ps aux | grep '[s]sh ' 1> /dev/null; then
    t down
  fi
}

compdef s=ssh

s-forward-setup() {
  local SSH_KEY="${1:-~/.ssh/id_rsa}"

  eval "$(ssh-agent -s)"
  ssh-add "$SSH_KEY"
  ssh-add -L
}
