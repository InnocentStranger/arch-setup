#!/bin/bash

# Removing Some Keybinds
echo "Remove Keybinds"
gsettings set org.gnome.shell.keybindings toggle-message-tray "['<Super>m']"
gsettings set org.gnome.desktop.wm.keybindings switch-applications "['<Alt>Tab']"

# Close Window
gsettings set org.gnome.desktop.wm.keybindings close "['<Super>q']"

# Print
echo "Print Shortcuts"
gsettings set org.gnome.shell.keybindings screenshot "['Print']"
gsettings set org.gnome.shell.keybindings screenshot-window "['<Alt>Print']"
gsettings set org.gnome.shell.keybindings show-screenshot-ui "['<Shift>Print']"

# Free Super Key
echo "Free Super Key"
gsettings set org.gnome.mutter overlay-key ''

# Workspaces
echo "Workspace keybinds"
gsettings set org.gnome.mutter workspaces-only-on-primary true

for i in {1..9}; do gsettings set org.gnome.shell.keybindings switch-to-application-$i "[]"; done

gsettings set org.gnome.mutter dynamic-workspaces false
gsettings set org.gnome.desktop.wm.preferences num-workspaces 10


for i in {1..9}; do
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-$i "['<Super>$i']"
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-$i "['<Super><Shift>$i']"
done

gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-10 "['<Super>0']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-10 "['<Super><Shift>0']"


# Custom Shortcuts

BASE_PATH="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/"
BIND_SCHEMA="org.gnome.settings-daemon.plugins.media-keys.custom-keybinding"

### Kitty
KITTY="custom_kitty"

gsettings set $BIND_SCHEMA:"$BASE_PATH$KITTY/" name "Open Kitty"
gsettings set $BIND_SCHEMA:"$BASE_PATH$KITTY/" command "kitty"
gsettings set $BIND_SCHEMA:"$BASE_PATH$KITTY/" binding "<Super>t"

### Walker
WALKER="custom_walker"
RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
WALKER_SOCK="$RUNTIME_DIR/walker/walker.sock"
gsettings set $BIND_SCHEMA:"$BASE_PATH$WALKER/" name "Walker Launcher"
gsettings set $BIND_SCHEMA:"$BASE_PATH$WALKER/" command "nc -U $WALKER_SOCK"
gsettings set $BIND_SCHEMA:"$BASE_PATH$WALKER/" binding "<Super>r"

### Add Here

## Register it using the exact same combined string
echo "Manually Added Custom Shortcuts got overriden by script"
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['$BASE_PATH$KITTY/', '$BASE_PATH$WALKER/']"
