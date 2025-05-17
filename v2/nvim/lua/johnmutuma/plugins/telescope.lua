local keymap = vim.keymap

return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
        { "nvim-lua/plenary.nvim" },
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
        local telescope = require("telescope")
        local builtin = require("telescope.builtin")

        local window_utils = require("johnmutuma.utils.windows")
        telescope.setup({
            defaults = {
                -- Default configuration for telescope goes here:
                -- config_key = value,
                mappings = {
                    i = {
                        -- map actions.which_key to <C-h> (default: <C-/>)
                        -- actions.which_key shows the mappings for your picker,
                        -- e.g. git_{create, delete, ...}_branch for the git_branches picker
                        ["<C-?>"] = "which_key",
                        ["<C-j>"] = "move_selection_next",
                        ["<C-k>"] = "move_selection_previous",
                    },
                },
            },
            pickers = {
                -- Default configuration for builtin pickers goes here:
                -- picker_name = {
                --   picker_config_key = value,
                --   ...
                -- }
                -- Now the picker_config_key will be applied every time you call this
                -- builtin picker
            },
            extensions = {
                -- Your extension configuration goes here:
                -- extension_name = {
                --   extension_config_key = value,
                -- }
                -- please take a look at the readme of the extension you want to configure
            },
        })

        telescope.load_extension("fzf") -- make use of nvim-fzf-native plugin for better performance

        -- Plugins mappings
        -- -- telescope
        keymap.set("n", "<C-F>f", builtin.git_files, {})
        keymap.set("n", "<C-F>s", builtin.live_grep, {})
        keymap.set("n", "<C-F>b", builtin.buffers, {})
        keymap.set("n", "<C-F>h", builtin.help_tags, {})
        keymap.set("n", "<C-F>y", builtin.git_branches, {})

        -- manually adding a backdrop to telescope prompt to add depth
        -- can remove this when Telescope has added a backdrop internally or if neovim decideds to include backdrops to floating windows for depth
        window_utils.with_win_backdrop("TelescopePrompt")
    end,
}
