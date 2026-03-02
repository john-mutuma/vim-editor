----------------------------------------------------------------------
-- Extension Configurations
----------------------------------------------------------------------
local Blank = {
    sections = {
        lualine_a = { "" },
    },
    filetypes = {
        "packer",
        "filetree",
        "bufferlist",
        "NvimTree",
    },
}

local GitBranch = {
    sections = {
        lualine_a = { "" },
        lualine_b = { "branch" },
    },
    filetypes = {
        "snacks_dashboard",
        "snacks_terminal",
        "opencode",
        "opencode_terminal",
        "sidekick_terminal",
    },
}

return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = { "VeryLazy" },
    config = function()
        require("lualine").setup({
            sections = {
                lualine_a = { "mode" },
                lualine_c = {
                    {
                        "filename",
                        file_status = true, -- displays file status (readonly status, modified status)
                        path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
                    },
                },
            },
            extensions = {
                GitBranch,
                Blank,
            },
            -- options = { theme = "grubbox" },
        })
    end,
}
