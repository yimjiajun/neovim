local function setup()
    if pcall(require, 'dapui') == 0 or pcall(require, 'dap') == 0 then return end

    local dap = require("dap")
    local dapui = require("dapui")

    dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end

    dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end

    dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
end

return {Setup = setup}
