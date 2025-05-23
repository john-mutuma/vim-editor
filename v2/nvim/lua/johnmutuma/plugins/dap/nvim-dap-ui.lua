return {
    "rcarriga/nvim-dap-ui",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local dapui = require("dapui")
        local dap = require("dap")

        dapui.setup()
        dap.listeners.before.attach.dapui_config = function()
            dapui.open()
        end

        dap.listeners.before.launch.dapui_config = function()
            dapui.open()
        end

        dap.listeners.before.event_terminated.dapui_config = function()
            dapui.close()
        end

        dap.listeners.before.event_exited.dapui_config = function()
            dapui.close()
        end
    end,
}
