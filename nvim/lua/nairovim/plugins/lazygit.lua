local g = vim.g
return {
    "kdheepak/lazygit.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "sindrets/diffview.nvim",
    },

    init = function()
        local window_utils = require("nairovim.utils.windows")

        g.lazygit_floating_window_winblend = 4 -- transparency of floating window
        g.lazygit_floating_window_scaling_factor = 0.8 -- scaling factor for floating window

        -- Keymaps for LazyGit
        local common_utils = require("nairovim.utils.common")
        local mappings = require("nairovim.plugins.customizations.keymaps.lazygit").mappings
        common_utils.map(mappings)

        -- Highlight groups for LazyGit
        local get_hightlights = require("nairovim.plugins.customizations.highlights.lazygit").get
        common_utils.apply_highlights(get_hightlights, "lazygit_highlights_overrides_augroup")

        -- manually adding a backdrop to lazygit prompt to add depth
        -- can remove this when Telescope has added a backdrop internally or if neovim decideds to include backdrops to floating windows for depth
        window_utils.with_win_backdrop("lazygit")
    end,
}
