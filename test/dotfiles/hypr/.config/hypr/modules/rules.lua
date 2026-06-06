-- modules/rules.lua
-- References:
--   https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
--   https://wiki.hypr.land/Configuring/Basics/Window-Rules/

local monitor = require("modules.monitor")

-- ── Workspace rules ───────────────────────────────────────────────────
-- Pin workspace 10 to secondary monitor as default
hl.workspace_rule({ workspace = "10", monitor = monitor.secondary, default = true })

hl.workspace_rule({ workspace = "w[tv1]s[false]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]s[false]", gaps_out = 0, gaps_in = 0 })
hl.window_rule({ match = { float = false, workspace = "w[tv1]s[false]" }, border_size = 0 })
hl.window_rule({ match = { float = false, workspace = "w[tv1]s[false]" }, rounding = 0 })
hl.window_rule({ match = { float = false, workspace = "f[1]s[false]" }, border_size = 0 })
hl.window_rule({ match = { float = false, workspace = "f[1]s[false]" }, rounding = 0 })

-- test
hl.workspace_rule({ workspace = "9", layout = "scrolling" })
