----------------------------------------------------------------------
-- 1. Scooter Keymaps (nairovim.KeymapDef)
----------------------------------------------------------------------

local M = {}

--- @type nairovim.KeymapDef[]
M.mappings = {
    {
        mode = "n",
        key_sequence = "<leader>s",
        handler = "<cmd>FindReplace<CR>",
        opts = { desc = "Open scooter for Find and Replace" },
    },
    {
        mode = "v",
        key_sequence = "<leader>r",
        handler = '"ay<ESC><cmd>lua OpenScooterSearchText(vim.fn.getreg("a"))<CR>',
        opts = { desc = "Search selected text in scooter" },
    },
}

return M
