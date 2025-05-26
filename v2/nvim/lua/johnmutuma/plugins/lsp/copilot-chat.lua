return {
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        dependencies = {
            { "github/copilot.vim" },
            { "nvim-lua/plenary.nvim", branch = "master" },
        },
        build = "make tiktoken",

        config = function()
            -- Lazy requires for performance
            local copilot_chat = require("CopilotChat")
            local workspace_utils = require("johnmutuma.utils.workspace")
            local window_utils = require("johnmutuma.utils.windows")
            local git_utils = require("johnmutuma.utils.git")

            ----------------------------------------------------------------------
            -- 1. Workspace & Window Configuration
            ----------------------------------------------------------------------
            local layout = workspace_utils.copilot_chat.layout
            local instructions = workspace_utils.load_file_from_closest_dir(".github", "copilot-instructions.md")
            local chat_width = layout == "float" and 0.85 or 0.25

            ----------------------------------------------------------------------
            -- 2. CopilotChat Setup
            ----------------------------------------------------------------------
            copilot_chat.setup({
                window = {
                    layout = layout,
                    width = chat_width,
                    height = 0.85,
                    zindex = 45,
                },
                prompts = {
                    WORKSPACE_COPILOT_INSTRUCTIONS = {
                        system_prompt = instructions,
                    },
                    PullRequestDescription = {
                        prompt = "Generate a pull request title and description based on the provided code changes.",
                    },
                },
                contexts = {
                    git = {
                        input = function(callback)
                            local git_branches, err = git_utils.get_git_branches()
                            if err or not git_branches then
                                vim.notify("Error fetching git branches: " .. err, vim.log.levels.ERROR)
                                return
                            end

                            vim.ui.select(
                                { "staged", "unstaged", unpack(git_branches) },
                                { prompt = "Select anchor to diff against: " },
                                callback
                            )
                        end,
                        resolve = function(input, source)
                            local diff = git_utils.get_git_diff(input, source.cwd())
                            return {
                                {
                                    content = diff,
                                    filetype = "diff",
                                    filename = "git_diff-@-" .. input,
                                },
                            }
                        end,
                    },
                },
                sticky = {
                    "Today: " .. os.date("%Y-%m-%d"),
                    "/WORKSPACE_COPILOT_INSTRUCTIONS",
                },
                question_header = " John Mutuma ",
                answer_header = "  Copilot ",
            })

            ----------------------------------------------------------------------
            -- 3. Autocmds (Grouped)
            ----------------------------------------------------------------------
            -- Buffer-local options for CopilotChat windows
            vim.api.nvim_create_autocmd("BufEnter", {
                pattern = { "copilot-chat", "copilot-overlay" },
                callback = function()
                    vim.opt_local.relativenumber = false
                    vim.opt_local.number = false
                    vim.opt_local.colorcolumn = ""
                    vim.opt_local.conceallevel = 0
                end,
            })

            ----------------------------------------------------------------------
            -- 4. UI/UX: Window Backdrop
            ----------------------------------------------------------------------
            if layout == "float" then
                window_utils.with_win_backdrop("copilot-chat")
                window_utils.with_win_backdrop("copilot-overlay")
            end

            ----------------------------------------------------------------------
            -- 5. User Commands
            ----------------------------------------------------------------------
            vim.api.nvim_create_user_command("OpenCopilotChat", function()
                if layout == "vertical" then
                    -- vim.cmd("silent! Workspace RightPanelClose")
                    vim.cmd("silent! Workspace RightPanelClose")
                    vim.cmd("CopilotChat")
                else
                    vim.cmd("CopilotChat")
                end
            end, { desc = "Open Copilot instructions file" })

            ----------------------------------------------------------------------
            -- 6. Keymaps (Global, with description for discoverability)
            ----------------------------------------------------------------------
            vim.keymap.set(
                { "n", "v" },
                "<leader>cp",
                "<cmd>OpenCopilotChat<CR>",
                { noremap = true, silent = true, desc = "Open Copilot Chat" }
            )
        end,
    },
}
