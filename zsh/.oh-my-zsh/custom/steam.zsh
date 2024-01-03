# Vars
export STEAM_COMPAT_DATA_PATH=~/.var/app/com.valvesoftware.Steam/data/Steam/steamapps/compatdata/
export STEAM_GAME_ID_SHIN_MEGAMI_TENSEI_III="1413480"
export STEAM_GAME_ID_TALES_OF_BERSERIA="429660"

# Aliases
alias steam-missing-libs="cd ~/.var/app/com.valvesoftware.Steam/.local/share/Steam/ubuntu12_64/ && file * | grep ELF | cut -d: -f1 | LD_LIBRARY_PATH=. xargs ldd | grep 'not found' | sort | uniq; cd - > /dev/null"

# Functions
steam-desktop-shortcuts-to-app-menu() {
  STEAM_PATH=~/.var/app/com.valvesoftware.Steam
  [ ! -d "$STEAM_PATH" ] && echo 'Flatpak Steam not found' && exit 1

  # Copy the icon files
  USER_ICONS_PATH=~/.local/share/icons
  mkdir -p "$USER_ICONS_PATH"
  rsync -a "$STEAM_PATH"/data/icons/* "$USER_ICONS_PATH"

  # Copy the desktop entries from flatpak to user apps directory
  USER_APPS_STEAM=~/.local/share/applications/steam-flatpak
  [ -d "$USER_APPS_STEAM" ] && trash-put "$USER_APPS_STEAM"
  mkdir -p "$USER_APPS_STEAM"
  for DESKTOP_ENTRY in "$STEAM_PATH"/Desktop/*; do
    cp "$DESKTOP_ENTRY" "$USER_APPS_STEAM"
  done

  # Replace the executable with the flatpak steam one
  for DESKTOP_ENTRY in "$USER_APPS_STEAM"/*; do
    sed -i 's/Exec=steam/Exec=\/usr\/bin\/flatpak run --branch=stable --arch=x86_64 --command=\/app\/bin\/steam-wrapper --file-forwarding com.valvesoftware.Steam/' "$DESKTOP_ENTRY"
  done

  update-desktop-database ~/.local/share/applications
}
