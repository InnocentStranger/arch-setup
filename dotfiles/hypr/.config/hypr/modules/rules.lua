hl.window_rule({
  match = { class = "^(com.gabm.satty)$" },
  float = true,
  size = { 1200, 800 },
})

hl.window_rule({
  match = { class = "org.gnome.Nautilus" },
  float = true,
  size = { 1100, 750 },
  rounding = 20,
})

hl.window_rule({
  match = { class = "^(zenity)$" },
  float = true,
  center = true,
  rounding = 12, -- Modern, subtle curve for a dialog box
  dim_around = true, -- Dims the background to emphasize the prompt
  pin = true, -- Keeps it on top across workspaces
  border_size = 0, -- Removes the border accent for a seamless look
})

-- Media players & Audio controls
hl.window_rule({
  match = { class = "^(pavucontrol|org.pulseaudio.pavucontrol|blueman-manager)$" },
  rounding = 12,
  float = true,
  size = { 700, 500 },
  center = true,
})
