local function setup_telescope()
	local function get_live_grep_args()
		local lga_actions = require("telescope-live-grep-args.actions")
		local ret = {
			auto_quoting = true,
			mappings = {
				i = {
					["<C-k>"] = lga_actions.quote_prompt(),
					["<C-i>"] = lga_actions.quote_prompt({ postfix = " --no-ignore " }),
					["<C-f>"] = lga_actions.quote_prompt({ postfix = " --glob **/*." }),
					["<C-F>"] = lga_actions.quote_prompt({ postfix = " --no-ignore --glob **/*." }),
				},
			},
		}

		return ret
	end


	local function get_file_browser()
		local ret = {
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

	local extensions = {
		live_grep_args = get_live_grep_args(),
		file_browser = get_file_browser(),
		bookmarks = get_bookmark(),
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
			prompt_prefix='  ',
		},
		extensions = extensions,
	}

	telescope.load_extension('live_grep_args')
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

	vim.api.nvim_set_keymap('n', "<leader>fw",
		[[<cmd> lua require("telescope-live-grep-args.shortcuts").grep_word_under_cursor()<CR>]],
		{ silent = true, desc = 'search word under cursor' })

	vim.api.nvim_set_keymap('n', "<leader>fA",
		[[<cmd> lua require('telescope').extensions.live_grep_args.live_grep_args({prompt_title='search ALL', glob_pattern={"!.*", "!tags"}})<CR>]],
		{ silent = true, desc = 'search all from user input' })

	vim.api.nvim_set_keymap('n', "<leader>fa",
		[[<cmd> lua require('telescope').extensions.live_grep_args.live_grep_args({prompt_title='search all', default_text=vim.fn.expand('<cword>'), glob_pattern={"**/*", "!.*", "!tags"}})<CR>]],
		{ silent = true, desc = 'search all from cursor' })

	vim.api.nvim_set_keymap('n', "<leader>fc",
		[[<cmd> lua  require('telescope').extensions.live_grep_args.live_grep_args({prompt_title='search c,cpp', default_text=vim.fn.expand('<cword>'), glob_pattern={"**/*.[c,cpp]", "!.*", "!tags"}})<CR>]],
		{ silent = true, desc = 'c' })

	vim.api.nvim_set_keymap('n', "<leader>fC",
		[[<cmd> lua  require('telescope').extensions.live_grep_args.live_grep_args({prompt_title='search c,cpp,h', default_text=vim.fn.expand('<cword>'), glob_pattern={"**/*.[c,h]", "!.*", "!tags"}})<CR>]],
		{ silent = true, desc = 'c & h' })

	vim.api.nvim_set_keymap('n', "<leader>fh",
		[[<cmd> lua  require('telescope').extensions.live_grep_args.live_grep_args({prompt_title='search h', default_text=vim.fn.expand('<cword>'), glob_pattern={"**/*.h", "!.*", "!tags"}})<CR>]],
		{ silent = true, desc = 'header' })

	vim.api.nvim_set_keymap('n', "<leader>fK",
		[[<cmd> lua  require('telescope').extensions.live_grep_args.live_grep_args({prompt_title='search Kconfig', default_text=vim.fn.expand('<cword>'), glob_pattern={"**/Kconfig", "!.*", "!tags"}})<CR>]],
		{ silent = true, desc = 'Kconfig' })

	vim.api.nvim_set_keymap('n', "<leader>fk",
		[[<cmd> lua  require('telescope').extensions.live_grep_args.live_grep_args({prompt_title='search .conf', default_text=vim.fn.expand('<cword>'), glob_pattern={"**/*.conf", "!.*", "!tags"}})<CR>]],
		{ silent = true, desc = '.config' })

	vim.api.nvim_set_keymap('n', "<leader>fd",
		[[<cmd> lua  require('telescope').extensions.live_grep_args.live_grep_args({prompt_title='search dts,dtsi', default_text=vim.fn.expand('<cword>'), glob_pattern={"**/*.[dts,dtsi]", "!.*", "!tags"}})<CR>]],
		{ silent = true, desc = 'dts & dtsi' })

	vim.api.nvim_set_keymap('n', "<leader>fm",
		[[<cmd> lua  require('telescope').extensions.live_grep_args.live_grep_args({prompt_title='search Make', default_text=vim.fn.expand('<cword>'), glob_pattern={"**/[CMakeLists.txt,MakeFile,makefile]", "!.*", "!tags"}})<CR>]],
		{ silent = true, desc = 'make' })

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

setup_telescope()
setting_key_telescope()

local ret = {
	Buffer = telescope_buffer,
}

return ret
