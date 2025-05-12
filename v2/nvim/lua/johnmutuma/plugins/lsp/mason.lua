local _, mason = pcall(require, "mason")
local _, mason_lspconfig = pcall(require, "mason-lspconfig")
local _, mason_null_ls = pcall(require, "mason-null-ls")
local _, workspaceSettings = pcall(require, "johnmutuma.utils.workspace")

-- local _, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
-- local capabilities = cmp_nvim_lsp.default_capabilities()

local capabilities = vim.lsp.protocol.make_client_capabilities()

print("set6tings: ", vim.inspect(workspaceSettings))

vim.lsp.config("eslint", {
    capabilities = capabilities,
    settings = {
        options = workspaceSettings.eslintOptions,
        workingDirectory = workspaceSettings.eslintWorkingDirectories and workspaceSettings.eslintWorkingDirectories[1],
        workingDirectories = workspaceSettings.eslintWorkingDirectories,
        codeActionOnSave = workspaceSettings.eslintCodeActionOnSave,
        execArgv = workspaceSettings.eslintExecArgv,
        quiet = workspaceSettings.eslintQuiet,
    },
})

-- Set up Mason
mason.setup({
    ui = { border = "single" },
})
mason_lspconfig.setup({
    ensure_installed = workspaceSettings.ensure_installed_lsp,
})
mason_null_ls.setup({
    ensure_installed = workspaceSettings.ensure_installed_null_ls,
    automatic_installation = false,
    handlers = {},
})

-- Configure DAP bucket
-- Configure mason-nvim-dap Debuggers
