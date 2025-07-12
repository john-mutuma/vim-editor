local vim = vim

return {
    "nvimtools/none-ls.nvim",
    event = "LspAttach",
    dependencies = {
        { "rachartier/tiny-inline-diagnostic.nvim" },
        { "stevearc/conform.nvim", opts = {} },
    },
    config = function()
        -- Cache requires for performance
        local null_ls = require("null-ls")
        local conform = require("conform")
        local tiny_inline_diagnostic = require("tiny-inline-diagnostic")

        -- Helper: Format on save using conform.nvim
        local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = true })
        local function configure_format_on_save(client, bufnr)
            if client.supports_method("textDocument/formatting") then
                vim.api.nvim_create_autocmd("BufWritePre", {
                    group = augroup,
                    buffer = bufnr,
                    callback = function(args)
                        conform.format({ bufnr = args.buf })
                    end,
                })
            end
        end

        ----------------------------------------------------------------------
        -- 1. Setup null-ls (none-ls)
        ----------------------------------------------------------------------
        null_ls.setup({
            debug = false,
            sources = {
                -- Add custom sources here if needed
            },
            on_attach = configure_format_on_save,
            root_dir = function(_)
                return nil
            end,
        })

        ----------------------------------------------------------------------
        -- 2. Diagnostics UI
        ----------------------------------------------------------------------
        vim.diagnostic.config({ virtual_text = false })

        tiny_inline_diagnostic.setup({
            preset = "powerline",
            options = {
                show_source = {
                    enabled = true,
                    if_many = false,
                },
                break_line = {
                    enabled = true,
                    after = 95,
                },
            },
        })

        ----------------------------------------------------------------------
        -- 3. Setup conform.nvim (formatters)
        ----------------------------------------------------------------------
        conform.setup({
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "isort", "black" },
                rust = { "rustfmt", lsp_format = "fallback" },
                javascript = { "prettier", "prettierd", stop_after_first = true },
                javascriptreact = { "prettier", "prettierd", stop_after_first = true },
                typescript = { "prettier", "prettierd", stop_after_first = true },
                typescriptreact = { "prettier", "prettierd", stop_after_first = true },
                json = { "prettier", "prettierd", stop_after_first = true },
            },
        })
    end,
}
