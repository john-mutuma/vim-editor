local common_utils = require("johnmutuma.utils.common")
local uv = vim.loop

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

-- Find the closest .vscode/settings.json file upwards from start_dir
local function find_closest_vscode_settings(start_dir)
    local dir = start_dir or uv.cwd()
    while dir do
        local settings_path = dir .. "/.vscode/settings.json"
        local stat = uv.fs_stat(settings_path)
        if stat and stat.type == "file" then
            return settings_path
        end
        -- Use vim.fs.dirname if available, fallback to pattern
        local parent = vim.fs and vim.fs.dirname and vim.fs.dirname(dir) or dir:match("(.+)/[^/]+$")
        if parent == dir or not parent then
            break
        end
        dir = parent
    end
    return nil
end

-- Cache parsed settings for performance
local function load_vscode_settings()
    local settings_path = find_closest_vscode_settings()
    if not settings_path then
        return nil
    end
    local settings_content = common_utils.get_file_content(settings_path)
    return common_utils.parse_json_safe(settings_content)
end

local settings = load_vscode_settings()

if settings then
    M.eslintOptions = settings["eslint.options"]
    M.eslintExecArgv = settings["eslint.execArgv"]
    M.eslintWorkingDirectories = settings["eslint.workingDirectories"] or {}
    M.eslintCodeActionOnSave = {
        enable = true,
        rules = settings["eslint.codeActionOnSave.rules"],
    }
    M.eslintQuiet = false
end

return M
