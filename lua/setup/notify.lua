require('notify').setup({
	background_colour = "Normal",
	fps = 60,
	icons = {
	  DEBUG = "",
	  ERROR = "",
	  INFO = "",
	  TRACE = "✎",
	  WARN = ""
	},
	level = 0,
	minimum_width = 50,
	render = "default",
	stages = "slide",
	timeout = 5000,
	top_down = true,
})

-- replace vim notify by using notify plugin
vim.notify = require("notify")

-- suppress error messages from lang servers
vim.notify = function(msg, log_level, _opts)
    if msg:match("exit code") then
        return
    end
    if log_level == vim.log.levels.ERROR then
        vim.api.nvim_err_writeln(msg)
    else
        vim.api.nvim_echo({{msg}}, true, {})
    end
end
