return {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
        require("copilot").setup({
            suggestion = {
                auto_trigger = true,
                accept_line = true,
                keymap = {
                    accept = "<Tab>",
                },
            },
        })
    end,
}
