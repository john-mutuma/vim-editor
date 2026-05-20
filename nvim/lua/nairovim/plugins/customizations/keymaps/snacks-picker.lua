----------------------------------------------------------------------
-- 1. Snacks Picker Keymaps (nairovim.KeymapDef)
----------------------------------------------------------------------
-- Migrated from telescope.lua — preserving all existing key bindings

local M = {}

--- @type nairovim.KeymapDef[]
M.mappings = {
    {
        mode = "n",
        key_sequence = "<C-S>f",
        handler = function()
            require("snacks").picker.git_files()
        end,
        opts = { desc = "Snacks: Git Files" },
    },
    {
        mode = "n",
        key_sequence = "<C-S>s",
        handler = function()
            require("snacks").picker.grep()
        end,
        opts = { desc = "Snacks: Live Grep" },
    },
    {
        mode = "n",
        key_sequence = "<C-S>b",
        handler = function()
            require("snacks").picker.buffers()
        end,
        opts = { desc = "Snacks: Buffers" },
    },
    {
        mode = "n",
        key_sequence = "<C-S>r",
        handler = function()
            require("snacks").picker.recent()
        end,
        opts = { desc = "Snacks: Recent Files" },
    },
    {
        mode = "n",
        key_sequence = "<C-S>h",
        handler = function()
            require("snacks").picker.help()
        end,
        opts = { desc = "Snacks: Help Tags" },
    },
    {
        mode = "n",
        key_sequence = "<C-S>y",
        handler = function()
            require("snacks").picker.git_branches()
        end,
        opts = { desc = "Snacks: Git Branches" },
    },
}

return M
