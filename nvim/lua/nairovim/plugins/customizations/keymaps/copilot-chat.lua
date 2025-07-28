local M = {}

--- @type nairovim.KeymapDef[]
M.mappings = {
    {
        mode = { "n", "v" },
        key_sequence = "<leader>cp",
        handler = "<cmd>OpenCopilotChat<CR>",
        opts = { noremap = true, silent = true, desc = "Open Copilot Chat" },
    },
}

return M
