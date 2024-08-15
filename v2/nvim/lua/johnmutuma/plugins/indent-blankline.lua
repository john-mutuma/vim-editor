local globl = vim.g
local opt = vim.opt

globl.indentLine_char = "│"
-- globl.indentLine_char = "⁞⋮"
-- globl.indentLine_char = "┆┊"
--
opt.list = true
-- opt.listchars:append("eol:↴")

require("ibl").setup({
	-- show_end_of_line = true,
	scope = { enabled = false },
})
