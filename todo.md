# TODO For hyprland Desktop Environment

- [ ] statusbar
- [ ] settings app
- [ ] osd for volume and brightness
- [ ] theming
- [ ] paru install script

## Statusbar

- power-menu
- battery
- workspaces
- time & date
- system tray
- control centre
  - network components (wifi,bluetooth)
  - volume (input,output devices)
  - mic
  - brightness
  - power profile daemon (saver/balanced/perf)

## Laptop

- fwupd (update firmware from lvfs [linux vendor firmware service])
- To set it to 90%, run:
  echo 90 | sudo tee /sys/class/power_supply/BAT0/charge_control_end_threshold
- cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_driver check flag

# If brightness doesn't work, try this, also swayosd doesn't work on external monitors

sudo usermod -aG video $USER
and reboot
