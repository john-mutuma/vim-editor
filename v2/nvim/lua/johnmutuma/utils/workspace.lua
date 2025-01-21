local M = {}

-- LSP (Language server) clients to ensure are installed with Mason
M.ensure_installed_lsp = {
	"ts_ls",
	"html",
	"cssls",
	"lua_ls",
	"eslint",
	"gopls",
	-- "jsonls", -- preferring coc-json for workspace features
}

-- Null-ls - Code formatters, linters, fixers, etc. installed with Mason
M.ensure_installed_null_ls = {
	"prettier",
	"stylua",
	"eslint",
	"cspell",
	"gofumpt",
}

-- TODO - these should be read from a workspace config e.g. .vscode/settings.json
M.eslintExecArgv = { "--max_old_space_size=32568" }
M.eslintWorkingDirectory = { mode = "auto" }
M.eslintOptions = {
	resolvePluginsRelativeTo = "../eslint-config",
}
M.eslintCodeActionOnSave = {
	enable = true,
	rules = { "!@typescript-eslint/*", "!import/order", "*" },
}
M.eslintQuiet = true

return M
