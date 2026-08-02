hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})

hl.config({
    master = {
        new_status = "master",
    },
})

require("hyprland/animations")
require("hyprland/decorations")
require("hyprland/env")
require("hyprland/execs")
require("hyprland/general")
require("hyprland/input")
require("hyprland/keybinds")
require("hyprland/misc")
require("hyprland/devices")
