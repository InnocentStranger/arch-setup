## Application Launcher: Walker & Elephant

This setup uses [Walker](https://github.com/abenz1267/walker) as a lightning-fast, extensible Wayland application runner, backed by the Elephant daemon for system-wide search. 

It is configured to run as a background GTK4 service and triggered via a UNIX socket to eliminate startup delays.

### Dependencies
Install the following packages from the AUR and official repositories:

- `walker-bin`: The graphical GTK4 frontend.
- `elephant-all-bin`: The backend daemon and all default search providers (apps, clipboard, web, etc.).
- `openbsd-netcat`: Required for the instant socket-trigger workaround.

**Installation (Arch Linux):**
\`\`\`bash
paru -S walker-bin elephant-all-bin
sudo pacman -S openbsd-netcat
\`\`\`

### Post-Install Setup
1. **Enable the backend daemon:**
   \`\`\`bash
   elephant service enable
   systemctl --user daemon-reload
   systemctl --user enable --now elephant.service
   \`\`\`
2. **Start the frontend daemon (add to Hyprland autostart):**
   \`\`\`text
   exec-once = walker --gapplication-service
   \`\`\`
3. **Trigger Walker via socket (bind in Hyprland config):**
   \`\`\`text
   bind = $mainMod, R, exec, nc -U /run/user/1000/walker/walker.sock
   \`\`\`
