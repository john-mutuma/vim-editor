local mason_ok, mason = pcall(require, "mason")
local mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
local lspconfig_ok, lspconfig = pcall(require, "lspconfig")

local mason_null_ls_ok, mason_null_ls = pcall(require, "mason-null-ls")
local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
-- local typescript_ok, typescript = pcall(require, "typescript")

local workspaceSettings = require("johnmutuma.utils.workspace")

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

-- if not typescript_ok then
-- 	print("jose-elias-alvarez/typescript could not be loaded")
-- 	return
-- end

-- Set up Mason
mason.setup()

local capabilities = cmp_nvim_lsp.default_capabilities()
mason_lspconfig.setup({
	ensure_installed = workspaceSettings.ensure_installed_lsp,
	--
	-- setup handlers for Mason installed lsp clients
	handlers = {
		-- The first entry (without a key) will be the default handler
		-- and will be called for each installed server that doesn't have a dedicated handler.
		function(server_name) -- default handler (optional)
			lspconfig[server_name].setup({
				capabilities = capabilities,
				-- on_attach = on_attach,
			})
		end,

		["eslint"] = function()
			lspconfig["eslint"].setup({
				capabilities = capabilities,
				-- on_attach = on_attach,
				settings = {
					options = workspaceSettings.eslintOptions,
					workingDirectory = workspaceSettings.eslintWorkingDirectory,
					codeActionOnSave = workspaceSettings.eslintCodeActionOnSave,
					execArgv = workspaceSettings.eslintExecArgv,
				},
			})
		end,

		["lua_ls"] = function()
			lspconfig["lua_ls"].setup({
				capabilities = capabilities,
				-- on_attach = on_attach,

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
				-- on_attach = on_attach,
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

-- typescript.setup({
-- 	server = {
-- 		capabilities = capabilities,
-- 		-- on_attach = on_attach,
-- 	},
-- })

mason_null_ls.setup({
	ensure_installed = workspaceSettings.ensure_installed_null_ls,
	automaticinstallation = false,
	handlers = {},
})

-- Configure DAP bucket
-- Configure mason-nvim-dap Debuggers
