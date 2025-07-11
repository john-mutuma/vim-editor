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
            local workspace_utils = require("nairovim.utils.workspace")
            local window_utils = require("nairovim.utils.windows")
            local git_utils = require("nairovim.utils.git")

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
                                vim.notify("Error fetching git branches: " .. (err or ""), vim.log.levels.ERROR)
                                return
                            end

                            local options = { "staged", "unstaged" }
                            vim.list_extend(options, git_branches)

                            vim.ui.select(options, { prompt = "Select anchor to diff against: " }, callback)
                        end,
                        resolve = function(input, source)
                            local cwd = source.cwd()
                            local diff = git_utils.get_git_diff(input, cwd)
                            local content = diff or ""
                            local filename = string.format("git_diff-@-%s", input)

                            return {
                                {
                                    content = content,
                                    filetype = "diff",
                                    filename = filename,
                                },
                            }
                        end,
                    },
                },
                sticky = {
                    "Today: " .. os.date("%Y-%m-%d"),
                    "/WORKSPACE_COPILOT_INSTRUCTIONS",
                    "$claude-sonnet-4",
                },
                question_header = " John Mutuma ",
                answer_header = "  Copilot ",
            })

            ----------------------------------------------------------------------
            -- 3. Autocmds (Grouped)
            ----------------------------------------------------------------------
            -- Buffer-local options for CopilotChat windows

            -- Create an augroup for copilot chat buffer settings
            local copilot_chat_group = vim.api.nvim_create_augroup("CopilotChatBufferOptions", { clear = true })
            vim.api.nvim_create_autocmd("BufEnter", {
                group = copilot_chat_group,
                pattern = { "copilot-chat", "copilot-overlay" },
                callback = function()
                    local opts = {
                        relativenumber = false,
                        number = false,
                        colorcolumn = "",
                        conceallevel = 0,
                        winfixwidth = true,
                    }
                    for k, v in pairs(opts) do
                        vim.opt_local[k] = v
                    end
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
                    vim.cmd("silent! Workspace RightPanelClose")
                    vim.cmd("CopilotChat")
                else
                    vim.cmd("CopilotChat")
                end
            end, { desc = "Open Copilot instructions file" })

            ----------------------------------------------------------------------
            -- 6. Keymaps (Global, with description for discoverability)
            ----------------------------------------------------------------------
            local mappings = require("nairovim.plugins.customizations.keymaps.copilot-chat").mappings
            local common_utils = require("nairovim.utils.common")
            common_utils.map(mappings)
        end,
    },
}
