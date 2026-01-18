----------------------------------------------------------------------
-- Tutorial System - Core Engine
----------------------------------------------------------------------
-- Interactive tutorial system for NairoVIM with step-by-step
-- guided lessons, real-time validation, and progress tracking.
----------------------------------------------------------------------

local M = {}

-- State management
local state = {
    current_lesson = nil,
    current_step = 1,
    lesson_progress = {},
    ui = {
        win = nil,
        buf = nil,
        backdrop = nil,
    },
}

-- Tutorial data file path
local DATA_PATH = vim.fn.stdpath("data") .. "/nairovim-tutorial.json"

----------------------------------------------------------------------
-- 1. Data Persistence
----------------------------------------------------------------------

--- Load tutorial progress from disk
---@return table
function M.load_progress()
    local file = io.open(DATA_PATH, "r")
    if not file then
        return {
            tutorials_completed = {},
            current_tutorial = nil,
            current_step = 1,
            first_launch = true,
        }
    end
    local content = file:read("*a")
    file:close()
    local ok, data = pcall(vim.json.decode, content)
    if not ok then
        return {
            tutorials_completed = {},
            current_tutorial = nil,
            current_step = 1,
            first_launch = true,
        }
    end
    return data
end

--- Save tutorial progress to disk
---@param data table
function M.save_progress(data)
    local file = io.open(DATA_PATH, "w")
    if not file then
        vim.notify("Failed to save tutorial progress", vim.log.levels.WARN)
        return false
    end
    local json = vim.json.encode(data)
    file:write(json)
    file:close()
    return true
end

----------------------------------------------------------------------
-- 2. UI Management
----------------------------------------------------------------------

--- Create tutorial window with backdrop
---@param lesson table
function M.create_ui(lesson)
    -- Close existing UI if any
    M.close_ui()

    -- Create backdrop
    local windows = require("nairovim.utils.windows")
    state.ui.backdrop = windows.create_backdrop("TutorialBackdrop", 70, 49)

    -- Calculate window dimensions
    local width = math.min(80, vim.o.columns - 10)
    local height = math.min(25, vim.o.lines - 5)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    -- Create buffer
    state.ui.buf = vim.api.nvim_create_buf(false, true)
    vim.bo[state.ui.buf].bufhidden = "wipe"
    vim.bo[state.ui.buf].filetype = "nairovim-tutorial"

    -- Create window
    state.ui.win = vim.api.nvim_open_win(state.ui.buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded",
        title = string.format(" 📚 %s ", lesson.title),
        title_pos = "center",
        zindex = 50,
    })

    -- Window options
    vim.wo[state.ui.win].wrap = true
    vim.wo[state.ui.win].linebreak = true
    vim.wo[state.ui.win].cursorline = true

    -- Key mappings for tutorial window
    local opts = { buffer = state.ui.buf, noremap = true, silent = true }
    vim.keymap.set("n", "q", function()
        M.quit()
    end, opts)
    vim.keymap.set("n", "<Space>", function()
        M.next_step()
    end, opts)
    vim.keymap.set("n", "n", function()
        M.next_step()
    end, opts)
    vim.keymap.set("n", "b", function()
        M.previous_step()
    end, opts)
    vim.keymap.set("n", "p", function()
        M.previous_step()
    end, opts)
    vim.keymap.set("n", "s", function()
        M.skip_lesson()
    end, opts)
    vim.keymap.set("n", "r", function()
        M.restart_lesson()
    end, opts)
    vim.keymap.set("n", "R", function()
        M.reset_all_progress()
    end, opts)

    -- Auto-close on buffer leave
    vim.api.nvim_create_autocmd("BufLeave", {
        buffer = state.ui.buf,
        once = true,
        callback = function()
            vim.schedule(function()
                M.close_ui()
            end)
        end,
    })
end

--- Close tutorial UI
function M.close_ui()
    if state.ui.win and vim.api.nvim_win_is_valid(state.ui.win) then
        vim.api.nvim_win_close(state.ui.win, true)
    end
    if state.ui.buf and vim.api.nvim_buf_is_valid(state.ui.buf) then
        vim.api.nvim_buf_delete(state.ui.buf, { force = true })
    end
    if state.ui.backdrop then
        state.ui.backdrop.cleanup()
    end
    state.ui = { win = nil, buf = nil, backdrop = nil }
end

