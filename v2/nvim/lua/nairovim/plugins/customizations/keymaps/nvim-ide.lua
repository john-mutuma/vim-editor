local M = {}

--- @type nairovim.KeymapDef[]
M.mappings = {
    {
        mode = "n",
        key_sequence = "<leader>tl",
        handler = ":Workspace LeftPanelToggle<CR>",
        desc = "Toggle Left Panel",
    },
    {
        mode = "n",
        key_sequence = "<leader>tr",
        handler = ":Workspace RightPanelToggle<CR>",
        desc = "Toggle Right Panel",
    },
    {
        mode = "n",
        key_sequence = "<leader>Tf",
        handler = ":Workspace Timeline Focus<CR>",
        desc = "Focus Timeline",
    },
    {
        mode = "n",
        key_sequence = "<leader>Bf",
        handler = ":Workspace BufferList Focus<CR>",
        desc = "Focus Buffer List",
    },
    {
        mode = "n",
        key_sequence = "<leader>Of",
        handler = ":Workspace Outline Focus<CR>",
        desc = "Focus Outline",
    },
}

return M
