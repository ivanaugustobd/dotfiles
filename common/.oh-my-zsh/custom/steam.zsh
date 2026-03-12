# Vars
export STEAM_COMPAT_DATA_PATH=~/.var/app/com.valvesoftware.Steam/data/Steam/steamapps/compatdata/

# Aliases
alias steam-missing-libs="cd ~/.var/app/com.valvesoftware.Steam/.local/share/Steam/ubuntu12_64/ && file * | grep ELF | cut -d: -f1 | LD_LIBRARY_PATH=. xargs ldd | grep 'not found' | sort | uniq; cd - > /dev/null"

# Functions
steam-desktop-shortcuts-to-app-menu() {
  local STEAM_PATH=~/.var/app/com.valvesoftware.Steam
  local USER_ICONS_PATH=~/.local/share/icons
  local USER_APPS_STEAM=~/.local/share/applications/steam-flatpak

  [ ! -d "$STEAM_PATH" ] && echo 'Flatpak Steam not found' && exit 1

  mkdir -p "$USER_ICONS_PATH"
  rsync -a "$STEAM_PATH"/data/icons/* "$USER_ICONS_PATH"

  [ -d "$USER_APPS_STEAM" ] && trash-put "$USER_APPS_STEAM"
  mkdir -p "$USER_APPS_STEAM"
  for DESKTOP_ENTRY in "$STEAM_PATH"/Desktop/*; do
    cp "$DESKTOP_ENTRY" "$USER_APPS_STEAM"
  done

  for DESKTOP_ENTRY in "$USER_APPS_STEAM"/*; do
    sed -i 's/Exec=steam/Exec=\/usr\/bin\/flatpak run --branch=stable --arch=x86_64 --command=\/app\/bin\/steam-wrapper --file-forwarding com.valvesoftware.Steam/' "$DESKTOP_ENTRY"
  done

  update-desktop-database ~/.local/share/applications
}
