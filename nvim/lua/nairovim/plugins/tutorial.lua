----------------------------------------------------------------------
-- Tutorial Plugin Configuration
----------------------------------------------------------------------
-- Integrates the tutorial system with Neovim commands and lifecycle
----------------------------------------------------------------------

return {
    "nairovim-tutorial",
    dir = vim.fn.stdpath("config"), -- Local plugin
    lazy = false, -- Load immediately
    config = function()
        local tutorial = require("nairovim.utils.tutorial")

        -- Create user commands
        vim.api.nvim_create_user_command("Tutorial", function(opts)
            local lesson_id = opts.args ~= "" and opts.args or nil
            tutorial.start(lesson_id)
        end, {
            nargs = "?",
            desc = "Start or resume interactive tutorial",
            complete = function()
                local registry = require("nairovim.tutorials")
                local lessons = registry.get_all_lessons()
                local ids = {}
                for _, lesson in ipairs(lessons) do
                    if lesson and lesson.id then
                        table.insert(ids, lesson.id)
                    end
                end
                return ids
            end,
        })

        vim.api.nvim_create_user_command("TutorialList", function()
            tutorial.list_lessons()
        end, {
            desc = "List all available tutorial lessons",
        })

        vim.api.nvim_create_user_command("TutorialNext", function()
            tutorial.start_next_lesson()
        end, {
            desc = "Start the next uncompleted lesson",
        })

        vim.api.nvim_create_user_command("TutorialRestart", function()
            tutorial.restart_lesson()
        end, {
            desc = "Restart the current lesson",
        })

        -- First launch detection (run after everything is loaded)
        vim.schedule(function()
            if tutorial.is_first_launch() then
                vim.defer_fn(function()
                    tutorial.show_welcome_prompt()
                end, 1000) -- Wait 1 second after startup
            end
        end)
    end,
}
