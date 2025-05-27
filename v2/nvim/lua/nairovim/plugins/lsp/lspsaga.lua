return {
    "glepnir/lspsaga.nvim",
    branch = "main",
    event = { "LspAttach" },
    config = function()
        require("lspsaga").setup({
            ui = {
                code_action = "",
                border = "rounded",
            },
            finder = {
                keys = {
                    close = "<C-c>k",
                    quit = { "<C-c>k", "<C-[>" },
                },
            },
        })

        ----------------------------------------------------------------------
        -- 4. LSP Keymaps (on LspAttach)
        ----------------------------------------------------------------------
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("glance_lspattach_augroup", { clear = true }),
            callback = function(args)
                local bufnr = args.buf
                -- local client = vim.lsp.get_client_by_id(args.data.client_id)

                local mappings = require("nairovim.plugins.customizations.keymaps.lspsaga").mappings
                local common_utils = require("nairovim.utils.common")
                common_utils.map(mappings, bufnr)
            end,
        })
    end,
}
