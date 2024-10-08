local opt = vim.opt
local globl = vim.g

-- shell
opt.shell = "/bin/bash"

-- line numbers
opt.relativenumber = true
opt.number = true

-- sign column -- column
opt.signcolumn = "yes:1"

-- tabs and indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

-- wrapping
opt.wrap = false

-- search settings
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true

-- other appearance settings
opt.cursorline = true
opt.termguicolors = true
-- opt.background = "dark"
opt.colorcolumn = "118"

-- backspace
opt.backspace = "indent,eol,start"

-- clipboard linking with Vim
opt.clipboard:append("unnamedplus")

-- split windows
opt.splitright = true
opt.splitbelow = false

opt.iskeyword:append("-")

-- Plugins  mappings
-- nvim tree
opt.termguicolors = true

-- bufferline
opt.mousemoveevent = true

-- nvim-cmp
opt.completeopt = "menu,menuone,noselect"
opt.rtp:append(os.getenv("HOME") .. "/.fzf")
--
globl.qs_highlight_on_keys = { "f", "F", "t", "T", "/", "?" }
globl.sonokai_enable_italic = true
