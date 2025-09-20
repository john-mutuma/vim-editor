----------------------------------------------------------------------
-- MCPHub.nvim - Model Context Protocol Hub for Neovim
----------------------------------------------------------------------
local window_utils = require("nairovim.utils.windows")

return {
    "ravitemer/mcphub.nvim",
    lazy = false, -- Load early for MCP server integration
    priority = 900, -- Load before AI plugins but after core dependencies
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    build = function()
        -- Only install if npm is available and not already installed
        if vim.fn.executable("npm") == 1 then
            local handle = io.popen("npm list -g mcp-hub 2>/dev/null")
            if handle then
                local result = handle:read("*a")
                handle:close()
                if not result:match("mcp%-hub@") then
                    return "npm install -g mcp-hub@latest"
                end
            end
        else
            vim.notify("npm not found - mcphub.nvim build step skipped", vim.log.levels.WARN)
        end
    end,
    config = function()
        -- Lazy require for better startup performance
        local ok, mcphub = pcall(require, "mcphub")
        if not ok then
            vim.notify("Failed to load mcphub: " .. mcphub, vim.log.levels.ERROR)
            return
        end

        mcphub.setup({
            extensions = {
                avante = {
                    make_slash_commands = true, -- make /slash commands from MCP server prompts
                },
                copilotchat = {
                    enabled = true,
                    convert_tools_to_functions = true, -- Convert MCP tools to CopilotChat functions
                    convert_resources_to_functions = true, -- Convert MCP resources to CopilotChat functions
                    add_mcp_prefix = false, -- Add "mcp_" prefix to function names
                },
            },
            -- Optimize for better performance
            timeout = 10000, -- 10 second timeout for MCP operations
            auto_start_servers = true, -- Automatically start configured servers
            log_level = "warn", -- Reduce log verbosity for better performance

            global_env = function(context)
                local env = {
                    "DBUS_SESSION_BUS_ADDRESS",
                }
                -- Add context-aware variables
                if context.is_workspace_mode then
                    env.workspaceFolder = context.workspace_root
                    -- env.WORKSPACE_PORT = tostring(context.port)
                end
                env.CONFIG_FILES = table.concat(context.config_files, ":")
                return env
            end,
            ui = {
                window = {
                    border = "rounded",
                },
            },
        })

        window_utils.with_win_backdrop("mcphub")
    end,
}
