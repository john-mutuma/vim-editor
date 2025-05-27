----------------------------------------------------------------------
-- 1. General Keymaps Table (nairovim.KeymapDef[])
----------------------------------------------------------------------
---@type nairovim.KeymapDef[]
local general_keymaps = {
    -- Insert mode
    {
        mode = "i",
        key_sequence = "jk",
        handler = "<ESC>",
        opts = { desc = "Exit insert mode with jk" },
    },
    {
        mode = "i",
        key_sequence = "<C-U>",
        handler = "<ESC>gUiwea",
        opts = { desc = "Uppercase current word in insert mode" },
    },

    -- Normal mode
    {
        mode = "n",
        key_sequence = "<leader><CR>",
        handler = ":nohlsearch<CR>:<CR>",
        opts = { desc = "Clear search highlights" },
    },

    ----------------------------------------------------------------------
    -- 2. Window Management Keymaps
    ----------------------------------------------------------------------
    {
        mode = "n",
        key_sequence = "gq",
        handler = "<C-W>c",
        opts = { desc = "Close current window" },
    },
    {
        mode = "n",
        key_sequence = "<leader>qq",
        handler = ":qa<CR>",
        opts = { desc = "Quit all windows (soft)" },
    },
    {
        mode = "n",
        key_sequence = "<leader>QQ",
        handler = ":qa!<CR>",
        opts = { desc = "Quit all windows (force)" },
    },
    {
        mode = "n",
        key_sequence = "<C-T>o",
        handler = ":tabonly<CR>",
        opts = { desc = "Close all other tabs" },
    },
    {
        mode = "n",
        key_sequence = "<leader>F",
        handler = ":MaximizerToggle<CR>",
        opts = { desc = "Toggle window maximizer" },
    },

    ----------------------------------------------------------------------
    -- 3. Folds and Navigation Keymaps
    ----------------------------------------------------------------------
    {
        mode = "n",
        key_sequence = "j",
        handler = "gj",
        opts = { desc = "Move down (respect folds)" },
    },
    {
        mode = "n",
        key_sequence = "k",
        handler = "gk",
        opts = { desc = "Move up (respect folds)" },
    },

    ----------------------------------------------------------------------
    -- 4. Save Keymaps
    ----------------------------------------------------------------------
    {
        mode = "n",
        key_sequence = "<leader>ww",
        handler = ":noautocmd w<CR>",
        opts = { desc = "Save file (no autocmd)" },
    },
    {
        mode = "n",
        key_sequence = "<leader>w<CR>",
        handler = ":noautocmd w<CR>",
        opts = { desc = "Save file (no autocmd)" },
    },

    ----------------------------------------------------------------------
    -- 5. FZF Keymaps
    ----------------------------------------------------------------------
    {
        mode = "n",
        key_sequence = "<C-F>f",
        handler = ":GFiles<CR>",
        opts = { desc = "FZF: Git files" },
    },
    {
        mode = "n",
        key_sequence = "<C-F>y",
        handler = ":GBranches<CR>",
        opts = { desc = "FZF: Git branches" },
    },
    {
        mode = "n",
        key_sequence = "<C-F>s",
        handler = "Rg ",
        opts = { desc = "FZF: Ripgrep search" },
    },
    {
        mode = "n",
        key_sequence = "<C-F>b",
        handler = ":Buffers<CR>",
        opts = { desc = "FZF: Open buffers" },
    },
}

----------------------------------------------------------------------
-- 6. Apply Keymaps Utility
----------------------------------------------------------------------
local common_utils = require("nairovim.utils.common")
common_utils.map(general_keymaps)
