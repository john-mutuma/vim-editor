local vim = vim

-- Format on save helper
local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = true })
local configure_format_on_save = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
                -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
                -- on later neovim version, you should use vim.lsp.buf.format({ async = false }) instead
                vim.lsp.buf.format({ async = false, timeout_ms = 2000 })
            end,
        })
    end
end

return {
    "nvimtools/none-ls.nvim",
    event = "LspAttach",
    config = function()
        -- Configure linters, formatters, diagnostics, code actions
    require("null-ls").setup({
            debug = false,


            sources = {
                -- use this section to add sources unsupported by Mason yet
                -- require("none-ls.diagnostics.eslint").with({
                --     extra_args = eslint_extra_args,
                -- }),
            },
            on_attach = configure_format_on_save,
            root_dir = function(_)
                return nil
            end,
        })

        -- -- setting up diagnostics plugins
        vim.diagnostic.config({ virtual_text = false }) -- Only if needed in your configuration, if you already have native LSP diagnostics

        require("tiny-inline-diagnostic").setup({
            preset = "powerline",
            options = {
                show_source = {
                    enabled = true,
                    if_many = false,
                },
                break_line = {
                    -- Enable the feature to break messages after a specific length
                    enabled = true,
                    -- Number of characters after which to break the line
                    after = 95,
                },
            },
        })
    end,
}
