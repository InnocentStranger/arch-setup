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
    "mako" # notification daemon
)

paru_packages=(
    "satty"
)

# Systemd Services
# pipewire
# wireplumber
# hyprpaper:  systemctl --user enable --now hyprpaper.service
# systemctl --user enable --now hyprpolkitagent.service
