#!/bin/bash
set -euo pipefail

[[ "${TRACE:-}" == "1" ]] && set -x

arch_pacman_packages=(
    "paru"
    "stow"
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
    "vesktop"
    "spotify-launcher"
)

paru_packages=(
    "sddm-astronaut-theme"
)

# Sddm Theme

echo "Configuring SDDM Astronaut Theme..."
sudo mkdir -p /etc/sddm.conf.d
THEME_CONF="[Theme]
Current=sddm-astronaut-theme"
echo "$THEME_CONF" | sudo tee /etc/sddm.conf.d/theme.conf >/dev/null
echo "SDDM configuration applied successfully!"

# Systemd Services
# pipewire
# wireplumber
# hyprpaper:  systemctl --user enable --now hyprpaper.service
# systemctl --user enable --now hyprpolkitagent.service
