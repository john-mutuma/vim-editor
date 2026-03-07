return {
    "folke/snacks.nvim",
    init = function()
        vim.ui.select = require("snacks").picker.select
        vim.notify = require("snacks").notifier.notify

        -- Keymaps for LazyGit
        local common_utils = require("nairovim.utils.common")
        local mappings = require("nairovim.plugins.customizations.keymaps.lazygit").mappings
        common_utils.map(mappings)
    end,
    config = function()
        local Snacks = require("snacks")
        Snacks.setup({
            notifier = { enabled = true, style = "fancy" },
            input = { enabled = true },
            words = { enabled = true },
            scroll = { enabled = true },
            terminal = { enabled = true },

            lazygit = {
                configure = true,
                config = {
                    os = {
                        -- nvim-remote generates bash syntax that fails on cmd.exe
                        editPreset = vim.fn.has("win32") == 1 and "nvim" or "nvim-remote",
                    },
                },
                win = {
                    border = "rounded",
                    width = 0.8,
                    wo = {
                        winblend = 6,
                    },
                },
            },
            dashboard = {
                pick = function(arg)
                    return Snacks.picker.pick(arg)
                end,
                preset = {
                    header = (function()
                        local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
                        return string.format(
                            [[
 _   _       _       __      _______ __  __
| \ | |     (_)      \ \    / /_   _|  \/  |
|  \| | __ _ _ _ __ __\ \  / /  | | | \  / |
| . ` |/ _` | | '__/ _ \ \/ /   | | | |\/| |
| |\  | (_| | | | | (_) \  /   _| |_| |  | |
|_| \_|\__,_|_|_|  \___/ \/   |_____|_|  |_|


Hey there! Welcome. Enjoy a focused dev experience with NairoVIM.

You are in %s
   ]],
                            string.upper(cwd)
                        )
                    end)(),
                    keys = (function()
                        local keys_before = {
                            {
                                icon = " ",
                                key = "f",
                                desc = "Find File",
                                action = ":lua Snacks.dashboard.pick('files')",
                            },
                            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
                            {
                                icon = "📚",
                                key = "t",
                                desc = "Interactive Tutorial",
                                action = ":lua require('nairovim.utils.tutorial').start()",
                            },
                            { icon = " ", key = "F", desc = "Find/Replace", action = ":FindReplace" },
                            {
                                icon = " ",
                                key = "g",
                                desc = "Fuzzy Find Text",
                                action = ":lua Snacks.dashboard.pick('live_grep')",
                            },
                            {
                                icon = " ",
                                key = "r",
                                desc = "Recent Files",
                                action = ":lua Snacks.dashboard.pick('oldfiles')",
                            },
                            {
                                icon = " ",
                                key = "G",
                                desc = "Git",
                                action = ":lua Snacks.lazygit()",
                            },
                        }

                        local ai_entries = {
                            {
                                icon = " ",
                                key = "A",
                                desc = "AI Hub (Agent CLIs)",
                                action = ":lua require('sidekick.cli').select()",
                            },
                        }

                        local keys_after = {
                            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
                            {
                                icon = " ",
                                key = "c",
                                desc = "Config",
                                action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
                            },
                            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
                            -- { icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
                            { icon = " ", key = "m", desc = "Mason", action = ":Mason" },
                            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
                        }

                        return vim.list_extend(vim.list_extend(keys_before, ai_entries), keys_after)
                    end)(),
                },
            },
        })
    end,
}
