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
        local palette = require("nairovim.utils.theme").palette

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

        local function setHighlightOverrides()
            local bg = vim.opt.background:get()
            local c = palette[bg == "light" and "light" or "dark"]

            --- @type nairovim.highlightspec
            local highlights = {
                GlanceWinBarFilepath = { italic = true, bg = c.highlight },
                GlanceWinBarFilename = { italic = true, fg = c.fg, bg = c.highlight },
                GlanceWinBarTitle = { bold = true, fg = c.fg, bg = c.highlight },
                GlanceListNormal = { italic = true },
                GlanceBorderTop = { link = "FloatBorder" },
                GlancePreviewBorderBottom = { link = "FloatBorder" },
                GlanceListBorderBottom = { link = "FloatBorder" },
            }

            for group, opts in pairs(highlights) do
                vim.api.nvim_set_hl(0, group, opts)
            end
        end

        setHighlightOverrides()

        ----------------------------------------------------------------------
        -- Autocmd: Update Highlights on Colorscheme Change
        ----------------------------------------------------------------------
        vim.api.nvim_create_autocmd("ColorScheme", {
            group = vim.api.nvim_create_augroup("GlanceHighlightOverrides", { clear = true }),
            callback = setHighlightOverrides,
        })

        ----------------------------------------------------------------------
        -- 4. LSP Keymaps (on LspAttach)
        ----------------------------------------------------------------------
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("glance_lspattach_augroup", { clear = true }),
            callback = function(args)
                local bufnr = args.buf
                -- local client = vim.lsp.get_client_by_id(args.data.client_id)

                local mappings = require("nairovim.plugins.customizations.keymaps.glance").mappings
                local common_utils = require("nairovim.utils.common")
                common_utils.map(mappings, bufnr)
            end,
        })

        ----------------------------------------------------------------------
        -- Optional: Window Backdrop for Glance
        ----------------------------------------------------------------------
        window_utils.with_win_backdrop("Glance")
    end,
}
