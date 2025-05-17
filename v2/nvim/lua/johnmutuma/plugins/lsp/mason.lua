local vim = vim

return {
    "mason-org/mason.nvim",
    dependencies = {
        "mason-org/mason-lspconfig.nvim",
        "jay-babu/mason-null-ls.nvim",
        "nvimtools/none-ls.nvim",
        "neovim/nvim-lspconfig",
    },
    config = function()
        local mason = require("mason")
        local mason_lspconfig = require("mason-lspconfig")
        local mason_null_ls = require("mason-null-ls")
        local workspaceSettings = require("johnmutuma.utils.workspace")
        -- Extract workspace settings for clarity and performance
        local eslintOptions = workspaceSettings.eslintOptions
        local eslintWorkingDirectories = workspaceSettings.eslintWorkingDirectories
        local eslintCodeActionOnSave = workspaceSettings.eslintCodeActionOnSave
        local eslintExecArgv = workspaceSettings.eslintExecArgv

        local eslintQuiet = workspaceSettings.eslintQuiet
        local ensure_installed_lsp = workspaceSettings.ensure_installed_lsp
        local ensure_installed_null_ls = workspaceSettings.ensure_installed_null_ls

        local capabilities = vim.lsp.protocol.make_client_capabilities()


        vim.lsp.config("eslint", {
            capabilities = capabilities,
            settings = {
                options = eslintOptions,
                workingDirectory = eslintWorkingDirectories and eslintWorkingDirectories[1],
                workingDirectories = eslintWorkingDirectories,
                codeActionOnSave = eslintCodeActionOnSave,
                execArgv = eslintExecArgv,
                quiet = eslintQuiet,
            },
        })
        mason.setup({
            ui = { border = "single" },
        })

        mason_lspconfig.setup({
            ensure_installed = ensure_installed_lsp,
        })

        mason_null_ls.setup({

            ensure_installed = ensure_installed_null_ls,
            automatic_installation = false,
            handlers = {},
        })

        -- Configure DAP bucket
        -- Configure mason-nvim-dap Debuggers
    end,
}
