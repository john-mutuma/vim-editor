--
--
-- Use this file to install nvim-dap adapters, and use .vscode/launch.json to configure DAP launch configurations
-- Find available nvim-dap adapters from the nvim-dap repository
--
--

local dap_vscode_js_ok, dap_vscode_js = pcall(require, "dap-vscode-js")
local dap_ok, dap = pcall(require, "nvim-dap")

if not dap_vscode_js_ok then
	print("dap-vscode-js could not be loaded")
	return
end

-- Run DapInstall in neovim to open this file and install the adapters
vim.api.nvim_create_user_command("DapInstall", function(opts)
	local path_to_this_file = (debug.getinfo(1, "S").source:sub(2))
	vim.cmd("e " .. path_to_this_file)
	vim.cmd("normal! G")
end, { nargs = nil })

-- JS/TS debugg adapters
dap_vscode_js.setup({
	adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }, -- which adapters to register in nvim-dap
	--
})

-- dap.adapters.python = {
