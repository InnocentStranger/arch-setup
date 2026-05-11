#!/bin/bash

# --- Install Walker & Elephant ---
echo "Setting up Walker & Elephant ..."

echo "Installing Walker ..."
paru -S walker
echo "Installing Elephant..."
paru -S elephant
echo "Installing Elephant Providers..."
paru -S elephant-desktopapplications elephant-files

# ---  Start the Elephant Service ---
echo "🧠 Starting Elephant background service..."
systemctl --user daemon-reload
systemctl --user enable --now elephant.service

# --- Setup Walker Daemon ---
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
