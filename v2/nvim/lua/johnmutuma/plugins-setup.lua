local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end

-- update reload plugins plugins with PackerSync whenever this file is saved
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins-setup.lua source <afile> | PackerSync
  augroup end
]])

local packer_bootstrap = ensure_packer()

local success, packer = pcall(require, "packer")
if not success then
	return
end

return packer.startup(function(use)
	-- use({
	-- 	"goolord/alpha-nvim",
	-- 	config = function()
	-- 		require("alpha").setup(require("alpha.themes.dashboard").config)
	-- 	end,
	-- })
	use("wbthomason/packer.nvim")
	-- My plugins here

	-- use 'foo1/bar1.nvim'
	-- workspace
	use({
		"ldelossa/nvim-ide",
	})
	use({
		"folke/zen-mode.nvim",
		config = function()
			require("zen-mode").setup({
				window = {
					width = 200,
				},
			})
		end,
	})
	-- lazy.nvim
	use({
		"folke/noice.nvim",

		-- event = "VeryLazy",
		opts = {
			-- add any options here
		},
		requires = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			-- OPTIONAL:
			--   `nvim-notify` is only needed, if you want to use the notification view.
			--   If not available, we use `mini` as the fallback
			"rcarriga/nvim-notify",
		},
	})
	use({ "folke/tokyonight.nvim" })
	use({
		"simrat39/symbols-outline.nvim",
		config = function()
			require("symbols-outline").setup()
		end,
	})
	-- preferred colorscheme
	use("dracula/vim") -- preferred colorscheme
	use("sainnhe/sonokai")
	use("tomasr/molokai")
	use("tanvirtin/monokai.nvim")
	use("Shatur/neovim-ayu")
	-- use("Mofiqul/vscode.nvim")
	use("ellisonleao/gruvbox.nvim")

	-- higlighting, indentation and folding
	use({
		"nvim-treesitter/nvim-treesitter",
		run = function()
			local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
			ts_update()
		end,
	})
	use("lukas-reineke/indent-blankline.nvim")

	use("szw/vim-maximizer") -- zoom out and in current buffer
	use("tpope/vim-surround")
	use("vim-scripts/ReplaceWithRegister") -- go replace <motion> e.g. graw --> go replace a word, gri{ --> go replace inside {
	use("machakann/vim-highlightedyank")
	use({
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	})
	use({
		"nvim-tree/nvim-tree.lua",
		requires = {
			"nvim-tree/nvim-web-devicons", -- optional
		},
	})
	use("preservim/nerdtree")
	use({
		"nvim-lualine/lualine.nvim",
		requires = { "nvim-tree/nvim-web-devicons", opt = true },
	})
	use({
		"nvim-telescope/telescope.nvim",
		tag = "0.1.2",
		-- or                            , branch = '0.1.x',
		requires = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
		},
	})
	use({
		"akinsho/bufferline.nvim",
		tag = "*",
		requires = "nvim-tree/nvim-web-devicons",
	})

	-- managing LSP servers, DAP servers, linters, formatters
	use({ "williamboman/mason.nvim", ["do"] = ":MasonUpdate" })
	use("williamboman/mason-lspconfig.nvim")
	-- configure LSP
	-- use CoC for some LSPs and vscode extensions
	use({ "neoclide/coc.nvim", branch = "release" })
	-- LSP cofigurations
	use("neovim/nvim-lspconfig")
	use({
		"nvimdev/lspsaga.nvim",
		requires = { "nvim-lspconfig" },
	})
	use("jose-elias-alvarez/typescript.nvim") -- better typescript development

	-- completion and snippets
	use({
		"hrsh7th/nvim-cmp", -- completion engine : needs to configure snippet engine in setup config e.g., luasnip, vsnip, ultisnip, snippy
		requires = {
			"L3MON4D3/LuaSnip", -- snippet engine
			"neovim/nvim-lspconfig", -- support lsp intergration in cmp window

			"saadparwaiz1/cmp_luasnip", -- snippet source for LuaSnip
			"hrsh7th/cmp-buffer", -- snippet source for buffer
			"hrsh7th/cmp-cmdline", -- snippet source for cmdline
			"hrsh7th/cmp-path", -- snippet source for path
			"rafamadriz/friendly-snippets", -- snippet source for various programming languages
			-- cmp lsp deps
			"hrsh7th/cmp-nvim-lsp", -- - nvim source for nvims builtin language server client
			"onsails/lspkind.nvim", -- add pictograms i.e. icons and/or labels to the cmp window
		},
	})

	-- auto pair, auto-tag, matching completions
	use("windwp/nvim-autopairs")
	use("windwp/nvim-ts-autotag")
	use({
		"andymass/vim-matchup",
		setup = function()
			-- may set any options here
			vim.g.matchup_matchparen_offscreen = { method = "popup" }
		end,
	})

	use("github/copilot.vim")
	-- linting and formatting
	use({
		"nvimtools/none-ls.nvim",
		requires = {
			{ "nvim-lua/plenary.nvim" },
		},
	})
	use({
		"jay-babu/mason-null-ls.nvim",
		requires = { "nvimtools/none-ls.nvim" },
	})
	use("lewis6991/gitsigns.nvim")

	-- working with VCS, git
	use("tpope/vim-fugitive")
	use("cedarbaum/fugitive-azure-devops.vim") --  support for GBrowse
	use("sindrets/diffview.nvim")
	use({
		"kdheepak/lazygit.nvim",
		-- optional for floating window border decoration
		requires = {
			"nvim-lua/plenary.nvim",
		},
	})
	-- Fzf support in NeoVim
	use({
		"junegunn/fzf",
		run = ":call fzf#install()",
	})
	use({
		"junegunn/fzf.vim",
	})
	use("yuki-yano/fzf-preview.vim")
	use("stsewd/fzf-checkout.vim")

	-- General utility plugins
	use("ctrlpvim/ctrlp.vim") -- access recent buffers quickly
	use("junegunn/vim-peekaboo") -- higlight contents of registers
	use("mattn/emmet-vim") -- just emmet
	use("unblevable/quick-scope") -- quickly jump horizontally
	use("rcarriga/nvim-notify")
	use({
		"dnlhc/glance.nvim",
		config = function()
			require("glance").setup({
				-- your configuration
			})
		end,
	})
	use({ "VidocqH/lsp-lens.nvim" })
	--
	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if packer_bootstrap then
		require("packer").sync()
	end
end)
