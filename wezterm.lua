local wezterm = require("wezterm")

-- Ensure the config directory is in the package path for resolving modules in the config folder
local config_dir = wezterm.home_dir .. "/.config/wezterm"
package.path = package.path .. ";" .. config_dir .. "/?.lua"
package.path = package.path .. ";" .. config_dir .. "/?/init.lua"

local plugin_root = config_dir .. "/plugin"

local function load_local_plugin(name)
	local plugin_lua_path = plugin_root .. "/" .. name .. "/plugin/?.lua"
	local plugin_init_path = plugin_root .. "/" .. name .. "/plugin/?/init.lua"
	package.path = package.path .. ";" .. plugin_lua_path .. ";" .. plugin_init_path

	local ok, plugin = pcall(dofile, plugin_root .. "/" .. name .. "/plugin/init.lua")
	if not ok then
		wezterm.log_warn("Failed to load local plugin '" .. name .. "': " .. tostring(plugin))
		return nil
	end
	return plugin
end

-- Load Plugins from Local Directory
local plugins = {
	agent_deck = load_local_plugin("wezterm-agent-deck"),
	tabline = load_local_plugin("wezterm-tabline"),
	toggle_terminal = load_local_plugin("wezterm-toggle-terminal"),
	wezterm_sync = load_local_plugin("wezterm-sync"),
}

local config = {}
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- Apply modular configurations
require("config.general").apply_to_config(config, plugins)
require("config.fonts").apply_to_config(config)
require("config.appearance").apply_to_config(config, plugins)
require("config.domains").apply_to_config(config)
require("config.launch").apply_to_config(config)
require("config.bindings").apply_to_config(config, plugins)

-- Register events
require("config.events").register_events()

return config
