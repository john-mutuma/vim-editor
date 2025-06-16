local M = {}

----------------------------------------------------------------------
-- 1. Remove Comments from JSON String
----------------------------------------------------------------------

--- Strips single-line comments (//) from a JSON string.
--- @param str string: The JSON string with possible comments.
--- @return string: The JSON string without comments.
function M.strip_json_comments(str)
    local lines = {}
    for line in str:gmatch("[^\r\n]+") do
        if not line:match("^%s*//") then
            table.insert(lines, line)
        end
    end
    return table.concat(lines, "\n")
end

----------------------------------------------------------------------
-- 2. Read File Content
----------------------------------------------------------------------

--- Reads the entire content of a file.
--- @param file_path string: Path to the file.
--- @return string|nil: File content or nil if error.
function M.get_file_content(file_path)
    if not file_path then
        vim.notify("File path is nil", vim.log.levels.WARN)
        return nil
    end
    local file, err = io.open(file_path, "r")
    if not file then
        vim.notify("Could not open file: " .. file_path, vim.log.levels.ERROR)
        return nil
    end
    local content = file:read("*a")
    file:close()
    if not content then
        vim.notify("No content: " .. file_path, vim.log.levels.WARN)
        return nil
    end
    return content
end

----------------------------------------------------------------------
-- 3. Safe JSON Parsing
----------------------------------------------------------------------

--- Safely parses a JSON string, stripping comments first.
--- @param json_str string: The JSON string to parse.
--- @return table|nil: Parsed table or nil if error.
function M.parse_json_safe(json_str)
    local clean_str = M.strip_json_comments(json_str)
    local ok, result = pcall(vim.fn.json_decode, clean_str)
    if not ok then
        vim.notify("Error parsing JSON: " .. tostring(result), vim.log.levels.ERROR)
        return nil
    end
    return result
end

-- Utility to run a shell command and capture output or error
function M.run_command(cmd)
    local handle = io.popen(cmd)
    if not handle then
        return nil, "Failed to run command: " .. cmd
    end
    local result = handle:read("*a")
    handle:close()
    if not result or result == "" then
        return nil, "No output from command: " .. cmd
    end
    return result
end

----------------------------------------------------------------------
-- 1. Map a list of keymaps using vim.keymap.set
----------------------------------------------------------------------

--- Map a list of keymaps using vim.keymap.set
--- @param mappings nairovim.KeymapDef[] List of keymap definitions
--- @param bufnr integer|nil Buffer number to set the mapping for (optional)
--- @usage
--- ```
--- local mappings = {
---   { mode = "n", key_sequence = "<leader>ff", handler = "<cmd>Telescope find_files<CR>", opts = { noremap = true, silent = true } },
---   { mode = "i", key_sequence = "jk", handler = "<Esc>", opts = { noremap = true } },
--- }
--- require("nairovim.utils.common").map(mappings)
--- -- For buffer-local mappings:
--- -- require("nairovim.utils.common").map(mappings, bufnr)
--- ```
function M.map(mappings, bufnr)
    for _, map_def in ipairs(mappings) do
        local mode = map_def.mode
        local key_sequence = map_def.key_sequence
        local handler = map_def.handler
        local opts = map_def.opts or {}
        if bufnr then
            opts.buffer = bufnr
        end
        vim.keymap.set(mode, key_sequence, handler, opts)
    end
end

--- Applies a set of highlight groups using Neovim's API, and ensures
---   they persist across colorscheme changes.
--- @param get_highlights fun(): nairovim.highlightspec Function that returns a `nairovim.highlightspec`
---   table, where each key is a highlight group name
---   and each value is a table of highlight options (e.g., fg, bg, bold, italic, etc.).
--- @param highlights_groupname string The name of the augroup to use for reapplying highlights
---   on ColorScheme events.
--- @usage
---   M.apply_highlights(function()
---     return {
---       Normal = { fg = "#ffffff", bg = "#000000" },
---       Comment = { fg = "#888888", italic = true },
---     }
---   end, "MyHighlightGroup")
---
--- This function is colorscheme aware: it automatically reapplies the
---   specified highlights whenever the colorscheme changes.
function M.apply_highlights(get_highlights, highlights_groupname)
    for group, opts in pairs(get_highlights()) do
        vim.api.nvim_set_hl(0, group, opts)
    end

    vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup(highlights_groupname, { clear = true }),
        callback = function()
            M.apply_highlights(get_highlights, highlights_groupname)
        end,
    })
end
return M
