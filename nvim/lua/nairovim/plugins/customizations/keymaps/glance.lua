----------------------------------------------------------------------
-- 1. Glance LSP Keymaps (nairovim.KeymapDef[])
----------------------------------------------------------------------
local M = {}

---@type nairovim.KeymapDef[]
M.mappings = {
    -- Glance
    {
        mode = "n",
        key_sequence = "gR",
        handler = "<cmd>Glance references<CR>",
        opts = { desc = "LSP: References (Glance)" },
    },
    {
        mode = "n",
        key_sequence = "gd",
        handler = "<cmd>Glance definitions<CR>",
        opts = { desc = "LSP: Definitions (Glance)" },
    },
    {
        mode = "n",
        key_sequence = "gi",
        handler = "<cmd>Glance implementations<CR>",
        opts = { desc = "LSP: Implementations (Glance)" },
    },
    {
        mode = "n",
        key_sequence = "gT",
        handler = "<cmd>Glance type_definitions<CR>",
        opts = { desc = "LSP: Type Definitions (Glance)" },
    },
}

return M
