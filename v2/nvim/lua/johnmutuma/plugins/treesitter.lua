local opt = vim.opt
local treesitter_ok, treesitter = pcall(require, "nvim-treesitter.configs")

if not treesitter_ok then
	print("treesitter could not be loaded")
	return
end

treesitter.setup({
	highlight = { enable = true },
	indent = { enable = true },
	auto_tag = { enable = true },
	ensure_installed = {
		"json",
		"javascript",
		"typescript",
		"tsx",
		"lua",
		"vim",
		"css",
		"html",
		"markdown",
		"markdown_inline",
		"dockerfile",
		"gitignore",
		"bash",
		"yaml",
		"graphql",
		"c_sharp",
	},
	auto_install = true,
})

opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldenable = false --  Disable folding at startup.
-- opt.foldlevel = 1
