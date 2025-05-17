return {
    "hrsh7th/nvim-cmp",                 -- completion engine : needs to configure snippet engine in setup config e.g., luasnip, vsnip, ultisnip, snippy
    event = { "InsertEnter" },          -- lazy load when enter insert mode
    dependencies = {
        "L3MON4D3/LuaSnip",             -- snippet engine
        "neovim/nvim-lspconfig",        -- support lsp intergration in cmp window

        "saadparwaiz1/cmp_luasnip",     -- snippet source for LuaSnip
        "hrsh7th/cmp-buffer",           -- snippet source for buffer
        "hrsh7th/cmp-cmdline",          -- snippet source for cmdline
        "hrsh7th/cmp-path",             -- snippet source for path
        "rafamadriz/friendly-snippets", -- snippet source for various programming languages
        -- cmp lsp deps
        "hrsh7th/cmp-nvim-lsp",         -- - nvim source for nvims builtin language server client
        "onsails/lspkind.nvim",         -- add pictograms i.e. icons and/or labels to the cmp window
    },
    config = function()
        require("luasnip.loaders.from_vscode").lazy_load({
            paths = { "./.vscode/nova.code-snippets", "./.vscode/fluent.code-snippets" },
        })
        local lspkind = require("lspkind")
        local luasnip = require("luasnip")
        local cmp = require("cmp")

        cmp.setup({
            snippet = {
                -- REQUIRED - you must specify a snippet engine
                expand = function(args)
                    luasnip.lsp_expand(args.body) -- For `luasnip` users.
                    -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
                    -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
                    -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
                end,
            },
            formatting = {
                format = lspkind.cmp_format({
                    mode = "symbol_text",  -- show only symbol annotations
                    maxwidth = 50,         -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                    ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)

                    -- The function below will be called before any actual modifications from lspkind
                    -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
                    before = function(entry, vim_item)
                        -- ...
                        return vim_item
                    end,
                }),
            },
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
            mapping = cmp.mapping.preset.insert({
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-c>"] = cmp.mapping.abort(),
                ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
            }),
            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "luasnip" }, -- For luasnip users.
                -- { name = 'vsnip' }, -- For vsnip users.
                -- { name = 'ultisnips' }, -- For ultisnips users.
                -- { name = 'snippy' }, -- For snippy users.
                { name = "buffer" },
            }),
        })
    end,
}
