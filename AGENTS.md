# Instructions for AI Agents

## Overview
This repository is a collection of dotfiles for customizing a Linux desktop environment. Configurations are version-controlled via git and deployed to the system using GNU stow for symlink management. The project is organized into two main groups: **i3** (desktop environment and appearance) and **common** (general utilities).

## Key Components

### `i3/` Group - Desktop Environment & Appearance
This group manages the visual and functional aspects of the desktop:
- **xorg**: HiDPI configuration for 4K monitors (2x scale)
- **i3**: Tiling window manager configuration with workspaces and keybindings
- **picom**: Compositor for visual effects and rendering
- **polybar**: Status bar and workspace switcher
- **rofi**: Application launcher
- **pywal**: Dynamic color scheme generator (pywal16 fork) based on wallpaper; used with `wal -i` for wallpaper management

### `common/` Group - General Utilities
This group contains configurations for cross-desktop utilities:
- **kitty**: Terminal emulator (default terminal for the system)
- **oh-my-zsh**: Shell customizations, functions, and aliases
- **nvim**: Neovim editor configuration with lazy.nvim and catppuccin theme
- **btop**: TUI process manager configuration
- **flameshot**: Screenshot tool configuration
- **shellcheck**: Global linting rules for shell scripts

## i3 Window Manager & Desktop Environment

### Main Configuration
- `i3/.config/i3/config`: Main i3 configuration with workspace definitions, keybindings, and modular includes
  - Uses variables for workspace names and key bindings
  - Includes additional configs from `i3/.config/i3/config.d/*.conf`
- `i3/.config/i3/scripts/`: Custom scripts for extended functionality
  - `volume.sh`: Handles volume changes and sends desktop notifications via `dunstify`
  - `i3lock-pywal.sh`: Locks screen with colors derived from pywal color scheme

### Desktop Appearance & Integration
- **xorg**: HiDPI settings for 4K display at 2x scaling
- **picom**: Compositor configuration
- **polybar**: Status bar and workspace indicator
- **rofi**: Application launcher (triggered with `$mod+a`)
- **pywal**: Dynamic color scheme based on wallpaper; ensures consistent colors across all components (i3, picom, polybar, rofi, and other pywal-aware applications)

## Workflow & Development

### Making Changes
1. Edit configuration files in the repository
2. Use `stow <component>` to deploy changes to your system
3. Commit changes to git with clear commit messages
4. Configuration is automatically available on the system via symlinks

### Pywal Integration
Certain configuration files are pywal templates that receive dynamic colors based on your wallpaper. These templates are stored in `i3/.config/wal/templates/` and are prefixed with `colors-` (e.g., `colors-dunst.conf`, `colors-rofi.conf`, `colors-flameshot.conf`). Use `wal -i <wallpaper>` to set a wallpaper and regenerate color schemes across all components.

### Color Scheme
The system color scheme is powered by **pywal16** (a fork of pywal that generates a full **16-color palette**, i.e., `color0`–`color15`). Colors are derived from the current wallpaper and written to cache files at `~/.cache/wal/`.

#### Retrieving the Current Color Palette
When you need to know the active colors (e.g., to style a new component or template), read the generated files directly:

- **JSON (all formats)**: `~/.cache/wal/colors.json` — contains `colors`, `special` (background, foreground, cursor), and `wallpaper` keys.
- **Shell variables**: `~/.cache/wal/colors.sh` — sourceable file exporting `$color0`–`$color15`, `$background`, `$foreground`, `$cursor`, and `$wallpaper`.
- **CSS variables**: `~/.cache/wal/colors.css`
- **Hex list**: `~/.cache/wal/colors` — one hex color per line (`color0`–`color15`).

To quickly print the current palette in a terminal:
```sh
# via xrdb (reads from the X resource database, which pywal populates):
xrdb -query | grep -iE '^\*\.color([0-9]|1[0-5]):'
# or from the cache files directly:
cat ~/.cache/wal/colors.json
# or, for just the 16 hex values:
cat ~/.cache/wal/colors
```

#### Creating New Pywal Templates
To make a new config file receive pywal colors automatically, create a template in `i3/.config/wal/templates/` named `colors-<component>.conf` (or the appropriate extension). Use the `{color0}`–`{color15}`, `{background}`, `{foreground}`, and `{cursor}` placeholders. After running `wal -i <wallpaper>`, the rendered output is written to `~/.cache/wal/colors-<component>.conf` and can be sourced or included by the target application.

## References
- See `README.md` for a visual overview.
- Key configs: `i3/.config/i3/config`, `common/.config/nvim/init.lua`, `common/.shellcheckrc`
- Scripts: `i3/.config/i3/scripts/`

---

> Update this file if you add new major components, scripts, or change keybindings.
