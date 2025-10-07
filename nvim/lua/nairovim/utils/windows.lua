----------------------------------------------------------------------
-- 1. Window Backdrop Utility
----------------------------------------------------------------------

local vim = vim
local M = {}

----------------------------------------------------------------------
-- 1. create_backdrop: Create a backdrop window
----------------------------------------------------------------------
--- Creates a backdrop window with the specified styling.
---  @param backdrop_name (string) The highlight group name for the backdrop.
---  @param blend (number) The transparency level (0-100).
---  @param zindex (number) The z-index for the backdrop window.
---  @return table A table containing backdrop_bufnr, backdrop_winid, and cleanup function.
---  @usage
---      local backdrop = require('nairovim.utils.windows').create_backdrop('MyBackdrop', 60, 39)
---      -- Later, call backdrop.cleanup() to remove the backdrop
M.create_backdrop = function(backdrop_name, blend, zindex)
    -- Set highlight for the backdrop if not already set
    if not vim.api.nvim_get_hl(0, { name = backdrop_name, link = false }) then
        vim.api.nvim_set_hl(0, backdrop_name, { bg = "#000000", default = true })
    end

    -- Create a scratch buffer for the backdrop
    local backdrop_bufnr = vim.api.nvim_create_buf(false, true)
    local backdrop_winid = vim.api.nvim_open_win(backdrop_bufnr, false, {
        relative = "editor",
        row = 0,
        col = 0,
        width = vim.o.columns,
        height = vim.o.lines,
        focusable = false,
        style = "minimal",
        zindex = zindex,
    })

    -- Style the backdrop window
    vim.wo[backdrop_winid].winhighlight = "Normal:" .. backdrop_name
    vim.wo[backdrop_winid].winblend = blend
    vim.bo[backdrop_bufnr].buftype = "nofile"

    -- Cleanup function to close backdrop window and buffer
    local function cleanup()
        if vim.api.nvim_win_is_valid(backdrop_winid) then
            vim.api.nvim_win_close(backdrop_winid, true)
        end
        if vim.api.nvim_buf_is_valid(backdrop_bufnr) then
            vim.api.nvim_buf_delete(backdrop_bufnr, { force = true })
        end
    end

    return {
        backdrop_bufnr = backdrop_bufnr,
        backdrop_winid = backdrop_winid,
        cleanup = cleanup,
    }
end

----------------------------------------------------------------------
-- 2. with_win_backdrop: Add a semi-transparent backdrop to a window
----------------------------------------------------------------------
---- Adds a semi-transparent backdrop behind a target floating window.
---  This function creates a scratch buffer and opens it as a floating window
---  behind the specified target window (by filetype or buffer pattern).
---  The backdrop is styled with a dark, semi-transparent background and is
---  automatically closed when the reference buffer is closed or left.
---
---  @param target_win (string) The filetype or buffer pattern for the target window.
---  @usage
---      require('nairovim.utils.windows').with_win_backdrop('NvimTree')
function M.with_win_backdrop(target_win)
    local blend = 60
    local default_zIndex = 40
    local backdrop_name = target_win .. "_backdrop"
    local augroup_name = "WinBackdrop_" .. target_win

    -- Create or clear the augroup for this target_win
    local group = vim.api.nvim_create_augroup(augroup_name, { clear = true })

    vim.api.nvim_create_autocmd({ "FileType", "BufWinEnter" }, {
        pattern = target_win,
        group = group,
        callback = function(ctx)
            local ref_bufnr = ctx.buf

            -- Create backdrop using the reusable function
            local backdrop = M.create_backdrop(backdrop_name, blend, default_zIndex - 1)

            -- Close backdrop when the reference buffer is closed or left
            vim.api.nvim_create_autocmd({ "WinClosed", "BufLeave" }, {
                once = true,
                buffer = ref_bufnr,
                group = group,
                callback = backdrop.cleanup,
            })
        end,
    })
end

return M
