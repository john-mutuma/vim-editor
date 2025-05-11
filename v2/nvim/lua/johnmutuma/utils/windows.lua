local M = {}
-- Creates backdrop for popup windows
function with_win_backdrop(target_win)
    -- CONFIG
    local blend = 60

    vim.api.nvim_create_autocmd({ "FileType", "BufWinEnter" }, {
        pattern = target_win,
        callback = function(ctx)
            local backdropName = "floating-win_backdrop"
            local bufnr = ctx.buf

            -- it uses the default value
            -- of `nvim_open_win`, which is 50: https://neovim.io/doc/user/api.html#nvim_open_win()
            local default_zIndex = 40

            local backdropBufnr = vim.api.nvim_create_buf(false, true)
            local winnr = vim.api.nvim_open_win(backdropBufnr, false, {
                relative = "editor",
                row = 0,
                col = 0,
                width = vim.o.columns,
                height = vim.o.lines,
                focusable = false,
                style = "minimal",
                zindex = default_zIndex - 1, -- ensure it's below the reference window
            })

            vim.api.nvim_set_hl(0, backdropName, { bg = "#000000", default = true })
            vim.wo[winnr].winhighlight = "Normal:" .. backdropName
            vim.wo[winnr].winblend = blend
            vim.bo[backdropBufnr].buftype = "nofile"

            -- close backdrop when the reference buffer is closed
            vim.api.nvim_create_autocmd({ "WinClosed", "BufLeave" }, {
                once = true,
                buffer = bufnr,
                callback = function()
                    if vim.api.nvim_win_is_valid(winnr) then
                        vim.api.nvim_win_close(winnr, true)
                    end
                    if vim.api.nvim_buf_is_valid(backdropBufnr) then
                        vim.api.nvim_buf_delete(backdropBufnr, { force = true })
                    end
                end,
            })
        end,
    })
end

M.with_win_backdrop = with_win_backdrop

return M
