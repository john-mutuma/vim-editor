local M = {}
local scooter_backdrop = nil

--- Open scooter terminal
local open_scooter = function()
    -- Clean up existing backdrop if any
    if scooter_backdrop then
        scooter_backdrop.cleanup()
        scooter_backdrop = nil
    end

    require("snacks").terminal("scooter", {
        win = {
            border = "rounded",
            width = 175,
            wo = {
                winblend = 9,
            },
        },
        on_exit = function()
            -- Clean up backdrop when terminal exits
            if scooter_backdrop then
                scooter_backdrop.cleanup()
                scooter_backdrop = nil
            end
        end,
    })
end

--- Called by scooter to open the selected file at the correct line from the scooter search list
_G.EditLineFromScooter = function(file_path, line)
    -- Close any open terminal windows
    local wins = vim.api.nvim_list_wins()
    for _, win in ipairs(wins) do
        local buf = vim.api.nvim_win_get_buf(win)
        local buf_name = vim.api.nvim_buf_get_name(buf)
        if buf_name:match("snacks_terminal") or vim.bo[buf].buftype == "terminal" then
            vim.api.nvim_win_close(win, true)
        end
    end

    -- Clean up backdrop
    if scooter_backdrop then
        scooter_backdrop.cleanup()
        scooter_backdrop = nil
    end

    local current_path = vim.fn.expand("%:p")
    local target_path = vim.fn.fnamemodify(file_path, ":p")

    if current_path ~= target_path then
        vim.cmd.edit(vim.fn.fnameescape(file_path))
    end

    vim.api.nvim_win_set_cursor(0, { line, 0 })
end

--- Opens scooter with the search text populated by the `search_text` arg
_G.OpenScooterSearchText = function(search_text)
    -- Clean up existing backdrop if any
    if scooter_backdrop then
        scooter_backdrop.cleanup()
        scooter_backdrop = nil
    end

    local escaped_text = vim.fn.shellescape(search_text:gsub("\r?\n", " "))
    require("snacks").terminal("scooter --search-text " .. escaped_text, {
        win = {
            border = "rounded",
            width = 175,
            wo = {
                winblend = 9,
            },
        },
        on_exit = function()
            -- Clean up backdrop when terminal exits
            if scooter_backdrop then
                scooter_backdrop.cleanup()
                scooter_backdrop = nil
            end
        end,
    })
end

----------------------------------------------------------------------
-- 2. User Commands
----------------------------------------------------------------------
vim.api.nvim_create_user_command("FindReplace", open_scooter, { desc = "Open scooter terminal for Find and replace" })

----------------------------------------------------------------------
-- 3. Keymaps
----------------------------------------------------------------------
local common_utils = require("nairovim.utils.common")
local mappings = require("nairovim.plugins.customizations.keymaps.scooter").mappings
common_utils.map(mappings)

return M
