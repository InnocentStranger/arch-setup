#!/bin/bash

# Configuration (Matching your install script)
BINARY_NAME="deepcool-digital-linux"
INSTALL_PATH="/usr/local/bin/$BINARY_NAME"
SERVICE_NAME="deepcool-digital.service"
UDEV_RULE_PATH="/etc/udev/rules.d/99-deepcool-digital.rules"

echo "🗑️  Starting cleanup..."

# 1. Stop and Disable the Systemd Service
echo "⚡ Stopping and disabling service..."
sudo systemctl stop $SERVICE_NAME 2>/dev/null || true
sudo systemctl disable $SERVICE_NAME 2>/dev/null || true

# 2. Remove the Systemd Service file
echo "⚙️  Removing Systemd service file..."
sudo rm -f "/etc/systemd/system/$SERVICE_NAME"
sudo systemctl daemon-reload

# 3. Remove Udev Rules
echo "🔄 Removing Udev rules..."
sudo rm -f "$UDEV_RULE_PATH"
sudo udevadm control --reload-rules
sudo udevadm trigger

# 4. Remove the Binary
echo "📂 Removing binary..."
sudo rm -f "$INSTALL_PATH"

echo "----------------------------------------------------"
echo "✨ Cleanup Complete! Your system is back to normal."
echo "----------------------------------------------------"
