local function setup()
	local telescope = require("telescope")
	local extensions

	local function setup_keymap()
		local k = vim.api.nvim_set_keymap
		local opts = { noremap = true, silent = true }

		k('n', '<leader>w', [[<cmd> lua require('plugin.telescope').Buffer().buffer_with_del() <CR>]], opts)
		k('n', '<Leader>ggs', [[<cmd> lua require('telescope.builtin').git_status() <CR>]], opts)
		k('n', '<leader>q', [[<cmd> lua require('telescope.builtin').marks() <CR>]], opts)
		k('n', '<leader>h', [[<cmd> lua require('telescope.builtin').jumplist() <CR>]], opts)
		k('n', '<leader>r', [[<cmd> lua require('telescope.builtin').registers() <CR>]], opts)
		k('n', "z=", [[<cmd> lua require('telescope.builtin').spell_suggest() <CR>]],
			{ silent = true, desc = 'Spell Suggest' })
		k('n', '<Leader>ggL', [[<cmd> lua require('telescope.builtin').git_commits() <CR>]], opts)

		if vim.fn.filereadable("tags") == 1 and vim.fn.exists(':Tagbar') == 0 then
			k('n', "<leader>tt", [[<cmd> lua require('telescope.builtin').current_buffer_tags() <CR>]],
				{ silent = true, desc = 'buffer tags list' })
		end

		k('n', "<leader>tS", [[<cmd> lua require('telescope.builtin').tagstack() <CR>]],
			{ silent = true, desc = 'tag stack selection' })
		k('n', "<leader>fb", [[<cmd> lua require('telescope.builtin').current_buffer_fuzzy_find() <CR>]],
			{ silent = true, desc = 'search current buffer' })
		k('n', "<leader>ft", [[<cmd> lua require('telescope.builtin').tags() <CR>]],
			{ silent = true, desc = 'search from tags' })
		k('n', "<leader>ff",
			[[<cmd> lua require('telescope.builtin').find_files({hidden=false, no_ignore=false, no_ignore_parent=false}) <CR>]],
			{ silent = true, desc = 'search files' })
		k('n', "<leader>fF",
			[[<cmd> lua require('telescope.builtin').find_files({hidden=true, no_ignore=true, no_ignore_parent=true}) <CR>]],
			{ silent = true, desc = 'search all files' })

		if pcall(require, "which-key") then
			local wk = require("which-key")
			wk.register({
				t = { t = "tags list",
					S = "tags stack" },
				f = {
					b = "buffer search",
					F = "all files",
					t = "tags", },
				}, { prefix = "<leader>" })
		end
	end

	local function get_live_grep_args()
		local lga_actions = require("telescope-live-grep-args.actions")
		local ret = {
			auto_quoting = true,
			mappings = {
				i = {
					["<C-k>"] = lga_actions.quote_prompt(),
					["<C-i>"] = lga_actions.quote_prompt({ postfix = " --no-ignore " }),
					["<A-c>"] = lga_actions.quote_prompt({ postfix = " --no-ignore --glob '*.{c,cpp}'"}),
					["<A-C>"] = lga_actions.quote_prompt({ postfix = " --no-ignore --glob '*.{c,cpp,h,hpp}'"}),
					["<A-h>"] = lga_actions.quote_prompt({ postfix = " --no-ignore --glob '*.{h,hpp}'"}),
					["<A-k>"] = lga_actions.quote_prompt({ postfix = " --no-ignore --glob '{*.conf,Kconfig}'"}),
					["<A-K>"] = lga_actions.quote_prompt({ postfix = " --no-ignore --glob 'Kconfig'"}),
					["<A-d>"] = lga_actions.quote_prompt({ postfix = " --no-ignore --glob '*.{dts,dtsi}'"}),
					["<A-m>"] = lga_actions.quote_prompt({ postfix = " --no-ignore --glob '{CMakeLists,MakeFile,makefile}'"}),
					["<A-M>"] = lga_actions.quote_prompt({ postfix = " --no-ignore --glob '*.{md,rst,txt}'"}),
				},
			},
		}

		return ret
	end

	local function get_bookmark()
		local function get_browser()
			if vim.fn.executable("buku") == 1 then
				return 'buku'
			elseif vim.fn.executable("chrome") == 1 then
				return 'chrome'
			elseif vim.fn.executable("msedge.exe") == 1 then
				return 'edge'
			elseif vim.fn.executable("safari") == 1 then
				return 'safari'
			elseif vim.fn.executable("firefox") == 1 then
				return 'firefox'
			else
				return nil
			end
		end

		local function get_url_open_command()
			if vim.fn.executable("wslview") == 1 then
				return 'wslview'
			elseif vim.fn.executable("xdg-open") == 1 then
				return 'xdg-open'
			elseif vim.fn.executable("powershell.exe") == 1 then
				return 'powershell.exe -Command Start-Process'
			elseif vim.fn.executable("open") == 1 then
				return 'open'
			else
				return nil
			end
		end

		local ret = {
			selected_browser = get_browser(),
			url_open_command = get_url_open_command(),
			buku_include_tags = true,
			full_path = true,
		}

		return ret
	end

	extensions = {
		live_grep_args = get_live_grep_args(),
	}

	telescope.setup {
		defaults = {
			theme = "dropdown",
			layout_strategy = 'vertical',
			layout_config = {
				preview_cutoff = 10,
				height = 0.95,
				width = 0.90,
				prompt_position = 'bottom',
				mirror = false,
			},
			wrap_results = true,
			path_display = {
				shorten = {
					len = 1,
					exclude = {1, -2, -1},
				},
			},
			mappings = {
				i = {
					["<C-h>"] = "which_key"
				},
			},
			borderchars = {
				prompt = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
				results = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
				preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
			},
			prompt_prefix=' ★ ',
		},
		extensions = extensions,
	}

	setup_keymap()
	require('telescope').load_extension('live_grep_args')
	require('browser_bookmarks').setup(get_bookmark())
	vim.cmd("command! -nargs=0 TelescopeSshList lua require('plugin.telescope').SshList()")
