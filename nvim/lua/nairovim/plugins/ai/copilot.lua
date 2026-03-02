return {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "VimEnter", -- Load on startup to avoid timing/attachment issues
    config = function()
        require("copilot").setup({
            suggestion = {
                enabled = true,
                auto_trigger = true,
            },
        })

        -- Load keymaps from customizations
        local mappings = require("nairovim.plugins.customizations.keymaps.copilot").mappings
        local common_utils = require("nairovim.utils.common")
        common_utils.map(mappings)
    end,
}
