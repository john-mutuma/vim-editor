local common_utils = require("johnmutuma.utils.common")
local uv = vim.loop
local M = {}

-- Find the closest .vscode/settings.json file upwards from start_dir
M.find_closest_vscode_dir = function(start_dir)
    local dir = start_dir or uv.cwd()
    while dir and dir ~= "" do
        local vscode_path = dir .. "/.vscode"
        local stat = uv.fs_stat(vscode_path)
        if stat and stat.type == "directory" then
            return vscode_path
        end
        local parent = dir:match("^(.*)/[^/]+$")
        if not parent or parent == dir then
            break
        end
        dir = parent
    end
    return nil
end

local function find_file_in_closest_vscode_dir(filename, start_dir)
    local vscode_dir = M.find_closest_vscode_dir(start_dir)
    if vscode_dir then
        local settings_path = vscode_dir .. "/" .. filename
        local stat = uv.fs_stat(settings_path)
        if stat and stat.type == "file" then
            return settings_path
        end
    end
    return nil
end

--- Loads and parses a JSON file from the closest VSCode workspace directory.
-- Cache parsed settings for performance
-- @param filename string: The name of the file to load (e.g., 'settings.json').
-- @return table|nil: Parsed JSON table if the file exists and is valid, otherwise nil.
M.load_file_from_vscode_workspace_dir = function(filename)
    local settings_path = find_file_in_closest_vscode_dir(filename)
    if not settings_path then
        return nil
    end
    local settings_content = common_utils.get_file_content(settings_path)
    return common_utils.parse_json_safe(settings_content)
end

--
--
--
--
--
--
-- need to move this from here to a separate workspace settings file
--
--
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

local settings = M.load_file_from_vscode_workspace_dir("settings.json")
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
