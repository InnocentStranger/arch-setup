#!/bin/bash

echo "⌨️  Configuring Custom Shortcuts ..."

# 1. Define Schemas
# Parent schema for the "Guest List"
LIST_SCHEMA="org.gnome.settings-daemon.plugins.media-keys"
# Relocatable schema for the individual shortcuts
BIND_SCHEMA="org.gnome.settings-daemon.plugins.media-keys.custom-keybinding"

# 2. Define Unique Paths
KITTY_PATH="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
WALKER_LAUNCHER_PATH="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
WALKER_CLIPBOARD_PATH="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"

# 3. Environment for Walker Socket (for speed)
RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
WALKER_SOCK="$RUNTIME_DIR/walker/walker.sock"

# 4. Tell GNOME the "Guest List" (Crucial: Added the key 'custom-keybindings')
gsettings set $LIST_SCHEMA custom-keybindings "['$KITTY_PATH', '$WALKER_LAUNCHER_PATH', '$WALKER_CLIPBOARD_PATH']"

# 5. Configure Kitty (custom0)
gsettings set $BIND_SCHEMA:$KITTY_PATH name "Open Kitty"
gsettings set $BIND_SCHEMA:$KITTY_PATH command "kitty"
gsettings set $BIND_SCHEMA:$KITTY_PATH binding "<Super>t"

# 6. Configure Walker Launcher (custom1)
# Using nc -U is the fastest way to trigger the Walker daemon
gsettings set $BIND_SCHEMA:$WALKER_LAUNCHER_PATH name "Walker Launcher"
gsettings set $BIND_SCHEMA:$WALKER_LAUNCHER_PATH command "nc -U $WALKER_SOCK"
gsettings set $BIND_SCHEMA:$WALKER_LAUNCHER_PATH binding "<Super>r"

# 7. Configure Walker Clipboard (custom2)
gsettings set $BIND_SCHEMA:$WALKER_CLIPBOARD_PATH name "Walker Clipboard"
gsettings set $BIND_SCHEMA:$WALKER_CLIPBOARD_PATH command "walker -m clipboard"
gsettings set $BIND_SCHEMA:$WALKER_CLIPBOARD_PATH binding "<Super>v"

echo "✅ Custom keybinds applied!"
echo "💡 Tip: Make sure 'nmap-ncat' is installed for the <Super>r shortcut to work."
