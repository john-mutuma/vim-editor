----------------------------------------------------------------------
-- Glance.nvim LSP UI Configuration
----------------------------------------------------------------------

return {
    "dnlhc/glance.nvim",
    event = "LspAttach",
    cmd = "Glance",
    config = function()
        local glance = require("glance")
        local window_utils = require("johnmutuma.utils.windows")

        ----------------------------------------------------------------------
        -- Glance Setup
        ----------------------------------------------------------------------
        glance.setup({
            detached = true,
            border = {
                enable = true,
                top_char = "~",
                bottom_char = " ",
            },
        })

        ----------------------------------------------------------------------
        -- Highlight Overrides Based on Colorscheme
        ----------------------------------------------------------------------
        local function setHighlightOverrides()
            local bg = vim.opt.background:get()
            if bg == "light" then
                vim.cmd([[
                  hi GlanceBorderTop gui=underline guifg=black guibg=white
                  hi GlanceWinBarFilepath gui=italic guibg=#c1c1c1
                  hi GlanceWinBarFilename gui=italic guifg=black guibg=#c1c1c1
                  hi GlanceWinBarTitle gui=bold guifg=#010101 guibg=#c1c1c1
                  hi GlancePreviewBorderBottom gui=underline guifg=black
                  hi GlanceListCursorLine gui=none guibg=#aaaaaa
                  hi GlanceListBorderBottom gui=underline guifg=black
                  hi GlanceListNormal gui=italic guifg=indigo
                ]])
                return
            end
            -- dark theme
            vim.cmd([[
              hi GlanceBorderTop gui=underline guifg=#b5bcbd guibg=#10110A
              hi GlanceWinBarFilepath gui=italic guibg=#14140F
              hi GlanceWinBarFilename gui=none guibg=#14140F
              hi GlanceWinBarTitle gui=none guibg=#14140F
              hi GlancePreviewBorderBottom gui=underline guifg=#b5bcbd
              hi GlanceListCursorLine gui=none guibg=#656661
              hi GlanceListBorderBottom gui=underline guifg=#b5bcbd
              hi GlanceListNormal gui=italic guifg=e1e1e1
            ]])
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
