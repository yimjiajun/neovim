local function setup()
    local dap = require("dap")
    local user_root = vim.fn.expand("$HOME")
    local tbl = require("plugin.dap").GetInfo("python")

    dap.adapters.python = function(cb, config)
        if config.request == "attach" then
            ---@diagnostic disable-next-line: undefined-field
            local port = (config.connect or config).port
            ---@diagnostic disable-next-line: undefined-field
            local host = (config.connect or config).host or "127.0.0.1"
            cb({
                type = "server",
                port = assert(
                    port,
                    "`connect.port` is required for a python `attach` configuration"
                ),
                host = host,
                options = { source_filetype = "python" },
            })
        else
            cb({
                type = "executable",
                command = user_root
                    .. "/.local/share/.virtualenvs/debugpy/bin/python",
                args = { "-m", "debugpy.adapter" },
                options = { source_filetype = "python" },
            })
        end
    end

    for _, v in pairs(tbl) do
        table.insert(dap.configurations.python, v)
    end
end

return { Setup = setup }
