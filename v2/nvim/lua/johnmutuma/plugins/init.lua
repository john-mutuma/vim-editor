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
