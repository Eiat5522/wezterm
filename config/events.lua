local wezterm = require("wezterm")
local mux = wezterm.mux
local M = {}

function M.register_events()
	-- Maximize window on gui-attached
	wezterm.on("gui-attached", function(domain)
		local workspace = mux.get_active_workspace()
		for _, window in ipairs(mux.all_windows()) do
			if window:get_workspace() == workspace then
				window:gui_window():maximize()
			end
		end
	end)

	-- Maximize window on gui-startup
	wezterm.on("gui-startup", function(cmd)
		local tab, pane, window = mux.spawn_window(cmd or {})
		window:gui_window():maximize()
	end)

	-- Update status listener directly on the wezterm module
	wezterm.on("update-status", function(window, pane)
		local meta = pane:get_metadata() or {}
		local overrides = window:get_config_overrides() or {}
		-- Display mux latency in the right status area
		if meta.is_tardy then
			local secs = meta.since_last_response_ms / 1000.0
			window:set_right_status(string.format("tardy: %5.1fs⏳", secs))
		else
			-- Change color scheme if input is a password field
			if meta.password_input then
				overrides.color_scheme = "Red Alert"
			else
				overrides.color_scheme = nil
			end
			window:set_config_overrides(overrides)
		end
	end)
end

return M
