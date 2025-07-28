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
        "windwp/nvim-ts-autotag",
    },
    config = function()
        ----------------------------------------------------------------------
        -- 3. Treesitter Core Configuration
        ----------------------------------------------------------------------
        require("nvim-treesitter.configs").setup({
            highlight = { enable = true },
            indent = { enable = true },
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

        ----------------------------------------------------------------------
        -- 4. Setup nvim-ts-autotag separately
        ----------------------------------------------------------------------
        require("nvim-ts-autotag").setup({
            opts = {
                enable_close = true, -- Auto close tags
                enable_rename = true, -- Auto rename pairs of tags
                enable_close_on_slash = false, -- Auto close on trailing </
            },
            -- Override individual filetype configs
            per_filetype = {
                ["html"] = {
                    enable_close = false,
                },
            },
        })
    end,
}
