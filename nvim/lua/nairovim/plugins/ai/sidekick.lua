----------------------------------------------------------------------
-- 1. Terminal Theme Bridge
----------------------------------------------------------------------

local function format_rgb(color)
    local hex = string.format("%06x", color)
    local red = hex:sub(1, 2)
    local green = hex:sub(3, 4)
    local blue = hex:sub(5, 6)

    return string.format("rgb:%s%s/%s%s/%s%s", red, red, green, green, blue, blue)
end

local function resolve_color(color)
    if type(color) == "number" then
        return color
    end

    if type(color) == "string" then
        local resolved = vim.api.nvim_get_color_by_name(color)
        return resolved >= 0 and resolved or nil
    end
end

local function get_normal_color(key)
    local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
    local color = resolve_color(normal[key])
    if color then
        return color
    end

    local palette = require("nairovim.utils.theme").palette[vim.o.background]
    return resolve_color(key == "fg" and palette.fg or palette.bg)
end

local function setup_terminal_theme_bridge()
    local group = vim.api.nvim_create_augroup("NairoVimSidekickTerminalTheme", { clear = true })

    local function sync_colorfgbg()
        vim.env.COLORFGBG = vim.o.background == "light" and "0;15" or "15;0"
    end

    local function notify_theme_change()
        for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
            local reporting_enabled = vim.b[buffer].nairovim_color_scheme_reporting
            local channel = vim.bo[buffer].channel
            if reporting_enabled and channel > 0 then
                vim.api.nvim_chan_send(channel, "\027[?997n")
            end
        end
    end

    sync_colorfgbg()
    vim.api.nvim_create_autocmd("ColorScheme", {
        group = group,
        callback = function()
            sync_colorfgbg()
            vim.schedule(notify_theme_change)
        end,
    })

    vim.api.nvim_create_autocmd("TermRequest", {
        group = group,
        callback = function(event)
            if vim.bo[event.buf].filetype ~= "sidekick_terminal" then
                return
            end

            local sequence = event.data.sequence
            local responses = {}

            if sequence:find("\027%[%?2031h") then
                vim.b[event.buf].nairovim_color_scheme_reporting = true
            elseif sequence:find("\027%[%?2031l") then
                vim.b[event.buf].nairovim_color_scheme_reporting = false
            end

            if sequence:find("\027%[%?996n") then
                local color_scheme = vim.o.background == "light" and 2 or 1
                table.insert(responses, string.format("\027[?997;%dn", color_scheme))
            end

            for code in sequence:gmatch("\027%](1[01]);%?") do
                local color = get_normal_color(code == "10" and "fg" or "bg")
                if color then
                    table.insert(responses, string.format("\027]%s;%s\027\\", code, format_rgb(color)))
                end
            end

            local palette_query = sequence:match("\027%]4;([^\007\027]+)")
            if palette_query then
                for index in palette_query:gmatch("(%d+);%?") do
                    local color_index = tonumber(index)
                    local color = color_index and resolve_color(vim.g["terminal_color_" .. color_index])
                    if color_index and color_index >= 0 and color_index <= 15 and color then
                        table.insert(responses, string.format("\027]4;%d;%s\027\\", color_index, format_rgb(color)))
                    end
                end
            end

            if #responses > 0 then
                vim.api.nvim_chan_send(vim.bo[event.buf].channel, table.concat(responses))
            end
        end,
    })
end

local is_windows_terminal = vim.env.WT_SESSION ~= nil

----------------------------------------------------------------------
-- 2. Sidekick Plugin
----------------------------------------------------------------------

return {
    "john-mutuma/sidekick.nvim",
    opts = {
        -- add any options here
        cli = {
            mux = {
                -- backend = vim.fn.has("win32") == 1 and "tmux" or "zellij",
                backend = "tmux",
                -- Copilot's palette probes can time out behind psmux/tmux in Windows Terminal.
                enabled = not is_windows_terminal,
                -- enabled = true, -- Enable mux even in Windows Terminal (for Copilot CLI)
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
                    -- Let Copilot CLI handle its own keybindings (including <C-s> for save)
                },
            },
        },
    },
    config = function(_, opts)
        require("sidekick").setup(opts)
        setup_terminal_theme_bridge()

        -- Load keymaps from customizations
        local mappings = require("nairovim.plugins.customizations.keymaps.sidekick").mappings
        local common_utils = require("nairovim.utils.common")
        common_utils.map(mappings)

        -- Auto-restart CLI process in-place on ColorScheme so palettes re-detect bg.
        -- Complements the terminal theme bridge above: the bridge sends OSC 997
        -- "color scheme changed" notifications for CLIs that honor them (e.g.
        -- ghostty-native tools), but Copilot CLI does not re-read its palette at
        -- runtime — so we force a `tmux respawn-pane -k` restart of the CLI.
        -- See nvim/lua/nairovim/utils/sidekick_theme_sync.lua for details.
        require("nairovim.utils.sidekick_theme_sync").setup()
    end,
}
