# Hyprland 0.55+ Setup — CachyOS

Config is **Lua** (`~/.config/hypr/hyprland.lua`). The old hyprlang `.conf` syntax still loads but is deprecated as of 0.55 and will be removed. Migrate now.

---

## Install packages

```bash
sudo pacman -S \
  hyprland hypridle hyprlock hyprpolkitagent \
  xdg-desktop-portal-hyprland xdg-desktop-portal-gtk \
  pipewire wireplumber pipewire-pulse pipewire-alsa \
  qt5-wayland qt6-wayland \
  mako \
  waybar \                   # or: ashell
  wpaperd \
  grim slurp satty \
  obs-studio \
  walker \                   # or: vicinae (AUR)
  sddm \
  wl-clipboard cliphist \
  brightnessctl playerctl \
  ttf-jetbrains-mono-nerd    # or any nerd font you prefer
```

**AUR packages** (use `paru` or `yay`):

```bash
paru -S localsend monique wlogout hyprshutdown
```

> **PipeWire** starts automatically on CachyOS via systemd. You don't exec it.  
> **xdg-desktop-portal-hyprland** also starts automatically via systemd. If screensharing breaks, see the Troubleshooting section.

---

## File layout

```
~/.config/hypr/
  hyprland.lua       ← entry point, requires the rest
  env.lua            ← environment variables (SDDM path; skip if using uwsm)
  monitor.lua        ← monitor config
  settings.lua       ← general / decoration / animations / input
  autostart.lua      ← services started on hyprland.start
  keybinds.lua       ← all keybindings
  windowrules.lua    ← float / workspace / special rules
  hyprlock.conf      ← lock screen

~/.config/hypridle/
  hypridle.conf      ← idle timeouts

~/.config/mako/
  config             ← notification daemon

~/.config/wpaperd/
  wallpaper.toml     ← wallpaper daemon

~/.config/uwsm/     ← ONLY if launching via uwsm (see below)
  env                ← toolkit env vars
  env-hyprland       ← AQ_* / HYPR* vars
```

---

## Session launch: SDDM vs uwsm

### SDDM (simplest, recommended for most users)

Enable and start SDDM:

```bash
sudo systemctl enable --now sddm
```

At the login screen select **Hyprland**. Environment variables live in `env.lua`.

### uwsm (advanced — systemd integration, crash recovery)

```bash
# In ~/.bash_profile or ~/.zprofile — at the very bottom:
if uwsm check may-start && uwsm select; then
  exec systemd-cat -t uwsm_start uwsm start default
fi
```

When using uwsm:

- **Do not** set env vars in `env.lua`. Use `~/.config/uwsm/env` and `~/.config/uwsm/env-hyprland` instead.
- **Do not** use `hl.dsp.exit()` to quit. Use `uwsm stop` (already wired to `SUPER+CTRL+M` in keybinds).
- Enable polkit agent as a systemd unit instead of exec: `systemctl --user enable --now hyprpolkitagent.service`

---

## Multi-monitor (Monique)

Monique is a GUI for aligning monitors and generating `hl.monitor()` calls.

```bash
paru -S monique
monique   # drag monitors into position, copy the output
```

Paste the generated `hl.monitor(...)` lines into `monitor.lua`, replacing the fallback.

---

## PipeWire / audio notes

PipeWire + WirePlumber start via systemd on CachyOS — nothing to configure unless something is broken.

Check status:

```bash
systemctl --user status pipewire wireplumber
```

Restart if needed:

```bash
systemctl --user restart pipewire wireplumber
```

Volume keybinds use `wpctl` (WirePlumber control) — already in `keybinds.lua`.

---

## Keybinds (defaults)

| Key                   | Action                       |
| --------------------- | ---------------------------- |
| `SUPER + Return`      | Terminal (kitty)             |
| `SUPER + D`           | App launcher (walker)        |
| `SUPER + V`           | Clipboard history            |
| `SUPER + Q`           | Close window                 |
| `SUPER + F`           | Fullscreen                   |
| `SUPER + Space`       | Toggle float                 |
| `SUPER + S`           | Scratchpad toggle            |
| `SUPER + 1–0`         | Switch workspace             |
| `SUPER+SHIFT + 1–0`   | Move window to workspace     |
| `SUPER+CTRL + L`      | Lock (hyprlock)              |
| `SUPER+SHIFT + E`     | Power menu (wlogout)         |
| `SUPER+CTRL + M`      | Exit Hyprland / uwsm stop    |
| `Print`               | Screenshot → clipboard       |
| `SUPER+SHIFT + Print` | Area select → satty annotate |
| `SUPER+SHIFT + L`     | LocalSend                    |
| `SUPER+SHIFT + O`     | OBS Studio                   |
| `XF86Audio*`          | Volume / mute / mic          |
| `XF86Brightness*`     | Screen brightness            |

---

## Screensharing / OBS

Requires `pipewire`, `wireplumber`, and `xdg-desktop-portal-hyprland` to be running.

Test: open OBS → Add source → Screen Capture (PipeWire). A Qt picker should appear.

If it does **not** appear:

```bash
# Check portal is running
systemctl --user status xdg-desktop-portal-hyprland xdg-desktop-portal

# Force restart
systemctl --user restart xdg-desktop-portal-hyprland xdg-desktop-portal
```

If still broken, uncomment the nuclear-restart block in `autostart.lua`.

---

## Wallpapers

Put images in `~/Pictures/wallpapers/`. wpaperd picks randomly and rotates every 30 minutes (configure in `wpaperd/wallpaper.toml`).

To change wallpaper immediately:

```bash
wpaperd-remote next-wallpaper
```

---

## Idle / lock / sleep chain

`hypridle.conf` controls the chain:

| Timeout | Action            |
| ------- | ----------------- |
| 3 min   | Dim screen to 20% |
| 5 min   | Lock (hyprlock)   |
| 6 min   | Displays off      |
| 30 min  | Suspend           |

Sleep always locks first via `before_sleep_cmd = loginctl lock-session`.

---

## Troubleshooting

**Black screen after login**  
→ Check `journalctl --user -xe` and `hyprctl monitors`. If no output, GPU driver issue.

**Screensharing not working**  
→ `systemctl --user restart xdg-desktop-portal-hyprland xdg-desktop-portal`

**Qt apps look wrong / no theme**  
→ Install `qt5ct` + `qt6ct` and set a theme. Make sure `QT_QPA_PLATFORMTHEME=qt5ct` is exported.

**Cursor invisible in some apps (Nvidia)**  
→ Add `export WLR_NO_HARDWARE_CURSORS=1` to `~/.config/uwsm/env-hyprland` (or `env.lua`).

**Config error on reload**  
→ Emergency binds are always active: `SUPER+Q` (terminal), `SUPER+R` (run), `SUPER+M` (exit).

---

## References

- [Hyprland Wiki](https://wiki.hypr.land) — always the source of truth
- [0.55 release notes](https://hypr.land/news/update55/)
- [Environment variables](https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/)
- [xdg-desktop-portal-hyprland](https://wiki.hypr.land/Hypr-Ecosystem/xdg-desktop-portal-hyprland/)
- [hyprpolkitagent](https://wiki.hypr.land/Hypr-Ecosystem/hyprpolkitagent/)
