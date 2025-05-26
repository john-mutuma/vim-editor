local globl = vim.g
local opt = vim.opt

globl.indentLine_char = "│"
-- globl.indentLine_char = "⁞⋮"
-- globl.indentLine_char = "┆┊"
--
opt.list = true
-- opt.listchars:append("eol:↴")

return {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        require("ibl").setup({
            -- show_end_of_line = true,
            scope = { enabled = false },
        })
    end,
}
