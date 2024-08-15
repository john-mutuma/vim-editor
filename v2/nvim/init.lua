require("johnmutuma.plugins-setup")

require("johnmutuma.core.colorscheme")
require("johnmutuma.core.keymaps")
require("johnmutuma.core.options")

-- Plugins
require("johnmutuma.plugins.bufferline")
require("johnmutuma.plugins.lualine")
require("johnmutuma.plugins.nvim-cmp")
require("johnmutuma.plugins.nvim-tree")
require("johnmutuma.plugins.nerdtree")
require("johnmutuma.plugins.telescope")
-- - LSP
require("johnmutuma.plugins.lsp.mason")
require("johnmutuma.plugins.lsp.lspconfig")
require("johnmutuma.plugins.lsp.coc-nvim")
require("johnmutuma.plugins.lsp.lspsaga")
require("johnmutuma.plugins.lsp.lsp-lens")
require("johnmutuma.plugins.lsp.gitsigns")
require("johnmutuma.plugins.lsp.null-ls")

--
require("johnmutuma.plugins.autopairs")
require("johnmutuma.plugins.treesitter")
require("johnmutuma.plugins.indent-blankline")
require("johnmutuma.plugins.vim-fugitive")

require("johnmutuma.plugins.glance")

-- ide / workspace
require("johnmutuma.plugins.nvim-ide")
require("johnmutuma.plugins.noice")
