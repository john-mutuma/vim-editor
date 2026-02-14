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
                width = {
                    min = 30,
                    max = 50,
                },
            },
            renderer = {
                indent_markers = {
                    enable = true,
                },
            },
        })

        local mappings = require("nairovim.plugins.customizations.keymaps.nvim-tree").mappings
        local common_utils = require("nairovim.utils.common")
        common_utils.map(mappings)

        -- Highlight groups for NvimTree
        local get_hightlights = require("nairovim.plugins.customizations.highlights.nvim-tree").get
        common_utils.apply_highlights(get_hightlights, "nvim-tree_highlights_overrides_augroup")
    end,
}
