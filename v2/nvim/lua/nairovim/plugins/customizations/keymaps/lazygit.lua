local M = {}

--- @type nairovim.KeymapDef[]
M.mappings = {
    {
        mode = "n",
        key_sequence = "<leader>G",
        handler = ":LazyGit<CR>",
        desc = "Open LazyGit",
    },
}

return M
