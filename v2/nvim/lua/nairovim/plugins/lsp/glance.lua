----------------------------------------------------------------------
-- Glance.nvim LSP UI Configuration
----------------------------------------------------------------------

return {
    "dnlhc/glance.nvim",
    event = "LspAttach",
    cmd = "Glance",
    config = function()
        local glance = require("glance")
        local window_utils = require("nairovim.utils.windows")

        ----------------------------------------------------------------------
        -- Glance Setup
        ----------------------------------------------------------------------
        glance.setup({
            detached = true,
            border = {
                enable = true,
            },
            theme = {
                enable = true,
                mode = "auto",
            },
        })

        ----------------------------------------------------------------------
        -- Highlight Overrides Based on Colorscheme
        ----------------------------------------------------------------------
        local get_hightlights = require("nairovim.plugins.customizations.highlights.glance").get

        local common_utils = require("nairovim.utils.common")
        common_utils.apply_highlights(get_hightlights, "glance_highlights_overrides_augroup")

        ----------------------------------------------------------------------
        -- 4. LSP Keymaps (on LspAttach)
        ----------------------------------------------------------------------
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("glance_lspattach_augroup", { clear = true }),
            callback = function(args)
                local bufnr = args.buf
                -- local client = vim.lsp.get_client_by_id(args.data.client_id)

                local mappings = require("nairovim.plugins.customizations.keymaps.glance").mappings
                common_utils.map(mappings, bufnr)
            end,
        })

        ----------------------------------------------------------------------
        -- Optional: Window Backdrop for Glance
        ----------------------------------------------------------------------
        window_utils.with_win_backdrop("Glance")
    end,
}
