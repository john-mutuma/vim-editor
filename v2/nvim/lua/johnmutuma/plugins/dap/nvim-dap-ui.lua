local nvim_dap_ui_ok, dapui = pcall(require, "dapui")
local dap_ok, dap = pcall(require, "dap")

if not nvim_dap_ui_ok or not dap_ok then
    print("nvim-dap and/or nvim-dap-ui could not be loaded")
    return
end

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
