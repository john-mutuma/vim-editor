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
    {
        "MagicDuck/grug-far.nvim",
        -- Note (lazy loading): grug-far.lua defers all it's requires so it's lazy by default
        -- additional lazy config to defer loading is not really needed...
        config = function()
            -- optional setup call to override plugin options
            -- alternatively you can set options with vim.g.grug_far = { ... }
            require("grug-far").setup({
                -- options, see Configuration section below
                -- there are no required options atm
            })
        end,
    },
    { "sindrets/diffview.nvim" },
    { "mattn/emmet-vim" },
    { "unblevable/quick-scope" },
    { "junegunn/vim-peekaboo" },
    { "ctrlpvim/ctrlp.vim" },
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
