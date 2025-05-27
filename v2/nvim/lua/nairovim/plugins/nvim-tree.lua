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

        local mappings = require("nairovim.plugins.customizations.keymaps.nvim-tree").mappings
        local common_utils = require("nairovim.utils.common")
        common_utils.map(mappings)

        -- Highlight groups for NvimTree
        local function setHighlightOverrides()
            --- @type highlightspec
            local highlights = {
                NvimTreeGitDirtyIcon = { fg = "red" },
                NvimTreeModifiedIcon = { fg = "red" },
            }

            for group, opts in pairs(highlights) do
                vim.api.nvim_set_hl(0, group, opts)
            end
        end

        setHighlightOverrides()
        ----------------------------------------------------------------------
        -- Autocmd: Update Highlights on Colorscheme Change
        ----------------------------------------------------------------------
        vim.api.nvim_create_autocmd("ColorScheme", {
            group = vim.api.nvim_create_augroup("NvimTreeHighlightOverrides", { clear = true }),
            callback = setHighlightOverrides,
        })
    end,
}
