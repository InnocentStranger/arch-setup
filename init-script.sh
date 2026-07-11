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
    # "hyprpaper"
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
    "power-profiles-daemon"
    "fwupd"
    "swayosd"
    "fprintd"
    "awww"
    "matugen"
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
[ -e "$HOME/.config" ] && mv "$HOME/.config" "$BACKUP_DIR/"
[ -e "$HOME/.bashrc" ] && mv "$HOME/.bashrc" "$BACKUP_DIR/"
[ -e "$HOME/.inputrc" ] && mv "$HOME/.inputrc" "$BACKUP_DIR/"
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
    "systemd"
    # "themes"
    "tmux"
    "uwsm"
    "walker"
    "waybar"
)
for folder in "${STOW_FOLDERS[@]}"; do
    echo "Stowing $folder..."
    stow -R -t "$HOME" "$folder"
done

# Install Rust via rustup
echo "Setting up Rust via rustup..."
rustup default stable
echo "Rust version: $(rustc --version)"
echo "Cargo version: $(cargo --version)"

echo "Enabling power management daemons..."
sudo systemctl enable --now power-profiles-daemon.service

echo "Verifying installer-provided defaults..."
pacman -Qi amd-ucode &>/dev/null &&
    echo "  [ok] amd-ucode present (microcode updates active)" ||
    echo "  [WARN] amd-ucode missing — install manually: sudo pacman -S amd-ucode"

cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_driver 2>/dev/null | grep -q amd-pstate &&
    echo "  [ok] amd-pstate driver active" ||
    echo "  [WARN] amd-pstate driver not active — check kernel params"

mkdir -p ~/Pictures/Screenshots/

sudo systemctl enable --now swayosd-libinput-backend.service
echo "Enabling and starting Wayland user services..."
systemctl --user daemon-reload
systemctl --user enable --now hyprpolkitagent.service
systemctl --user enable --now hypridle.service
# systemctl --user enable --now hyprpaper.service
systemctl --user enable --now elephant.service
systemctl --user enable --now walker.service
systemctl --user enable --now waybar.service
# Elephant & Walker run as uwsm app -- instead of systemd native service

echo "======================================================="
echo "Setup Complete!"
echo "======================================================="
