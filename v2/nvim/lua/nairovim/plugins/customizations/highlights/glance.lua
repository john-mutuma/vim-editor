local palette = require("nairovim.utils.theme").palette

local M = {}

local bg = vim.opt.background:get()
local c = palette[bg == "light" and "light" or "dark"]

--- @type nairovim.highlightspec
M.highlights = {
    GlanceWinBarFilepath = { italic = true, bg = c.highlight },
    GlanceWinBarFilename = { italic = true, fg = c.fg, bg = c.highlight },
    GlanceWinBarTitle = { bold = true, fg = c.fg, bg = c.highlight },
    GlanceListNormal = { italic = true },
    GlanceBorderTop = { link = "FloatBorder" },
    GlancePreviewBorderBottom = { link = "FloatBorder" },
    GlanceListBorderBottom = { link = "FloatBorder" },
}

return M
