local vim = vim

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
            local copilot_chat = require("CopilotChat")

            local workspace_utils = require("johnmutuma.utils.workspace")
            local window_utils = require("johnmutuma.utils.windows")

            local copilot_chat_layout = workspace_utils.copilot_chat.layout

            local copilot_instructions =
                workspace_utils.load_file_from_closest_dir(".github", "copilot-instructions.md")

            local chat_window_size = 0.33
            if copilot_chat_layout == "float" then
                chat_window_size = 0.85
            end

            vim.api.nvim_create_user_command("OpenCopilotChat", function()
                if copilot_chat_layout == "vertical" then
                    vim.cmd([[
                        Workspace RightPanelClose
                        CopilotChat
                    ]])
                else
                    vim.cmd([[
                        CopilotChat
                    ]])
                end
            end, { desc = "Open Copilot instructions file" })

            vim.api.nvim_create_autocmd("BufEnter", {
                pattern = { "copilot-chat", "copilot-overlay" },
                callback = function()
                    -- Set buffer-local options
                    vim.opt_local.relativenumber = false
                    vim.opt_local.number = false
                    vim.opt_local.conceallevel = 0
                    vim.opt_local.colorcolumn = ""
                end,
            })

            copilot_chat.setup({
                window = {
                    layout = copilot_chat_layout,
                    width = chat_window_size,
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
                    "Today: " .. os.date("%Y-%m-%d"),
                },
                question_header = " John Mutuma ",
                answer_header = "  Copilot ",
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
                            "<cmd>OpenCopilotChat<CR>",
                            { noremap = true, buffer = args.buf, silent = true }
                        )
                    end
                end,
            })

            if copilot_chat_layout == "float" then
                -- Add backdrop to Copilot floating windows for depth
                window_utils.with_win_backdrop("copilot-chat")
                window_utils.with_win_backdrop("copilot-overlay")
            end
        end,
    },
}