--- Render current step content
function M.render_step()
    if not state.current_lesson or not state.ui.buf or not vim.api.nvim_buf_is_valid(state.ui.buf) then
        return
    end

    local lesson = state.current_lesson
    if not lesson.steps then
        return
    end
    local step = lesson.steps[state.current_step]
    if not step then
        return
    end

    local lines = {}
    local total_steps = #lesson.steps

    -- Header
    table.insert(lines, string.format("Lesson %s - Step %d of %d", lesson.id, state.current_step, total_steps))
    table.insert(lines, string.rep("─", 76))
    table.insert(lines, "")

    -- Step title
    table.insert(lines, "📍 " .. step.title)
    table.insert(lines, "")

    -- Step content (wrap text)
    for _, line in ipairs(vim.split(step.content, "\n")) do
        -- Simple word wrapping
        local wrapped = {}
        local current_line = ""
        for word in line:gmatch("%S+") do
            if #current_line + #word + 1 > 72 then
                table.insert(wrapped, current_line)
                current_line = word
            else
                current_line = current_line == "" and word or current_line .. " " .. word
            end
        end
        if current_line ~= "" then
            table.insert(wrapped, current_line)
        end
        for _, w in ipairs(wrapped) do
            table.insert(lines, "  " .. w)
        end
    end
    table.insert(lines, "")

    -- Progress indicator
    table.insert(lines, "Progress:")
    for i, s in ipairs(lesson.steps) do
        local icon = i < state.current_step and "✓" or (i == state.current_step and "→" or " ")
        local status = i < state.current_step and "(completed)" or (i == state.current_step and "(current)" or "")
        table.insert(lines, string.format("  %s Step %d: %s %s", icon, i, s.title, status))
    end
    table.insert(lines, "")

    -- Hint (if available)
    if step.hint then
        table.insert(lines, "💡 Hint: " .. step.hint)
        table.insert(lines, "")
    end

    -- Footer
    table.insert(lines, string.rep("─", 76))
    table.insert(lines, "[Space/n] Next  [b/p] Previous  [s] Skip  [r] Restart  [R] Reset All  [q] Quit")

    -- Render to buffer
    vim.bo[state.ui.buf].modifiable = true
    vim.api.nvim_buf_set_lines(state.ui.buf, 0, -1, false, lines)
    vim.bo[state.ui.buf].modifiable = false
end

----------------------------------------------------------------------
-- 3. Navigation & Control
----------------------------------------------------------------------

--- Start or resume tutorial
---@param lesson_id string|nil Lesson ID to start, or nil to resume last
function M.start(lesson_id)
    local progress = M.load_progress()

    -- Determine which lesson to load
    local target_lesson_id = lesson_id or progress.current_tutorial
    if not target_lesson_id then
        -- No lesson specified and no saved progress, show lesson list
        M.list_lessons()
        return
    end

    -- Load lesson
    local registry = require("nairovim.tutorials")
    local lesson = registry.get_lesson(target_lesson_id)
    if not lesson then
        vim.notify("Lesson not found: " .. target_lesson_id, vim.log.levels.ERROR)
        return
    end

    -- Set up state
    state.current_lesson = lesson
    state.current_step = progress.current_tutorial == target_lesson_id and progress.current_step or 1

    -- Create UI
    M.create_ui(lesson)
    M.render_step()

    -- Welcome notification
    vim.notify(string.format("📚 Starting: %s", lesson.title), vim.log.levels.INFO)
end

--- Move to next step
function M.next_step()
    if not state.current_lesson then
        return
    end

    local total_steps = #state.current_lesson.steps
    if state.current_step >= total_steps then
        M.complete_lesson()
        return
    end

    state.current_step = state.current_step + 1
    M.render_step()
    M.save_current_progress()
    
    -- Scroll to top of tutorial
    if state.ui.win and vim.api.nvim_win_is_valid(state.ui.win) then
        vim.api.nvim_win_set_cursor(state.ui.win, { 1, 0 })
    end
end

--- Move to previous step
function M.previous_step()
    if not state.current_lesson or state.current_step <= 1 then
        return
    end

    state.current_step = state.current_step - 1
    M.render_step()
    M.save_current_progress()
    
    -- Scroll to top of tutorial
    if state.ui.win and vim.api.nvim_win_is_valid(state.ui.win) then
        vim.api.nvim_win_set_cursor(state.ui.win, { 1, 0 })
    end
end

--- Skip current lesson
function M.skip_lesson()
    if not state.current_lesson then
        return
    end

    vim.ui.select({ "Yes", "No" }, {
        prompt = "Skip this lesson? You can return to it later.",
    }, function(choice)
        if choice == "Yes" then
            M.close_ui()
            vim.notify("Lesson skipped. Use :TutorialList to see all lessons.", vim.log.levels.INFO)
        end
    end)
end

--- Restart current lesson
function M.restart_lesson()
    if not state.current_lesson then
        return
    end

    state.current_step = 1
    M.render_step()
    M.save_current_progress()
    
    -- Scroll to top of tutorial
    if state.ui.win and vim.api.nvim_win_is_valid(state.ui.win) then
        vim.api.nvim_win_set_cursor(state.ui.win, { 1, 0 })
    end
    
    vim.notify("Lesson restarted", vim.log.levels.INFO)
end

