-- colorscheme
local globl = vim.g

globl.sonokai_enable_italic = true
local success_background, _ = pcall(vim.cmd, "set background=dark")
-- local success_colorscheme, _ = pcall(vim.cmd, "colorscheme ayu-dark")
local success_colorscheme, _ = pcall(vim.cmd, "colorscheme tokyonight")
--
-- local success_background, _ = pcall(vim.cmd, "set background=light")
-- local success_colorscheme, _ = pcall(vim.cmd, "colorscheme retrobox")
-- local success_colorscheme, _ = pcall(vim.cmd, "colorscheme tokyonight-day")

if not (success_colorscheme and success_background) then
	print("Colorscheme not found")
	return
end
