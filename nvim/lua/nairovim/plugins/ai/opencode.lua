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
        -- Auto-cleanup OpenCode server processes on exit
        ----------------------------------------------------------------------
        -- OpenCode (Bun/TS) ignores SIGHUP, which is what Neovim sends when
        -- a terminal buffer is deleted. The built-in stop() alone is
        -- insufficient on Linux/macOS — the process survives as an orphan.
        -- On Windows, Neovim uses TerminateProcess() so stop() works fine.
        -- See: https://github.com/anomalyco/opencode/issues/14504
        --      https://github.com/anomalyco/opencode/issues/12767

        vim.api.nvim_create_autocmd("VimLeavePre", {
            group = vim.api.nvim_create_augroup("OpenCodeCleanup", { clear = true }),
            callback = function()
                -- Graceful: close the Snacks terminal buffer
                pcall(require("opencode").stop)

                -- Safety net: explicitly kill processes for this project
                if vim.fn.has("unix") == 1 then
                    local cwd = vim.fn.getcwd()
                    local pids = vim.fn.systemlist("pgrep -f 'opencode --port' 2>/dev/null")

                    for _, pid in ipairs(pids) do
                        pid = vim.trim(pid)
                        if pid ~= "" then
                            local proc_cwd = ""
                            if vim.fn.has("linux") == 1 then
                                proc_cwd = vim.trim(vim.fn.system(
                                    string.format("readlink /proc/%s/cwd 2>/dev/null", pid)
                                ))
                            elseif vim.fn.has("mac") == 1 then
                                proc_cwd = vim.trim(vim.fn.system(
                                    string.format("lsof -a -p %s -d cwd -Fn 2>/dev/null | grep '^n' | cut -c2-", pid)
                                ))
                            end

                            if proc_cwd == cwd then
                                -- Negative PID kills the entire process group (child LSPs too)
                                vim.fn.system(string.format("kill -15 -%s 2>/dev/null", pid))
                                vim.defer_fn(function()
                                    vim.fn.system(string.format("kill -9 -%s 2>/dev/null", pid))
                                end, 500)
                            end
                        end
                    end
                end
            end,
        })
    end,
}
