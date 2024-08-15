-- Lua configuration
local glance = require("glance")
local opt = vim.opt
-- local actions = glance.actions
glance.setup({
	border = {
		enable = true,
		top_char = " ",
		bottom_char = " ",
	},
})

vim.cmd([[
  :hi GlanceBorderTop gui=underline guifg=#ededed guibg=#10110A

  :hi GlanceWinBarFilepath gui=italic guibg=#14140F
  :hi GlanceWinBarFilename gui=none guibg=#14140F
  :hi GlanceWinBarTitle gui=none guibg=#14140F

  :hi GlancePreviewBorderBottom gui=underline guifg=#eeeeee

  :hi GlanceListCursorLine gui=none guibg=#656661

  :hi GlanceListBorderBottom gui=underline guifg=#eeeeee "guibg=#1D1D1D
  :hi GlanceListNormal gui=italic guifg=e1e1e1
  " :hi GlanceListEndOfBuffer gui=none guibg=#1D1D1D
]])

if opt.background:get() == "light" then
	vim.cmd([[
  :hi GlanceBorderTop gui=underline guifg=black guibg=white

  :hi GlanceWinBarFilepath gui=italic guibg=#c1c1c1
  :hi GlanceWinBarFilename gui=italic guifg=black guibg=#c1c1c1
  :hi GlanceWinBarTitle gui=bold guifg=#010101 guibg=#c1c1c1

  :hi GlancePreviewBorderBottom gui=underline guifg=black

  :hi GlanceListCursorLine gui=none guibg=#aaaaaa

  :hi GlanceListBorderBottom gui=underline guifg=black"guibg=#1D1D1D
  :hi GlanceListNormal gui=italic guifg=indigo
  " :hi GlanceListEndOfBuffer gui=underline guibg=#1D1D1D
]])
end
