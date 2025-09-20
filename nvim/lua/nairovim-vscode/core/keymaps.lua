----------------------------------------------------------------------
-- 1. Leader Key Configuration
----------------------------------------------------------------------
vim.g.mapleader = ","
vim.g.maplocalleader = " "

----------------------------------------------------------------------
-- 2. VSCode Keymaps Table (nairovim.KeymapDef[])
----------------------------------------------------------------------
---@type nairovim.KeymapDef[]
local vscode_keymaps = {
    ----------------------------------------------------------------------
    -- 3. Leader Key Mapping
    ----------------------------------------------------------------------
    {
        mode = "n",
        key_sequence = "<Space>",
        handler = "",
        opts = { noremap = true, silent = true, desc = "Leader key (Space)" },
    },

    ----------------------------------------------------------------------
    -- 4. System Clipboard Operations
    ----------------------------------------------------------------------
    {
        mode = { "n", "v" },
        key_sequence = "<leader>y",
        handler = '"+y',
        opts = { noremap = true, silent = true, desc = "Yank to system clipboard" },
    },
    {
        mode = { "n", "v" },
        key_sequence = "<leader>p",
        handler = '"+p',
        opts = { noremap = true, silent = true, desc = "Paste from system clipboard" },
    },

    ----------------------------------------------------------------------
    -- 5. General Navigation and Editing
    ----------------------------------------------------------------------
    {
        mode = "n",
        key_sequence = "<leader><CR>",
        handler = ":nohl<CR>",
        opts = { noremap = true, silent = true, desc = "Clear search highlights" },
    },
    {
        mode = "n",
        key_sequence = "<C-[>",
        handler = "<Esc>",
        opts = { noremap = true, silent = true, desc = "Alternative escape key" },
    },

    ----------------------------------------------------------------------
    -- 6. VSCode Integration Keymaps
    ----------------------------------------------------------------------
    {
        mode = "n",
        key_sequence = "gR",
        handler = function()
            require("vscode").action("editor.action.referenceSearch.trigger")
        end,
        opts = { noremap = true, silent = true, desc = "VSCode: Find references" },
    },
    {
        mode = "n",
        key_sequence = "<leader>ae",
        handler = function()
            require("vscode").action("inlineChat.start")
        end,
        opts = { noremap = true, silent = true, desc = "VSCode: Start inline chat" },
    },

    ----------------------------------------------------------------------
    -- 7. Window management
    ----------------------------------------------------------------------
    {
        mode = "n",
        key_sequence = "gq",
        handler = function()
            require("vscode").action("workbench.action.closeActiveEditor")
        end,
        opts = { noremap = true, silent = true, desc = "VSCode: close window" },
    },

    {
        mode = "n",
        key_sequence = "<leader>LL",
        handler = ":call VSCodeNotify('workbench.extensions.action.setColorTheme', 'Solarized Light')<CR>",
        -- handler = function()
        --     require("vscode").action("workbench.extensions.action.setColorTheme", { args = { "Solarized Light" } })
        -- end,
        opts = { noremap = true, silent = true, desc = "VSCode: Start inline chat" },
    },
}

----------------------------------------------------------------------
-- 7. Apply Keymaps Utility
----------------------------------------------------------------------
local common_utils = require("nairovim.utils.common")
common_utils.map(vscode_keymaps)
