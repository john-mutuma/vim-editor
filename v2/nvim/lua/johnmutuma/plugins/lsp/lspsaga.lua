local saga_ok, lspsaga = pcall(require, "lspsaga")
if not saga_ok then
	print("lspsaga could not be loaded")
	return
end

lspsaga.setup({
	ui = {
		code_action = "",
		border = "double",
	},
	finder = {
		keys = {
			close = "<C-c>k",
			quit = { "<C-c>k", "<C-[>" },
		},
	},
})
