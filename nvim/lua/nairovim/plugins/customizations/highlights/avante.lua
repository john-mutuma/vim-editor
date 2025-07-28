local M = {}

function M.get()
    --- @type nairovim.highlightspec
    return {
        AvanteSidebarWinHorizontalSeparator = { link = "MiniTablineTabpagesection" },
        AvantePromptInputBorder = { link = "FloatBorder" },
        AvanteSidebarWinSeparator = { link = "FloatBorder" },
    }
end

return M
