local M = {}

function M.apply_to_config(config)
	-- Set Default Program and Domain
	config.default_prog = { "wsl.exe", "-d", "Ubuntu-24.04", "--cd", "~", "bash", "-l" }
	config.default_domain = "WSL:Ubuntu-24.04"

	-- Custom Launcher Menu
	config.launch_menu = {
		{
			label = "Pwsh",
			args = { "pwsh.exe", "-NoLogo" },
			cwd = "C:\\Users\\Dev\\",
		},
		{
			label = "Powershell",
			args = { "C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe", "-NoLogo" },
			cwd = "C:\\Users\\Dev\\",
		},
		{
			label = "Command Prompt",
			args = { "cmd.exe", "/s", "/k", "c:/clink/clink_x64.exe", "inject", "-q" },
			cwd = "C:\\Users\\Dev\\",
			set_environment_variables = {
				prompt = "$E]7;file://localhost/$P$E\\$E[32m$T$E[0m $E[35m$P$E[36m$_$G$E[0m ",
				DIRCMD = "/d",
			},
		},
		{
			label = "WSL: Ubuntu-24.04",
			args = { "wsl.exe", "-d", "Ubuntu-24.04", "--cd", "~", "bash", "-l" },
		},
	}
end

return M
