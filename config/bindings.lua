local wezterm = require("wezterm")
local mux = wezterm.mux
local act = wezterm.action
local M = {}

local wsl_script_dir = "/mnt/c/Users/Dev/.config/wezterm/scripts"
local cht_sh_launcher = 'source "' .. wsl_script_dir .. '/cht-sh.sh" "$@"'
local snip_launcher = 'source "' .. wsl_script_dir .. '/snip.sh"'

local function trimmed(value)
	return (value or ""):gsub("[\r\n]+", " "):match("^%s*(.-)%s*$")
end

local function open_cht_sh(window, pane, seed_query)
	local query = trimmed(seed_query)
	local cwd_url = pane:get_current_working_dir()
	window:perform_action(
		act.SpawnCommandInNewWindow({
			label = query ~= "" and ("cht.sh: " .. query) or "cht.sh",
			args = { "bash", "-lic", cht_sh_launcher, "wezterm-cht-sh", query },
			cwd = cwd_url and cwd_url.file_path or nil,
			domain = "CurrentPaneDomain",
			position = { x = 100, y = 50 },
		}),
		pane
	)
end

local function open_cht_sh_from_selection(window, pane)
	open_cht_sh(window, pane, window:get_selection_text_for_pane(pane))
end

function M.apply_to_config(config, plugins)
	config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 3000 }

	config.mouse_bindings = {
		{
			event = { Up = { streak = 1, button = "Left" } },
			mods = "CTRL",
			action = act.OpenLinkAtMouseCursor,
		},
		{
			event = { Down = { streak = 1, button = "Left" } },
			mods = "CTRL",
			action = act.Nop,
		},
	}

	config.keys = {
		-- Pane Management
		{
			key = "/",
			mods = "CTRL|ALT",
			action = wezterm.action_callback(function(window, pane)
				local cwd_url = pane:get_current_working_dir()
				local domain = pane:get_domain_name()
				local args = nil

				if cwd_url and (domain == "local" or domain == "unix") then
					local path = cwd_url.file_path
					if not path:match("^%a:") then
						local unix_path = path:gsub("^/[wW][sS][lL]%.[lL][oO][cC][aA][lL][hH][oO][sS][tT]/[^/]+", "")
						unix_path = unix_path:gsub("^/[wW][sS][lL]%$/[^/]+", "")
						args = { "wsl.exe", "-d", "Ubuntu-24.04", "--cd", unix_path, "bash", "-l" }
					end
				end

				window:perform_action(
					act.SplitHorizontal({
						domain = "CurrentPaneDomain",
						args = args,
					}),
					pane
				)
			end),
		},
		{
			key = ".",
			mods = "CTRL|ALT",
			action = wezterm.action_callback(function(window, pane)
				local cwd_url = pane:get_current_working_dir()
				local domain = pane:get_domain_name()
				local args = nil

				if cwd_url and (domain == "local" or domain == "unix") then
					local path = cwd_url.file_path
					if not path:match("^%a:") then
						local unix_path = path:gsub("^/[wW][sS][lL]%.[lL][oO][cC][aA][lL][hH][oO][sS][tT]/[^/]+", "")
						unix_path = unix_path:gsub("^/[wW][sS][lL]%$/[^/]+", "")
						args = { "wsl.exe", "-d", "Ubuntu-24.04", "--cd", unix_path, "bash", "-l" }
					end
				end

				window:perform_action(
					act.SplitVertical({
						domain = "CurrentPaneDomain",
						args = args,
					}),
					pane
				)
			end),
		},
		-- Pane Navigation and Resizing
		{ key = "LeftArrow", mods = "CTRL|ALT", action = act.ActivatePaneDirection("Left") },
		{ key = "RightArrow", mods = "CTRL|ALT", action = act.ActivatePaneDirection("Right") },
		{ key = "UpArrow", mods = "CTRL|ALT", action = act.ActivatePaneDirection("Up") },
		{ key = "DownArrow", mods = "CTRL|ALT", action = act.ActivatePaneDirection("Down") },

		{ key = "H", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Left", 3 }) },
		{ key = "L", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Right", 3 }) },
		{ key = "K", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Up", 1 }) },
		{ key = "J", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Down", 1 }) },

		{ key = "w", mods = "CTRL|ALT", action = act.CloseCurrentPane({ confirm = false }) },
		{ key = "x", mods = "CTRL|ALT", action = act.CloseCurrentPane({ confirm = false }) },
		{ key = "x", mods = "LEADER", action = act.CloseCurrentTab({ confirm = true }) },
		-- Tab Management
		{ key = "t", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
		{ key = "Tab", mods = "CTRL", action = act.ActivateTabRelative(1) },
		{ key = "Tab", mods = "CTRL|SHIFT", action = act.ActivateTabRelative(-1) },
		-- Command Palette and Launcher
		{ key = "p", mods = "CTRL|SHIFT", action = act.ActivateCommandPalette },
		{
			key = "l",
			mods = "CTRL|ALT",
			action = act.ShowLauncherArgs({ flags = "FUZZY|LAUNCH_MENU_ITEMS|DOMAINS|TABS|WORKSPACES" }),
		},

		{ key = "a", mods = "LEADER|CTRL", action = act.SendKey({ key = "a", mods = "CTRL" }) },
		{ key = "d", mods = "CTRL|SHIFT", action = act.DetachDomain("CurrentPaneDomain") },
		{ key = "s", mods = "CTRL|SHIFT", action = act.AttachDomain("CurrentPaneDomain") },
		{
			key = "Y",
			mods = "CTRL|SHIFT",
			action = act.SpawnCommandInNewWindow({
				label = "Open Navi",
				args = { "navi" },
				cwd = "/home/eiat",
				domain = "CurrentPaneDomain",
				position = { x = 300, y = 500 },
			}),
		},

		{
			key = "C",
			mods = "LEADER|SHIFT",
			action = act.SpawnCommandInNewWindow({
				label = "Open Wezterm Config",
				args = { "bash", "-lc", '$EDITOR "/mnt/c/Users/Dev/.config/wezterm/wezterm.lua"' },
				domain = "CurrentPaneDomain",
				position = { x = 300, y = 500 },
			}),
		},
		{
			key = "B",
			mods = "CTRL|SHIFT",
			action = wezterm.action_callback(function(_, pane)
				local cwd_url = pane:get_current_working_dir()
				local cwd = cwd_url and cwd_url.file_path or nil
				local domain = pane:get_domain_name()

				local _, _, btop_window = mux.spawn_window({
					args = { "bash", "-lc", "btop" },
					cwd = cwd,
					domain = domain and { DomainName = domain } or nil,
					width = 80,
					height = 25,
					position = {
						x = 80,
						y = 40,
						origin = "ActiveScreen",
					},
				})

				wezterm.sleep_ms(50)

				local gui_window = btop_window and btop_window:gui_window()
				if gui_window then
					local overrides = gui_window:get_config_overrides() or {}
					overrides.enable_tab_bar = false
					gui_window:set_config_overrides(overrides)
				end
			end),
		},
		{
			key = "N",
			mods = "LEADER",
			action = act.SendString("nvm use default\n"),
		},
		{
			key = "E",
			mods = "CTRL|SHIFT",
			action = act.PromptInputLine({
				description = "Enter new name for tab",
				initial_value = "My Tab Name",
				action = wezterm.action_callback(function(window, pane, line)
					if line then
						window:active_tab():set_title(line)
					end
				end),
			}),
		},
		{
			key = "h",
			mods = "CTRL|SHIFT",
			action = wezterm.action_callback(open_cht_sh_from_selection),
		},
		{
			key = "n",
			mods = "CTRL|SHIFT",
			action = act.SendString("nvm use default\n"),
		},
		{
			key = "n",
			mods = "CTRL|ALT",
			action = act.SendString("nvm use default\n"),
		},
		{
			key = "n",
			mods = "LEADER",
			action = act.SendString("nvm use default\n"),
		},
		{
			key = "s",
			mods = "LEADER",
			action = act.SpawnCommandInNewWindow({
				label = "Open snip",
				domain = "CurrentPaneDomain",
				args = { "bash", "-lic", snip_launcher },
				position = { x = 300, y = 500 },
			}),
		},
	}

	-- Toggle Terminal configuration
	if plugins.toggle_terminal then
		local ok, err = pcall(plugins.toggle_terminal.apply_to_config, config, {
			key = ";",
			mods = "LEADER",
			direction = "Up",
			size = { Percent = 20 },
			change_invoker_id_everytime = false,
			zoom = {
				auto_zoom_toggle_terminal = false,
				auto_zoom_invoker_pane = true,
				remember_zoomed = true,
			},
		})
		if not ok then
			wezterm.log_warn("Failed to initialize toggle_terminal.wez: " .. tostring(err))
		end
	end
end

return M
