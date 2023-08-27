local dap_info = {
	python = {},
}

local dap = require('dap')

local function setup_dap_python()
	local user_root = vim.fn.expand('$HOME')

	dap.adapters.python = function(cb, config)
		if config.request == 'attach' then
			---@diagnostic disable-next-line: undefined-field
			local port = (config.connect or config).port
			---@diagnostic disable-next-line: undefined-field
			local host = (config.connect or config).host or '127.0.0.1'
			cb({
				type = 'server',
				port = assert(port, '`connect.port` is required for a python `attach` configuration'),
				host = host,
				options = {
					source_filetype = 'python',
				},
			})
		else
			cb({
				type = 'executable',
				command = user_root .. '/.local/share/.virtualenvs/debugpy/bin/python',
				args = { '-m', 'debugpy.adapter' },
				options = {
					source_filetype = 'python',
				},
			})
		end
	end

	for _, v in pairs(dap_info.python) do
		table.insert(dap.configurations.python, v)
	end
end

local function setup_dap_ui()
	local dapui = require("dapui")
	dap.listeners.after.event_initialized["dapui_config"] = function()
		dapui.open()
	end
	dap.listeners.before.event_terminated["dapui_config"] = function()
		dapui.close()
	end
	dap.listeners.before.event_exited["dapui_config"] = function()
		dapui.close()
	end
end

local function setup_keymapping(lang)
	local opts = { noremap = true, silent = true }

	if lang == 'python' then
		vim.api.nvim_set_keymap('n', '<leader>dpm', '<cmd>lua require"dap-python".test_method()<CR>', opts)
		vim.api.nvim_set_keymap('n', '<leader>dpc', '<cmd>lua require"dap-python".test_class()<CR>', opts)
		vim.api.nvim_set_keymap('v', '<leader>dps', '<cmd>lua require"dap-python".debug_selection()<CR>', opts)
		if pcall(require, 'which-key') then
			local wk = require('which-key')

			wk.register({
				p = { name = 'Python',
					m = 'test method',
					c = 'test class',
				}
			}, { mode = 'n', prefix = '<leader>d' })

			wk.register({
				p = { name = 'Python',
					s = 'debug selection'
				}
			}, { mode = 'v', prefix = '<leader>d' })
		end
	else
		vim.api.nvim_set_keymap('n', '<leader>db', '<cmd>lua require"dap".toggle_breakpoint()<CR>', opts)
		vim.api.nvim_set_keymap('n', '<leader>dB', '<cmd>lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>', opts)
		vim.api.nvim_set_keymap('n', '<leader>dd', '<cmd>lua require"dap".continue()<CR>', opts)
		vim.api.nvim_set_keymap('n', '<leader>dD', '<cmd>lua require"dap".disconnect()<CR>', opts)
		vim.api.nvim_set_keymap('n', '<leader>do', '<cmd>lua require"dap".repl.toggle()<CR>', opts)
		vim.api.nvim_set_keymap('n', '<leader>ds', '<cmd>lua require"dap".step_over()<CR>', opts)
		vim.api.nvim_set_keymap('n', '<leader>di', '<cmd>lua require"dap".step_into()<CR>', opts)
		vim.api.nvim_set_keymap('n', '<leader>dQ', '<cmd>lua require"dap".step_back()<CR>', opts)
		vim.api.nvim_set_keymap('n', '<leader>dq', '<cmd>lua require"dap".step_out()<CR>', opts)
		vim.api.nvim_set_keymap('n', '<leader>dT', '<cmd>lua require"dap".terminate()<CR>', opts)
		vim.api.nvim_set_keymap('n', '<leader>dR', '<cmd>lua require"dap".restart()<CR>', opts)
		vim.api.nvim_set_keymap('n', '<leader>dC', '<cmd>lua require"dap".clear_breakpoints()<CR>', opts)
		vim.api.nvim_set_keymap('n', '<leader>dl', '<cmd>lua require"dap".list_breakpoints()<CR>', opts)
		vim.api.nvim_set_keymap('n', '<leader>da', '<cmd>lua require"dap".run()<CR>', opts)
		vim.api.nvim_set_keymap('n', '<leader>dA', '<cmd>lua require"dap".run_last()<CR>', opts)
		vim.api.nvim_set_keymap('n', '<leader>dp', '<cmd>lua require"dap".pause()<CR>', opts)
		vim.api.nvim_set_keymap('n', '<leader>dg', '<cmd>lua require"dap".goto_()<CR>', opts)
		vim.api.nvim_set_keymap('n', '<leader>dS', '<cmd>lua require"dap".status()<CR>', opts)
		vim.api.nvim_set_keymap('n', '<leader>dp', '<cmd>lua require"dap".pause()<CR>', opts)

		if pcall(require, 'which-key') then
			local wk = require('which-key')
			local keymap = {
				b = 'toggle breakpoint',
				B = 'toggle conditional breakpoint',
				d = 'continue',
				s = 'step over',
				i = 'step into',
				q = 'step out',
				Q = 'step back',
				o = 'open repl',
				T = 'terminate',
				R = 'restart',
				C = 'clear all breakpoints',
				l = 'list breakpoints',
				a = 'run',
				A = 'run last',
				D = 'disconnect',
				p = 'pause',
				g = 'goto',
			}

			wk.register(keymap,
				{ mode = 'n', prefix = '<leader>d' })

			wk.register({ d = 'Debugger',
				}, { mode = 'v', prefix = '<leader>' })
		end
	end
end

local function dap_insert_info(tbl, client)
	if (client == nil) or (tbl == nil) then
		return
	end

	if client == 'python' then
		table.insert(dap_info.python, tbl)
	end
end

return {
	SetupKeymap = setup_keymapping,
	SetupUI = setup_dap_ui,
	SetupPython = setup_dap_python,
	InsertInfo = dap_insert_info,
}
