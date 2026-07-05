#!/bin/bash
set -euo pipefail

[[ "${TRACE:-}" == "1" ]] && set -x

# 1. Update and Install Pacman Packages
echo "Installing official packages..."
arch_pacman_packages=(
    "paru"
    "stow"
    "sddm"

    # Core Utilities
    "wl-clipboard"
    "brightnessctl"
    "playerctl"
    "ttf-jetbrains-mono-nerd"
    "pipewire"
    "wireplumber"

    # Hyprland Ecosystem
    "uwsm"
    "hyprland"
    "hyprlock"
    "hypridle"
    "hyprpaper"
    "xdg-desktop-portal-hyprland"
    "xdg-desktop-portal-gtk"
    "hyprpolkitagent"
    "qt5-wayland"
    "qt6-wayland"

    # Screenshot & Notifications
    "grim"
    "slurp"
    "satty"
    "mako"

    # File Management
    "nautilus"
    "gvfs"
    "gvfs-mtp"
    "gvfs-afc"
    "file-roller"
    "sushi"
    "tumbler"
    "ffmpegthumbnailer"
    "poppler-glib"

    # Apps
    "kitty"
    "vesktop"
    "spotify-launcher"
)

sudo pacman -Syu --needed "${arch_pacman_packages[@]}" --noconfirm

# 2. Install AUR Packages
echo "Installing AUR packages..."
paru_packages=(
    "sddm-astronaut-theme"
    "walker" # Assuming walker is from AUR if not in CachyOS repos
)
paru -S --needed "${paru_packages[@]}" --noconfirm

# 3. SDDM Configuration
echo "Configuring SDDM Astronaut Theme..."
sudo mkdir -p /etc/sddm.conf.d
THEME_CONF="[Theme]
Current=sddm-astronaut-theme"
echo "$THEME_CONF" | sudo tee /etc/sddm.conf.d/theme.conf >/dev/null
sudo systemctl enable sddm.service
echo "SDDM configuration applied successfully!"

# 4. GNU Stow Dotfiles Deployment
echo "Symlinking dotfiles using GNU Stow..."
# Assuming the script is run from inside the cloned dotfiles repository
STOW_FOLDERS=(
    "bash"
    "hypr"
    "kitty"
    "mako"
    "starship"
    "systemd"
    "tmux"
    "uwsm"
    "walker"
    "waybar"
)

for folder in "${STOW_FOLDERS[@]}"; do
    echo "Stowing $folder..."
    stow -t "$HOME" "$folder"
done

# 5. Enable Systemd User Services
echo "Enabling and starting Wayland user services..."

# Reload daemon to recognize the newly stowed .config/systemd/user files
systemctl --user daemon-reload

# Enable daemons (they will start automatically when graphical-session.target is reached)
systemctl --user enable hyprpolkitagent.service
systemctl --user enable hypridle.service
systemctl --user enable hyprpaper.service
systemctl --user enable waybar.service

# Enable custom services from your tree
systemctl --user enable elephant.service
systemctl --user enable walker.service # Only if Walker is intended to run as a background daemon

echo "======================================================="
echo "Setup Complete! Your dotfiles are symlinked."
echo "Please reboot your system. At the SDDM login screen,"
echo "ensure you select the 'hyprland (uwsm-managed)' session."
echo "======================================================="
