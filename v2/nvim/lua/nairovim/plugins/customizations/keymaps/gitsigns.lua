local M = {}

local gs = package.loaded.gitsigns

--- @type nairovim.KeymapDef[]
M.mappings = {
    -- Navigation
    {
        mode = "n",
        key_sequence = "]c",
        handler = function()
            if vim.wo.diff then
                return "]c"
            end
            vim.schedule(gs.next_hunk)
            return "<Ignore>"
        end,
        opts = { expr = true, desc = "Next Hunk" },
    },
    {
        mode = "n",
        key_sequence = "[c",
        handler = function()
            if vim.wo.diff then
                return "[c"
            end
            vim.schedule(gs.prev_hunk)
            return "<Ignore>"
        end,
        opts = { expr = true, desc = "Previous Hunk" },
    },

    -- Actions
    {
        mode = "n",
        key_sequence = "<leader>hs",
        handler = gs.stage_hunk,
        opts = { desc = "Stage Hunk" },
    },
    {
        mode = "n",
        key_sequence = "<leader>hr",
        handler = gs.reset_hunk,
        opts = { desc = "Reset Hunk" },
    },
    {
        mode = "v",
        key_sequence = "<leader>hs",
        handler = function()
            gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end,
    },
    {
        mode = "v",
        key_sequence = "<leader>hr",
        handler = function()
            gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end,
    },
    {
        mode = "n",
        key_sequence = "<leader>hS",
        handler = gs.stage_buffer,
        opts = { desc = "Stage entire buffer" },
    },
    {
        mode = "n",
        key_sequence = "<leader>hu",
        handler = gs.undo_stage_hunk,
        opts = { desc = "Undo stage hunk" },
    },
    {
        mode = "n",
        key_sequence = "<leader>hR",
        handler = gs.reset_buffer,
        opts = { desc = "Reset entire buffer" },
    },
    {
        mode = "n",
        key_sequence = "<leader>hp",
        handler = gs.preview_hunk,
        opts = { desc = "Preview hunk" },
    },
    {
        mode = "n",
        key_sequence = "<leader>hb",
        handler = gs.blame_line,
        opts = { desc = "Blame current line" },
    },
    {
        mode = "n",
        key_sequence = "<leader>hB",
        handler = function()
            gs.blame_line({ full = true })
        end,
        opts = { desc = "Full blame for current line" },
    },
    {
        mode = "n",
        key_sequence = "<leader>htb",
        handler = gs.toggle_current_line_blame,
        opts = { desc = "Toggle current line blame" },
    },
    {
        mode = "n",
        key_sequence = "<leader>hd",
        handler = gs.diffthis,
        opts = { desc = "Diff this buffer" },
    },
    {
        mode = "n",
        key_sequence = "<leader>hD",
        handler = function()
            gs.diffthis("~")
        end,
        opts = { desc = "Diff against last commit" },
    },
    {
        mode = "n",
        key_sequence = "<leader>htd",
        handler = gs.toggle_deleted,
        opts = { desc = "Toggle deleted" },
    },

    -- Text Object
    { mode = { "o", "x" }, key_sequence = "ih", handler = "<cmd><C-U>Gitsigns select_hunk<CR>" },
}

return M
