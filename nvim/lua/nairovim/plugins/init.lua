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
        { "folke/tokyonight.nvim", event = { "VeryLazy" } },
        { "catppuccin/nvim", name = "catppuccin", event = { "VeryLazy" } },
        {
            "EdenEast/nightfox.nvim",
            priority = 1000,
            init = function()
                keymap.set("n", "<leader>DD", ":colorscheme tokyonight-night<CR>")
                keymap.set("n", "<leader>LL", ":colorscheme tokyonight-day<CR>")
                vim.cmd("colorscheme tokyonight-night")
                -- vim.cmd("colorscheme gruvbox")
            end,
        },
    },

    -- Editing Enhancements
    {
        { "sindrets/diffview.nvim" },
        { "mattn/emmet-vim", event = { "BufReadPre", "BufNewFile" } },
        { "unblevable/quick-scope" },
        { "junegunn/vim-peekaboo" },
        { "windwp/nvim-ts-autotag", event = { "BufReadPre", "BufNewFile" } },
        { "tpope/vim-surround", event = { "BufReadPre", "BufNewFile" } },
        { "vim-scripts/ReplaceWithRegister", event = { "BufReadPre", "BufNewFile" } },
        { "machakann/vim-highlightedyank", event = { "VeryLazy" } },
    },

    -- UI/UX
    {
        {
            "folke/which-key.nvim",
            event = "VeryLazy",
            opts = {
                delay = 850,
                win = {
                    border = "rounded",
                },
            },
        },
    },

    -- Search/Replace
    -- Search and replace functionality provided by scooter terminal (keybinding: <leader>s)

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
        {
            -- Make sure to set this up properly if you have lazy=true
            "MeanderingProgrammer/render-markdown.nvim",
            opts = {
                file_types = {
                    "markdown",
                    "Avante",
                    "mcphub",
                    "copilot-chat",
                    "opencode_terminal",
                    "opencode_output",
                    "opencode",
                },
                code = {
                    sign = false,
                    language_border = "",
                },
            },
            ft = { "markdown", "Avante", "mcphub", "copilot-chat" },
        },
    },

    -- Other utility plugins
    -- Terminal functionality provided by Snacks.nvim
}
