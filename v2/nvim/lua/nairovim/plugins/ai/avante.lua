----------------------------------------------------------------------
-- Avante.nvim - AI-powered coding assistant
----------------------------------------------------------------------

----------------------------------------------------------------------
-- Optimized Avante Window Detection
----------------------------------------------------------------------
-- Convert to hash table for O(1) lookup performance
local M = {}
M.SELECTED_FILES_INITIALIZED = false
local avante_filetypes = {
    ["Avante"] = true,
    ["AvanteInput"] = true,
    ["AvanteAsk"] = true,
    ["AvanteSelectedFiles"] = true,
    ["AvanteTodos"] = true,
}

--- Check if the given buffer is in an Avante window
--- @param buf number Buffer handle
--- @return boolean true if buffer is in Avante window, false otherwise
local function is_in_avante_window(buf)
    -- Cache the filetype lookup for better performance
    local ok, ft = pcall(vim.api.nvim_get_option_value, "filetype", { buf = buf })
    if not ok or not ft then
        return false
    end
    -- O(1) hash table lookup instead of O(n) table search
    return avante_filetypes[ft]
end

----------------------------------------------------------------------
-- Reusable Avante Ask Function
----------------------------------------------------------------------
--- Send a question to Avante using the API
--- @param question string The question to ask Avante
--- @param opts? AskOptions Optional configuration for the ask request
local function ask_avante(question, opts)
    opts = opts or {}

    -- Get the Avante API
    local ok, avante_api = pcall(require, "avante.api")
    if not ok then
        vim.notify("Failed to load Avante API", vim.log.levels.ERROR)
        return false
    end

    -- Send the question
    local success, result = pcall(avante_api.ask, vim.tbl_extend("force", { question = question }, opts))
    if not success then
        vim.notify("Failed to ask Avante: " .. tostring(result), vim.log.levels.ERROR)
        return false
    end

    return true
end

return {
    "yetone/avante.nvim",
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    -- ⚠️ must add this setting! ! !
    build = function()
        -- conditionally use the correct build system for the current OS
        if vim.fn.has("win32") == 1 then
            return "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
        else
            return "make"
        end
    end,
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    config = function()
        local avante = require("avante")

        -- Set up Avante.nvim with the provided options
        avante.setup({
            -- add any opts here
            -- for example
            provider = "copilot",
            providers = {
                copilot = {
                    endpoint = "https://api.github.com",
                    model = "claude-sonnet-4",
                    -- timeout = 30000, -- Timeout in milliseconds
                    -- extra_request_body = {
                    -- temperature = 0.5,
                    -- max_tokens = 2048,
                    -- },
                },
                claude = {
                    endpoint = "https://api.anthropic.com",
                    model = "claude-sonnet-4-20250514",
                    timeout = 30000, -- Timeout in milliseconds
                    extra_request_body = {
                        temperature = 0.75,
                        max_tokens = 20480,
                    },
                },
            },
            selector = {
                provider = "snacks", -- or "fzf", "mini.pick"
                provider_opts = {
                    snacks = {
                        layout = {
                            split = false,
                        },
                    },
                },
            },
            file_selector = {
                provider = "snacks",
            },
            windows = {
                width = 33,
                input = {
                    height = 10,
                    border = "rounded", -- or "none", "single", "double", "solid", "shadow"
                },
                edit = {
                    border = "rounded", -- or "none", "single", "double", "solid", "shadow"
                },
                ask = {
                    border = "rounded", -- or "none", "single", "double", "solid", "shadow"
                },
            },
            slash_commands = {
                {
                    name = "pr_description",
                    description = "Generate a PR title and description for current branch",
                    callback = function()
                        -- Simple question - let Avante determine context automatically
                        local question =
                            "Generate a Pull Request title and description for the current branch changes following the project guidelines."
                        -- Use the reusable ask_avante function
                        ask_avante(question)
                    end,
                },
            },
            -- system_prompt as function ensures LLM always has latest MCP server state
            -- This is evaluated for every message, even in existing chats
            system_prompt = function()
                local hub = require("mcphub").get_hub_instance()
                return hub and hub:get_active_servers_prompt() or ""
            end,
            -- Using function prevents requiring mcphub before it's loaded
            custom_tools = function()
                return {
                    require("mcphub.extensions.avante").mcp_tool(),
                }
            end,
            disabled_tools = {
                "list_files", -- Built-in file operations
                "search_files",
                "read_file",
                "replace_in_file",
                "create_file",
                "rename_file",
                "delete_file",
                "create_dir",
                "rename_dir",
                "delete_dir",
                "view",
                "bash", -- Built-in terminal access
            },
        })

        local avante_chat_group = vim.api.nvim_create_augroup("AvanteBufferEnter", { clear = true })
        vim.api.nvim_create_autocmd("BufEnter", {
            group = avante_chat_group,
            pattern = "",
            callback = function(event)
                if not is_in_avante_window(event.buf) or M.SELECTED_FILES_INITIALIZED then
                    return
                end

                local opts = {
                    winfixwidth = true,
                }
                for k, v in pairs(opts) do
                    vim.opt_local[k] = v
                end

                local workspace = require("nairovim.utils.workspace")
                local github_workspace_dir = workspace.find_closest_dir_by_name(".github")
                if not github_workspace_dir then
                    print("No .github directory found in the workspace")
                    return
                end

                avante.get().file_selector:add_selected_file(github_workspace_dir)
                M.SELECTED_FILES_INITIALIZED = true
            end,
        })

        ----------------------------------------------------------------------
        -- Highlight Overrides Based on Colorscheme
        ----------------------------------------------------------------------
        local get_hightlights = require("nairovim.plugins.customizations.highlights.avante").get

        local common_utils = require("nairovim.utils.common")
        common_utils.apply_highlights(get_hightlights, "avante_highlights_overrides_augroup")
    end,
    dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        --- The below dependencies are optional,
        -- "echasnovski/mini.pick", -- for file_selector provider mini.pick
        "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
        "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
        -- "ibhagwan/fzf-lua", -- for file_selector provider fzf
        -- "stevearc/dressing.nvim", -- for input provider dressing
        "folke/snacks.nvim", -- for input provider snacks
        "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
        "zbirenbaum/copilot.lua", -- for providers='copilot'
        {
            -- support for image pasting
            "HakonHarnes/img-clip.nvim",
            event = "VeryLazy",
            opts = {
                -- recommended settings
                default = {
                    embed_image_as_base64 = false,
                    prompt_for_file_name = false,
                    drag_and_drop = {
                        insert_mode = true,
                    },
                    -- required for Windows users
                    use_absolute_path = true,
                },
            },
        },
        {
            -- Make sure to set this up properly if you have lazy=true
            "MeanderingProgrammer/render-markdown.nvim",
            opts = {
                file_types = { "markdown", "Avante", "copilot-chat" },
                code = {
                    language_border = " ",
                },
            },
            ft = { "markdown", "Avante" },
        },
    },
}
