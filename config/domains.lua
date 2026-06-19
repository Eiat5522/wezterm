local wezterm = require("wezterm")
local M = {}

function M.apply_to_config(config)
	-- WSL domains
	config.wsl_domains = {
		{
			name = "WSL:Ubuntu-24.04",
			distribution = "Ubuntu-24.04",
			default_cwd = "~",
			default_prog = { "bash" },
		},
	}

	-- Unix domains
	config.unix_domains = {
		{
			name = "unix",
			local_echo_threshold_ms = 10,
		},
	}

	-- SSH domains (auto-discovered from local hosts)
	local ssh_domains = {}
	for host in pairs(wezterm.enumerate_ssh_hosts()) do
		table.insert(ssh_domains, {
			name = host,
			remote_address = host,
			multiplexing = "WezTerm",
			assume_shell = "Posix",
			no_agent_auth = false,
			timeout = 60,
			remote_wezterm_path = "/home/eiat/.local/opt/wezterm-20260610-150805-891bed31/usr/bin/wezterm",
		})
	end
	config.ssh_domains = ssh_domains

	-- TLS clients
	config.tls_clients = {
		{
			name = "tls.server",
			bootstrap_via_ssh = "eiat@127.0.0.1:2222",
			remote_address = "127.0.0.1:8083",
			accept_invalid_hostnames = false,
			connect_automatically = false,
			read_timeout = 60,
			write_timeout = 60,
			remote_wezterm_path = "/home/eiat/.local/opt/wezterm-20260610-150805-891bed31/usr/bin/wezterm",
			local_echo_threshold_ms = 10,
		},
	}

	-- Configure SSH Agent socket in panes
	config.mux_enable_ssh_agent = true
end

return M
