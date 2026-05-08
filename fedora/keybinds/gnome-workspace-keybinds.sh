#!/bin/bash

echo "🖥️ Setting workspaces to primary monitor only..."
gsettings set org.gnome.mutter workspaces-only-on-primary true

echo "⌨️ Configuring 10 static workspaces and shortcuts..."
for i in {1..9}; do gsettings set org.gnome.shell.keybindings switch-to-application-$i "[]"; done

gsettings set org.gnome.mutter dynamic-workspaces false
gsettings set org.gnome.desktop.wm.preferences num-workspaces 10


for i in {1..9}; do
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-$i "['<Super>$i']"
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-$i "['<Super><Shift>$i']"
done

gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-10 "['<Super>0']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-10 "['<Super><Shift>0']"

echo "✅ Workspace keybinds applied!"

