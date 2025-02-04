require("notify").setup({
	max_width = 130,
})

require("noice").setup({
	routes = {
		{
			filter = {
				event = "msg_show",
				kind = "search_count",
			},
			opts = { skip = true },
		},
	},
	cmdline = {
		-- view = "cmdline",
		format = { cmdline = { icon = "_" } },
	},
	lsp = {
		-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
		override = {
			["vim.lsp.util.convert_input_to_markdown_lines"] = false,
			["vim.lsp.util.stylize_markdown"] = false,
			["cmp.entry.get_documentation"] = false,
		},
	},
	-- you can enable a preset for easier configuration
	presets = {
		bottom_search = true, -- use a classic bottom cmdline for search
		command_palette = true, -- position the cmdline and popupmenu together
		long_message_to_split = true, -- long messages will be sent to a split
		inc_rename = false, -- enables an input dialog for inc-rename.nvim
		lsp_doc_border = false, -- add a border to hover docs and signature help
	},
	views = {
		cmdline_popup = {
			position = {
				row = 2,
				col = "50%",
			},
			size = {
				width = 110,
				height = "auto",
			},
		},
		cmdline_popupmenu = {
			position = {
				row = 4,
				col = "50%",
			},
			size = {
				width = 110,
				height = "auto",
			},
		},
		-- popupmenu = {
		-- 	position = {
		-- 		row = 4,
		-- 		col = "50%",
		-- 	},
		-- 	size = {
		-- 		width = 100,
		-- 		height = 20,
		-- 	},
		-- 	border = {
		-- 		style = "rounded",
		-- 		padding = { 0, 1 },
		-- 	},
		-- 	win_options = {
		-- 		winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
		-- 	},
		-- },
	},
})
