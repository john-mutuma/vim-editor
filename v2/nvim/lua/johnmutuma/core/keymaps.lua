vim.g.mapleader = ","

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
keymap.set("n", "gq", "<C-W>c")
keymap.set("n", "<C-T>o", ":tabonly<CR>")
keymap.set("n", "<leader>z", ":MaximizerToggle<CR>")

-- Folds
-- - -- jump folded with j and k
keymap.set("n", "j", "gj")
keymap.set("n", "k", "gk")

-- - -- save with ww for save without autocmd
keymap.set("n", "<leader>ww", ":noautocmd w<CR>")
keymap.set("n", "<leader>w<CR>", ":noautocmd w<CR>")

-- Plugins mappings
-- nvim-tree
keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>:<CR>$")
-- keymap.set("n", "<C-n>", ":Neotree<CR>:<CR>")

-- -- telescope
local builtin = require("telescope.builtin")
-- vim.keymap.set("n", "<C-F>f", builtin.find_files, {})
-- vim.keymap.set("n", "<C-F>s", builtin.live_grep, {})
-- vim.keymap.set("n", "<C-F>b", builtin.buffers, {})
vim.keymap.set("n", "<C-F>h", builtin.help_tags, {})
vim.keymap.set("n", "<C-F>y", ":GBranches<CR>", {})
-- vim.keymap.set("n", "<C-F>y", builtin.git_branches, {})

-- fzf.vim
vim.keymap.set("n", "<C-F>f", ":GFiles<CR>", {})
vim.keymap.set("n", "<C-F>s", "Rg ", {})
vim.keymap.set("n", "<C-F>b", ":Buffers<CR>", {})
