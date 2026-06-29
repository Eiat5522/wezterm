local wezterm = require("wezterm")
local M = {}

function M.apply_to_config(config)
	config.font_size = 16
	config.font = wezterm.font_with_fallback({
		{
			family = "JetBrains Mono",
			weight = "Medium",
		},
		{
			family = "Terminus",
			weight = "Bold",
		},
		family = "Noto Color Emoji",
	})
end

return M
