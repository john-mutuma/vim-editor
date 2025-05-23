local vim = vim

return {
    "mason-org/mason.nvim",
    dependencies = {
        "mason-org/mason-lspconfig.nvim",
        "jay-babu/mason-null-ls.nvim",
        "neovim/nvim-lspconfig",
    },
    config = function()
        ----------------------------------------------------------------------
        -- 1. Module & Workspace Caching
        ----------------------------------------------------------------------
        local mason = require("mason")
        local mason_lspconfig = require("mason-lspconfig")
        local mason_null_ls = require("mason-null-ls")
        local workspace = require("johnmutuma.utils.workspace")

        ----------------------------------------------------------------------
        -- 2. Workspace Settings Extraction
        ----------------------------------------------------------------------
        local eslint_opts = {
            options = workspace.eslintOptions,
            workingDirectory = workspace.eslintWorkingDirectories and workspace.eslintWorkingDirectories[1] or nil,
            workingDirectories = workspace.eslintWorkingDirectories,
            codeActionOnSave = workspace.eslintCodeActionOnSave,
            execArgv = workspace.eslintExecArgv,
            quiet = workspace.eslintQuiet,
        }
        local ensure_lsp = workspace.ensure_installed_lsp
        local ensure_null_ls = workspace.ensure_installed_null_ls

        ----------------------------------------------------------------------
        -- 3. LSP Capabilities
        ----------------------------------------------------------------------
        local capabilities = vim.lsp.protocol.make_client_capabilities()

        ----------------------------------------------------------------------
        -- 4. ESLint LSP Setup
        ----------------------------------------------------------------------
        vim.lsp.config("eslint", {
            capabilities = capabilities,
            settings = eslint_opts,
        })

        ----------------------------------------------------------------------
        -- 5. Mason UI Setup
        ----------------------------------------------------------------------
        mason.setup({
            ui = { border = "single" },
        })

        ----------------------------------------------------------------------
        -- 6. Mason LSPConfig Setup
        ----------------------------------------------------------------------
        mason_lspconfig.setup({
            ensure_installed = ensure_lsp,
        })

        ----------------------------------------------------------------------
        -- 7. Mason Null-LS Setup
        ----------------------------------------------------------------------
        mason_null_ls.setup({
            ensure_installed = ensure_null_ls,
            automatic_installation = false,
            handlers = {},
        })

        -- --------------------------------------------------------------------
        -- 8. (Optional) DAP Configuration Placeholders
        -- --------------------------------------------------------------------
        -- -- Configure DAP bucket
        -- -- Configure mason-nvim-dap Debuggers
    end,
}
