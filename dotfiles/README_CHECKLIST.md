# Utility

## Must Have

- [x] hypridle
- [x] hyprlock
- [x] authentication agent - hyprpolkitagent
- [x] Notification Daemon - mako
- [x] Desktop Portal - xdg-desktop-portal-hyprland
- [x] pipewire, wireplumber
- [x] qt-wayland via packages qt5-wayland and qt6-wayland
- [x] nerd-font
- [x] statusbar like waybar
- [x] wallpaper daemon - hyprpaper and waypaper
- [x] screenshot tool - grim, slurp - for area selection, swappy/satty - for editing and annotations
- [ ] obs-studio
- [x] app launcher + clipboard - walker
- [ ] sddm
- [ ] LocalSend
- [ ] Mutli Monitor Configuration and alignment - Monique
- [ ] wlogout, hyprshutdown, uwsm stop
- [ ] fprintd

## Environment Variables

- [x] [essential-env](https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/)

## Configuration

### Essential Utils

```sh
sudo pacman -S \
  hyprland hyprlock \
  sddm \
  wl-clipboard \
  brightnessctl playerctl \
  ttf-jetbrains-mono-nerd
```

### SystemD Services

```sh
sudo pacman -S \
  xdg-desktop-portal-hyprland xdg-desktop-portal-gtk \
  pipewire wireplumber pipewire-pulse pipewire-alsa \
  qt5-wayland qt6-wayland \
  hyprpolkitagent \
  hypridle \
  hyprpaper \
  waypaper
```

```sh
systemctl --user status pipewire wireplumber xdg-desktop-portal-hyprland
systemctl --user enable --now hyprpolkitagent.service
systemctl --user enable --now hypridle.service
systemctl --user enable --now hyprpaper.service
```

### Mako

- Reload config: makoctl reload

- it run via systemd

### Walker

- dependencies

```sh
sudo pacman -S gtk4 gtk4-layer-shell cairo poppler-glib protobuf
```

```sh
yay -S walker-bin elephant-bin elephant-desktopapplications-bin elephant-clipboard-bin
elephant service enable
systemctl --user enable --now elephant.service
systemctl --user enable --now walker.service
systemctl --user enable --now waybar.service
```

- websearch, runner, clipboard, files, app-launcher
  sudo pacman -S gsimplecal // noneed

  ❯ paru -Rns walker elephant-
  elephant-bin elephant-files-bin
  elephant-clipboard-bin elephant-runner-bin
  elephant-desktopapplications-bin elephant-websearch-bin

# Screenshot

sudo pacman -S grim slurp satty wl-clipboard libnotify
mkdir -p ~/Pictures/Screenshots
