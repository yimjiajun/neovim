local system_prefix_key = '<leader>vs'
local keymap = vim.api.nvim_set_keymap

local function setup_ui_git()
	local git_cmd
	local key = 'g'
	local desc = "git UI"
	local opts = { silent = true, desc = desc }

	if vim.fn.executable('lazygit') > 0 then
		git_cmd = 'lazygit'
	end

	if vim.fn.executable('gitui') > 0 then
		git_cmd = 'gitui'
	end

	if git_cmd ~= nil then
		if vim.fn.exists(':ToggleTerm') > 0 then
			git_cmd = [[<cmd> silent! TermExec cmd="]] .. git_cmd .. [[; exit" <CR>]]
		else
			git_cmd = [[<cmd> silent! term ]] .. git_cmd .. [[<CR>]]
		end

		if pcall(require, 'which-key') then
			local wk = require("which-key")
			local wk_mode = { mode = 'n', prefix = system_prefix_key }

			wk.register({[key] = desc }, wk_mode)
		end

		key = system_prefix_key .. key
		keymap('n', key, git_cmd, opts)
	end
end

local function setup_top()
	local top_cmd = 'top'
	local key = 't'
	local desc = "system resource"
	local opts = { silent = true, desc = desc }

	if vim.fn.executable('htop') == 1 then
		top_cmd = 'htop'
	end

	if vim.fn.executable('bpytop') == 1 then
		top_cmd = 'bpytop'
	end

	if vim.fn.exists(':ToggleTerm') > 0 then
		top_cmd = [[<cmd> silent! TermExec cmd="]] .. top_cmd .. [[; exit" <CR>]]
	else
		top_cmd = [[<cmd> silent! term ]] .. top_cmd .. [[<CR>]]
	end

	if pcall(require, 'which-key') then
		local wk = require("which-key")
		local wk_mode = { mode = 'n', prefix = system_prefix_key }
		wk.register({[key] = desc }, wk_mode)
	end

	key = system_prefix_key .. key
	keymap('n', key, top_cmd, opts)
end

local function setup_disk_usage()
	local du_cmd='clear;' .. 'du -h --max-depth=1 %:h' .. '; read -n 1'
	local key = 'd'
	local desc = "disk usage"
	local opts = { silent = true, desc = desc }

	if vim.fn.executable('ncdu') > 0 then
		du_cmd='ncdu %:h'
	end

	if vim.fn.executable('dutree') > 0 then
		du_cmd='clear;' .. 'dutree -d1 %:h' .. '; read -n 1'
	end

	if vim.fn.exists(':ToggleTerm') > 0 then
		du_cmd = [[<cmd> silent! TermExec cmd="]] .. du_cmd .. [[; exit" <CR>]]
	else
		du_cmd = [[<cmd> silent! term ]] .. du_cmd .. [[<CR>]]
	end

	if pcall(require, 'which-key') then
		local wk = require("which-key")
		local wk_mode = { mode = 'n', prefix = system_prefix_key }

		wk.register({[key] = desc }, wk_mode)
	end

	key = system_prefix_key .. key
	keymap('n',  key, du_cmd, opts)
end

local function setup_calendar()
	local prefix_key = '<leader>vc'
	local key = 'c'
	local desc = "date/calendar"
	local opts = { silent = true, desc = desc }
	local cmd

  if vim.fn.executable('khal') > 0 then
		keymap('n', prefix_key .. 't', [[<cmd> sp | term khal list today; exit <CR>]],
			{ silent = true, desc = 'khal list today'})
		keymap('n', prefix_key .. 'i', [[<cmd> term khal interactive; exit <CR>]],
			{ silent = true, desc = 'khal interactive'})

		cmd = [[khal calendar --format '● {start-time} | {title}']]

		if pcall(require, 'which-key') then
			local wk = require("which-key")
			local wk_mode = { mode = 'n', prefix = prefix_key }

			wk.register({
				[key] = desc,
				t = "khal list today",
				i = "khal interactive"
			}, wk_mode)
		end
	elseif vim.fn.executable('cal') > 0 then
		cmd = 'cal -y'
	else
		cmd = 'date'
	end

  if vim.fn.exists(":Calendar") > 0 then
		keymap('n', prefix_key .. 't', [[<cmd> Calendar -day <CR>]],
			{ silent = true, desc = 'Vim google Calendar list today'})

		if pcall(require, 'which-key') then
			local wk = require("which-key")
			local wk_mode = { mode = 'n', prefix = prefix_key }

			wk.register({ [key] = desc, t = "list today (vim)" }, wk_mode)
		end
  end

  cmd = [[<cmd> silent! sp | term ]] .. cmd .. [[<CR>]]

	if pcall(require, 'which-key') then
		local wk = require("which-key")
		local wk_mode = { mode = 'n', prefix = prefix_key }

		wk.register({[key] = desc }, wk_mode)
	end

	key = prefix_key .. key
	keymap('n',  key, cmd, opts)
end

local function setup()
	local tools_setup = {
		setup_ui_git,
		setup_top,
		setup_disk_usage,
		setup_calendar
	}

	for _, tool in ipairs(tools_setup) do
		tool()
	end
end

return {
	Setup = setup
}
