local window_utils = require("johnmutuma.utils.windows")

require("CopilotChat").setup({
    window = {
        layout = "float", -- 'vertical', 'horizontal', 'float', 'replace', or a function that returns the layout
        width = 0.85,
        height = 0.8,
        zindex = 45,
    },
})

local grp = vim.api.nvim_create_augroup("copilot_lspattach_augroup", { clear = true })
vim.api.nvim_create_autocmd({ "LspAttach" }, {
    group = grp,
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        local bufnr = args.buf
        local opts = { noremap = true, buffer = bufnr, silent = true }

        if client.name == "GitHub Copilot" then
            vim.keymap.set({ "n", "v" }, "<leader>cp", "<cmd>CopilotChat<CR>", opts)
        end
    end,
})

-- manually adding a backdrop to telescope prompt to add depth
-- can remove this when coplot has added a backdrop internally or if neovim decideds to include backdrops to floating windows for depth
window_utils.with_win_backdrop("copilot-chat")
window_utils.with_win_backdrop("copilot-overlay")
