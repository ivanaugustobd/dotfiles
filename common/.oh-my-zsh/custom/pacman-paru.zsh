# Aliases
alias p="paru"
alias p-install="paru -S --needed --noconfirm"
alias p-provides="paru -F"
alias p-reinstall="paru -S --noconfirm"
alias p-remove="sudo pacman -Rcs"

p-autoremove() {
  [ -z "$(pacman -Qqtd)" ] && echo 'No orphans found.' && return 0
  paru -Rcs $(pacman -Qqtd)
}

p-list-installed() {
  [ -z "$1" ] && pacman -Q || pacman -Q | grep "$@"
}

p-list-updates() {
  paru -Sy
  pacman -Qu
}

p-rank-mirrors() {
  ! which rankmirrors && sudo pacman -S --noconfirm pacman-contrib
  curl -s 'https://archlinux.org/mirrorlist/?country=BR&protocol=http&protocol=https&ip_version=4&use_mirror_status=on' | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n 5 - | sudo tee /etc/pacman.d/mirrorlist
}

p-search() {
  [ "$1" != '-a' ] && pacman -Ss "$@" && return 0
  shift
  paru -Ss "$@"
}

p-upgrade() {
  #sudo pacman -Sy &> /dev/null
  #sudo pacman -Fy &> /dev/null
  [ "$1" = "--noconfirm" ] && paru -Syu --noconfirm && return 0
  [ -z "$1" ] && paru -Syu || paru -Sy --needed "$@"
}