--- Complete current lesson
function M.complete_lesson()
    if not state.current_lesson then
        return
    end

    local progress = M.load_progress()
    table.insert(progress.tutorials_completed, state.current_lesson.id)
    progress.current_tutorial = nil
    progress.current_step = 1
    M.save_progress(progress)

    M.close_ui()

    -- Celebration notification
    vim.notify(string.format("🎉 Lesson completed: %s!", state.current_lesson.title), vim.log.levels.INFO)

    -- Check if all lessons completed
    local registry = require("nairovim.tutorials")
    local all_lessons = registry.get_all_lessons()
    if #progress.tutorials_completed >= #all_lessons then
        vim.schedule(function()
            M.show_completion_certificate()
        end)
    else
        -- Offer next lesson
        vim.schedule(function()
            vim.ui.select({ "Continue to next lesson", "Return to lesson list", "Quit" }, {
                prompt = "What would you like to do next?",
            }, function(choice)
                if choice == "Continue to next lesson" then
                    M.start_next_lesson()
                elseif choice == "Return to lesson list" then
                    M.list_lessons()
                end
            end)
        end)
    end

    state.current_lesson = nil
    state.current_step = 1
end

--- Quit tutorial
function M.quit()
    M.save_current_progress()
    M.close_ui()
    vim.notify("Tutorial paused. Use :Tutorial to resume.", vim.log.levels.INFO)
end

----------------------------------------------------------------------
-- 4. Progress Management
----------------------------------------------------------------------

--- Save current progress
function M.save_current_progress()
    if not state.current_lesson then
        return
    end

    local progress = M.load_progress()
    progress.current_tutorial = state.current_lesson.id
    progress.current_step = state.current_step
    progress.first_launch = false
    M.save_progress(progress)
end

--- Reset all tutorial progress
function M.reset_all_progress()
    vim.ui.select({ "Yes, reset everything", "No, cancel" }, {
        prompt = "⚠️  Reset ALL tutorial progress? This will clear all completed lessons and start from scratch.",
    }, function(choice)
        if choice == "Yes, reset everything" then
            -- Reset progress data
            local default_progress = {
                tutorials_completed = {},
                current_tutorial = nil,
                current_step = 1,
                first_launch = true,
            }
            
            -- Attempt to save and verify success
            if M.save_progress(default_progress) then
                -- Close UI and reset state
                M.close_ui()
                state.current_lesson = nil
                state.current_step = 1
                
                vim.notify("✨ Tutorial progress reset! Use :Tutorial to start fresh.", vim.log.levels.INFO)
            else
                vim.notify("❌ Failed to reset progress. Please check file permissions and try again.", vim.log.levels.ERROR)
            end
        end
    end)
end

--- Check if this is first launch
---@return boolean
function M.is_first_launch()
    local progress = M.load_progress()
    return progress.first_launch == true
end

--- Show welcome prompt for first-time users
function M.show_welcome_prompt()
    vim.notify(
        "👋 Welcome to NairoVIM! Press <leader>tt to start the interactive tutorial, or press 't' from the dashboard.",
        vim.log.levels.INFO
    )
end

----------------------------------------------------------------------
-- 5. Lesson Management
----------------------------------------------------------------------

--- List all available lessons
function M.list_lessons()
    local registry = require("nairovim.tutorials")
    local lessons = registry.get_all_lessons()
    local progress = M.load_progress()

    local choices = {}
    for _, lesson in ipairs(lessons) do
        if lesson and lesson.id and lesson.title then
            local completed = vim.tbl_contains(progress.tutorials_completed or {}, lesson.id)
            local status = completed and "✓" or " "
            table.insert(
                choices,
                string.format("%s [%s] %s (%s)", status, lesson.id, lesson.title, lesson.duration or "5 min")
            )
        end
    end

    vim.ui.select(choices, {
        prompt = "Select a lesson to start:",
    }, function(choice, idx)
        if choice and idx then
            M.start(lessons[idx].id)
        end
    end)
end

--- Start the next uncompleted lesson
function M.start_next_lesson()
    local registry = require("nairovim.tutorials")
    local lessons = registry.get_all_lessons()
    local progress = M.load_progress()

    for _, lesson in ipairs(lessons) do
        if not vim.tbl_contains(progress.tutorials_completed, lesson.id) then
            M.start(lesson.id)
            return
        end
    end

    vim.notify("All lessons completed! 🎉", vim.log.levels.INFO)
end

--- Show completion certificate
function M.show_completion_certificate()
    local lines = {
        "",
        "╔══════════════════════════════════════════════════════╗",
        "║                                                      ║",
        "║              🎉 Congratulations! 🎉                  ║",
        "║                                                      ║",
        "║      You've completed all NairoVIM tutorials!       ║",
        "║                                                      ║",
        "║              ✓ 7 lessons completed                  ║",
        "║              ✓ 50 minutes of learning               ║",
        "║              ✓ 60+ keybindings mastered             ║",
        "║                                                      ║",
        "║        You're now ready to code like a pro! 🚀      ║",
        "║                                                      ║",
        "╚══════════════════════════════════════════════════════╝",
        "",
    }

    vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
end

return M
