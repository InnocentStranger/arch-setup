local primary_monitor = {
  output = "",
  mode = "preferred",
  position = "auto",
  scale = "auto",
}

hl.monitor(primary_monitor)
hl.workspace_rule({ workspace = "10", monitor = "HDMI-A-1", default = true })
