----------------------------------------------------------------------
-- Tutorial Registry
----------------------------------------------------------------------
-- Central registry for all tutorial lessons
----------------------------------------------------------------------

local M = {}

-- Lazy-loaded lesson modules
local lessons = {
    require("nairovim.tutorials.lessons.01_basics"),
    require("nairovim.tutorials.lessons.02_editing"),
    require("nairovim.tutorials.lessons.03_search"),
    require("nairovim.tutorials.lessons.04_lsp"),
    require("nairovim.tutorials.lessons.05_ai"),
    require("nairovim.tutorials.lessons.06_git"),
    require("nairovim.tutorials.lessons.07_advanced"),
}

--- Get all available lessons
---@return table[]
function M.get_all_lessons()
    return lessons
end

--- Get a specific lesson by ID
---@param lesson_id string
---@return table|nil
function M.get_lesson(lesson_id)
    for _, lesson in ipairs(lessons) do
        if lesson and lesson.id == lesson_id then
            return lesson
        end
    end
    return nil
end

--- Get lesson count
---@return number
function M.count()
    return #lessons
end

return M
