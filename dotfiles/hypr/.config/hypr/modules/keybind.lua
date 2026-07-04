local mod = "SUPER"
local programs = require("modules.programs")

-- ── Core window/session ──────────────────────────────────────────────
hl.bind(mod .. " + T", hl.dsp.exec_cmd(programs.terminal), { desc = "Launch terminal" })
hl.bind(mod .. " + Q", hl.dsp.window.close(), { desc = "Close active window" })
hl.bind(mod .. " + M", hl.dsp.exec_cmd("uwsm stop"))
hl.bind(mod .. " + R", hl.dsp.exec_cmd(programs.app_launcher), { desc = "Open app launcher" })
hl.bind(mod .. " + V", hl.dsp.exec_cmd(programs.clipboard), { desc = "Open Clipboard" })
hl.bind(mod .. " + ESCAPE", hl.dsp.exec_cmd(programs.lock_screen), { desc = "lock screen" })

-- ── motion/workspace──────────────────────────────────────────────────
hl.bind(mod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + J", hl.dsp.focus({ direction = "down" }))

for i = 1, 10 do
  local key = i % 10 -- 10 → key "0"
  hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
  hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind(
  mod .. " + F",
  hl.dsp.window.fullscreen_state({ internal = 2, client = 0, action = "toggle" }),
  { desc = "Toggle fullscreen" }
)
-- ── miscellaneous ──────────────────────────────────────────────────

-- ── screenshot ──────────────────────────────────────────────────

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
