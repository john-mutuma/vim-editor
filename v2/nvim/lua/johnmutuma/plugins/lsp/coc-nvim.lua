local keymap = vim.keymap
local augroup = vim.api.nvim_create_augroup -- Create/get autocommand group
local autocmd = vim.api.nvim_create_autocmd -- Create autocommand

keymap.set("n", "<space>ca", "<Plug>(coc-codeaction)")
keymap.set("n", "<space>cc", "<cmd>CocCommand<CR>")

-- Configure auto-Organize Imports
local org_augroup = augroup("organizeImports", { clear = true })
autocmd("BufWritePre", {
	group = org_augroup,
	pattern = { "*.ts", "*.js", "*.tsx", "*.jsx" },
	command = ":silent call CocAction('runCommand', 'editor.action.organizeImport')",
})
vim.api.nvim_create_user_command("OI", ":silent call CocAction('runCommand', 'editor.action.organizeImport')", {})
