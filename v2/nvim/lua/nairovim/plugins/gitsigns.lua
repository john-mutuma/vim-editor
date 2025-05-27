----------------------------------------------------------------------
-- 1. Plugin Specification & Setup
----------------------------------------------------------------------
return {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        ----------------------------------------------------------------------
        -- 3. Gitsigns Setup & Keymaps
        ----------------------------------------------------------------------
        require("gitsigns").setup({
            preview_config = {
                border = "rounded",
            },
            on_attach = function(bufnr)
                local mappings = require("nairovim.plugins.customizations.keymaps.gitsigns").mappings
                local common_utils = require("nairovim.utils.common")
                common_utils.map(mappings, bufnr)
            end,
        })
    end,
}
