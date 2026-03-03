return {
    "john-mutuma/sidekick.nvim",
    opts = {
        -- add any options here
        cli = {
            mux = {
                -- Platform-specific backend: psmux (tmux-compatible) on Windows, zellij on macOS/Linux
                backend = vim.fn.has("win32") == 1 and "tmux" or "zellij",
                enabled = true,
            },
            win = {
                layout = "right", -- Terminal appears on right side
                split = {
                    width = 0.40, -- 40% of screen width (matches OpenCode config)
                    height = 0, -- Full height (0 = auto)
                },
            },
            tools = {
                opencode = {
                    -- OpenCode uses <c-p> for its own command list functionality
                    -- Override sidekick's default to use Alt+P instead
                    keys = { prompt = { "<a-p>", "prompt" } },
                },
                copilot = {
                    cmd = { "agency", "copilot" },
                    -- Optional: custom keymaps for this tool
                    keys = {
                        submit = {
                            "<c-s>",
                            function(t)
                                t:send("\n")
                            end,
                        },
                    },
                },
            },
        },
    },
    config = function(_, opts)
        require("sidekick").setup(opts)

        -- Load keymaps from customizations
        local mappings = require("nairovim.plugins.customizations.keymaps.sidekick").mappings
        local common_utils = require("nairovim.utils.common")
        common_utils.map(mappings)
    end,
}
