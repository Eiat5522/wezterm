-- Compatibility shim for older launchers that still point at this file.
local wezterm = require("wezterm")

return dofile(wezterm.config_dir .. "/wezterm.lua")
