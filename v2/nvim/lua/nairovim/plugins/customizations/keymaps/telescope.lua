----------------------------------------------------------------------
-- 1. Telescope Keymaps (nairovim.KeymapDef)
----------------------------------------------------------------------

local builtin = require("telescope.builtin")
local M = {}

--- @type nairovim.KeymapDef[]
M.mappings = {
    {
        mode = "n",
        key_sequence = "<C-F>f",
        handler = builtin.git_files,
        opts = { desc = "Telescope: Git Files" },
    },
    {
        mode = "n",
        key_sequence = "<C-F>s",
        handler = builtin.live_grep,
        opts = { desc = "Telescope: Live Grep" },
    },
    {
        mode = "n",
        key_sequence = "<C-F>b",
        handler = builtin.buffers,
        opts = { desc = "Telescope: Buffers" },
    },
    {
        mode = "n",
        key_sequence = "<C-F>r",
        handler = builtin.oldfiles,
        opts = { desc = "Telescope: Recent Files" },
    },
    {
        mode = "n",
        key_sequence = "<C-F>h",
        handler = builtin.help_tags,
        opts = { desc = "Telescope: Help Tags" },
    },
    {
        mode = "n",
        key_sequence = "<C-F>y",
        handler = builtin.git_branches,
        opts = { desc = "Telescope: Git Branches" },
    },
}

return M
