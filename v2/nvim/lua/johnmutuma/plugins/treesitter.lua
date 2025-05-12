local opt = vim.opt
local treesitter_ok, treesitter = pcall(require, "nvim-treesitter.configs")
local treesitter_autotag_ok, treesitter_autotag = pcall(require, "nvim-ts-autotag")

if not treesitter_ok then
    print("treesitter could not be loaded")
    return
end

if not treesitter_autotag_ok then
    print("treesitter-autotag could not be loaded")
    return
end

opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldenable = true --  Enable/Disable folding at startup.
opt.foldlevel = 2

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
        enable_close = true, -- Auto close tags
        enable_rename = true, -- Auto rename pairs of tags
        enable_close_on_slash = true, -- Auto close on trailing </
    },
    --
    -- Also override individual filetype configs, these take priority.
    -- Empty by default, useful if one of the "opts" global settings doesn't work well in a specific filetype
    --
    -- per_filetype = {
    --     ["html"] = {
    --         enable_close = false,
    --         enable_close_on_slash = true, -- Auto close on trailing </
    --     },
    -- },
})
