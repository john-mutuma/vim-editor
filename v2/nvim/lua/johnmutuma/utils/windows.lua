----------------------------------------------------------------------
-- 1. Window Backdrop Utility
----------------------------------------------------------------------

local vim = vim
local M = {}

-- Creates a semi-transparent backdrop for popup windows
function M.with_win_backdrop(target_win)
    local blend = 60
    local default_zIndex = 40

    vim.api.nvim_create_autocmd({ "FileType", "BufWinEnter" }, {
        pattern = target_win,
        callback = function(ctx)
            local backdrop_name = target_win .. "_backdrop"
            local bufnr = ctx.buf

            -- Create a scratch buffer for the backdrop
            local backdrop_bufnr = vim.api.nvim_create_buf(false, true)
            local winnr = vim.api.nvim_open_win(backdrop_bufnr, false, {
                relative = "editor",
                row = 0,
                col = 0,
                width = vim.o.columns,
                height = vim.o.lines,
                focusable = false,
                style = "minimal",
                zindex = default_zIndex - 1, -- ensure it's below the reference window
            })

            -- Set highlight for the backdrop (only if not already set)
            if not vim.api.nvim_get_hl(0, { name = backdrop_name, link = false }) then
                vim.api.nvim_set_hl(0, backdrop_name, { bg = "#000000", default = true })
            end

            vim.wo[winnr].winhighlight = "Normal:" .. backdrop_name
            vim.wo[winnr].winblend = blend
            vim.bo[backdrop_bufnr].buftype = "nofile"

            -- Close backdrop when the reference buffer is closed or left
            vim.api.nvim_create_autocmd({ "WinClosed", "BufLeave" }, {
                once = true,
                buffer = bufnr,
                callback = function()
                    if vim.api.nvim_win_is_valid(winnr) then
                        vim.api.nvim_win_close(winnr, true)
                    end
                    if vim.api.nvim_buf_is_valid(backdrop_bufnr) then
                        vim.api.nvim_buf_delete(backdrop_bufnr, { force = true })
                    end
                end,
            })
        end,
    })
end

return M
