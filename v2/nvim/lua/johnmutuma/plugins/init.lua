local vim = vim

-- colorscheme
local globl = vim.g

local keymap = vim.keymap
globl.sonokai_enable_italic = true

return {
    --  colorschemes
    -- { "ellisonleao/gruvbox.nvim" },
    -- { "Mofiqul/vscode.nvim" },
    -- { "folke/tokyonight.nvim" },
    -- { "catppuccin/nvim",         name = "catppuccin" },
    {
        "Shatur/neovim-ayu",
        priority = 1000,
        config = function()
            keymap.set("n", "<leader>DD", ":colorscheme ayu-mirage<CR>")
            keymap.set("n", "<leader>LL", ":colorscheme dayfox<CR>")
            vim.cmd("colorscheme ayu-mirage")
        end,
    },
    { "EdenEast/nightfox.nvim",                event = { "VeryLazy" } },
    --
    --
    { "sindrets/diffview.nvim" },
    { "mattn/emmet-vim" },
    { "unblevable/quick-scope" },
    { "junegunn/vim-peekaboo" },
    { "ctrlpvim/ctrlp.vim" },
    { "rachartier/tiny-inline-diagnostic.nvim" },
    { "windwp/nvim-ts-autotag" },
    { "tpope/vim-surround" },
    { "vim-scripts/ReplaceWithRegister" },
    { "machakann/vim-highlightedyank" },
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
    },
    {
        "folke/zen-mode.nvim",
        opts = {
            window = {
                width = 200,
            },
        },
    },
}
