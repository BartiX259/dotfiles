# dotfiles

Managed via [chezmoi](https://www.chezmoi.io/).
Includes automatic setup for Arch and Alpine.

## Installation

Run this one-liner on a fresh machine:

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply BartiX259
```


## Features

*   **WM:** Niri
*   **Editor:** Neovim (External repo)
*   **Terminal:** Alacritty
*   **Shell:** Fish
*   **Bar:** Waybar
*   **OSD:** Eww
*   **File explorer:** Nemo
*   **Browser:** Firefox

## Dependencies

List of all the packages used by the config (for arch, names might be different on other distros):

```
alacritty neovim fish waybar rofi-wayland niri nemo firefox fzf jq fd gum imagemagick mako swww networkmanager pamixer matugen wiremix ttf-jetbrains-mono-nerd ttf-material-symbols-variable
```

On a laptop:

```
acpi brightnessctl
```
```
```

AUR/compile from source:

```
eww bibata-cursor-theme-bin
```
