return {
    "glepnir/lspsaga.nvim",
    branch = "main",
    event = { "LspAttach" },
    config = function()
        require("lspsaga").setup({
            ui = {
                code_action = "",
                border = "double",
            },
            finder = {
                keys = {
                    close = "<C-c>k",
                    quit = { "<C-c>k", "<C-[>" },
                },
            },
        })
    end,
}
