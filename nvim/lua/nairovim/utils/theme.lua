----------------------------------------------------------------------
-- 1. Generic Theme Palette
----------------------------------------------------------------------

--- @class nairovim.ThemeColors
--- @field fg string Foreground color
--- @field bg string Background color
--- @field border string Border color
--- @field border_bg string Border background color
--- @field accent string Accent color
--- @field muted string Muted color
--- @field subtle string Subtle color
--- @field highlight string Highlight color
--- @field error string Error color
--- @field info string Info color
--- @field warning string Warning color

--- @class nairovim.ThemePalette
--- @field light nairovim.ThemeColors Light theme colors
--- @field dark nairovim.ThemeColors Dark theme colors

local M = {}

--- Generic theme palette with light and dark variants.
--- @type nairovim.ThemePalette
M.palette = {
    light = {
        fg = "#010101",
        bg = "#ffffff",
        border = "black",
        border_bg = "white",
        accent = "indigo",
        muted = "#c1c1c1",
        subtle = "#aaaaaa",
        highlight = "#c1c1c1",
        error = "red",
        info = "blue",
        warning = "orange",
    },
    dark = {
        fg = "#e1e1e1",
        bg = "#10110A",
        border = "#b5bcbd",
        border_bg = "#10110A",
        accent = "#b5bcbd",
        muted = "#14140F",
        subtle = "#656661",
        highlight = "#14140F",
        error = "red",
        info = "blue",
        warning = "orange",
    },
}

return M
