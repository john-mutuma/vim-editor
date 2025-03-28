local globl = vim.g
local keymap = vim.keymap
local window_utils = require("johnmutuma.utils.windows")

globl.lazygit_floating_window_winblend = 4 -- transparency of floating window
globl.lazygit_floating_window_scaling_factor = 0.9 -- scaling factor for floating window

keymap.set("n", "<leader>G", ":LazyGit<CR>", {})

-- manually adding a backdrop to lazygit prompt to add depth
-- can remove this when Telescope has added a backdrop internally or if neovim decideds to include backdrops to floating windows for depth
window_utils.create_win_backdrop("lazygit")

return {}
