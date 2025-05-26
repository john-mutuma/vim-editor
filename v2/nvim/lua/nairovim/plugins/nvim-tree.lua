return {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
        "nvim-tree/nvim-web-devicons", -- optional, for file icons
    },
    event = { "VeryLazy" },
    config = function()
        -- Disable netrw at the very start
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

        require("nvim-tree").setup({
            filesystem_watchers = {
                enable = false,
                debounce_delay = 50,
                ignore_dirs = { "node_modules", "lib" },
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

        -- Keymap: Toggle NvimTree with <C-n>
        vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>:<CR>$", { silent = true })

        -- Highlight groups for NvimTree
        local highlights = {
            NvimTreeCursorLine = vim.opt.background:get() == "light" and { guibg = "#c1c1c1", guifg = "#252525" }
                or { guibg = "#444548" },
            NvimTreeGitDirtyIcon = { guifg = "red" },
            NvimTreeModifiedIcon = { guifg = "red" },
        }

        for group, opts in pairs(highlights) do
            local cmd = "hi " .. group
            for k, v in pairs(opts) do
                cmd = cmd .. " " .. k .. "=" .. v
            end
            vim.cmd(cmd)
        end
    end,
}
