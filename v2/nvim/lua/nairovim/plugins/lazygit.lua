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
        g.lazygit_floating_window_scaling_factor = 0.85 -- scaling factor for floating window

        -- Keymaps for LazyGit
        local mappings = require("nairovim.plugins.customizations.keymaps.lazygit").mappings
        local common_utils = require("nairovim.utils.common")
        common_utils.map(mappings)

        local function set_lazygit_border_highlight()
            vim.api.nvim_set_hl(0, "LazyGitBorder", { link = "FloatBorder" })
            -- Add your custom highlights here
        end

        -- Set highlight on startup
        set_lazygit_border_highlight()

        -- Set highlight on colorscheme change
        local lazygit_hl_augroup = vim.api.nvim_create_augroup("LazyGitHighlightOverrides", { clear = true })
        vim.api.nvim_create_autocmd("ColorScheme", {
            pattern = "*",
            group = lazygit_hl_augroup,
            callback = set_lazygit_border_highlight,
        })

        -- manually adding a backdrop to lazygit prompt to add depth
        -- can remove this when Telescope has added a backdrop internally or if neovim decideds to include backdrops to floating windows for depth
        window_utils.with_win_backdrop("lazygit")
    end,
}
