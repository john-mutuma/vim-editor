local M = {}

function M.get()
    --- @type nairovim.highlightspec
    return {
        LazyGitBorder = { link = "FloatBorder" },
    }
end

return M
