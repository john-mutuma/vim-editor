----------------------------------------------------------------------
-- 1. Treesitter Folding Settings (Buffer-local for performance)
----------------------------------------------------------------------
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "*" },
    callback = function()
        vim.opt_local.foldmethod = "expr"
        vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
        vim.opt_local.foldenable = true
        vim.opt_local.foldlevel = 2
    end,
})

----------------------------------------------------------------------
-- 2. Treesitter Plugin Setup
----------------------------------------------------------------------
return {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    build = function()
        local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
        ts_update()
    end,
    dependencies = {
        -- "nvim-treesitter/nvim-treesitter-textobjects",
        -- "JoosepAlviste/nvim-ts-context-commentstring",
        "windwp/nvim-ts-autotag",
    },
    config = function()
        ----------------------------------------------------------------------
        -- 3. Treesitter Core Configuration
        ----------------------------------------------------------------------

        require("nvim-treesitter.configs").setup({
            highlight = { enable = true },
            indent = { enable = true },
            autotag = { enable = true }, -- Correct key is 'autotag'
            ensure_installed = {
                "json",
                "javascript",
                "typescript",
                "tsx",
                "lua",
                "vim",
                "css",
                "html",
                "markdown",
                "markdown_inline",
                "dockerfile",
                "gitignore",
                "bash",
                "yaml",
                "graphql",
                "c_sharp",
            },
            auto_install = true,
        })
        -- No need to call require("nvim-ts-autotag").setup() separately
    end,
}
