-- return {
--     "sudo-tee/opencode.nvim",
--     config = function()
--         require("opencode").setup({})
--     end,
--     dependencies = {
--         "nvim-lua/plenary.nvim",
--         {
--             "MeanderingProgrammer/render-markdown.nvim",
--             opts = {
--                 anti_conceal = { enabled = false },
--                 file_types = { "markdown", "opencode_output" },
--             },
--             ft = { "markdown", "Avante", "copilot-chat", "opencode_output" },
--         },
--         -- Optional, for file mentions and commands completion, pick only one
--         "saghen/blink.cmp",
--         -- 'hrsh7th/nvim-cmp',
--
--         -- Optional, for file mentions picker, pick only one
--         "folke/snacks.nvim",
--         -- 'nvim-telescope/telescope.nvim',
--         -- 'ibhagwan/fzf-lua',
--         -- 'nvim_mini/mini.nvim',
--     },
-- }
-- OpenCode.nvim configuration for AI-powered coding assistance
-- Provides interactive AI chat and code generation capabilities within Neovim
return {
    "NickvanDyke/opencode.nvim",
    dependencies = {
        -- Recommended for better prompt input, and required to use `opencode.nvim`'s embedded terminal — otherwise optional
        { "folke/snacks.nvim", opts = { input = { enabled = true } } },
    },
    config = function()
        -- Global configuration options for opencode.nvim
        -- Can be customized with various settings (see lua/opencode/config.lua for available options)
        vim.g.opencode_opts = {
            -- Your configuration, if any — see `lua/opencode/config.lua`
            provider = {
                snacks = {
                    win = {
                        width = 85,
                        wo = {
                            winfixwidth = true,
                        },
                    },
                },
            },
        }

        -- Enable automatic file reloading when files are changed externally
        -- Required for opencode's auto_reload functionality to work properly
        vim.opt.autoread = true

        ----------------------------------------------------------------------
        -- Keymaps
        ----------------------------------------------------------------------
        -- Load custom keybinding configurations for opencode functionality
        local mappings = require("nairovim.plugins.customizations.keymaps.opencode").mappings
        local common_utils = require("nairovim.utils.common")
        -- Apply the keymaps using the common utility function
        common_utils.map(mappings)
    end,
}
