local M = {}
---
function M.get()
    --- @type nairovim.highlightspec
    return {
        NvimTreeGitDirtyIcon = { fg = "red" },
        NvimTreeModifiedIcon = { fg = "red" },
    }
end
return M
