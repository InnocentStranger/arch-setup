#!/bin/bash

echo "🚀 Setting up Copyous on CachyOS GNOME..."

# 1. Install dependencies and the extension itself
echo "📦 Installing packages..."
paru -S --needed libgda6 gsound gnome-shell-extension-copyous

# Added a quick check to make sure the ini file actually exists before trying to load it
if [ -f "copyous-config.ini" ]; then
    dconf load /org/gnome/shell/extensions/copyous/ < copyous-config.ini
    echo "✅ Custom config loaded successfully!"
else
    echo "⚠️ copyous-config.ini not found in the current directory! Skipping custom config."
fi

echo "🎉 Setup complete!"
echo "⚠️ IMPORTANT: GNOME still needs to reload to start the extension properly."
echo "⚠️ Please LOG OUT and LOG BACK IN, And then Enable Copyous From Extensions."
