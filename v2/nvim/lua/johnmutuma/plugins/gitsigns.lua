return {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        vim.api.nvim_create_user_command("GitsignsBlameLine", function()
            local gitsigns = require("gitsigns")
            gitsigns.blame_line()
        end, { desc = "Toggle blame line" })

        vim.api.nvim_create_user_command("GitsignsBlameLineFull", function()
            local gitsigns = require("gitsigns")
            gitsigns.blame_line()
        end, { desc = "Toggle full blame line" })

        require("gitsigns").setup({
            preview_config = {
                border = "single",
            },
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns

                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                -- Navigation
                map("n", "]c", function()
                    if vim.wo.diff then
                        return "]c"
                    end
                    vim.schedule(function()
                        gs.next_hunk()
                    end)
                    return "<Ignore>"
                end, { expr = true })

                map("n", "[c", function()
                    if vim.wo.diff then
                        return "[c"
                    end
                    vim.schedule(function()
                        gs.prev_hunk()
                    end)
                    return "<Ignore>"
                end, { expr = true })

                -- Actions
                map("n", "<leader>hs", ":Gitsigns stage_hunk<CR>")
                map("n", "<leader>hr", ":Gitsigns reset_hunk<CR>")
                map("v", "<leader>hs", function()
                    gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end)
                map("v", "<leader>hr", function()
                    gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end)
                map("n", "<leader>hS", "<cmd>Gitsigns stage_buffer<CR>")
                map("n", "<leader>hu", "<cmd>Gitsigns undo_stage_hunk<CR>")
                map("n", "<leader>hR", "<cmd>Gitsigns reset_buffer<CR>")
                map("n", "<leader>hp", "<cmd>Gitsigns preview_hunk<CR>")
                map("n", "<leader>hb", "<cmd>GitsignsBlameLine<CR>")
                map("n", "<leader>hB", "<cmd>GitsignsBlameLineFull<CR>")
                map("n", "<leader>htb", "<cmd>Gitsigns toggle_current_line_blame<CR>")
                map("n", "<leader>hd", "<cmd>Gitsigns diffthis<CR>")
                map("n", "<leader>hD", function()
                    gs.diffthis("~")
                end)
                map("n", "<leader>td", "<cmd>Gitsigns toggle_deleted<CR>")

                -- Text object
                map({ "o", "x" }, "ih", "<cmd><C-U>Gitsigns select_hunk<CR>")
            end,
        })
    end,
}
