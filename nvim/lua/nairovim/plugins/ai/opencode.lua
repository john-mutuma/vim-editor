-- return {
--
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
--             ft = { "markdown", "opencode_output" },
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
        local opencode_cmd = "opencode --port"
        ---@type snacks.terminal.Opts
        local snacks_terminal_opts = {
            win = {
                position = "right",
                width = 0.45, -- 45% of screen width
                wo = {
                    winfixwidth = true,
                },
                enter = false,
                on_win = function(win)
                    -- Set up keymaps and cleanup for an arbitrary terminal
                    require("opencode.terminal").setup(win.win)
                end,
            },
        }
        ---@type opencode.Opts
        vim.g.opencode_opts = {
            server = {
                start = function()
                    require("snacks.terminal").open(opencode_cmd, snacks_terminal_opts)
                end,
                stop = function()
                    require("snacks.terminal").get(opencode_cmd, snacks_terminal_opts):close()
                end,
                toggle = function()
                    require("snacks.terminal").toggle(opencode_cmd, snacks_terminal_opts)
                end,
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

        ----------------------------------------------------------------------
        -- Auto-cleanup OpenCode server process on exit
        ----------------------------------------------------------------------
        -- Simply call the configured stop() function when Neovim exits.
        -- This leverages the built-in server lifecycle management.
        
        vim.api.nvim_create_autocmd("VimLeavePre", {
            group = vim.api.nvim_create_augroup("OpenCodeCleanup", { clear = true }),
            callback = function()
                pcall(require("opencode").stop)
            end,
        })
    end,
}
