local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
local typescript_ok, typescript = pcall(require, "typescript")
local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")

local setup_lsp = function(on_attach)
	local capabilities = cmp_nvim_lsp.default_capabilities()
	--
	-- configure the Language servers
	-- lspconfig["eslint"].setup({
	--   capabilities = capabilities,
	--   on_attach = on_attach,
	-- })

	lspconfig["html"].setup({
		capabilities = capabilities,
		on_attach = on_attach,
	})

	typescript.setup({
		server = {
			capabilities = capabilities,
			on_attach = on_attach,
		},
	})

	lspconfig["tsserver"].setup({
		capabilities = capabilities,
		on_attach = on_attach,
	})

	lspconfig["cssls"].setup({
		capabilities = capabilities,
		on_attach = on_attach,
	})

	-- lspconfig["jsonls"].setup({ -- preferring coc-json for workspace settings
	-- 	capabilities = capabilities,
	-- 	on_attach = on_attach,
	-- })

	lspconfig["lua_ls"].setup({
		capabilities = capabilities,
		on_attach = on_attach,
		settings = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim" },
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true),
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			},
		},
	})
end

if not lspconfig_ok then
	print("lspconfig could not be loaded")
	return
end

if not typescript_ok then
	print("jose-elias-alvarez/typescript could not be loaded")
	return
end

if not cmp_nvim_lsp_ok then
	print("cmp_nvim_lsp could not be loaded")
	return
end

local keymap = vim.keymap
local on_attach = function(client, bufnr)
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

	if client.name == "tsserver" then
		keymap.set("n", "<leader>rf", "<cmd>TypescriptRenameFile<CR>", opts)
	end
end

setup_lsp(on_attach)
