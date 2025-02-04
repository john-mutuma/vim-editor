local null_ls_ok, null_ls = pcall(require, "null-ls")
local workspaceSettings = require("johnmutuma.utils.workspace")

if not null_ls_ok then
	print("null_ls could not be loaded")
	return
end

-- local code_actions = null_ls.builtins.code_actions
-- local diagnostics = null_ls.builtins.diagnostics

-- Format on save helper
local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = true })
local configure_format_on_save = function(client, bufnr)
	if client.supports_method("textDocument/formatting") then
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

local eslint_extra_args = {
	"--resolve-plugins-relative-to",
	workspaceSettings.eslintOptions.resolvePluginsRelativeTo,
}

-- Configure linters, formatters, diagnostics, code actions
null_ls.setup({
	debug = false,
	sources = {
		-- use this section to add sources unsupported by Mason yet
		require("none-ls.diagnostics.eslint").with({
			extra_args = eslint_extra_args,
		}),
		-- require("none-ls.code_actions.eslint").with({ -- this has caused a huge performance hit when enabled
		-- 	extra_args = eslint_extra_args,
		-- }),
	},
	on_attach = configure_format_on_save,
	root_dir = function(_)
		return nil
	end,
})
