-- modules/keybinds.lua
-- Reference: https://wiki.hypr.land/Configuring/Basics/Binds/
-- Reference: https://wiki.hypr.land/Configuring/Basics/Dispatchers/

local mod = "SUPER"
local programs = require("modules.programs")

-- ── Core window/session ──────────────────────────────────────────────
hl.bind(mod .. " + E", hl.dsp.exec_cmd(programs.file_manager), { desc = "Launch file manager" })
hl.bind(mod .. " + T", hl.dsp.exec_cmd(programs.terminal), { desc = "Launch terminal" })
hl.bind(mod .. " + Q", hl.dsp.window.close(), { desc = "Close active window" })
hl.bind(mod .. " + R", hl.dsp.exec_cmd(programs.app_launcher), { desc = "Open app launcher" })

-- Colour picker → clipboard (hyprpicker)
hl.bind(mod .. " + SHIFT + P", hl.dsp.exec_cmd("hyprpicker -a -n"))

-- Lock screen (only spawns hyprlock if not already running)
hl.bind(mod .. " + SHIFT + L", hl.dsp.exec_cmd("pidof hyprlock || hyprlock"))

-- Clipboard manager via walker
hl.bind(mod .. " + V", hl.dsp.exec_cmd("walker -m clipboard"))

-- uwsm: always prefer hyprshutdown; fallback is present for non-uwsm setups
hl.bind(
  mod .. " + M",
  hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'")
)

-- ── Window state ─────────────────────────────────────────────────────
hl.bind(mod .. " + SHIFT + V", hl.dsp.window.float({ action = "toggle" }), { desc = "Toggle float" })
hl.bind(
  mod .. " + F",
  hl.dsp.window.fullscreen_state({ internal = 2, client = 0, action = "toggle" }),
  { desc = "Toggle fullscreen" }
)

-- ── Focus (vim motions) ──────────────────────────────────────────────
hl.bind(mod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + J", hl.dsp.focus({ direction = "down" }))

-- ── Workspaces ───────────────────────────────────────────────────────
for i = 1, 10 do
  local key = i % 10 -- 10 → key "0"
  hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
  hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- ── Scratchpad (special workspace) ───────────────────────────────────
hl.bind(mod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- ── Mouse: move and resize ───────────────────────────────────────────
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- ── Screenshots ──────────────────────────────────────────────────────
-- Full screen → clipboard
hl.bind("Print", hl.dsp.exec_cmd("grim - | wl-copy"))

-- Region → Satty editor
hl.bind(
  "SHIFT + Print",
  hl.dsp.exec_cmd(
    [[grim -g "$(slurp)" - | satty --filename - --output-filename ~/Pictures/Screenshots/screenshot-$(date '+%Y%m%d-%H%M%S').png]]
  )
)

-- Active window → clipboard
hl.bind(
  "ALT + Print",
  hl.dsp.exec_cmd(
    [[hyprctl -j activewindow | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' | grim -g - - | wl-copy]]
  )
)

-- ── Media & hardware keys ─────────────────────────────────────────────
hl.bind(
  "XF86AudioRaiseVolume",
  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
  { locked = true, repeating = true }
)
hl.bind(
  "XF86AudioLowerVolume",
  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
  { locked = true, repeating = true }
)
hl.bind(
  "XF86AudioMute",
  hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
  { locked = true, repeating = true }
)
hl.bind(
  "XF86AudioMicMute",
  hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
  { locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
