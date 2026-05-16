#!/bin/bash

# --- Helper Function ---
ask() {
    read -p "?? $1 (y/n): " choice
    [[ "$choice" == [Yy]* ]]
}


# Keybinds (Modular Scripts)
if ask "Apply all keybind scripts (Workspace, General, Custom)?"; then
    ./keybinds.sh
fi

if ask "Enable Clipboard (Copyous Gnome Extension)"; then
    chmod +x ./clipboard.sh
    ./clipboard.sh
fi

#  Walker
if ask "Install Walker & Elephant?"; then
    chmod +x ./walker-setup.sh
    ./walker-setup.sh
fi


# GNOME Tools
if ask "Install GNOME Tweaks?"; then
    sudo pacman -S gnome-tweaks
    paru -S gnome-shell-extension-copyous
fi

# (Kitty, Tmux, NVIM)
if ask "Install Kitty, Tmux, Neovim, Wl-Clipboard and GNU Stow?"; then
    sudo pacman -S kitty tmux neovim stow wl-clipboard
fi

# 9. Nerd Font (JetBrains)
if ask "Install JetBrains Mono Nerd Font?"; then
  sudo pacman -S ttf-jetbrains-mono-nerd
  echo "✅ Font installed to $FONT_DIR"
fi


# --- Stow (The Dotfiles) ---
# --- Inside setup.sh ---
if ask "Sync dotfiles using GNU Stow?"; then
    DOT_PATH="$(realpath ../dotfiles)"
    cd "$DOT_PATH" || exit
    
    echo "🔗 Linking configs..."
    
    # Force remove the existing system .bashrc so Stow can link yours
    mv ~/.bashrc ~/.bashrc-original-bak
    
    # Include 'bash' in the list of packages to stow
    stow -v -R -t ~/ --ignore='.*\.md' bash nvim tmux starship kitty
    
    cd - || exit
    echo "✅ Dotfiles linked!"
fi

# 10. Starship Prompt
if ask "Install Starship Prompt?"; then
  # curl -sS https://starship.rs/install.sh | sh -s -- -y
  sudo pacman -S starship
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
