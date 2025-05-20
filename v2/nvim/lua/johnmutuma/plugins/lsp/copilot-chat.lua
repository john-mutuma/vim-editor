local vim = vim
local workspace_utils = require("johnmutuma.utils.workspace")

local copilot_instructions = workspace_utils.load_file_from_closest_dir(".github", "copilot-instructions.md")

return {
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        -- event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            { "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
            { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
        },
        build = "make tiktoken", -- Only on MacOS or Linux
        config = function()
            local window_utils = require("johnmutuma.utils.windows")
            local copilot_chat = require("CopilotChat")

            copilot_chat.setup({
                window = {
                    layout = "float",
                    width = 0.85,
                    height = 0.85,
                    zindex = 45,
                },
                prompts = {
                    WORKSPACE_COPILOT_INSTRUCTIONS = {
                        system_prompt = copilot_instructions,
                    },
                },
                sticky = {
                    "/WORKSPACE_COPILOT_INSTRUCTIONS",
                },
            })

            local grp = vim.api.nvim_create_augroup("copilot_lspattach_augroup", { clear = true })
            vim.api.nvim_create_autocmd("LspAttach", {
                group = grp,
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    if client and client.name == "GitHub Copilot" then
                        vim.keymap.set(
                            { "n", "v" },
                            "<leader>cp",
                            "<cmd>CopilotChat<CR>",
                            { noremap = true, buffer = args.buf, silent = true }
                        )
                    end
                end,
            })

            -- Add backdrop to Copilot floating windows for depth
            window_utils.with_win_backdrop("copilot-chat")
            window_utils.with_win_backdrop("copilot-overlay")
        end,
    },
}
