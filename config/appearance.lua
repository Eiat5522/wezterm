local wezterm = require("wezterm")
local M = {}

function M.apply_to_config(config, plugins)
	-- Terminal appearance
	config.color_scheme = "tokyonight"
	config.window_background_opacity = 0.98
	config.adjust_window_size_when_changing_font_size = false
	config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }

	-- Tab bar display settings
	config.enable_tab_bar = true
	config.use_fancy_tab_bar = true
	config.hide_tab_bar_if_only_one_tab = false
	config.tab_bar_at_bottom = true

	-- Window decorations
	config.window_decorations = "RESIZE"
	config.integrated_title_button_style = "Gnome"
	config.integrated_title_buttons = { "Hide", "Close" }
	config.integrated_title_button_alignment = "Right"
	config.integrated_title_button_color = "Auto"

	-- Cursor settings
	config.default_cursor_style = "BlinkingBlock"
	config.cursor_blink_rate = 500
	config.underline_thickness = "2px"

	-- Other display options
	config.enable_scroll_bar = true
	config.hide_mouse_cursor_when_typing = true
	config.audible_bell = "SystemBeep"
	config.warn_about_missing_glyphs = true
	config.mouse_wheel_scrolls_tabs = false
	config.detect_password_input = true

	-- Tabline setup
	if plugins.tabline then
		local ok, err = pcall(plugins.tabline.setup, {
			options = {
				icons_enabled = true,
				theme = "Catppuccin Mocha",
				tabs_enabled = true,
				theme_overrides = {},
				section_separators = {
					left = wezterm.nerdfonts.pl_left_hard_divider,
					right = wezterm.nerdfonts.pl_right_hard_divider,
				},
				component_separators = {
					left = wezterm.nerdfonts.pl_left_soft_divider,
					right = wezterm.nerdfonts.pl_right_soft_divider,
				},
				tab_separators = {
					left = wezterm.nerdfonts.pl_left_hard_divider,
					right = wezterm.nerdfonts.pl_right_hard_divider,
				},
			},
			sections = {
				tabline_a = { "mode" },
				tabline_b = { "workspace" },
				tabline_c = { " " },
				tab_active = {
					"index",
					{ "cwd", padding = { left = 0, right = 1 } },
					{ "zoomed", padding = 0 },
				},
				tab_inactive = { "index", { "process", padding = { left = 0, right = 1 } } },
				tabline_x = { "tardy", { "agent_deck", agent_deck = plugins.agent_deck }, "ram" },
				tabline_y = { "" },
				tabline_z = { "domain" },
			},
			extensions = { "resurrect" },
		})
		if not ok then
			wezterm.log_warn("Failed to initialize tabline.wez: " .. tostring(err))
		end
	end
end

return M
