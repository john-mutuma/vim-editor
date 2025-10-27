----------------------------------------------------------------------
-- MCP Hub Status Component (Reusable)
----------------------------------------------------------------------
local mcp_status_component = {
    function()
        -- Cache current buffer info once
        local current_buf = vim.api.nvim_get_current_buf()
        local current_filetype = vim.bo[current_buf].filetype

        -- Optimized AvanteInput check: only scan if current buffer isn't AvanteInput
        if current_filetype ~= "AvanteInput" then
            -- Use more efficient window check with early break
            for _, win_id in ipairs(vim.api.nvim_list_wins()) do
                if vim.bo[vim.api.nvim_win_get_buf(win_id)].filetype == "AvanteInput" then
                    return "" -- AvanteInput is open but current window isn't AvanteInput
                end
            end
        end

        --
        -- Early exit: Check if MCPHub is loaded first (most common case)
        if not vim.g.loaded_mcphub then
            return "󰐻 - not loaded"
        end

        -- Cache global variables
        local status = vim.g.mcphub_status or "stopped"

        -- Early return for stopped state
        if status == "stopped" then
            return "MCP 󰐻 - stopped"
        end

        -- Check for spinner states (executing, starting, restarting)
        local executing = vim.g.mcphub_executing
        if executing or status == "starting" or status == "restarting" then
            -- Optimized spinner: use bitwise operation for better performance
            local spinner_frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
            local frame_index = (math.floor(vim.uv.now() / 100) % 10) + 1
            return "MCP 󰐻 " .. spinner_frames[frame_index]
        end

        -- Default state: show server count
        local server_count = vim.g.mcphub_servers_count or 0
        return "MCP 󰐻 - " .. server_count .. (server_count == 1 and " server" or " servers")
    end,
    color = function()
        if not vim.g.loaded_mcphub then
            return "Comment" -- Gray for not loaded
        end

        local status = vim.g.mcphub_status or "stopped"
        if status == "ready" or status == "restarted" then
            return "DiagnosticOk" -- Green for connected
        elseif status == "starting" or status == "restarting" then
            return "DiagnosticWarn" -- Orange/yellow for connecting
        else
            return "DiagnosticError" -- Red for error/stopped
        end
    end,
}

----------------------------------------------------------------------
-- Extension Configurations
----------------------------------------------------------------------
local Blank = {
    sections = {
        lualine_a = { "" },
    },
    filetypes = {
        "packer",
        "filetree",
        "bufferlist",
        "copilot-chat",
        "copilot-overlay",
        "opencode",
        "opencode_terminal",
        "Avante",
        "AvanteTodos",
        "AvanteSelectedFiles",
        "NvimTree",
    },
}

local AvanteInputLualine = {
    sections = {
        lualine_a = { "" },
        lualine_x = { mcp_status_component },
    },
    filetypes = { "AvanteInput" },
}

local Snacks_Dashboard = {
    sections = {
        lualine_a = { "" },
        lualine_b = { "branch" },
        lualine_x = { mcp_status_component },
    },
    filetypes = { "snacks_dashboard" },
}

return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = { "VeryLazy" },
    config = function()
        require("lualine").setup({
            sections = {
                lualine_a = { "mode" },
                lualine_c = {
                    {
                        "filename",
                        file_status = true, -- displays file status (readonly status, modified status)
                        path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
                    },
                },
                lualine_x = { mcp_status_component },
            },
            extensions = {
                AvanteInputLualine,
                Snacks_Dashboard,
                Blank,
            },
            -- options = { theme = "grubbox" },
        })
    end,
}
