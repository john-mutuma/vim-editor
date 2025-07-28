----------------------------------------------------------------------
-- MCP Hub Status Component (Reusable)
----------------------------------------------------------------------
local mcp_status_component = {
    function()
        -- Check if MCPHub is loaded
        if not vim.g.loaded_mcphub then
            return "󰐻 -"
        end

        local count = vim.g.mcphub_servers_count or 0
        local status = vim.g.mcphub_status or "stopped"
        local executing = vim.g.mcphub_executing

        -- Show "-" when stopped
        if status == "stopped" then
            return "󰐻 -"
        end

        -- Show spinner when executing, starting, or restarting
        if executing or status == "starting" or status == "restarting" then
            local frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
            local frame = math.floor(vim.loop.now() / 100) % #frames + 1
            return "󰐻 " .. frames[frame]
        end

        return "󰐻 " .. count
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
        "Avante",
        "AvanteInput",
        "AvanteTodos",
        "AvanteSelectedFiles",
    },
}

local MCP_Info = {
    sections = {
        lualine_a = { "" },
        lualine_x = { mcp_status_component },
    },
    filetypes = { "Avante" },
}
-- local Git_Branch = { sections = { lualine_b = { "branch" }, lualine_y = { "progress" } }, filetypes = { "NvimTree" } }
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
            },
            extensions = {
                -- Blank, --[[ Git_Branch  ]]
                MCP_Info,
                Blank,
            },
            -- options = { theme = "grubbox" },
        })
    end,
}
