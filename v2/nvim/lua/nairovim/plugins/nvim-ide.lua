return {
    "ldelossa/nvim-ide",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        -- Only require components that are actually used
        local bufferlist = require("ide.components.bufferlist")
        local outline = require("ide.components.outline")
        local callhierarchy = require("ide.components.callhierarchy")
        local timeline = require("ide.components.timeline")
        local bookmarks = require("ide.components.bookmarks")
        local icons = require("ide.icons")

        -- Use local variables for component names for readability
        local BufferListName = bufferlist.Name
        local BookmarksName = bookmarks.Name
        local OutlineName = outline.Name
        local TimelineName = timeline.Name
        local CallHierarchyName = callhierarchy.Name

        require("ide").setup({
            icon_set = "codicon",
            log_level = "info",
            components = {
                global_keymaps = {},
                Explorer = {
                    show_file_permissions = false,
                    list_directories_first = true,
                },
                BufferList = {
                    default_height = 15,
                },
                Timeline = {
                    default_height = 10,
                },
            },
            panels = {
                left = "git",
                right = "explorer",
            },
            panel_groups = {
                explorer = {
                    BufferListName,
                    BookmarksName,
                    OutlineName,
                    TimelineName,
                    CallHierarchyName,
                },
                git = {},
            },
            workspaces = {
                auto_open = "right",
            },
            panel_sizes = {
                left = nil,
                right = 47,
                bottom = 15,
            },
        })

        -- Set custom icons
        icons.global_icon_set.set_icon("Collapsed", "")
        icons.global_icon_set.set_icon("Expanded", "")
        icons.global_icon_set.set_icon("IndentGuide", "|")

        -- nvim-ide keymaps
        local mappings = require("nairovim.plugins.customizations.keymaps.nvim-ide").mappings
        local common_utils = require("nairovim.utils.common")
        common_utils.map(mappings)
    end,
}
