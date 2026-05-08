#!/bin/bash

# --- Helper Function ---
ask() {
    read -p "?? $1 (y/n): " choice
    [[ "$choice" == [Yy]* ]]
}

echo "------------------------------------------"
echo "   Fedora 44 Keyboard-First Master Setup  "
echo "------------------------------------------"

# 1. RPM Fusion
if ask "Install RPM Fusion?"; then
    sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
fi

# 2. Codec
if ask "Install Multimedia Codecs (libavcodec-freeworld)?"; then
  sudo dnf install -y libavcodec-freeworld
fi

# 3. Flathub
if ask "Enable Flathub?"; then
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
fi

# 4. Keybinds (Modular Scripts)
if ask "Apply all keybind scripts (Workspace, General, Custom)?"; then
    chmod +x ./keybinds/*.sh
    ./keybinds/gnome-workspace-keybinds.sh
    ./keybinds/general-keybinds.sh
    ./keybinds/custom-keybinds.sh
fi

# 5. Walker
if ask "Install Walker & Elephant?"; then
    chmod +x ./walker-setup.sh
    ./walker-setup.sh
fi


# 6 & 7. GNOME Tools
if ask "Install GNOME Extensions App & Tweaks?"; then
    sudo dnf install -y gnome-extensions-app gnome-tweaks
fi

# 8, 11, 13. DNF Apps (Kitty, Tmux, NVIM)
if ask "Install Kitty, Tmux, Neovim, and GNU Stow?"; then
    sudo dnf install -y kitty tmux neovim stow
fi

# 9. Nerd Font (JetBrains)
if ask "Install JetBrains Mono Nerd Font?"; then
    echo "📦 Downloading JetBrains Mono Nerd Font..."
    FONT_DIR="$HOME/.local/share/fonts/JetBrainsMonoNerd"
    mkdir -p "$FONT_DIR"
    # Download directly from official Nerd Fonts GitHub release
    curl -fLo "/tmp/JB.zip" https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
    unzip -o /tmp/JB.zip -d "$FONT_DIR"
    fc-cache -f
    echo "✅ Font installed to $FONT_DIR"
fi


# --- Stow (The Dotfiles) ---
# --- Inside setup.sh ---
if ask "Sync dotfiles using GNU Stow?"; then
    DOT_PATH="$(realpath ../dotfiles)"
    cd "$DOT_PATH" || exit
    
    echo "🔗 Linking configs..."
    
    # Force remove the existing system .bashrc so Stow can link yours
    rm -f ~/.bashrc
    
    # Include 'bash' in the list of packages to stow
    stow -v -R -t ~/ --ignore='.*\.md' bash nvim tmux walker starship kitty
    
    cd - || exit
    echo "✅ Dotfiles linked!"
fi

# 10. Starship Prompt
if ask "Install Starship Prompt?"; then
  curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

# 12. NVM (Node Version Manager)
if ask "Install NVM & Node 22?"; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    
    # CRITICAL: Manually load NVM into this script session so we can use it immediately
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    
    echo "🚀 Installing Node 22..."
    nvm install 22
    nvm use 22
    nvm alias default 22
fi

echo "------------------------------------------"
echo "✅ Setup Complete!"
