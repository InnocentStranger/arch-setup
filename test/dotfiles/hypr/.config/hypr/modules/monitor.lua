-- modules/monitor.lua

-- =======================================================================
-- MONITOR CONFIGURATION REFERENCE
-- =======================================================================
-- Omit or comment out any field in lua tables to use its default value.
--
-- output:   The port identifier (e.g., "DP-1", "HDMI-A-1").
-- mode:     Resolution@RefreshRate. Default is "preferred" (highest supported).
-- position: XxY coordinates. "0x0" is top-left. To place a 1920px monitor
--           to the right of the first, use "1920x0". Default is "auto".
-- scale:    UI scaling factor (e.g., 1 or 1.5). Default is 1.
-- disabled: Set to true to turn off the display. Default is false.
-- vrr:      Variable Refresh Rate (FreeSync). 0 = off, 1 = on, 2 = fullscreen only. Default is 0.
-- bitdepth: Color depth (e.g., 10 for wide color gamut). Default is 8.
-- =======================================================================

local primary_monitor = {
  output = "DP-3",
  mode = "1920x1080@165",
  position = "0x0",
  scale = 1,
  vrr = 1,
  bitdepth = 10,
}

local secondary_monitor = {
  output = "HDMI-A-1",
  mode = "1920x1080@100",
  position = "1920x0",
  scale = 1,
  vrr = 1,
}

hl.monitor(primary_monitor)
hl.monitor(secondary_monitor)

return {
  primary = primary_monitor.output,
  secondary = secondary_monitor.output,
}
