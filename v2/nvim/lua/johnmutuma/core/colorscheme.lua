-- colorscheme
local globl = vim.g

globl.sonokai_enable_italic = true
--
-- NICE DARK THEMES
--
-- local success_colorscheme, _ = pcall(vim.cmd, "colorscheme tokyonight")
-- local success_colorscheme, _ = pcall(vim.cmd, "colorscheme ayu-dark")
local success_colorscheme, _ = pcall(vim.cmd, "colorscheme catppuccin-mocha")
-- local success_colorscheme, _ = pcall(vim.cmd, "colorscheme catppuccin-macchiato")
-- local success_colorscheme, _ = pcall(vim.cmd, "colorscheme nightfox")
--
-- NICE LIGHT THEMES
--
-- local success_colorscheme, _ = pcall(vim.cmd, "colorscheme retrobox")
-- local success_colorscheme, _ = pcall(vim.cmd, "colorscheme tokyonight-day")
-- local success_colorscheme, _ = pcall(vim.cmd, "colorscheme catppuccin-latte")
-- local success_colorscheme, _ = pcall(vim.cmd, "colorscheme dayfox")
-- local success_colorscheme, _ = pcall(vim.cmd, "colorscheme dawnfox")

if not success_colorscheme then
	print("Colorscheme not found")
	return
end
