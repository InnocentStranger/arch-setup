#!/bin/bash
set -euo pipefail

[[ "${TRACE:-}" == "1" ]] && set -x

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
    "waybar"

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

    "neovim"
    "ripgrep"
    "nvm"
    "uv"
    "starship"
    "tmux"
    "tree-sitter-cli"
    "go"
    "rustup"
    "openbsd-netcat"
)

sudo pacman -Syu --needed "${arch_pacman_packages[@]}" --noconfirm
sudo -k

echo "Installing AUR packages..."
aur_packages=(
    "sddm-astronaut-theme"
    "walker-bin"
    "elephant-bin"
    "elephant-desktopapplications-bin"
    "elephant-clipboard-bin"
    "elephant-files-bin"
)

paru -S --needed "${aur_packages[@]}"

# SDDM Theme
echo "Configuring SDDM Astronaut Theme..."
sudo mkdir -p /etc/sddm.conf.d
THEME_CONF="[Theme]
Current=sddm-astronaut-theme"
echo "$THEME_CONF" | sudo tee /etc/sddm.conf.d/theme.conf >/dev/null
sudo -k
echo "SDDM configuration applied successfully!"

echo "Backing up ~/.config, ~/.bashrc, and ~/.inputrc..."
BACKUP_DIR="$HOME/.dotfiles.bak/$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Move the directories/files if they exist
[ -e "$HOME/.config" ] && mv "$HOME/.config" "$BACKUP_DIR/"
[ -e "$HOME/.bashrc" ] && mv "$HOME/.bashrc" "$BACKUP_DIR/"
[ -e "$HOME/.inputrc" ] && mv "$HOME/.inputrc" "$BACKUP_DIR/"

# Recreate a fresh .config directory for Stow
mkdir -p "$HOME/.config"
echo "Backup complete. Files moved to $BACKUP_DIR."

echo "stow dotfiles..."
cd "$(dirname "${BASH_SOURCE[0]}")/dotfiles"

STOW_FOLDERS=(
    "bash"
    # "autostart"
    "gtk"
    "hypr"
    "kitty"
    "mako"
    "nvim"
    "starship"
    # "systemd"
    "themes"
    "tmux"
    "uwsm"
    "walker"
    "waybar"
)

for folder in "${STOW_FOLDERS[@]}"; do
    echo "Stowing $folder..."
    stow -R -t "$HOME" "$folder"
done

# Install Node via nvm
echo "Installing Node.js 22 via nvm..."
source /usr/share/nvm/init-nvm.sh
nvm install 22
nvm alias default 22
nvm use 22

echo "Node version: $(node -v)"
echo "npm version: $(npm -v)"

# Install Rust via rustup
echo "Setting up Rust via rustup..."
rustup default stable

echo "Rust version: $(rustc --version)"
echo "Cargo version: $(cargo --version)"

# 5. Enable Systemd User Services
echo "Enabling and starting Wayland user services..."

systemctl --user daemon-reload

# Enable daemons
systemctl --user enable hyprpolkitagent.service
systemctl --user enable hypridle.service
systemctl --user enable hyprpaper.service
systemctl --user enable waybar.service
systemctl --user enable --now waybar.service

# Elephant & Walker run as uwsm app -- instead of systemd native service

echo "======================================================="
echo "Setup Complete!"
echo "======================================================="
