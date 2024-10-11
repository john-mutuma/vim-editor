-- colorscheme
local globl = vim.g

globl.sonokai_enable_italic = true
local success_colorscheme, _ = pcall(vim.cmd, "colorscheme tokyonight")
local success_background, _ = pcall(vim.cmd, "set background=dark")
-- local success_colorscheme, _ = pcall(vim.cmd, "colorscheme tokyonight-day")
-- local success_background, _ = pcall(vim.cmd, "set background=light")

if not (success_colorscheme and success_background) then
	print("Colorscheme not found")
	print("Colorscheme not found 1")
	return
end
