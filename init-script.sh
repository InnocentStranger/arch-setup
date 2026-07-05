#!/bin/bash
set -euo pipefail

[[ "${TRACE:-}" == "1" ]] && set -x

arch_pacman_packages=(
    # login
    "sddm"

    # core-system-packges
    "wl-clipboard"
    "brightnessctl"
    "playerctl"
    "ttf-jetbrains-mono-nerd"
    "pipewire"
    "wireplumber"

    # hyprland
    "uwsm"    # for uwsm
    "libnewt" # for uwsm
    "hyprland"
    "hyprlock"
    "hypridle"
    "hyprpaper"
    "xdg-desktop-portal-hyprland" # don't know exact usecase
    "xdg-desktop-portal-gtk"
    "hyprpolkitagent"
    # must haves qt5-wayland and qt6-wayland.
    "qt5-wayland"
    "qt6-wayland"
    "waypaper" # wallpaper ui
    # Screenshot Utils
    "grim"
    "slurp"
    "satty"
    "mako" # notification daemon

    # file-manager
    "nautilus"
    "gvfs"
    "gvfs-mtp"
    "gvfs-afc"
    "file-roller"
    "sushi"
    "tumbler"
    "ffmpegthumbnailer"
    "poppler-glib"

    "kitty"
)

paru_packages=(
)

# Systemd Services
# pipewire
# wireplumber
# hyprpaper:  systemctl --user enable --now hyprpaper.service
# systemctl --user enable --now hyprpolkitagent.service
