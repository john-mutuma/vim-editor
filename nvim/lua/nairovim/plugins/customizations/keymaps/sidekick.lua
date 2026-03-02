----------------------------------------------------------------------
-- Sidekick AI Keymaps (nairovim.KeymapDef[])
----------------------------------------------------------------------
local M = {}

---@type nairovim.KeymapDef[]
M.mappings = {
    -- NES (Next Edit Suggestion) - Jump or Apply
    {
        mode = "n",
        key_sequence = "<tab>",
        handler = function()
            -- if there is a next edit, jump to it, otherwise apply it if any
            if not require("sidekick").nes_jump_or_apply() then
                return "<Tab>" -- fallback to normal tab
            end
        end,
        opts = { expr = true, desc = "Goto/Apply Next Edit Suggestion" },
    },
    -- Sidekick Focus (normal, visual, modes)
    {
        mode = { "n", "x" },
        key_sequence = "<leader>aF",
        handler = function()
            require("sidekick.cli").focus()
        end,
        opts = { desc = "Sidekick Focus" },
    },
    -- Sidekick Toggle (all modes)
    {
        mode = { "n", "t", "i", "x" },
        key_sequence = "<c-.>",
        handler = function()
            require("sidekick.cli").toggle()
        end,
        opts = { desc = "Sidekick Toggle" },
    },
    -- Sidekick Toggle CLI
    {
        mode = "n",
        key_sequence = "<leader>aa",
        handler = function()
            require("sidekick.cli").toggle()
        end,
        opts = { desc = "Sidekick Toggle CLI" },
    },
    -- Select CLI Tool
    {
        mode = "n",
        key_sequence = "<leader>as",
        handler = function()
            require("sidekick.cli").select()
            -- Or to select only installed tools:
            -- require("sidekick.cli").select({ filter = { installed = true } })
        end,
        opts = { desc = "Select CLI" },
    },
    -- Detach/Close CLI Session
    {
        mode = "n",
        key_sequence = "<leader>ad",
        handler = function()
            require("sidekick.cli").close()
        end,
        opts = { desc = "Detach a CLI Session" },
    },
    -- Send This (current context)
    {
        mode = { "x", "n" },
        key_sequence = "<leader>at",
        handler = function()
            require("sidekick.cli").send({ msg = "{this}" })
        end,
        opts = { desc = "Send This" },
    },
    -- Send File
    {
        mode = "n",
        key_sequence = "<leader>af",
        handler = function()
            require("sidekick.cli").send({ msg = "{file}" })
        end,
        opts = { desc = "Send File" },
    },
    -- Send Visual Selection
    {
        mode = "x",
        key_sequence = "<leader>av",
        handler = function()
            require("sidekick.cli").send({ msg = "{selection}" })
        end,
        opts = { desc = "Send Visual Selection" },
    },
    -- Select Prompt
    {
        mode = { "n", "x" },
        key_sequence = "<leader>ap",
        handler = function()
            require("sidekick.cli").prompt()
        end,
        opts = { desc = "Sidekick Select Prompt" },
    },
    -- Toggle Claude directly
    {
        mode = "n",
        key_sequence = "<leader>ac",
        handler = function()
            require("sidekick.cli").toggle({ name = "claude", focus = true })
        end,
        opts = { desc = "Sidekick Toggle Claude" },
    },
}

return M
