local run_command = require("nairovim.utils.common").run_command

local M = {}

--- Get a list of git branches (local)
function M.get_git_branches()
    local result, err = run_command("git branch --format='%(refname:short)'")
    if not result then
        return nil, err
    end
    local branches = {}
    for branch in result:gmatch("[^\r\n]+") do
        -- Remove possible leading/trailing whitespace and single quotes
        branch = branch:match("^%s*'?([^']*)'?%s*$")
        if branch and branch ~= "" then
            table.insert(branches, branch)
        end
    end
    return branches
end

--- Get the git diff against a given branch name or staged/unstaged
-- @param branch string: The branch name, "staged", or "unstaged"
-- @param git_dir string|nil: Optional git directory
-- @return string|nil: The diff output, or nil on error
-- @return string|nil: Error message if any
function M.get_git_diff(branch, git_dir)
    branch = branch or "unstaged"
    if branch == "" then
        return nil, "No branch name provided"
    end

    local cmd = { "git" }
    if git_dir and git_dir ~= "" then
        table.insert(cmd, "-C")
        table.insert(cmd, git_dir)
    end
    table.insert(cmd, "diff")
    table.insert(cmd, "--no-color")
    table.insert(cmd, "--no-ext-diff")

    if branch == "staged" then
        table.insert(cmd, "--staged")
    elseif branch == "unstaged" then
        -- No extra argument needed for unstaged, just show working tree diff
    else
        table.insert(cmd, branch)
    end

    local result, err = run_command(table.concat(cmd, " "))
    if not result then
        return nil, err
    end
    return result
end

return M
