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

            local highlights = {
                GlanceWinBarFilepath = { gui = "italic", guibg = c.highlight },
                GlanceWinBarFilename = { gui = "italic", guifg = c.fg, guibg = c.highlight },
                GlanceWinBarTitle = { gui = "bold", guifg = c.fg, guibg = c.highlight },
                -- GlanceListCursorLine = { gui = "none", guibg = c.subtle },
                GlanceListNormal = { gui = "italic" },
            }

            for group, opts in pairs(highlights) do
                local cmd = "hi " .. group
                for k, v in pairs(opts) do
                    if v and v ~= "" then
                        cmd = cmd .. " " .. k .. "=" .. v
                    end
                end
                vim.cmd(cmd)
            end

            vim.api.nvim_set_hl(0, "GlanceBorderTop", { link = "FloatBorder" })
            vim.api.nvim_set_hl(0, "GlancePreviewBorderBottom", { link = "FloatBorder" })
            vim.api.nvim_set_hl(0, "GlanceListBorderBottom", { link = "FloatBorder" })
        end

        setHighlightOverrides()

        ----------------------------------------------------------------------
        -- Autocmd: Update Highlights on Colorscheme Change
        ----------------------------------------------------------------------
        local glance_hl_augroup = vim.api.nvim_create_augroup("GlanceHighlightOverrides", { clear = true })
        vim.api.nvim_create_autocmd("ColorScheme", {
            group = glance_hl_augroup,
            callback = setHighlightOverrides,
        })

        ----------------------------------------------------------------------
        -- Optional: Window Backdrop for Glance
        ----------------------------------------------------------------------
        window_utils.with_win_backdrop("Glance")
    end,
}
