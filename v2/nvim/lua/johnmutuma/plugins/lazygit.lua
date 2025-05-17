local globl = vim.g

local keymap = vim.keymap

return {
    "kdheepak/lazygit.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
        local window_utils = require("johnmutuma.utils.windows")

        globl.lazygit_floating_window_winblend = 4          -- transparency of floating window
        globl.lazygit_floating_window_scaling_factor = 0.85 -- scaling factor for floating window
        keymap.set("n", "<leader>G", ":LazyGit<CR>", {})

        -- manually adding a backdrop to lazygit prompt to add depth
        -- can remove this when Telescope has added a backdrop internally or if neovim decideds to include backdrops to floating windows for depth
        window_utils.with_win_backdrop("lazygit")
    end,
}
