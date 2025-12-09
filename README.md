# dotfiles

Managed via [chezmoi](https://www.chezmoi.io/).

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

List of all the packages used by the config (names are for arch, might be different on other distros):

```
alacritty neovim fish waybar rofi-wayland niri nemo firefox fzf jq fd ripgrep gum imagemagick mako swww networkmanager pamixer matugen wiremix ttf-jetbrains-mono-nerd ttf-material-symbols-variable
```

AUR/compile from source:

```
eww bibata-cursor-theme-bin
```

On a laptop:

```
acpi brightnessctl
```

Extra personal packages:

```
backlight-openrc ly-openrc github-cli less unzip btop fastfetch ripdrag(aur)
```

