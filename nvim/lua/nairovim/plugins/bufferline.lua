return {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
        require("bufferline").setup({
            options = {
                mode = "tabs",
                numbers = "ordinal",
                separator_style = "slant",
                buffer_close_icon = "",
                hover = {
                    enabled = true,
                    delay = 200,
                    reveal = { "close" },
                },
                offsets = {
                    {
                        filetype = "NvimTree",
                        text = "File Explorer",
                        text_align = "center",
                        separator = true,
                    },
                },
            },
        })
    end,
}
