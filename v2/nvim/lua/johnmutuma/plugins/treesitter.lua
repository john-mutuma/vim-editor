local opt = vim.opt

opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldenable = true --  Enable/Disable folding at startup.
opt.foldlevel = 2

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
        local treesitter = require("nvim-treesitter.configs")
        local treesitter_autotag = require("nvim-ts-autotag")

        treesitter.setup({
            highlight = { enable = true },
            indent = { enable = true },
            auto_tag = { enable = true },
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

        treesitter_autotag.setup({
            opts = {
                -- Defaults
                enable_close = true,          -- Auto close tags
                enable_rename = true,         -- Auto rename pairs of tags
                enable_close_on_slash = true, -- Auto close on trailing </
            },
        })
    end,
}
