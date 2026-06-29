local wezterm = require("wezterm")
local M = {}

function M.apply_to_config(config)
	config.font_size = 15
	config.font = wezterm.font_with_fallback({
		{
			family = "CaskaydiaCove NF",
			weight = "Medium",
		},
		{
			family = "CaskaydiaCove NF",
			weight = "Bold",
		},
		{
			family = "CaskaydiaCove NF",
			weight = "Light",
			style = "Italic",
		},
		family = "Noto Color Emoji",
	})
end

return M
