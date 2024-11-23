local globl = vim.g
local keymap = vim.keymap

keymap.set("n", "<C-n>", ":NERDTreeFind<CR>:<CR>$")

globl.NERDTreeWinSize = 60

return {}
