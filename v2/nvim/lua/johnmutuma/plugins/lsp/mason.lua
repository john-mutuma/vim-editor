local mason_ok, mason = pcall(require, "mason")
local mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
local mason_null_ls_ok, mason_null_ls = pcall(require, "mason-null-ls")

-- Configure LSP bucket
local set_up_lsp = function()
	mason_lspconfig.setup({
		ensure_installed = {
			"tsserver",
			"html",
			"cssls",
			-- "jsonls", -- preferring coc-json for workspace features
			"lua_ls",
			"eslint",
		},
	})
end

-- Configure Linters(Code Actions, Diagnostics) & Formatters bucket
local set_up_linters_and_formatters = function()
	mason_null_ls.setup({
		ensure_installed = {
			"prettier",
			"stylua",
			"eslint",
			"cspell",
		},
	})
end

-- Configure DAP bucket
local set_up_debuggers = function() end
--

local main = function()
	mason.setup()
	set_up_lsp()
	set_up_linters_and_formatters()
	set_up_debuggers()
end

if not mason_ok then
	print("mason could not be loaded")
	return
end

if not mason_lspconfig_ok then
	print("mason-lspconfig could not be loaded")
	return
end

if not mason_null_ls_ok then
	print("mason_null_ls_ok could not be loaded")
	return
end

main()
