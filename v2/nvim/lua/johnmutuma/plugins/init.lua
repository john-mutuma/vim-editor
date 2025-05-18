local vim = vim

-- colorscheme
local globl = vim.g

local keymap = vim.keymap
globl.sonokai_enable_italic = true

return {
    -- Colorschemes
    {
        {
            "Shatur/neovim-ayu",
            priority = 1000,
            init = function()
                keymap.set("n", "<leader>DD", ":colorscheme ayu-mirage<CR>")
                keymap.set("n", "<leader>LL", ":colorscheme dayfox<CR>")
                vim.cmd("colorscheme ayu-mirage")
            end,
        },
        { "EdenEast/nightfox.nvim", event = { "VeryLazy" } },
        -- { "ellisonleao/gruvbox.nvim" },
        -- { "Mofiqul/vscode.nvim" },
        -- { "folke/tokyonight.nvim" },
        -- { "catppuccin/nvim",         name = "catppuccin" },
    },

    -- Editing Enhancements
    {
        { "sindrets/diffview.nvim" },
        { "mattn/emmet-vim" },
        { "unblevable/quick-scope" },
        { "junegunn/vim-peekaboo" },
        { "ctrlpvim/ctrlp.vim" },
        { "windwp/nvim-ts-autotag", event = { "BufReadPre", "BufNewFile" } },
        { "tpope/vim-surround" },
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
