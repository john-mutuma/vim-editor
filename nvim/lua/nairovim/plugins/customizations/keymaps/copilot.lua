----------------------------------------------------------------------
-- Copilot AI Keymaps (nairovim.KeymapDef[])
----------------------------------------------------------------------
local M = {}

---@type nairovim.KeymapDef[]
M.mappings = {
    -- Tab: Accept Copilot suggestion or fallback to snippet/tab
    {
        mode = "i",
        key_sequence = "<Tab>",
        handler = function()
            local suggestion = require("copilot.suggestion")
            if suggestion.is_visible() then
                suggestion.accept()
                return ""
            else
                -- Fallback to snippet jump or normal tab
                return vim.snippet.active({ direction = 1 }) and "<Cmd>lua vim.snippet.jump(1)<CR>" or "<Tab>"
            end
        end,
        opts = { expr = true, silent = true, desc = "Copilot: Accept suggestion or Tab" },
    },
    -- Ctrl+]: Dismiss Copilot suggestion
    {
        mode = "i",
        key_sequence = "<C-]>",
        handler = function()
            require("copilot.suggestion").dismiss()
        end,
        opts = { silent = true, desc = "Copilot: Dismiss suggestion" },
    },
}

return M
