#!/bin/bash

# --- 1. Enable Repositories ---
echo "📡 Enabling COPR repositories..."
sudo dnf copr enable -y errornointernet/walker
sudo dnf copr enable -y errornointernet/packages

# --- 2. Install Walker, Elephant, and Dependencies ---
echo "🐘 Installing Walker, Elephant modules, and clipboard tools..."
# Added wl-clipboard so the clipboard module actually works
sudo dnf install -y walker elephant elephant-* wl-clipboard nmap-ncat

# --- 3. Start the Elephant Service ---
echo "🧠 Starting Elephant background service..."
systemctl --user daemon-reload
systemctl --user enable --now elephant.service

# --- 4. Setup Walker Daemon ---
echo "⚙️ Creating Walker user service for instant launch..."
mkdir -p ~/.config/systemd/user/

cat <<EOF > ~/.config/systemd/user/walker.service
[Unit]
Description=Walker Launcher Daemon
After=elephant.service

[Service]
Type=simple
# Using the service flag for instant response
ExecStart=/usr/bin/walker --gapplication-service
Restart=always
RestartSec=3

[Install]
WantedBy=default.target
EOF

systemctl --user daemon-reload
systemctl --user enable --now walker.service

echo "✅ Walker and Elephant setup complete!"
