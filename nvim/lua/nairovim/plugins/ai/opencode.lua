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
        -- Auto-cleanup OpenCode server processes
        ----------------------------------------------------------------------
        -- 1. On Neovim exit: Clean up this session's OpenCode processes
        -- 2. On startup: Clean up orphaned OpenCode processes from dead sessions

        local function kill_opencode_processes(nvim_socket)
            -- Find all OpenCode processes and check if they belong to this session
            local pids = vim.fn.systemlist("pgrep -f 'opencode --port' 2>/dev/null")

            for _, pid in ipairs(pids) do
                local environ_file = "/proc/" .. pid .. "/environ"
                local grep_cmd = string.format("grep -qz 'NVIM=%s' %s 2>/dev/null", nvim_socket, environ_file)
                vim.fn.system(grep_cmd)

                if vim.v.shell_error == 0 then
                    -- Use SIGTERM first for graceful shutdown
                    vim.fn.system(string.format("kill -15 %s 2>/dev/null", pid))
                    -- Wait a bit, then force kill if still alive
                    vim.defer_fn(function()
                        vim.fn.system(string.format("kill -9 %s 2>/dev/null", pid))
                    end, 500)
                end
            end
        end

        local function cleanup_orphaned_processes()
            -- Kill OpenCode processes whose parent Neovim is dead
            local pids = vim.fn.systemlist("pgrep -f 'opencode --port' 2>/dev/null")

            for _, pid in ipairs(pids) do
                local environ = vim.fn.system(string.format("cat /proc/%s/environ 2>/dev/null | tr '\\0' '\\n'", pid))
                local nvim_socket = environ:match("NVIM=([^\n]+)")

                if nvim_socket then
                    -- Extract Neovim PID from socket (e.g., nvim.12345.0 -> 12345)
                    local nvim_pid = nvim_socket:match("nvim%.(%d+)%.")
                    if nvim_pid then
                        -- Check if that Neovim process is still running
                        local check = vim.fn.system(string.format("ps -p %s > /dev/null 2>&1; echo $?", nvim_pid))
                        if check:match("1") then
                            -- Parent is dead, kill the orphan
                            vim.fn.system(string.format("kill -9 %s 2>/dev/null", pid))
                        end
                    end
                end
            end
        end

        -- Clean up orphaned processes on startup (after a short delay to let things settle)
        vim.defer_fn(cleanup_orphaned_processes, 2000)

        -- Clean up this session's processes on exit
        vim.api.nvim_create_autocmd("VimLeavePre", {
            group = vim.api.nvim_create_augroup("OpenCodeCleanup", { clear = true }),
            callback = function()
                local nvim_socket = vim.env.NVIM
                if nvim_socket and nvim_socket ~= "" then
                    kill_opencode_processes(nvim_socket)
                end
            end,
        })
    end,
}
