WM: Hyprland 0.54.3 (Wayland)

# Initial Setup

## 1. Install Packages

Run the following command to install required packages:

```sh
sudo pacman -S tmux neovim-git tree-sitter-cli tar curl ripgrep nvm starship ttf-jetbrains-mono-nerd
```

---

## 2. Change Default Shell to Bash

Set your default shell to bash:

```sh
chsh -s /bin/bash
```

Only run the following if you explicitly want to change the shell for the root user as well:  
sudo chsh -s /bin/bash

---

## 3. Verify Shell

Check your current shell:  
echo $SHELL

Expected output:  
/bin/bash

---

## 4. Refresh Font Cache

Refresh the font cache after installing Nerd Fonts:  
fc-cache -fv
