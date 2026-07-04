-- modules/input.lua

hl.config({
  input = {
    kb_layout = "us",
    kb_variant = "",
    kb_model = "",
    kb_options = "",
    kb_rules = "",

    follow_mouse = 1,

    sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

    touchpad = {
      natural_scroll = true,
    },
  },
})

hl.config({
  misc = {
    -- Set to true to disable the random Hyprland logo / anime girl background
    disable_hyprland_logo = true,

    -- Alternatively, you can use this to enforce a default state.
    -- Setting this to 0 or 1 disables the default anime background.
    -- -1 means "random" (default).
    force_default_wallpaper = 0,
  },
})
