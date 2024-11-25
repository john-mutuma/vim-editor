local globl = vim.g
local keymap = vim.keymap

-- general keymaps
-- - insert mode
keymap.set("i", "jk", "<ESC>")
keymap.set("i", "<C-U>", "<ESC>gUiwea")

-- - normal mode
keymap.set("n", "<leader><CR>", ":nohlsearch<CR>:<CR>")

-- removing this to be able to swap letters in normal mode with xp
-- keymap.set("n", "x", '"_x') -- don't copy into clipboard single char deleted with 'x'

-- Windows
-- - window management
keymap.set("n", "gq", "<C-W>c") -- close current window
keymap.set("n", "<leader>qq", ":qa<CR>") -- soft quit all windows
keymap.set("n", "<leader>QQ", ":qa!<CR>") -- hard quit all windows

keymap.set("n", "<C-T>o", ":tabonly<CR>")
keymap.set("n", "<leader>F", ":MaximizerToggle<CR>")
-- keymap.set("n", "<leader>F", ":ZenMode<CR>")

-- Folds
-- - -- jump folded with j and k
keymap.set("n", "j", "gj")
keymap.set("n", "k", "gk")

-- - -- save with ww for save without autocmd
keymap.set("n", "<leader>ww", ":noautocmd w<CR>")
keymap.set("n", "<leader>w<CR>", ":noautocmd w<CR>")

-- Plugins mappings
-- -- telescope
local builtin = require("telescope.builtin")
-- keymap.set("n", "<C-F>f", builtin.find_files, {})
-- keymap.set("n", "<C-F>s", builtin.live_grep, {})
-- keymap.set("n", "<C-F>b", builtin.buffers, {})
keymap.set("n", "<C-F>h", builtin.help_tags, {})
keymap.set("n", "<C-F>y", ":GBranches<CR>", {})
-- keymap.set("n", "<C-F>y", builtin.git_branches, {})

-- fzf.vim
keymap.set("n", "<C-F>f", ":GFiles<CR>", {})
keymap.set("n", "<C-F>s", "Rg ", {})
keymap.set("n", "<C-F>b", ":Buffers<CR>", {})
