local common_utils = require("johnmutuma.utils.common")
local uv = vim.loop
local M = {}

-- Find the closest directory by name upwards from start_dir
M.find_closest_dir_by_name = function(dirname, start_dir)
    local dir = start_dir or uv.cwd()
    while dir and dir ~= "" do
        local candidate = dir .. "/" .. dirname
        local stat = uv.fs_stat(candidate)
        if stat and stat.type == "directory" then
            return candidate
        end
        local parent = dir:match("^(.*)/[^/]+$")
        if not parent or parent == dir then
            break
        end
        dir = parent
    end
    return nil
end

M.find_file_in_closest_dir = function(dirname, filename, start_dir)
    local dir = M.find_closest_dir_by_name(dirname, start_dir)
    if dir then
        local file_path = dir .. "/" .. filename
        local stat = uv.fs_stat(file_path)
        if stat and stat.type == "file" then
            return file_path
        end
    end
    return nil
end

M.load_file_from_closest_dir = function(dirname, filename, start_dir)
    local file_path = M.find_file_in_closest_dir(dirname, filename, start_dir)
    if not file_path then
        return nil
    end
    local settings_content = common_utils.get_file_content(file_path)
    return common_utils.parse_json_safe(settings_content)
end

-- Loads and parses a JSON file from the closest VSCode workspace directory.
M.load_file_from_vscode_workspace_dir = function(filename, start_dir)
    return M.load_file_from_closest_dir(".vscode", filename, start_dir)
end

M.ensure_installed_lsp = {
    "ts_ls",
    "html",
    "cssls",
    "lua_ls",
    "eslint",
    "gopls",
    "jsonls",
}

M.ensure_installed_null_ls = {
    "prettierd",
    "stylua",
    "cspell",
    "gofumpt",
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