end

local function setup_extension_live_grep_args()
	local keymap = vim.api.nvim_set_keymap

	keymap('n', "<leader>fW",
		[[<cmd> lua require("telescope-live-grep-args.shortcuts").grep_word_under_cursor({prompt_title='fixed word'})<CR>]],
		{ silent = true, desc = 'search word under cursor' })

	keymap('n', "<leader>fw",
		[[<cmd> lua require('telescope').extensions.live_grep_args.live_grep_args(]] ..
		[[{prompt_title='word', default_text=vim.fn.expand('<cword>')})<CR>]],
		{ silent = true, desc = 'search word under cursor' })

	keymap('n', "<leader>fa",
		[[<cmd> lua require('telescope').extensions.live_grep_args.live_grep_args({prompt_title='ALL'})<CR>]],
		{ silent = true, desc = 'search all from user input' })

	keymap('n', "<leader>fA",
		[[<cmd> lua require('telescope').extensions.live_grep_args.live_grep_args(]] ..
		[[{prompt_title='all', default_text='"' .. vim.fn.expand('<cword>')  .. '"' ..  " --glob '!{.*,  tags}'"})<CR>]],
		{ silent = true, desc = 'search all from cursor' })

	keymap('n', "<leader>fc",
		[[<cmd> lua require('telescope').extensions.live_grep_args.live_grep_args(]] ..
		[[{prompt_title='c, cpp', default_text='"' .. vim.fn.expand('<cword>')  .. '"' ..]] ..
		[[" --glob '!{.*,  tags}' --glob '*.{c,cpp}'"})<CR>]],
		{ silent = true, desc = 'c' })

	keymap('n', "<leader>fC",
		[[<cmd> lua require('telescope').extensions.live_grep_args.live_grep_args(]] ..
		[[{prompt_title='c, cpp, h, hpp', default_text='"' .. vim.fn.expand('<cword>')  .. '"' ..]] ..
		[[" --glob '!{.*,  tags}' --glob '*.{c,cpp,h,hpp}'"})<CR>]],
		{ silent = true, desc = 'c & h' })

	keymap('n', "<leader>fh",
		[[<cmd> lua require('telescope').extensions.live_grep_args.live_grep_args(]] ..
		[[{prompt_title='h, hpp', default_text='"' .. vim.fn.expand('<cword>')  .. '"' ..]] ..
		[[" --glob '!{.*,  tags}' --glob '*.{h,hpp}'"})<CR>]],
		{ silent = true, desc = 'header' })

	keymap('n', "<leader>fK",
		[[<cmd> lua require('telescope').extensions.live_grep_args.live_grep_args(]] ..
		[[{prompt_title='Kconfig, conf', default_text='"' .. vim.fn.expand('<cword>')  .. '"' ..]] ..
		[[" --glob '!{.*,  tags}' --glob '{Kconfig,*.conf}'"})<CR>]],
		{ silent = true, desc = 'Kconfig' })

	keymap('n', "<leader>fk",
		[[<cmd> lua require('telescope').extensions.live_grep_args.live_grep_args(]] ..
		[[{prompt_title='conf', default_text='"' .. vim.fn.expand('<cword>')  .. '"' ..]] ..
		[[" --glob '!{.*,  tags}' --glob '*.conf'"})<CR>]],
		{ silent = true, desc = '.config' })

	keymap('n', "<leader>fd",
		[[<cmd> lua require('telescope').extensions.live_grep_args.live_grep_args(]] ..
		[[{prompt_title='dts, dtsi', default_text='"' .. vim.fn.expand('<cword>')  .. '"' ..]] ..
		[[" --glob '!{.*,  tags}' --glob '{*.dts,*.dtsi}'"})<CR>]],
		{ silent = true, desc = 'dts & dtsi' })

	keymap('n', "<leader>fm",
		[[<cmd> lua require('telescope').extensions.live_grep_args.live_grep_args(]] ..
		[[{prompt_title='CMakeLists, MakeFile, makefile', default_text='"' .. vim.fn.expand('<cword>')  .. '"' ..]] ..
		[[" --glob '!{.*,  tags}' --glob '{CMakeLists,MakeFile,makefile}'"})<CR>]],
		{ silent = true, desc = 'make' })

	keymap('n', "<leader>fM",
		[[<cmd> lua require('telescope').extensions.live_grep_args.live_grep_args(]] ..
		[[{prompt_title='md, rst', default_text='"' .. vim.fn.expand('<cword>')  .. '"' ..]] ..
		[[" --glob '!{.*,  tags}' --glob '*.{md,rst}'"})<CR>]],
		{ silent = true, desc = 'md, rst' })
