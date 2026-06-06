-- modules/auto-start.lua

-- Reference: https://wiki.hypr.land/Configuring/Basics/Autostart/
--            https://wiki.hypr.land/Useful-Utilities/Systemd-start/
--
-- uwsm RULES:
--   • Wrap every exec with "uwsm app -- <cmd>" so apps run as systemd units,
--     not as children of the Hyprland process.
--   • Apps with native systemd user units (hypridle, hyprpolkitagent) should
--     be enabled ONCE in a terminal instead:
--       systemctl --user enable --now hyprpolkitagent.service
--       systemctl --user enable --now hypridle.service
--     Remove them from here once you've done that.
--   • hl.exec_cmd() is async — no & or disown needed.
--   • hl.on("hyprland.start") fires ONCE at boot, NOT on config reload.

hl.on("hyprland.start", function()
  -- Notification daemon
  hl.exec_cmd("uwsm app -- dunst")

  -- Shell/bar (ashell)
  hl.exec_cmd("uwsm app -- ashell")

  -- App launcher background service (walker)
  hl.exec_cmd("uwsm app -- walker --gapplication-service")

  -- Wallpaper/animation daemon (awww)
  hl.exec_cmd("uwsm app -- awww-daemon")
end)
