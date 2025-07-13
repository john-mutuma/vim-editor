return {
    "folke/snacks.nvim",
    init = function()
        vim.ui.select = require("snacks").picker.select
    end,
    config = function()
        local Snacks = require("snacks")
        Snacks.setup({
            dashboard = {
                pick = function(arg)
                    return Snacks.picker.pick(arg)
                end,
                preset = {
                    header = [[
 _   _       _       __      _______ __  __
| \ | |     (_)      \ \    / /_   _|  \/  |
|  \| | __ _ _ _ __ __\ \  / /  | | | \  / |
| . ` |/ _` | | '__/ _ \ \/ /   | | | |\/| |
| |\  | (_| | | | | (_) \  /   _| |_| |  | |
|_| \_|\__,_|_|_|  \___/ \/   |_____|_|  |_|


Hey there! Welcome. Enjoy a focused dev experience with NairoVIM.
   ]],
                    keys = {
                        {
                            icon = " ",
                            key = "f",
                            desc = "Find File",
                            action = ":lua Snacks.dashboard.pick('files')",
                        },
                        { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
                        { icon = " ", key = "F", desc = "Find/Replace", action = ":GrugFar" },
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
                            icon = " ",
                            key = "c",
                            desc = "Config",
                            action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
                        },
                        { icon = " ", key = "s", desc = "Restore Session", section = "session" },
                        -- { icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
                        { icon = " ", key = "m", desc = "Mason", action = ":Mason" },
                        { icon = " ", key = "G", desc = "Git", action = ":LazyGit" },
                        { icon = " ", key = "C", desc = "GitHub Copilot", action = ":CopilotChat" },
                        { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
                        { icon = " ", key = "q", desc = "Quit", action = ":qa" },
                    },
                },
            },
        })
    end,
}
