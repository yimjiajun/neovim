vim.g.vim_git = "git"

local function search_file()
	local regex_file = vim.fn.input("File to search (regex): ")

	if regex_file == "" or regex_file == nil then
		return
	end

	local files = require('features.system').SearchFile(vim.loop.cwd(), regex_file)
	local msg = string.format("\tfound %d files", #files)

	if #files == 0 or files == nil then
		vim.api.nvim_echo({{"\tfiles not found", ""}}, false, {})
		return
	end

	local items = {}
	local std_item = {
		filename = nil,
		text = nil,
		type = 'f',
		bufnr = nil,
	}

	for _, file in ipairs(files) do
		local item = vim.deepcopy(std_item)
		item.filename = file
		item.text = string.format("[%s]", vim.fn.fnamemodify(file, ':t'))
		table.insert(items, item)
	end

	vim.fn.setqflist({}, ' ', { title = "Find Files", items = items })
	vim.api.nvim_echo({{msg, "MoreMsg"}}, false, {})
	vim.cmd("silent! copen")
end

local function search_word(extension, mode)
	local word, cmd
	local opts = ""

	if extension == nil then
		extension = vim.fn.input("Enter filetype to search: ", vim.fn.expand("%:e"))
	end

	if extension == "" then
		extension = "*"
	end

	if mode ~= 'cursor' then
		word = vim.fn.input("Enter word to search: ")
	else
		word = vim.fn.expand("<cword>")
	end

	if word == "" then
		return
	end

	vim.fn.setreg('/', tostring(word))

	if vim.fn.executable("rg") == 1 then
		if extension == "*" then
			extension = [[-g "*"]]
		else
			extension = string.format("-g \"*.%s\"", extension)
		end

		if mode == 'complete' then
			opts = " --no-ignore "
		end

		vim.fn.setreg('e', opts .. extension)
		cmd = [[cexpr system('rg --vimgrep --smart-case' .. " '" .. getreg('/') .. "' " .. getreg('e'))]]
	else
		if extension ~= "*" then
			extension = [[*.]] .. extension
		end

		vim.fn.setreg('e', tostring(extension))
		cmd = [[silent! vimgrep /]] .. vim.fn.getreg('/') .. [[/gj ./**/]] .. vim.fn.getreg('e')
	end

	vim.cmd("silent! " .. cmd  .. " | silent! +copen 5")
end

local function search_word_by_file(file, mode)
	local word, cmd
	local opts = ""

	if file == nil or file == "" then
		search_word("*", "normal")
	end

	if mode ~= 'cursor' then
		word = vim.fn.input("Enter word to search: ")
	else
		word = vim.fn.expand("<cword>")
	end

	if word == "" then
		return
	end

	vim.fn.setreg('w', tostring(word))

	if vim.fn.executable("rg") == 1 then
		file = string.format("./**/%s", file)

		if mode == 'complete' then
			opts = " --no-ignore "
		end

		vim.fn.setreg('e', opts .. file)
		cmd = [[cexpr system('rg --vimgrep --smart-case ' .. " '" .. getreg('w') .. "' " .. getreg('e'))]]
	else
		vim.fn.setreg('e', tostring(file))
		cmd = [[silent! vimgrep /]] .. vim.fn.getreg('w') .. [[/gj ./**/]] .. vim.fn.getreg('e')
	end

	vim.cmd("silent! " .. cmd  .. " | silent! +copen 5")
end

local function git_diff(mode)
	local cmd = vim.g.vim_git

	if vim.fn.expand("%:h") ~= "" and vim.g.vim_git == "git" then
		cmd = cmd .. " -C " .. vim.fn.expand("%:h")
	end

	if mode == "staging" then
		cmd = string.format("%s %s", cmd, "diff --staged")
	elseif mode == "previous" then
		cmd = string.format("%s %s", cmd, "diff HEAD~")
	elseif mode == "specify" then
		local file = vim.fn.input("enter file to git diff: ")
		cmd = string.format("%s %s", cmd, "diff ./**/" .. file)
	elseif mode == "staging_specify" then
		local file = vim.fn.input("enter file to git diff: ")
		cmd = string.format("%s %s", cmd, "diff --staged ./**/" .. file)
	else
		cmd = string.format("%s %s", cmd, "diff")
	end

	if vim.g.vim_git == "git" then
		vim.cmd(string.format("%s %s %s", "term", cmd, "; exit"))
	else
		vim.cmd(cmd);
	end
end

local function git_log(mode)
	local cmd = vim.g.vim_git

	if vim.fn.expand("%:h") ~= "" and vim.g.vim_git == "git" then
		cmd = cmd .. " -C " .. vim.fn.expand("%:h")
	end

	if mode == "graph" then
		cmd = string.format("%s %s", cmd, "log --oneline --graph")
	elseif mode == "commit_count" then
		cmd = string.format("%s %s", cmd, "rev-list HEAD --count")
	elseif mode == "diff" then
		cmd = string.format("%s %s", cmd, "log --patch")
	else
	  cmd = string.format("%s %s", cmd, "log")
  end

	if vim.g.vim_git == "git" then
		vim.cmd(string.format("%s %s %s", "term", cmd, "; exit"))
	else
		vim.cmd(cmd);
	end
end

local function git_status(mode)
	local cmd = vim.g.vim_git

	if vim.fn.expand("%:h") ~= "" and vim.g.vim_git == "git" then
		cmd = cmd .. " -C " .. vim.fn.expand("%:h")
	end

	if mode == "short" then
		cmd = string.format("%s %s", cmd, "status --short")
	elseif mode == "check_whitespace" then
		cmd = string.format("%s %s", cmd, "diff-tree --check $(git hash-object -t tree /dev/null) HEAD")
	else
		cmd = string.format("%s %s", cmd, "status")
	end

	if vim.g.vim_git == "git" then
		vim.cmd(string.format("%s %s %s", "split | term", cmd, "; exit"))
	else
		vim.cmd(cmd);
	end
end

local function git_add(mode)
	local cmd = vim.g.vim_git

	if vim.fn.expand("%:h") ~= "" and vim.g.vim_git == "git" then
		cmd = cmd .. " -C " .. vim.fn.expand("%:h")
	end

	if mode == "patch" then
		cmd = string.format("%s %s", cmd, "add -p")
	elseif mode == "all" then
		cmd = string.format("%s %s", cmd, "add .")
	else
		cmd = string.format("%s %s", cmd, "add -i")
	end

	if vim.g.vim_git == "git" then
		vim.cmd(string.format("%s %s %s", "term", cmd, "; exit"))
	else
		vim.cmd(cmd);
	end
end

local function git_commit(mode)
	local cmd = vim.g.vim_git

	if vim.fn.expand("%:h") ~= "" and vim.g.vim_git == "git" then
		cmd = cmd .. " -C " .. vim.fn.expand("%:h")
	end

	if mode == "amend" then
		cmd = string.format("%s %s", cmd, "commit --amend")
	else
		cmd = string.format("%s %s", cmd, "commit")
	end

	if vim.g.vim_git == "git" then
		vim.cmd(string.format("%s %s %s", "term", cmd, "; exit"))
	else
		vim.cmd(cmd);
	end
end

local function terminal(mode)
	if mode == "split" then
		vim.cmd("sp | term")
	elseif mode == "vertical" then
		vim.cmd("vs | term")
	elseif mode == "selection" then
		local shell = vim.fn.input("Select shell (bash, sh, zsh, powershell.exe): ")
		vim.cmd("tabnew | term " .. shell)
	else
		vim.cmd("tabnew | term")
	end
end

local function get_buffers(_mode)
	vim.cmd("ls")
end

local function get_marks(_mode)
	vim.cmd("marks")
end

local function get_jumplist(_mode)
	vim.cmd("jump")
end

local function get_register_list(_mode)
	vim.cmd("registers")
end

local function set_statusline(mode)
	if mode == "ascii" then
		vim.o.statusline = " %<%f%h%m%r%=%b\\ 0x%B\\ \\ %l,%c%V\\ %P"
	elseif mode == "byte" then
		vim.o.statusline = " %<%f%=\\ [%1*%M%*%n%R%H]\\ %-19(%3l,%02c%03V%)%O'%02b'"
	else
		local git_branch = require('features.system').GetGitInfo('branch', nil)
		vim.o.statusline = " %<%t [" .. git_branch .. "] %h%m%r%w%= / %Y / 0x%02B / %-10.(%l,%c%V%) / %-4P"
	end
end

local function session(mode)
	local delim = vim.fn.has('win32') ~= 0 and "\\" or "/"
	local path = vim.fn.stdpath('data') .. delim .. 'sessions'
	local session_name = vim.fn.substitute(vim.fn.expand(vim.fn.getcwd()), delim, '_', 'g') .. ".vim"
	local src = path .. delim .. session_name
	local json_file = path .. delim .. "sessions.json"
	local format = {
		path = nil,
		src = nil,
		name = nil,
		date = nil,
	}

	if vim.fn.isdirectory(path) == 0 then
		vim.fn.mkdir(path, "p")
	end

	if vim.fn.filereadable(json_file) == 0 then
		vim.fn.writefile({}, json_file)
	end

	local json_lua_tbl = require('features.system').GetJsonFile(json_file) or {}
	local function save_session()
		format = {
			path = vim.fn.getcwd(),
			src = src,
			name = vim.fn.fnamemodify(vim.fn.getcwd(), ':t'),
			date = os.date("%Y/%h/%d")
		}

		vim.fn.sessionoptions = {
			"buffers", "curdir", "folds", "tabpages", "winsize"
		}

		vim.cmd("mksession! " .. src)

		for i, v in ipairs(json_lua_tbl) do
			if v.path == format.path then
				table.remove(json_lua_tbl, i)
				break
			end
		end

		table.insert(json_lua_tbl, format)
		require('features.system').SetJsonFile(json_lua_tbl, json_file)
	end

	local function load_session()
		if (vim.fn.isdirectory(path) == 1) and (vim.fn.filereadable(src) == 1) then
			vim.cmd("source " .. src)
		else
			vim.api.nvim_echo({{"Session not found !", "ErrorMsg"}}, false, {})
		end
	end

	local function select_session()
		local lists = {}
		for i, v in ipairs(json_lua_tbl) do
			lists[i] = string.format("%2d. [%s]:\t%s\t{%s}",
				i, v.name, v.path, v.date)
		end

		if #lists == 0 then
			vim.api.nvim_echo({{"Session not found !", "ErrorMsg"}}, false, {})
			return
		end

		require('features.common').DisplayTitle("Select Session to Load")

		local s = vim.fn.inputlist(lists)

		if s > 0 then
			vim.cmd("source " .. json_lua_tbl[s].src)
		end
	end

	if mode == "save" then
		save_session()
	elseif mode == "selection" then
		select_session()
	else
		load_session()
	end
end

local function save_session()
	session("save")
end

local function load_session()
	session("load")
end

local function select_session()
	session("selection")
end

local function create_ctags()

	if vim.fn.executable("ctags") == 0 then
		vim.api.nvim_echo({{"Ctags not found !", "ErrorMsg"}}, false, {})
		return
	end

	vim.api.nvim_echo({{"Ctags creating ...", "MoreMsg"}}, false, {})

	local success = os.execute("ctags -R . && sort -u -o tags tags")

	if success then
		vim.api.nvim_echo({{"Ctags created !", "MoreMsg"}}, false, {})
	else
		vim.api.nvim_echo({{"Failed to create ctags !", "ErrorMsg"}}, false, {})
	end
end

local function build(mode)
	local compiler = require('features.compiler')
	local status

	if mode == "latest"
	then
		status = compiler.LastSelect()
	else
		status = compiler.Selection()
	end

	if status == nil
	then
		local msg = "\nBuild not found\n"
		vim.api.nvim_echo({{msg, "ErrorMsg"}}, false, {})
		return
	end

	if status == false
	then
		return
	end

	vim.cmd("make")
end

local function setup_file_format()
	vim.api.nvim_echo({{"Setup File Format: " .. vim.bo.filetype, "Normal"}}, false, {})

	if vim.bo.filetype == "c" or vim.bo.filetype == "cpp" then
		vim.cmd('setlocal cindent')
		vim.cmd('setlocal softtabstop=4')
		vim.cmd('setlocal tabstop=4')
		vim.cmd('setlocal shiftwidth=4')
		vim.cmd('setlocal noexpandtab')
	elseif vim.bo.filetype == "markdown" then
		vim.cmd('setlocal softtabstop=2')
		vim.cmd('setlocal tabstop=2')
		vim.cmd('setlocal shiftwidth=2')
		vim.cmd('setlocal expandtab')
		vim.cmd('setlocal spell')
	elseif vim.bo.filetype == "py" then
		vim.cmd('setlocal softtabstop=2')
		vim.cmd('setlocal tabstop=2')
		vim.cmd('setlocal shiftwidth=2')
		vim.cmd('setlocal expandtab')
	elseif vim.bo.filetype == "bin" then
		vim.cmd([[
		augroup Binary
			autocmd!
			autocmd BufReadPre *.bin let &bin=1
			autocmd BufReadPost *.bin if &bin | %!xxd
			autocmd BufReadPost *.bin set ft=xxd | endif
			autocmd BufWritePre *.bin if &bin | %!xxd -r
			autocmd BufWritePre *.bin endif
			autocmd BufWritePost *.bin if &bin | %!xxd
			autocmd BufWritePost *.bin set nomod | endif
		augroup END
		]])
	else
		vim.cmd('setlocal softtabstop=4')
		vim.cmd('setlocal tabstop=4')
		vim.cmd('setlocal shiftwidth=4')
		vim.cmd('setlocal noexpandtab')
	end

	vim.cmd([[setlocal expandtab? |
		setlocal cindent? |
		setlocal spell? |
		setlocal softtabstop? |
		setlocal tabstop? |
		setlocal shiftwidth?
	]])
end

local function check_quickfix_win_exists()
    local windows = vim.api.nvim_list_wins()

    for _, win in ipairs(windows) do
        local buf = vim.api.nvim_win_get_buf(win)
        local buftype = vim.api.nvim_buf_get_option(buf, 'buftype')
        if buftype == 'quickfix' then
            return true
        end
    end

    return false
end

local function toggle_quickfix()
	if check_quickfix_win_exists() then
		vim.cmd('silent! cclose')
	else
		vim.cmd('silent! copen')
	end
end

local function list_functions()
	local regex = ""

	if vim.tbl_contains({'c', 'cpp', 'lua', 'sh'}, vim.bo.filetype) then
		regex = [[^\w.*(.*)]]
	elseif vim.bo.filetype == 'python' then
		regex = [[\<def .*(.*):]]
	end

	if regex ~= "" then
		vim.fn.setreg('/', regex)
		vim.cmd("vimgrep /" .. regex .. "/j " .. vim.fn.expand("%"))
		vim.cmd("silent! copen")
	else
		vim.api.nvim_echo({{"not supporting in " .. vim.bo.filetype}}, false, {})
	end
end

local function setup()
	for name in pairs(require('config.function')) do
		local callback = "require('config.function')." .. name .. "()"
		callback = "lua print(" .. callback .. ")"
		vim.cmd("command! -nargs=0 -bang " .. name .. " " .. callback)
	end
end

return {
	Setup = setup,
	SearchFile = search_file,
	SearchWord = search_word,
	SearchWordByFile = search_word_by_file,
	GitAdd = git_add,
	GitCommit = git_commit,
	GitDiff = git_diff,
	GitLog = git_log,
	GitStatus = git_status,
	Terminal = terminal,
	GetBuffers = get_buffers,
	GetMarks = get_marks,
	GetJumplist = get_jumplist,
	GetRegisterList = get_register_list,
	SetStatusline = set_statusline,
	SetFileFormat = setup_file_format,
	SaveSession = save_session,
	GetSession = load_session,
	SelSession = select_session,
	CreateCtags = create_ctags,
	Build = build,
	ToggleQuickFix = toggle_quickfix,
	ListFunctions = list_functions
}

