local window_utils = require("johnmutuma.utils.windows")
local copilot_chat = require("CopilotChat")
local vim = vim

copilot_chat.setup({
    window = {
        layout = "float",
        width = 0.85,
        height = 0.8,
        zindex = 45,
    },
})

local grp = vim.api.nvim_create_augroup("copilot_lspattach_augroup", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
    group = grp,
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.name == "GitHub Copilot" then
            vim.keymap.set(
                { "n", "v" },
                "<leader>cp",
                "<cmd>CopilotChat<CR>",
                { noremap = true, buffer = args.buf, silent = true }
            )
        end
    end,
})

-- Add backdrop to Copilot floating windows for depth
window_utils.with_win_backdrop("copilot-chat")
window_utils.with_win_backdrop("copilot-overlay")
