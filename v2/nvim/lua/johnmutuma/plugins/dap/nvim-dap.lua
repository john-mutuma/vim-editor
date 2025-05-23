--
--
-- Use this file to install nvim-dap adapters, and use .vscode/launch.json to configure DAP launch configurations
-- Find available nvim-dap adapters from the nvim-dap repository
--
--

local vim = vim

return {
    "mfussenegger/nvim-dap",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "mxsdev/nvim-dap-vscode-js",
        "nvim-neotest/nvim-nio",
        {
            "microsoft/vscode-js-debug",
            opt = true,
            build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
        },
    },
    config = function()
        -- Run DapInstall in neovim to open this file and install the adapters
        vim.api.nvim_create_user_command("DapInstall", function(opts)
            local path_to_this_file = (debug.getinfo(1, "S").source:sub(2))
            vim.cmd("e " .. path_to_this_file)
            vim.cmd("normal! G")
        end, { nargs = nil })

        -- JS/TS debugg adapters
        require("dap-vscode-js").setup({
            adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }, -- which adapters to register in nvim-dap
            --
        })

        -- dap.adapters.python = {
    end,
}
