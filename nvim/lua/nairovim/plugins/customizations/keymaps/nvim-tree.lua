local M = {}

--- @type nairovim.KeymapDef[]
M.mappings = {
    {
        mode = "n",
        key_sequence = "<C-n>",
        handler = ":NvimTreeToggle<CR>",
        opts = { silent = true, desc = "Toggle NvimTree file explorer" },
    },
}

return M
