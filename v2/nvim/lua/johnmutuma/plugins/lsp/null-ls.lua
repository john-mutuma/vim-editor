local null_ls_ok, null_ls = pcall(require, "null-ls")
-- local eslint_ok, lspconfig = pcall(require, "lspconfig")

-- if not eslint_ok then
--   print("ESLint could not be loaded")
--   return
-- end

local formatting = null_ls.builtins.formatting
local code_actions = null_ls.builtins.code_actions
local diagnostics = null_ls.builtins.diagnostics

-- local eslint = lspconfig["eslint"]
-- eslint.setup({
--   capabilities = require("cmp_nvim_lsp").default_capabilities(),
--   on_attach = function()
--     return nil
--   end,
-- })
--
-- Configure linters, formatters, diagnostics, code actions
local set_up_linters_and_formatters = function(on_attach)
	null_ls.setup({
		debug = false,
		sources = {
			-- code_actions.gitsigns,
			formatting.stylua,
			formatting.prettier,
			-- diagnostics.cspell,
			-- diagnostics.eslint.with({
			--   name = "vs-code-eslint",
			--   meta = {
			--     url = "https://github.com/xojs/xo",
			--     description = "❤️ JavaScript/TypeScript linter (ESLint wrapper) with great defaults.",
			--   },
			--   filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
			--   command = "vscode-eslint-language-server",
			--   args = { "--reporter", "json", "--stdio", "--stdin-filename", "$FILENAME" },
			-- }),
		},
		on_attach = function(client, bufnr)
			on_attach(client, bufnr)
		end,
		root_dir = function(_)
			return nil
		end,
	})
end

-- Format on save helper
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local configure_format_on_save = function(client, bufnr)
	if client.supports_method("textDocument/formatting") then
		vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = augroup,
			buffer = bufnr,
			callback = function()
				-- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
				-- on later neovim version, you should use vim.lsp.buf.format({ async = false }) instead
				vim.lsp.buf.format({ async = false, timeout_ms = 2000 })
			end,
		})
	end
end

-- Configure linting and formatting sources
local main = function()
	set_up_linters_and_formatters(configure_format_on_save)
end

if not null_ls_ok then
	print("null_ls could not be loaded")
	return
end

main()
