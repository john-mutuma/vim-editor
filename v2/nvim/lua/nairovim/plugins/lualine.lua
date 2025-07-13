-- local config = lualine.get_config();
local Blank = {
    sections = { lualine_a = { "" } },
    filetypes = {
        "packer",
        "filetree",
        "bufferlist",
        "copilot-chat",
        "copilot-overlay",
        "Avante",
        "AvanteInput",
        "AvanteTodos",
        "AvanteSelectedFiles",
    },
}
-- local Git_Branch = { sections = { lualine_b = { "branch" }, lualine_y = { "progress" } }, filetypes = { "NvimTree" } }
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
                Blank, --[[ Git_Branch  ]]
            },
            -- options = { theme = "grubbox" },
        })
    end,
}
