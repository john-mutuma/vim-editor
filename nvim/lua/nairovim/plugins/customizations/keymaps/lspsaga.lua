----------------------------------------------------------------------
-- 1. Lspsaga LSP Keymaps (nairovim.KeymapDef[])
----------------------------------------------------------------------
local M = {}

---@type nairovim.KeymapDef[]
M.mappings = {
    -- Lspsaga
    {
        mode = "n",
        key_sequence = "g>",
        handler = "<cmd>Lspsaga outgoing_calls<CR>",
        opts = { desc = "LSP: Outgoing Calls (Lspsaga)" },
    },
    {
        mode = "n",
        key_sequence = "g<",
        handler = "<cmd>Lspsaga incoming_calls<CR>",
        opts = { desc = "LSP: Incoming Calls (Lspsaga)" },
    },
    {
        mode = "n",
        key_sequence = "gD",
        handler = function()
            vim.lsp.buf.declaration()
        end,
        opts = { desc = "LSP: Go to Declaration" },
    },
    {
        mode = "n",
        key_sequence = "<leader>ca",
        handler = "<cmd>Lspsaga code_action<CR>",
        opts = { desc = "LSP: Code Action (Lspsaga)" },
    },
    {
        mode = "n",
        key_sequence = "<leader>rn",
        handler = "<cmd>Lspsaga rename<CR>",
        opts = { desc = "LSP: Rename Symbol (Lspsaga)" },
    },
    {
        mode = "n",
        key_sequence = "]e",
        handler = "<cmd>Lspsaga diagnostic_jump_next<CR>",
        opts = { desc = "LSP: Next Diagnostic (Lspsaga)" },
    },
    {
        mode = "n",
        key_sequence = "[e",
        handler = "<cmd>Lspsaga diagnostic_jump_previous<CR>",
        opts = { desc = "LSP: Previous Diagnostic (Lspsaga)" },
    },
    {
        mode = "n",
        key_sequence = "<leader>D",
        handler = "<cmd>Lspsaga show_buf_diagnostics<CR>",
        opts = { desc = "LSP: Buffer Diagnostics (Lspsaga)" },
    },
    {
        mode = "n",
        key_sequence = "<leader>d",
        handler = "<cmd>Lspsaga show_line_diagnostics<CR>",
        opts = { desc = "LSP: Line Diagnostics (Lspsaga)" },
    },
    {
        mode = "n",
        key_sequence = "<leader>wd",
        handler = "<cmd>Lspsaga show_workspace_diagnostics<CR>",
        opts = { desc = "LSP: Workspace Diagnostics (Lspsaga)" },
    },
    {
        mode = "n",
        key_sequence = "K",
        handler = "<cmd>Lspsaga hover_doc<CR>",
        opts = { desc = "LSP: Hover Documentation (Lspsaga)" },
    },
}

return M
