# SSH
alias s-config="vi ~/.ssh/config"
alias s-key-copy="cat ~/.ssh/id_rsa.pub | pbcopy"

s-forward-setup() {
  eval "$(ssh-agent -s)"
  ssh-add ~/.ssh/id_rsa
  ssh-add -L
}
