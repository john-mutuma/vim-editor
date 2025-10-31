local M = {}
local Terminal = require("toggleterm.terminal").Terminal
local window_utils = require("nairovim.utils.windows")
local scooter_term = nil
local scooter_backdrop = nil

--- Open existing scooter terminal if one is available, otherwise create a new one
local open_scooter = function()
    if not scooter_term then
        scooter_term = Terminal:new({
            cmd = "scooter",
            direction = "float",
            close_on_exit = true,
            display_name = "Find and Replace",
            on_open = function()
                -- Create backdrop with z-index lower than terminal (default: 40)
                scooter_backdrop = window_utils.create_backdrop("ScooterBackdrop", 60, 39)
            end,
            on_close = function()
                -- Clean up backdrop when terminal closes
                if scooter_backdrop then
                    scooter_backdrop.cleanup()
                    scooter_backdrop = nil
                end
            end,
            highlights = {
                FloatBorder = { link = "FloatBorder" },
            },
            float_opts = {
                border = "rounded",
                winblend = 9,
                width = 175,
            },
            on_exit = function()
                scooter_term = nil
            end,
        })
    end
    scooter_term:open()
end

--- Called by scooter to open the selected file at the correct line from the scooter search list
_G.EditLineFromScooter = function(file_path, line)
    if scooter_term and scooter_term:is_open() then
        scooter_term:close()
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
    if scooter_term and scooter_term:is_open() then
        scooter_term:close()
    end

    local escaped_text = vim.fn.shellescape(search_text:gsub("\r?\n", " "))
    scooter_term = Terminal:new({
        cmd = "scooter --search-text " .. escaped_text,
        direction = "float",
        close_on_exit = true,
        on_open = function()
            -- Create backdrop with z-index lower than terminal (default: 40)
            scooter_backdrop = window_utils.create_backdrop("ScooterBackdrop", 60, 39)
        end,
        on_close = function()
            -- Clean up backdrop when terminal closes
            if scooter_backdrop then
                scooter_backdrop.cleanup()
                scooter_backdrop = nil
            end
        end,
        on_exit = function()
            scooter_term = nil
        end,
    })
    scooter_term:open()
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
