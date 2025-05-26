----------------------------------------------------------------------
-- 1. Plugin Specification & Setup
----------------------------------------------------------------------
return {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        ----------------------------------------------------------------------
        -- 3. Gitsigns Setup & Keymaps
        ----------------------------------------------------------------------
        require("gitsigns").setup({
            preview_config = {
                border = "rounded",
            },
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns

                -- Helper for mapping keys
                local function map(mode, lhs, rhs, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, lhs, rhs, opts)
                end

                ----------------------------------------------------------------------
                -- 3.1 Navigation Keymaps
                ----------------------------------------------------------------------
                map("n", "]c", function()
                    if vim.wo.diff then
                        return "]c"
                    end
                    vim.schedule(gs.next_hunk)
                    return "<Ignore>"
                end, { expr = true, desc = "Next Hunk" })

                map("n", "[c", function()
                    if vim.wo.diff then
                        return "[c"
                    end
                    vim.schedule(gs.prev_hunk)
                    return "<Ignore>"
                end, { expr = true, desc = "Previous Hunk" })

                -- Actions
                map("n", "<leader>hs", gs.stage_hunk, { desc = "Stage Hunk" })
                map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset Hunk" })
                map("v", "<leader>hs", function()
                    gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end)
                map("v", "<leader>hr", function()
                    gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end)
                map("n", "<leader>hS", gs.stage_buffer, { desc = "Stage entire buffer" })
                map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
                map("n", "<leader>hR", gs.reset_buffer, { desc = "Reset entire buffer" })
                map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview hunk" })
                map("n", "<leader>hb", gs.blame_line, { desc = "Blame current line" })
                map("n", "<leader>hB", function()
                    gs.blame_line({ full = true })
                end, { desc = "Full blame for current line" })
                map("n", "<leader>htb", gs.toggle_current_line_blame, { desc = "Toggle current line blame" })
                map("n", "<leader>hd", gs.diffthis, { desc = "Diff this buffer" })
                map("n", "<leader>hD", function()
                    gs.diffthis("~")
                end, { desc = "Diff against last commit" })
                map("n", "<leader>td", gs.toggle_deleted, { desc = "Toggle deleted" })

                ----------------------------------------------------------------------
                -- 3.3 Text Object
                ----------------------------------------------------------------------
                map({ "o", "x" }, "ih", "<cmd><C-U>Gitsigns select_hunk<CR>")
            end,
        })
    end,
}
