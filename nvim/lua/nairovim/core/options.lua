----------------------------------------------------------------------
-- 1. Leader and Localleader
----------------------------------------------------------------------
local opt = vim.opt
local g = vim.g

g.mapleader = ","
g.maplocalleader = " "

----------------------------------------------------------------------
-- 2. Shell (Cross-platform)
----------------------------------------------------------------------
if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
    -- Windows: Use PowerShell 7 with fallback to PowerShell 5.1
    if vim.fn.executable("pwsh") == 1 then
        opt.shell = "pwsh"
    else
        opt.shell = "powershell"
    end
    -- Windows shell flags for proper command execution
    opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
    opt.shellquote = ""
    opt.shellxquote = ""
else
    -- Unix/macOS: Use bash
    opt.shell = "/bin/bash"
end

----------------------------------------------------------------------
-- 3. Line Numbers
----------------------------------------------------------------------
opt.number = true
opt.relativenumber = true

----------------------------------------------------------------------
-- 4. Sign Column
----------------------------------------------------------------------
opt.signcolumn = "yes:1"

----------------------------------------------------------------------
-- 5. Tabs and Indentation
----------------------------------------------------------------------
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

----------------------------------------------------------------------
-- 6. Wrapping
----------------------------------------------------------------------
opt.wrap = false

----------------------------------------------------------------------
-- 7. Search Settings
----------------------------------------------------------------------
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true

----------------------------------------------------------------------
-- 8. Appearance
----------------------------------------------------------------------
opt.cursorline = true
opt.termguicolors = true
opt.colorcolumn = ""

----------------------------------------------------------------------
-- 9. Backspace
----------------------------------------------------------------------
opt.backspace = { "indent", "eol", "start" }

----------------------------------------------------------------------
-- 10. Clipboard
----------------------------------------------------------------------
opt.clipboard:append("unnamedplus")

-- WSL2 clipboard integration with Windows
if vim.fn.has("wsl") == 1 then
    g.clipboard = {
        name = "WslClipboard",
        copy = {
            ["+"] = "clip.exe",
            ["*"] = "clip.exe",
        },
        paste = {
            ["+"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
            ["*"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
        },
        cache_enabled = 0,
    }
end

----------------------------------------------------------------------
-- 11. Split Windows
----------------------------------------------------------------------
opt.splitright = true
opt.splitbelow = false

----------------------------------------------------------------------
-- 12. Keyword Characters
----------------------------------------------------------------------
opt.iskeyword:append("-")

----------------------------------------------------------------------
-- 13. Mouse and Bufferline
----------------------------------------------------------------------
opt.mousemoveevent = true

----------------------------------------------------------------------
-- 14. Completion
----------------------------------------------------------------------
opt.completeopt = { "menu", "menuone", "noselect" }

----------------------------------------------------------------------
-- 15. Runtime Path (FZF)
----------------------------------------------------------------------
local home = os.getenv("HOME")
if home then
    opt.rtp:append(home .. "/.fzf")
end

----------------------------------------------------------------------
-- 16. Plugin-specific Globals
----------------------------------------------------------------------
g.qs_highlight_on_keys = { "f", "F", "t", "T", "/", "?" }

----------------------------------------------------------------------
-- 17. Cursor Shape and Blinking
----------------------------------------------------------------------
opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,"
    .. "a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,"
    .. "sm:block-blinkwait175-blinkoff150-blinkon175"
