local common_utils = require("nairovim.utils.common")
local uv = vim.loop

local M = {}

----------------------------------------------------------------------
-- 1. Directory and File Search Utilities
----------------------------------------------------------------------

--- Find the closest directory by name upwards from a starting directory.
-- @param dirname string: The directory name to search for.
-- @param start_dir string|nil: The directory to start searching from (defaults to cwd).
-- @return string|nil: The path to the closest directory found, or nil if not found.
function M.find_closest_dir_by_name(dirname, start_dir)
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

--- Find a file in the closest directory by name upwards from a starting directory.
-- @param dirname string: The directory name to search for.
-- @param filename string: The file name to search for within the found directory.
-- @param start_dir string|nil: The directory to start searching from (defaults to cwd).
-- @return string|nil: The path to the file if found, or nil.
function M.find_file_in_closest_dir(dirname, filename, start_dir)
    local dir = M.find_closest_dir_by_name(dirname, start_dir)
    if not dir then
        return nil
    end
    local file_path = dir .. "/" .. filename
    local stat = uv.fs_stat(file_path)
    if stat and stat.type == "file" then
        return file_path
    end
    return nil
end

--- Load and optionally parse a file (JSON if needed) from the closest directory.
-- @param dirname string: The directory name to search for.
-- @param filename string: The file name to load.
-- @param start_dir string|nil: The directory to start searching from (defaults to cwd).
-- @return string|table|nil: The file content as a string, or parsed JSON table, or nil.
function M.load_file_from_closest_dir(dirname, filename, start_dir)
    local file_path = M.find_file_in_closest_dir(dirname, filename, start_dir)
    if not file_path then
        return nil
    end
    local content = common_utils.get_file_content(file_path)
    if filename:match("%.json$") then
        return common_utils.parse_json_safe(content)
    end
    return content
end

----------------------------------------------------------------------
-- 2. VSCode Workspace Utilities
----------------------------------------------------------------------

--- Loads and parses a JSON file from the closest VSCode workspace directory.
-- @param filename string: The file name to load from the .vscode directory.
-- @param start_dir string|nil: The directory to start searching from (defaults to cwd).
-- @return table|string|nil: The parsed JSON table, file content as string, or nil.
local function load_file_from_vscode_workspace_dir(filename, start_dir)
    return M.load_file_from_closest_dir(".vscode", filename, start_dir)
end

----------------------------------------------------------------------
-- 3. LSP and Null-LS Configuration
----------------------------------------------------------------------

--- List of LSP servers to ensure are installed.
M.ensure_installed_lsp = {
    "ts_ls",
    "html",
    "cssls",
    "lua_ls",
    "eslint",
    "gopls",
    "jsonls",
}

--- List of null-ls sources to ensure are installed.
M.ensure_installed_null_ls = {
    "prettierd",
    "stylua",
    "cspell",
    "gofumpt",
    "markdownlint",
}

----------------------------------------------------------------------
-- 4. VSCode Workspace Settings Integration
----------------------------------------------------------------------

-- Load VSCode workspace settings and expose relevant ESLint options.
local settings = load_file_from_vscode_workspace_dir("settings.json")
if settings then
    --- ESLint options from VSCode workspace settings.
    M.eslintOptions = settings["eslint.options"]
    --- ESLint execArgv from VSCode workspace settings.
    M.eslintExecArgv = settings["eslint.execArgv"]
    --- ESLint working directories from VSCode workspace settings.
    M.eslintWorkingDirectories = settings["eslint.workingDirectories"] or {}
    --- ESLint code action on save configuration.
    M.eslintCodeActionOnSave = {
        enable = true,
        rules = settings["eslint.codeActionOnSave.rules"],
    }
    --- Whether to run ESLint in quiet mode.
    M.eslintQuiet = false

    M.maxTsServerMemory = settings["typescript.tsserver.maxTsServerMemory"]
end

return M
