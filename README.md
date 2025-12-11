# dotfiles

Managed via [chezmoi](https://www.chezmoi.io/).

## Installation

Run this one-liner on a fresh machine:

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply BartiX259
```

Or install chezmoi with a package manager and run

```bash
chezmoi init --apply BartiX259
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
alacritty neovim fish waybar rofi-wayland niri nemo firefox fzf jq fd ripgrep gum imagemagick mako swww networkmanager pamixer matugen wiremix xdg-utils wl-clipboard ttf-jetbrains-mono-nerd ttf-material-symbols-variable
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
backlight-openrc ly-openrc artix-archlinux-support github-cli less unzip btop fastfetch ripdrag(aur)
```

## Installation notes

- Must add `$HOME/.local/bin` to `PATH`, for example by making `/etc/profile.d/localbin.sh`

```bash
[ -d $HOME/.local/bin ] && PATH="$PATH:$HOME/.local/bin"
export PATH
```

- Must run `matugen` once, for example `matugen color hex 888888`

- Must have `pulseaudio` running for waybar not to crash

- Might have to change `/usr/share/wayland-sessions/niri.desktop` to use `Exec=dbus-run-session niri --session` for niri to work

- Some recommended `/etc/pacman.conf` options:

```bash
Color
ILoveCandy
ParallelDownloads = 5
```

For artix, enable extra repo:

```bash
# artix-archlinux-support must be installed
[extra]
Include = /etc/pacman.d/mirrorlist-arch
```


