local success, bufferline = pcall(require, "bufferline")

if not success then
	print("could not load bufferline")
	return
end

bufferline.setup({
	options = {
		mode = "tabs",
		numbers = "ordinal",
		separator_style = "slant",
		buffer_close_icon = "",
		hover = {
			enabled = true,
			delay = 200,
			reveal = { "close" },
		},
		offsets = {
			{
				filetype = "NvimTree",
				text = "File Explorer",
				text_align = "center",
				separator = true,
			},
		},
	},
})
