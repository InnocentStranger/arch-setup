-- ==============================================================================
-- BATTERY-OPTIMIZED DECORATION & ANIMATION CONFIG
-- ==============================================================================

hl.config({
  general = {
    border_size = 5,
    col = {
      -- Simple static color (Battery efficient)
      active_border = "rgba(89b4faee)",
      inactive_border = "rgba(45475aee)",
    },
  },
  decoration = {
    rounding = 16,
    rounding_power = 2,

    active_opacity = 1.0,
    inactive_opacity = 1.0,

    shadow = {
      enabled = false, -- DISABLED: Removes rendering overhead for window shadows
    },

    blur = {
      enabled = false, -- DISABLED: Blur is the highest GPU tax in Hyprland
    },
  },

  animations = {
    enabled = true, -- We keep animations on, but optimize their execution below
  },
})
-- ==============================================================================
-- CURVES
-- Using purely 'bezier' math for battery efficiency.
-- 'snappy' replaces the slow ease-out to remove the "hanging" feeling at the end.
-- ==============================================================================
hl.curve("snappy", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })

-- ==============================================================================
-- ANIMATIONS
-- Speeds reduced to 1.5 (150ms) and 1.0 (100ms) for instant feedback.
-- ==============================================================================

-- Base global fallback
hl.animation({ leaf = "global", enabled = true, speed = 1.5, bezier = "default" })

-- Windows: Lightning fast pop-ins
hl.animation({ leaf = "windows", enabled = true, speed = 1.5, bezier = "snappy" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 1.5, bezier = "snappy", style = "popin 85%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.5, bezier = "snappy", style = "popin 85%" })

-- Borders: Fast fades, explicitly disabling loops
hl.animation({ leaf = "border", enabled = true, speed = 1.5, bezier = "snappy" })
hl.animation({ leaf = "borderangle", enabled = false })

-- Fading elements: Instant transitions (100ms)
hl.animation({ leaf = "fade", enabled = true, speed = 1, bezier = "linear" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1, bezier = "linear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1, bezier = "linear" })

-- Layers (Waybar, Wofi, Notifications)
hl.animation({ leaf = "layers", enabled = true, speed = 1.5, bezier = "snappy" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 1.5, bezier = "snappy", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })

-- Workspaces: Fast slides
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.5, bezier = "snappy", style = "slide" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.5, bezier = "snappy", style = "slide" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.5, bezier = "snappy", style = "slide" })
