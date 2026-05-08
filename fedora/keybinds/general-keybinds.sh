#!/bin/bash

echo "⌨️  Configuring general keybinds..."

# --- 2. Window Management ---
# Close application: Super + Q
gsettings set org.gnome.desktop.wm.keybindings close "['<Super>q']"

# --- 3. Screenshots (Standard GNOME Tools) ---
# Print -> Standard Full Screenshot
gsettings set org.gnome.shell.keybindings screenshot "['Print']"

# Shift + Print -> Interactive Menu (Select area, screen, or window)
gsettings set org.gnome.shell.keybindings show-screenshot-ui "['<Shift>Print']"

# Alt + Print -> Immediate window screenshot (no menu)
gsettings set org.gnome.shell.keybindings screenshot-window "['<Alt>Print']"


echo "✅ General keybinds applied!"
