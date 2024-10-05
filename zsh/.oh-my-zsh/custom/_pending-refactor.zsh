alias chrome-disable-history="chmod -w ~/.config/google-chrome/Default/History"
alias chrome-enable-history="chmod +w ~/.config/google-chrome/Default/History"
alias current-folder='echo ${PWD##*/}'
alias current-ip-local="current-local-ip"
alias current-local-ip="ip addr | grep 'state UP' -A2 | grep '/24' | tail -n1 | awk '{print \$2}' | sed 's/\/.*//g'"
alias external-ip='echo $(curl -s ifconfig.me)'
alias ip-external="external-ip"
alias lc='colorls -A --sd'
alias nvidia-processes="watch nvidia-smi"
alias pbcopy="wl-copy"
# alias pbcopy="xclip -sel clip"
alias pcloud-restore-conflicted="find ./ -not -iname '* (conflicted)' -exec trash-put {} \; && rename ' (conflicted)' "" *"
alias pestle="if [ ! -e ./pestle ]; then pestle-install; fi; ./pestle"
alias php-server="php -S 127.0.0.1:8000 -d display_errors=1"
alias rm="trash-put"
alias vi="vim"
alias watch-cpu-governor="watch cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor"
alias watch-gpu="nvidia-processes"
alias we="warden env"

lolban() {
  toilet -f pagga "$*" | lolcat
}

vscode() {
  code --ozone-platform-hint=x11 ~/Projects/$1
}

m2-frontools-setup() {
  [ ! -d 'vendor/snowdog/frontools' ] && echo 'Frontools not found, skipping.' && return 0
  m2-cli 'cd vendor/snowdog/frontools &&
    (rm -rf node_modules || true) &&
    yarn &&
    yarn setup
  '
}

m2-frontools-compile() {
  [ ! -d 'vendor/snowdog/frontools' ] && echo 'Frontools not found, skipping.' && return 0
  [ ! -d 'vendor/snowdog/frontools/node_modules' ] && m2-frontools-setup

  m2-cli 'cd vendor/snowdog/frontools &&
    yarn styles &&
    yarn babel &&
    yarn svg
  '
}

m2-frontools-watch() {
  [ ! -d 'vendor/snowdog/frontools' ] && echo 'Frontools not found, skipping.' && return 0
  m2-cli 'cd vendor/snowdog/frontools && yarn watch'
}
