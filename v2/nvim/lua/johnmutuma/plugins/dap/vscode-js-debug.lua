local dap_vscode_js_ok, dap_vscode_js = pcall(require, "dap-vscode-js")

if not dap_vscode_js_ok then
	print("dap-vscode-js could not be loaded")
	return
end

dap_vscode_js.setup({
	-- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
	-- debugger_path = "(runtimedir)/site/pack/packer/opt/vscode-js-debug", -- Path to vscode-js-debug installation.
	-- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
	adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }, -- which adapters to register in nvim-dap
	-- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
	-- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
	-- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
})

-- PREFERRING THE PER-PROJECT LAUNCH.JSON to configure adapters
--
-- for _, language in ipairs({ "typescript", "typescriptreact", "javascript", "javascriptreact" }) do
-- 	require("dap").configurations[language] = {
-- 		{
-- 			name = "[Edge] - Launch",
-- 			request = "launch",
-- 			type = "pwa-msedge",
-- 			url = "https://localhost:3333/?LivePersonaCardVersionOverride=localhost",
-- 			webRoot = "${workspaceFolder}",
-- 			userDataDir = "${workspaceFolder}/.vscode/msedge",
-- 			sourceMaps = true,
-- 		},
-- 	}
-- end
