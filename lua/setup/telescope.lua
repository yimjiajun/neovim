local function setup_telescope()
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

	local function get_file_browser()
		local ret = {
			layout_strategy = 'horizontal',
			layout_config = {
				preview_width = 0.7,
				prompt_position = 'bottom',
			},
			-- disables netrw and use telescope-file-browser in its place
			hijack_netrw = true,
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

	local function get_heading()
		local ret = {
			treesitter = true,
			picker_opts = {
				layout_config = { width = 0.9, preview_width = 0.7 },
				layout_strategy = 'horizontal',
				sorting_strategy = 'ascending',
			},
		}

		return ret
	end

	local extensions = {
		live_grep_args = get_live_grep_args(),
		file_browser = get_file_browser(),
		bookmarks = get_bookmark(),
		heading = get_heading(),
	}

	local telescope = require("telescope")

	telescope.setup {
		defaults = {
			theme = "dropdown",
			layout_strategy = 'vertical',
			layout_config = {
				height = 0.95,
				width = 0.90,
				prompt_position = 'bottom',
				mirror = false,
			},
			mappings = {
				i = {
					["<C-h>"] = "which_key"
				},
			},
			prompt_prefix=' > ',
		},
		extensions = extensions,
	}


	require('telescope').load_extension('live_grep_args')
end

local function setup_extension_live_grep_args()
	vim.api.nvim_set_keymap('n', "<leader>fW",
		[[<cmd> lua require("telescope-live-grep-args.shortcuts").grep_word_under_cursor({prompt_title='fixed word'})<CR>]],
		{ silent = true, desc = 'search word under cursor' })

	vim.api.nvim_set_keymap('n', "<leader>fw",
		[[<cmd> lua require('telescope').extensions.live_grep_args.live_grep_args({prompt_title='word', default_text=vim.fn.expand('<cword>')})<CR>]],
		{ silent = true, desc = 'search word under cursor' })

	vim.api.nvim_set_keymap('n', "<leader>fA",
		[[<cmd> lua require('telescope').extensions.live_grep_args.live_grep_args({prompt_title='ALL'})<CR>]],
		{ silent = true, desc = 'search all from user input' })

	vim.api.nvim_set_keymap('n', "<leader>fa",
		[[<cmd> lua require('telescope').extensions.live_grep_args.live_grep_args({prompt_title='all', default_text='"' .. vim.fn.expand('<cword>')  .. '"' ..  " --glob '!{.*,  tags}'"})<CR>]],
		{ silent = true, desc = 'search all from cursor' })

	vim.api.nvim_set_keymap('n', "<leader>fc",
		[[<cmd> lua require('telescope').extensions.live_grep_args.live_grep_args({prompt_title='c, cpp', default_text='"' .. vim.fn.expand('<cword>')  .. '"' ..  " --glob '!{.*,  tags}' --glob '*.{c,cpp}'"})<CR>]],
		{ silent = true, desc = 'c' })

	vim.api.nvim_set_keymap('n', "<leader>fC",
		[[<cmd> lua require('telescope').extensions.live_grep_args.live_grep_args({prompt_title='c, cpp, h, hpp', default_text='"' .. vim.fn.expand('<cword>')  .. '"' ..  " --glob '!{.*,  tags}' --glob '*.{c,cpp,h,hpp}'"})<CR>]],
		{ silent = true, desc = 'c & h' })

	vim.api.nvim_set_keymap('n', "<leader>fh",
		[[<cmd> lua require('telescope').extensions.live_grep_args.live_grep_args({prompt_title='h, hpp', default_text='"' .. vim.fn.expand('<cword>')  .. '"' ..  " --glob '!{.*,  tags}' --glob '*.{h,hpp}'"})<CR>]],
		{ silent = true, desc = 'header' })

	vim.api.nvim_set_keymap('n', "<leader>fK",
		[[<cmd> lua require('telescope').extensions.live_grep_args.live_grep_args({prompt_title='Kconfig, conf', default_text='"' .. vim.fn.expand('<cword>')  .. '"' ..  " --glob '!{.*,  tags}' --glob '{Kconfig,*.conf}'"})<CR>]],
		{ silent = true, desc = 'Kconfig' })

	vim.api.nvim_set_keymap('n', "<leader>fk",
		[[<cmd> lua require('telescope').extensions.live_grep_args.live_grep_args({prompt_title='conf', default_text='"' .. vim.fn.expand('<cword>')  .. '"' ..  " --glob '!{.*,  tags}' --glob '*.conf'"})<CR>]],
		{ silent = true, desc = '.config' })

	vim.api.nvim_set_keymap('n', "<leader>fd",
		[[<cmd> lua require('telescope').extensions.live_grep_args.live_grep_args({prompt_title='dts, dtsi', default_text='"' .. vim.fn.expand('<cword>')  .. '"' ..  " --glob '!{.*,  tags}' --glob '{*.dts,*.dtsi}'"})<CR>]],
		{ silent = true, desc = 'dts & dtsi' })

	vim.api.nvim_set_keymap('n', "<leader>fm",
		[[<cmd> lua require('telescope').extensions.live_grep_args.live_grep_args({prompt_title='CMakeLists, MakeFile, makefile', default_text='"' .. vim.fn.expand('<cword>')  .. '"' ..  " --glob '!{.*,  tags}' --glob '{CMakeLists,MakeFile,makefile}'"})<CR>]],
		{ silent = true, desc = 'make' })

	vim.api.nvim_set_keymap('n', "<leader>fM",
		[[<cmd> lua require('telescope').extensions.live_grep_args.live_grep_args({prompt_title='md, rst', default_text='"' .. vim.fn.expand('<cword>')  .. '"' ..  " --glob '!{.*,  tags}' --glob '*.{md,rst}'"})<CR>]],
		{ silent = true, desc = 'md, rst' })
end

local function setting_key_telescope()
	vim.api.nvim_set_keymap('n', '<leader>w', [[<cmd> lua require('setup.telescope').Buffer().buffer_with_del() <CR>]], { silent = true })

	vim.api.nvim_set_keymap('n', '<Leader>ggs', [[<cmd> lua require('telescope.builtin').git_status() <CR>]], { silent = true })

	vim.api.nvim_set_keymap('n', '<leader>q', [[<cmd> lua require('telescope.builtin').marks() <CR>]], { silent = true })

	vim.api.nvim_set_keymap('n', '<leader>h', [[<cmd> lua require('telescope.builtin').jumplist() <CR>]], { silent = true })

	vim.api.nvim_set_keymap('n', '<leader>r', [[<cmd> lua require('telescope.builtin').registers() <CR>]], { silent = true })

	vim.api.nvim_set_keymap('n', "z=",
		[[<cmd> lua require('telescope.builtin').spell_suggest() <CR>]],
		{ silent = true, desc = 'Spell Suggest' })

		vim.api.nvim_set_keymap('n', '<Leader>ggL', [[<cmd> lua require('telescope.builtin').git_commits() <CR>]], { silent = true })

	if vim.fn.filereadable("tags") == 1 then
		vim.api.nvim_set_keymap('n', "<leader>tt",
			[[<cmd> lua require('telescope.builtin').current_buffer_tags() <CR>]],
			{ silent = true, desc = 'buffer tags list' })
	end

	vim.api.nvim_set_keymap('n', "<leader>tS",
		[[<cmd> lua require('telescope.builtin').tagstack() <CR>]],
		{ silent = true, desc = 'tag stack selection' })

	vim.api.nvim_set_keymap('n', "<leader>fb",
		[[<cmd> lua require('telescope.builtin').current_buffer_fuzzy_find() <CR>]],
		{ silent = true, desc = 'search current buffer' })

	vim.api.nvim_set_keymap('n', "<leader>ft",
		[[<cmd> lua require('telescope.builtin').tags() <CR>]],
		{ silent = true, desc = 'search from tags' })

	vim.api.nvim_set_keymap('n', "<leader>ff",
		[[<cmd> lua require('telescope.builtin').find_files({hidden=false, no_ignore=false, no_ignore_parent=false}) <CR>]],
		{ silent = true, desc = 'search files' })

	vim.api.nvim_set_keymap('n', "<leader>fF",
		[[<cmd> lua require('telescope.builtin').find_files({hidden=false, no_ignore=true, no_ignore_parent=true}) <CR>]],
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
			end
			map('i', '<del>', delete_buf)
			return true
		end
		require('telescope.builtin').buffers(opts)
	end
	return m
end

local function setup_extension_file_browser()
	vim.api.nvim_set_keymap('n', "<leader>e",
		[[<cmd> Telescope file_browser <CR>]],
		{ silent = true, desc = 'Explorer' })

	vim.api.nvim_set_keymap('n', "<leader>E",
		[[<cmd> Telescope file_browser path=%:p:h select_buffer=true <cr>]],
		{ silent = true, desc = 'explorer from current buffer path' })

	require('telescope').load_extension('file_browser')
end

local function setup_extension_bookmarks()
	vim.api.nvim_set_keymap('n', "<leader>vl",
		[[<cmd> Telescope bookmarks <cr>]],
		{ silent = true, desc = 'open browser bookmarks' })

	if pcall(require, "which-key") then
		local wk = require("which-key")
		wk.register({ l = "browser bookmarks" }, { prefix = "<leader>v" })
	end

	require('telescope').load_extension('bookmarks')
end

local function setup_extension_heading()
	require('features.compiler').InsertInfo("md (heading)",
		"Telescope heading", "display markdown heading",
		"markdown", "builtin", "plugin")

	require('telescope').load_extension('heading')
end

local ret = {
	Buffer = telescope_buffer,
	setup = setup_telescope,
	setup_keymapping = setting_key_telescope,
	setup_live_grep_args = setup_extension_live_grep_args,
	setup_file_browser = setup_extension_file_browser,
	setup_bookmarks = setup_extension_bookmarks,
	setup_heading = setup_extension_heading,
}

return ret
