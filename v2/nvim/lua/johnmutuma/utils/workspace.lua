local common_utils = require("johnmutuma.utils.common")

local M = {}

-- LSP (Language server) clients to ensure are installed with Mason
M.ensure_installed_lsp = {
    "ts_ls",
    "html",
    "cssls",
    "lua_ls",
    "eslint",
    "gopls",
    "jsonls",
}

-- Null-ls - Code formatters, linters, fixers, etc. installed with Mason
M.ensure_installed_null_ls = {
    "prettierd",
    "stylua",
    "cspell",
    "gofumpt",
}

local function find_closest_vscode_settings(start_dir)
    local uv = vim.loop
    local dir = start_dir or uv.cwd()
    while dir do
        local settings_path = dir .. "/.vscode/settings.json"
        local stat = uv.fs_stat(settings_path)
        if stat and stat.type == "file" then
            return settings_path
        end
        local parent = dir:match("(.+)/[^/]+$")
        if parent == dir or not parent then
            break
        end
        dir = parent
    end
    return nil
end

local settings_content = common_utils.get_file_content(find_closest_vscode_settings())
local settings = common_utils.parse_json_safe(settings_content)

if not settings then
    return M
end

M.eslintOptions = settings["eslint.options"]
M.eslintExecArgv = settings["eslint.execArgv"]
M.eslintWorkingDirectories = settings["eslint.workingDirectories"] or {}
M.eslintCodeActionOnSave = {
    enable = true,
    rules = settings["eslint.codeActionOnSave.rules"],
}
M.eslintQuiet = false

return M
