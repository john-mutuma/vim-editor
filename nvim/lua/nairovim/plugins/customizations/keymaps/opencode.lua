----------------------------------------------------------------------
-- 1. OpenCode AI Keymaps (nairovim.KeymapDef[])
----------------------------------------------------------------------
local M = {}

---@type nairovim.KeymapDef[]
M.mappings = {
    -- OpenCode AI - Toggle
    {
        mode = "n",
        key_sequence = "<leader>ot",
        handler = function()
            require("opencode").toggle()
        end,
        opts = { desc = "Toggle" },
    },
    -- OpenCode AI - Ask (general)
    {
        mode = "n",
        key_sequence = "<leader>oA",
        handler = function()
            require("opencode").ask()
        end,
        opts = { desc = "Ask" },
    },
    -- OpenCode AI - Ask about cursor
    {
        mode = "n",
        key_sequence = "<leader>oa",
        handler = function()
            require("opencode").ask("@cursor: ")
        end,
        opts = { desc = "Ask about this" },
    },
    -- OpenCode AI - Ask about selection
    {
        mode = "v",
        key_sequence = "<leader>oa",
        handler = function()
            require("opencode").ask("@selection: ")
        end,
        opts = { desc = "Ask about selection" },
    },
    -- OpenCode AI - Add buffer to prompt
    {
        mode = "n",
        key_sequence = "<leader>o+",
        handler = function()
            require("opencode").append_prompt("@buffer")
        end,
        opts = { desc = "Add buffer to prompt" },
    },
    -- OpenCode AI - Add selection to prompt
    {
        mode = "v",
        key_sequence = "<leader>o+",
        handler = function()
            require("opencode").append_prompt("@selection")
        end,
        opts = { desc = "Add selection to prompt" },
    },
    -- OpenCode AI - New session
    {
        mode = "n",
        key_sequence = "<leader>on",
        handler = function()
            require("opencode").command("session_new")
        end,
        opts = { desc = "New session" },
    },
    -- OpenCode AI - Copy last response
    {
        mode = "n",
        key_sequence = "<leader>oy",
        handler = function()
            require("opencode").command("messages_copy")
        end,
        opts = { desc = "Copy last response" },
    },
    -- OpenCode AI - Messages half page up
    {
        mode = "n",
        key_sequence = "<S-C-u>",
        handler = function()
            require("opencode").command("messages_half_page_up")
        end,
        opts = { desc = "Messages half page up" },
    },
    -- OpenCode AI - Messages half page down
    {
        mode = "n",
        key_sequence = "<S-C-d>",
        handler = function()
            require("opencode").command("messages_half_page_down")
        end,
        opts = { desc = "Messages half page down" },
    },
    -- OpenCode AI - Select prompt
    {
        mode = { "n", "v" },
        key_sequence = "<leader>os",
        handler = function()
            require("opencode").select()
        end,
        opts = { desc = "Select prompt" },
    },
    -- OpenCode AI - Explain code (custom prompt)
    {
        mode = "n",
        key_sequence = "<leader>oe",
        handler = function()
            require("opencode").prompt("Explain @cursor and its context")
        end,
        opts = { desc = "Explain this code" },
    },
}

return M
