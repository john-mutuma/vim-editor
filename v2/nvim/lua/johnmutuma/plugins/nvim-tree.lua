local globl = vim.g
local keymap = vim.keymap

-- disable netrw at the very start of your init.lua
globl.loaded_netrw = 1
globl.loaded_netrwPlugin = 1
keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>:<CR>$")

-- settings or options

local success, nvimTree = pcall(require, "nvim-tree")
if not success then
    print("nvim-tree failed to load")
    return
end

nvimTree.setup({
    filesystem_watchers = {
        enable = true,
        debounce_delay = 50,
        ignore_dirs = {
            "node_modules",
            "lib",
        },
    },
    update_focused_file = {
        enable = true,
        update_root = true,
        update_cwd = true,
        ignore_list = { "node_modules" },
    },
    git = {
        enable = true,
        timeout = 3000,
    },
    filters = {
        git_ignored = true,
    },
    view = {
        width = 50,
    },
    renderer = {
        indent_markers = {
            enable = true,
        },
    },
})

vim.cmd([[
  :hi NvimTreeCursorLine guibg=#444548
  :hi NvimTreeGitDirtyIcon guifg=red
  :hi NvimTreeModifiedIcon guifg=red
]])

if vim.opt.background:get() == "light" then
    vim.cmd([[
    :hi NvimTreeCursorLine guibg=#c1c1c1 guifg=#252525
  ]])
end
