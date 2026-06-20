local wezterm = require("wezterm")
local act = wezterm.action
local M = {}

local function open_cht_sh(window, pane, line)
	if not line then
		return
	end

	local query = line:match("^%s*(.-)%s*$")
	local command = "cht.sh --shell=bash --mode=auto"
	if query ~= "" then
		command = command .. " " .. string.format("%q", query)
	end

	window:perform_action(
		act.SpawnCommandInNewWindow({
			label = query ~= "" and ("cht.sh: " .. query) or "cht.sh",
			args = { "bash", "-l", "-c", command },
			domain = "local",
			position = { x = 100, y = 50 },
		}),
		pane
	)
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

		{ key = "t", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
		{ key = "Tab", mods = "CTRL", action = act.ActivateTabRelative(1) },
		{ key = "Tab", mods = "CTRL|SHIFT", action = act.ActivateTabRelative(-1) },

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
				args = { "bash", "-c", '$EDITOR "/mnt/c/Users/Dev/.wezterm.lua"' },
				domain = "CurrentPaneDomain",
				position = { x = 300, y = 500 },
			}),
		},
		{
			key = "B",
			mods = "CTRL|SHIFT",
			action = act.SpawnCommandInNewWindow({
				label = "Open btop",
				args = { "bash", "-c", "$EDITOR '/mnt/c/Users/Dev/.wezterm.lua'" },
				domain = "CurrentPaneDomain",
				position = { x = 300, y = 500 },
			}),
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
			key = "H",
			mods = "CTRL|SHIFT",
			action = act.PromptInputLine({
				description = "Enter package or library for cht.sh",
				action = wezterm.action_callback(function(window, pane, line)
					open_cht_sh(window, pane, line)
				end),
			}),
		},
	}

	-- Smart Workspace Switcher configuration
	if plugins.smart_workspace_switcher then
		local sws = plugins.smart_workspace_switcher
		sws.choices.get_zoxide_elements = function(choice_table, opts)
			if opts == nil then
				opts = { extra_args = "", workspace_ids = {} }
			end

			local cmd = "zoxide query -l " .. (opts.extra_args or "")
			local success, stdout, stderr = wezterm.run_child_process({ "wsl.exe", "bash", "-l", "-c", cmd })

			-- Temporary debug logger
			local f = io.open("C:\\Users\\Dev\\wezterm_debug.log", "w")
			if f then
				f:write("Command: " .. tostring(cmd) .. "\n")
				f:write("Success: " .. tostring(success) .. "\n")
				f:write("Stdout length: " .. tostring(stdout and #stdout or "nil") .. "\n")
				f:write("Stdout: " .. tostring(stdout) .. "\n")
				f:write("Stderr: " .. tostring(stderr) .. "\n")
				f:close()
			end

			if not success then
				wezterm.log_error("WSL zoxide query failed: " .. tostring(stderr))
				return choice_table
			end

			for _, path in ipairs(wezterm.split_by_newlines(stdout)) do
				local updated_path = string.gsub(path, "^/home/eiat", "~")
				if not opts.workspace_ids[updated_path] then
					table.insert(choice_table, {
						id = path,
						label = updated_path,
					})
				end
			end
			return choice_table
		end

		table.insert(config.keys, {
			key = "s",
			mods = "LEADER",
			action = sws.switch_workspace({
				extra_args = " | rg -Fxf '\\\\wsl.localhost\\Ubuntu-24.04\\home\\eiat\\projects'",
			}),
		})
		table.insert(config.keys, {
			key = "S",
			mods = "LEADER",
			action = sws.switch_to_prev_workspace(),
		})
		sws.zoxide_path = "\\\\wsl.localhost\\Ubuntu-24.04\\home\\eiat\\bin\\zoxide"
	end

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
