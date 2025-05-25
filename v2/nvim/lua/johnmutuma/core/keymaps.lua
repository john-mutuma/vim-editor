----------------------------------------------------------------------
-- 1. Keymap Helpers
----------------------------------------------------------------------
local keymap = vim.keymap
local api = vim.api

-- Helper for buffer-local LSP keymaps
local function buf_map(bufnr, mode, lhs, rhs, opts)
    opts = opts or {}
    opts.buffer = bufnr
    opts.silent = opts.silent ~= false -- default silent = true
    opts.noremap = opts.noremap ~= false -- default noremap = true
    keymap.set(mode, lhs, rhs, opts)
end

----------------------------------------------------------------------
-- 2. General Keymaps
----------------------------------------------------------------------
-- Insert mode
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })
keymap.set("i", "<C-U>", "<ESC>gUiwea", { desc = "Uppercase current word in insert mode" })

-- Normal mode
keymap.set("n", "<leader><CR>", ":nohlsearch<CR>:<CR>", { desc = "Clear search highlights" })

-- Window management
keymap.set("n", "gq", "<C-W>c", { desc = "Close current window" })
keymap.set("n", "<leader>qq", ":qa<CR>", { desc = "Quit all windows (soft)" })
keymap.set("n", "<leader>QQ", ":qa!<CR>", { desc = "Quit all windows (force)" })
keymap.set("n", "<C-T>o", ":tabonly<CR>", { desc = "Close all other tabs" })
keymap.set("n", "<leader>F", ":MaximizerToggle<CR>", { desc = "Toggle window maximizer" })

-- Folds and navigation
keymap.set("n", "j", "gj", { desc = "Move down (respect folds)" })
keymap.set("n", "k", "gk", { desc = "Move up (respect folds)" })

-- Save
keymap.set("n", "<leader>ww", ":noautocmd w<CR>", { desc = "Save file (no autocmd)" })
keymap.set("n", "<leader>w<CR>", ":noautocmd w<CR>", { desc = "Save file (no autocmd)" })

----------------------------------------------------------------------
-- 3. FZF Keymaps
----------------------------------------------------------------------
keymap.set("n", "<C-F>f", ":GFiles<CR>", { desc = "FZF: Git files" })
keymap.set("n", "<C-F>y", ":GBranches<CR>", { desc = "FZF: Git branches" })
keymap.set("n", "<C-F>s", "Rg ", { desc = "FZF: Ripgrep search" })
keymap.set("n", "<C-F>b", ":Buffers<CR>", { desc = "FZF: Open buffers" })

----------------------------------------------------------------------
-- 4. LSP Keymaps (on LspAttach)
----------------------------------------------------------------------
local lsp_group = api.nvim_create_augroup("lspattach_augroup", { clear = true })
api.nvim_create_autocmd("LspAttach", {
    group = lsp_group,
    callback = function(args)
        local bufnr = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        -- Glance/Lspsaga navigation
        buf_map(bufnr, "n", "gR", "<cmd>Glance references<CR>", { desc = "LSP: References (Glance)" })
        buf_map(bufnr, "n", "gd", "<cmd>Glance definitions<CR>", { desc = "LSP: Definitions (Glance)" })
        buf_map(bufnr, "n", "gi", "<cmd>Glance implementations<CR>", { desc = "LSP: Implementations (Glance)" })
        buf_map(bufnr, "n", "gT", "<cmd>Glance type_definitions<CR>", { desc = "LSP: Type Definitions (Glance)" })
        buf_map(bufnr, "n", "g>", "<cmd>Lspsaga outgoing_calls<CR>", { desc = "LSP: Outgoing Calls (Lspsaga)" })
        buf_map(bufnr, "n", "g<", "<cmd>Lspsaga incoming_calls<CR>", { desc = "LSP: Incoming Calls (Lspsaga)" })
        buf_map(bufnr, "n", "gD", vim.lsp.buf.declaration, { desc = "LSP: Go to Declaration" })
        buf_map(bufnr, "n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", { desc = "LSP: Code Action (Lspsaga)" })
        buf_map(bufnr, "n", "<leader>rn", "<cmd>Lspsaga rename<CR>", { desc = "LSP: Rename Symbol (Lspsaga)" })
        buf_map(bufnr, "n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", { desc = "LSP: Next Diagnostic (Lspsaga)" })
        buf_map(
            bufnr,
            "n",
            "[e",
            "<cmd>Lspsaga diagnostic_jump_previous<CR>",
            { desc = "LSP: Previous Diagnostic (Lspsaga)" }
        )
        buf_map(
            bufnr,
            "n",
            "<leader>D",
            "<cmd>Lspsaga show_buf_diagnostics<CR>",
            { desc = "LSP: Buffer Diagnostics (Lspsaga)" }
        )
        buf_map(
            bufnr,
            "n",
            "<leader>d",
            "<cmd>Lspsaga show_line_diagnostics<CR>",
            { desc = "LSP: Line Diagnostics (Lspsaga)" }
        )
        buf_map(
            bufnr,
            "n",
            "<leader>wd",
            "<cmd>Lspsaga show_workspace_diagnostics<CR>",
            { desc = "LSP: Workspace Diagnostics (Lspsaga)" }
        )
        buf_map(bufnr, "n", "K", "<cmd>Lspsaga hover_doc<CR>", { desc = "LSP: Hover Documentation (Lspsaga)" })

        -- Typescript-specific
        if client and client.name == "ts_ls" then
            buf_map(bufnr, "n", "<leader>rf", "<cmd>TypescriptRenameFile<CR>", { desc = "TS: Rename File" })
        end
    end,
})
