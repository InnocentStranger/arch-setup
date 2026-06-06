-- modules.settings.init.lua
-- Single require point for all settings sub-modules.
-- In hyprland.lua you just write: require("modules.settings")
-- Lua automatically looks for modules.settings.init.lua when the path is a directory.

require("modules.settings.animations")
require("modules.settings.layout")
require("modules.settings.misc")
require("modules.settings.input")
