local M = {}
local snacks = require("snacks")

--- @type nairovim.KeymapDef[]
M.mappings = {
    {
        mode = "n",
        key_sequence = "<leader>G",
        handler = function()
            snacks.lazygit()
        end,
        desc = "Open LazyGit",
    },
}

return M
