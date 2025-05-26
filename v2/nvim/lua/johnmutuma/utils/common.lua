local M = {}

----------------------------------------------------------------------
-- 1. Remove Comments from JSON String
----------------------------------------------------------------------

--- Strips single-line comments (//) from a JSON string.
-- @param str string: The JSON string with possible comments.
-- @return string: The JSON string without comments.
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
-- @param file_path string: Path to the file.
-- @return string|nil: File content or nil if error.
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
-- @param json_str string: The JSON string to parse.
-- @return table|nil: Parsed table or nil if error.
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

return M
