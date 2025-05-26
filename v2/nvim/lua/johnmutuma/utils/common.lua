local M = {}

M.strip_json_comments = function(str)
    local lines = {}
    for line in str:gmatch("[^\r\n]+") do
        if not line:match("^%s*//") then
            table.insert(lines, line)
        end
    end
    return table.concat(lines, "\n")
end

M.get_file_content = function(file_path)
    if file_path then
        local file = io.open(file_path, "r")
        if not file then
            print("Could not open file: " .. file_path)
            return nil
        end
        local content = file:read("*a")
        file:close()
        if not content then
            print("No content: " .. file_path)
            return nil
        end
        return content
    else
        print("File path is nil")
    end
end

M.parse_json_safe = function(json_str)
    json_str = M.strip_json_comments(json_str)
    local ok, result = pcall(vim.fn.json_decode, json_str)

    if not ok then
        print("Error parsing JSON: " .. result)
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
