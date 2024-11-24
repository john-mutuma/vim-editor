local globl = vim.g
local keymap = vim.keymap

globl.lazygit_floating_window_winblend = 4 -- transparency of floating window
globl.lazygit_floating_window_scaling_factor = 0.9 -- scaling factor for floating window

keymap.set("n", "<leader>G", ":LazyGit<CR>", {})

return {}
