local M = {}

function M.apply_to_config(config, plugins)
	-- Performance Tuning
	config.front_end = "WebGpu"

	-- Default workspace name
	config.default_workspace = "󱂬: "

	-- Windows input mode
	config.allow_win32_input_mode = true

	-- Apply agent deck plugin configuration
	if plugins.agent_deck then
		plugins.agent_deck.apply_to_config(config, {
			update_interval = 1000,
			right_status = {
				register_update_status = false,
			},
			notifications = {
				enabled = true,
				on_waiting = true,
				on_finished = true,
			},
		})
	end

	-- Apply wezterm sync plugin configuration
	if plugins.wezterm_sync then
		plugins.wezterm_sync.apply_to_config(config)
	end
end

return M
