----------------------------------------------------------------------
-- 1. Telescope Plugin Setup
----------------------------------------------------------------------

return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
        { "nvim-lua/plenary.nvim" },
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
        ----------------------------------------------------------------------
        -- 2. Module Requires
        ----------------------------------------------------------------------
        local telescope = require("telescope")
        local builtin = require("telescope.builtin")
        local window_utils = require("johnmutuma.utils.windows")

        ----------------------------------------------------------------------
        -- 3. Telescope Setup
        ----------------------------------------------------------------------
        telescope.setup({
            defaults = {
                mappings = {
                    i = {
                        ["<C-?>"] = "which_key",
                        ["<C-j>"] = "move_selection_next",
                        ["<C-k>"] = "move_selection_previous",
                    },
                },
            },
        })

        ----------------------------------------------------------------------
        -- 4. Load Extensions (Safely)
        ----------------------------------------------------------------------
        pcall(function()
            telescope.load_extension("fzf")
        end)

        ----------------------------------------------------------------------
        -- 5. Keymap Helper
        ----------------------------------------------------------------------
        local function map(lhs, func, desc)
            vim.keymap.set("n", lhs, func, { desc = desc })
        end

        ----------------------------------------------------------------------
        -- 6. Telescope Keymaps
        ----------------------------------------------------------------------
        map("<C-F>f", builtin.git_files, "Telescope: Git Files")
        map("<C-F>s", builtin.live_grep, "Telescope: Live Grep")
        map("<C-F>b", builtin.buffers, "Telescope: Buffers")
        map("<C-F>r", builtin.oldfiles, "Telescope: Recent Files")
        map("<C-F>h", builtin.help_tags, "Telescope: Help Tags")
        map("<C-F>y", builtin.git_branches, "Telescope: Git Branches")

        ----------------------------------------------------------------------
        -- 7. Add Backdrop for Depth
        ----------------------------------------------------------------------
        window_utils.with_win_backdrop("TelescopePrompt")
    end,
}
