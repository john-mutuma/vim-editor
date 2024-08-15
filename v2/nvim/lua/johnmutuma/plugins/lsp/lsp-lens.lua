local success, lsp_lens = pcall(require, "lsp-lens")

if not success then
	print("lsp-lens failed to load")
	return
end

lsp_lens.setup({
	enable = true,
	include_declaration = false, -- Reference include declaration
	sections = { -- Enable / Disable specific request, formatter example looks 'Format Requests'
		definition = false,
		references = true,
		implements = false,
		git_authors = true,
	},
	ignore_filetype = {
		"prisma",
	},
})
