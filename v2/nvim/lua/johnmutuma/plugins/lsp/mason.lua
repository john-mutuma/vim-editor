local mason_ok, mason = pcall(require, "mason")
local mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
local lspconfig_ok, lspconfig = pcall(require, "lspconfig")

local mason_null_ls_ok, mason_null_ls = pcall(require, "mason-null-ls")
local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
local typescript_ok, typescript = pcall(require, "typescript")

local keymap = vim.keymap
local capabilities = cmp_nvim_lsp.default_capabilities()

-- Configure Language servers LSP
local ensure_installed_lsp = {
	"ts_ls",
	"html",
	"cssls",
	"lua_ls",
	"eslint",
	"gopls",
	-- "jsonls", -- preferring coc-json for workspace features
}

-- Configure Linters(Code Actions, Diagnostics) & Formatters bucket
local ensure_installed_null_ls = {
	"prettier",
	"stylua",
	"eslint",
	"cspell",
	"gofumpt",
}

-- Sanity checks
if not cmp_nvim_lsp_ok then
	print("cmp_nvim_lsp could not be loaded")
	return
end

if not mason_ok then
	print("mason could not be loaded")
	return
end

if not mason_lspconfig_ok then
	print("mason-lspconfig could not be loaded")
	return
end

if not lspconfig_ok then
	print("lspconfig could not be loaded")
	return
end

if not mason_null_ls_ok then
	print("mason_null_ls_ok could not be loaded")
	return
end

if not typescript_ok then
	print("jose-elias-alvarez/typescript could not be loaded")
	return
end

-- Set up Mason
mason.setup()

local set_up_lsp = function(on_attach)
	mason_lspconfig.setup({
		ensure_installed = ensure_installed_lsp,
		handlers = {
			-- The first entry (without a key) will be the default handler
			-- and will be called for each installed server that doesn't have
			-- a dedicated handler.
			function(server_name) -- default handler (optional)
				lspconfig[server_name].setup({
					capabilities = capabilities,
					on_attach = on_attach,
				})
			end,

			["lua_ls"] = function()
				lspconfig["lua_ls"].setup({
					capabilities = capabilities,
					on_attach = on_attach,

					on_init = function(client)
						if client.workspace_folders then
							local path = client.workspace_folders[1].name
							if vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc") then
								return
							end
						end

						client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
							runtime = {
								-- Tell the language server which version of Lua you're using
								-- (most likely LuaJIT in the case of Neovim)
								version = "LuaJIT",
							},
							-- Make the server aware of Neovim runtime files
							workspace = {
								checkThirdParty = false,
								library = {
									vim.env.VIMRUNTIME,
									-- Depending on the usage, you might want to add additional paths here.
									-- "${3rd}/luv/library"
									-- "${3rd}/busted/library",
								},
								-- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
								-- library = vim.api.nvim_get_runtime_file("", true)
							},
						})
					end,
					settings = {
						Lua = {},
					},
				})
			end,

			["gopls"] = function()
				lspconfig["gopls"].setup({
					capabilities = capabilities,
					on_attach = on_attach,
					settings = {
						gopls = {
							analyses = {
								unusedparams = true,
							},
							staticcheck = true,
							gofumpt = true,
						},
					},
				})
			end,
		},
	})

	typescript.setup({
		server = {
			capabilities = capabilities,
			on_attach = on_attach,
		},
	})
end

local set_up_linters_and_formatters = function(on_attach)
	mason_null_ls.setup({
		ensure_installed = ensure_installed_null_ls,
		automaticinstallation = false,
		handlers = {},
	})
end

-- Configure DAP bucket
local set_up_debuggers = function(on_attach) end
--

local on_attach = function(client, bufnr)
	-- some language servers crash on semantic tokens when previewing files quickly e.g. Glance previews
	-- disabling sematic tokens - hihglighting for now will be provided by nvim-treesitter
	-- client.server_capabilities.semanticTokensProvider = nil

	local opts = { noremap = true, buffer = bufnr, silent = true }
	-- LSP key bindings
	keymap.set("n", "gR", "<cmd>Glance references<CR>", opts)
	-- keymap.set("n", "gR", "<cmd>Lspsaga finder<CR>", opts)
	-- keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>", opts)
	keymap.set("n", "gd", "<cmd>Glance definitions<CR>", opts)
	keymap.set("n", "gi", "<cmd>Glance implementations<CR>")
	keymap.set("n", "gT", "<cmd>Glance type_definitions<CR>")
	keymap.set("n", "g>", "<cmd>Lspsaga outgoing_calls<CR>")
	keymap.set("n", "g<", "<cmd>Lspsaga incoming_calls<CR>")
	keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
	-- keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
	-- keymap.set("n", "gr", vim.lsp.buf.references, opts)
	keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts)
	keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts)
	keymap.set("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts)
	keymap.set("n", "[e", "<cmd>Lspsaga diagnostic_jump_previous<CR>", opts)
	keymap.set("n", "<leader>D", "<cmd>Lspsaga show_buf_diagnostics<CR>", opts)
	keymap.set("n", "<leader>d", "<cmd>Lspsaga show_line_diagnostics<CR>", opts)
	keymap.set("n", "<leader>wd", "<cmd>Lspsaga show_workspace_diagnostics<CR>", opts)
	keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts)

	if client.name == "ts_ls" then
		keymap.set("n", "<leader>rf", "<cmd>TypescriptRenameFile<CR>", opts)
	end
end

set_up_lsp(on_attach)
set_up_linters_and_formatters(on_attach)
set_up_debuggers(on_attach)
