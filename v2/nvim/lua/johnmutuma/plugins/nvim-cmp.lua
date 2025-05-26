return {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter" },
    dependencies = {
        "L3MON4D3/LuaSnip",
        "neovim/nvim-lspconfig",
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-path",
        "rafamadriz/friendly-snippets",
        "hrsh7th/cmp-nvim-lsp",
        "onsails/lspkind.nvim",
    },
    config = function()
        local workspace_utils = require("johnmutuma.utils.workspace")
        local vs_path = workspace_utils.find_file_in_closest_dir(".vscode", "nova.code-snippets")
        if vs_path then
            require("luasnip.loaders.from_vscode").lazy_load({ paths = { vs_path } })
        end

        local lspkind = require("lspkind")
        local luasnip = require("luasnip")
        local cmp = require("cmp")

        cmp.setup({
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            formatting = {
                format = lspkind.cmp_format({
                    mode = "symbol_text",
                    maxwidth = 50,
                    ellipsis_char = "...",
                    -- Removed unused 'entry' parameter for clarity
                    before = function(_, vim_item)
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
                ["<CR>"] = cmp.mapping.confirm({ select = true }),
            }),
            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "luasnip" },
                { name = "buffer" },
            }),
        })
    end,
}
