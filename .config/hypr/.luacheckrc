-- Rerun tests only if their modification time changed.
cache = true

-- Hyprland 0.56 embeds Lua 5.5; lua54 is the closest std luacheck knows.
std = lua54
codes = true

self = false

-- Glorious list of warnings: https://luacheck.readthedocs.io/en/stable/warnings.html
ignore = {
  "212", -- Unused argument, In the case of callback function, _arg_name is easier to understand than _, so this option is set to off.
  "122", -- Indirectly setting a readonly global
  "631", -- Line length too long
}

-- Global objects injected by Hyprland's lua config manager
read_globals = {
  "hl",
}
