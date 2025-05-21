local vim = vim

-- colorscheme
local globl = vim.g

local keymap = vim.keymap
globl.sonokai_enable_italic = true

return {
    -- Colorschemes
    {
        { "Shatur/neovim-ayu", event = { "VeryLazy" } },
        { "ellisonleao/gruvbox.nvim", event = { "VeryLazy" } },
        { "Mofiqul/vscode.nvim", event = { "VeryLazy" } },
        { "folke/tokyonight.nvim", event = { "VeryLazy" } },
        { "catppuccin/nvim", name = "catppuccin", event = { "VeryLazy" } },
        {
            "EdenEast/nightfox.nvim",
            priority = 1000,
            init = function()
                keymap.set("n", "<leader>DD", ":colorscheme tokyonight-night<CR>")
                keymap.set("n", "<leader>LL", ":colorscheme dayfox<CR>")
                vim.cmd("colorscheme tokyonight-night")
            end,
        },
    },

    -- Editing Enhancements
    {
        { "sindrets/diffview.nvim" },
        { "mattn/emmet-vim", event = { "BufReadPre", "BufNewFile" } },
        { "unblevable/quick-scope" },
        { "junegunn/vim-peekaboo" },
        -- { "ctrlpvim/ctrlp.vim" },
        { "windwp/nvim-ts-autotag", event = { "BufReadPre", "BufNewFile" } },
        { "tpope/vim-surround", event = { "BufReadPre", "BufNewFile" } },
        { "vim-scripts/ReplaceWithRegister", event = { "BufReadPre", "BufNewFile" } },
        { "machakann/vim-highlightedyank", event = { "BufReadPre", "BufNewFile" } },
    },

    -- UI/UX
    {
        {
            "folke/which-key.nvim",
            event = "VeryLazy",
            opts = {
                delay = 700,
            },
        },
        {
            "folke/zen-mode.nvim",
            opts = {
                window = {
                    width = 200,
                },
            },
        },
        {
            "folke/snacks.nvim",
            opts = {
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
            },
        },
    },

    -- Search/Replace
    {
        {
            "MagicDuck/grug-far.nvim",
            config = function()
                require("grug-far").setup({})
            end,
        },
    },

    -- Markdown
    {
        {
            "iamcco/markdown-preview.nvim",
            cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
            ft = { "markdown" },
            build = function()
                vim.fn["mkdp#util#install"]()
            end,
        },
    },
}
