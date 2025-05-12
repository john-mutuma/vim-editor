local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
local keymap = vim.keymap

if not lspconfig_ok then
    print("lspconfig could not be loaded")
    return
end

-- Setting LSP Keymaps
local grp = vim.api.nvim_create_augroup("lspattach_augroup", { clear = true })
vim.api.nvim_create_autocmd({ "LspAttach" }, {
    group = grp,
    callback = function(args)
        local bufnr = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        -- some language servers crash on semantic tokens when previewing files quickly e.g. Glance previews
        -- disabling sematic tokens - hihglighting for now will be provided by nvim-treesitter
        -- client.server_capabilities.semanticTokensProvider = nil

        local opts = { noremap = true, buffer = bufnr, silent = true }
        -- LSP key bindings
        keymap.set("n", "gR", "<cmd>Glance references<CR>", opts)
        -- keymap.set("n", "gR", "<cmd>Lspsaga finder<CR>", opts)
        -- keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>", opts)
        keymap.set("n", "gd", "<cmd>Glance definitions<CR>", opts)
        keymap.set("n", "gi", "<cmd>Glance implementations<CR>")
        keymap.set("n", "gT", "<cmd>Glance type_definitions<CR>")
        keymap.set("n", "g>", "<cmd>Lspsaga outgoing_calls<CR>")
        keymap.set("n", "g<", "<cmd>Lspsaga incoming_calls<CR>")
        keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        -- keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        -- keymap.set("n", "gr", vim.lsp.buf.references, opts)
        keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts)
        keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts)
        keymap.set("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts)
        keymap.set("n", "[e", "<cmd>Lspsaga diagnostic_jump_previous<CR>", opts)
        keymap.set("n", "<leader>D", "<cmd>Lspsaga show_buf_diagnostics<CR>", opts)
        keymap.set("n", "<leader>d", "<cmd>Lspsaga show_line_diagnostics<CR>", opts)
        keymap.set("n", "<leader>wd", "<cmd>Lspsaga show_workspace_diagnostics<CR>", opts)
        keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts)

        if client.name == "ts_ls" then
            keymap.set("n", "<leader>rf", "<cmd>TypescriptRenameFile<CR>", opts)
        end
    end,
    -- command = ":lua setHiglightOverrides()",
    -- pattern = {"*.adoc", "*.md", "*.tex"},
})
