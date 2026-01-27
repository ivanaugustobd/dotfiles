# ssh
alias s-config="vi ~/.ssh/config"
alias s-key-copy="cat ~/.ssh/id_rsa.pub | pbcopy"

s() {
  if t status | grep stopped 1> /dev/null; then
    t up
  fi

  ssh $@

  if ! ps aux | grep '[s]sh ' 1> /dev/null; then
    t down
  fi
}

compdef s=ssh

s-forward-setup() {
  eval "$(ssh-agent -s)"
  ssh-add ~/.ssh/id_rsa
  ssh-add -L
}