end

local function telescope_buffer()
	local action_state = require('telescope.actions.state')
	local actions = require('telescope.actions')
	local m = {}

	m.buffer_with_del = function(opts)
		opts = opts or {}
		opts.attach_mappings = function(prompt_bufnr, map)
			local delete_buf = function()
				local selection = action_state.get_selected_entry()
				actions.close(prompt_bufnr)
				vim.api.nvim_buf_delete(selection.bufnr, { force = true })
				vim.cmd([[lua require('plugin.telescope').Buffer().buffer_with_del()]])
			end
			map('i', '<del>', delete_buf)
			return true
		end
		require('telescope.builtin').buffers(opts)
	end
	return m
end

local function setup_extension_bookmarks()
	vim.api.nvim_set_keymap('n', "<leader>vl", [[<cmd> Telescope bookmarks <cr>]],
		{ silent = true, desc = 'open browser bookmarks' })

	if pcall(require, "which-key") then
		local wk = require("which-key")
		wk.register({ l = "browser bookmarks" }, { prefix = "<leader>v" })
	end

	require('telescope').load_extension('bookmarks')
end

local function ssh_get_list_in_telescope()
	local pickers = require "telescope.pickers"
	local finders = require "telescope.finders"
	local conf = require("telescope.config").values
	local action_state = require('telescope.actions.state')
	local actions = require('telescope.actions')
	local telescope_opts = {sorting_strategy = 'ascending'}

	local select_connection = function(opts)
		opts = opts or {}
		local results = {}
		for i, info in ipairs(vim.g.ssh_data) do

			table.insert(results, {
				string.format("%-20s", info.host),
				string.format("%+25s", info.name),
				string.format("%-3s", info.port),
				string.format("%-s", info.description),
				string.format("%-15s", info.group),
				string.format("%-15s", info.pass),
				string.format("%2s", i)
			})
		end

		pickers.new(opts, {
			prompt_title = 'SSH Connection',
			finder = finders.new_table {
				results = results,
				entry_maker = function(entry)
					return {
						value = entry,
						display = '| ' .. entry[7] ..' | ' ..
							entry[5] .. ' || ' ..
							entry[2] .. ' | ' .. entry[1] .. ' | ' ..
							entry[3] .. ' | ' .. entry[4],
						ordinal = entry[7] .. ' ' .. entry[5] .. ' ' .. entry[2] .. ' ' .. entry[1] .. ' ' .. entry[3] .. ' ' .. entry[4],
					}
				end
			},
			sorter = conf.generic_sorter(opts),
			attach_mappings = function(prompt_bufnr, map)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					local host = vim.fn.trim(selection.value[1])
					local name = vim.fn.trim(selection.value[2])
					local port = vim.fn.trim(selection.value[3])
					local pass = vim.fn.trim(selection.value[6])
					require('features.ssh').SshConnect(name, host, port, pass)
					-- print(vim.inspect(selection))
					-- vim.api.nvim_put({ selection[1] }, "", false, true)
				end)
				local call_help = function()
					require('features.common').DisplayTitle(" Help")
					local selection = action_state.get_selected_entry()
					print(">> ", selection.value[4])
				end
				map('i', '<C-h>', call_help)
				return true
			end,
		}):find()
	end

	select_connection(telescope_opts)
end

local ret = {
	Buffer = telescope_buffer,
	SshList = ssh_get_list_in_telescope,
	SetupLiveGrepArgs = setup_extension_live_grep_args,
	SetupBookmarks = setup_extension_bookmarks,
	Setup = setup,
}

return ret
