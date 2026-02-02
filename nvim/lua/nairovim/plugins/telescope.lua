----------------------------------------------------------------------
-- 1. Telescope Plugin Setup
----------------------------------------------------------------------

return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
        { "nvim-lua/plenary.nvim" },
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = vim.fn.has("win32") == 1
                    and "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release"
                    or "make",
        },
    },
    config = function()
        ----------------------------------------------------------------------
        -- 2. Module Requires
        ----------------------------------------------------------------------
        local telescope = require("telescope")
        local builtin = require("telescope.builtin")
        local window_utils = require("nairovim.utils.windows")

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
        -- 5. Telescope Keymaps
        ----------------------------------------------------------------------
        local mappings = require("nairovim.plugins.customizations.keymaps.telescope").mappings
        local common_utils = require("nairovim.utils.common")
        common_utils.map(mappings)

        ----------------------------------------------------------------------
        -- 6. Add Backdrop for Depth
        ----------------------------------------------------------------------
        window_utils.with_win_backdrop("TelescopePrompt")
    end,
}
