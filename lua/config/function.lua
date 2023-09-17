vim.g.vim_git = "!git"

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
	local word = ""

	if extension == nil then
		extension = "*"
	end

	if extension == "" then
		if vim.fn.executable("rg") == 1 then
			extension = vim.fn.input("Enter filetype to search: ", '-g "*.' .. vim.fn.expand("%:e") .. '"')

			if mode == 'complete' then
				extension = "--no-ignore " .. extension
			end
		else
			extension = vim.fn.input("Enter filetype to search: ")
		end
	end

	if mode ~= 'cursor' then
		word = vim.fn.input("Enter word to search: ")
	end

	if word == "" then
		word = vim.fn.expand("<cword>")
	end

	vim.fn.setreg('"', tostring(extension))
	vim.fn.setreg('-', tostring(word))

	local cmd = [[silent! vimgrep /]] .. vim.fn.getreg('-') .. [[/gj ]] .. vim.fn.getreg('"')

	if vim.fn.executable("rg") == 1 then
		cmd = [[cexpr system('rg --vimgrep --smart-case ' .. ' "' .. getreg('-') .. '" ' .. getreg('"'))]]
	end

	vim.cmd("silent! " .. cmd  .. " | silent! +copen 5")
end

local function git_diff(mode)
	local cmd = vim.g.vim_git
	if mode == "staging" then
		vim.cmd(string.format("%s %s", cmd, "diff --staged"))
	elseif mode == "previous" then
		vim.cmd(string.format("%s %s", cmd, "diff HEAD~"))
	elseif mode == "specify" then
		local file = vim.fn.input("enter file to git diff: ")
		vim.cmd(string.format("%s %s", cmd, "diff ./**/" .. file))
	elseif mode == "staging_specify" then
		local file = vim.fn.input("enter file to git diff: ")
		vim.cmd(string.format("%s %s", cmd, "diff --staged ./**/" .. file))
	else
		vim.cmd(string.format("%s %s", cmd, "diff"))
	end
end

local function git_log(mode)
	local cmd = vim.g.vim_git
	if mode == "graph" then
		vim.cmd(string.format("%s %s", cmd, "log --oneline --graph"))
	elseif mode == "commit_count" then
		vim.cmd(string.format("%s %s", cmd, "rev-list HEAD --count"))
	elseif mode == "diff" then
		vim.cmd(string.format("%s %s", cmd, "log --patch"))
	else
	  vim.cmd(string.format("%s %s", cmd, "log"))
  end
end

local function git_status(mode)
	local cmd = vim.g.vim_git
	if mode == "short" then
		vim.cmd(string.format("%s %s", cmd, "status --short"))
	elseif mode == "check_whitespace" then
		vim.cmd(string.format("%s %s", cmd, "diff-tree --check $(git hash-object -t tree /dev/null) HEAD"))
	else
		vim.cmd(string.format("%s %s", cmd, "status"))
	end
end

local function git_add(mode)
	local cmd = vim.g.vim_git
	if mode == "patch" then
		vim.cmd(string.format("%s %s", cmd, "add -p"))
	elseif mode == "all" then
		vim.cmd(string.format("%s %s", cmd, "add ."))
	else
		vim.cmd(string.format("%s %s", cmd, "add -i"))
	end
end

local function git_commit(mode)
	local cmd = vim.g.vim_git
	if mode == "amend" then
		vim.cmd(string.format("%s %s", cmd, "commit --amend"))
	else
		vim.cmd(string.format("%s %s", cmd, "commit"))
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

local function get_buffers(mode)
	vim.cmd("ls")
end

local function get_marks(mode)
	vim.cmd("marks")
end

local function get_jumplist(mode)
	vim.cmd("jump")
end

local function get_register_list(mode)
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

		if vim.fn.isdirectory(path) == 0 then
			vim.fn.mkdir(path, "p")
		end

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
		status = compiler.LatestSetup()
	else
		status = compiler.Setup()
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

local files_in_bank = {}
local function files_bank(act)
	local title = 'Files Bank'
	local file = vim.fn.expand('%:#')
	local items = {}

	if act == nil or act == ''
	then
		items = files_in_bank

		vim.fn.setqflist({}, ' ', {
			title = title,
			items = items,
		})

		vim.cmd([[silent! copen]])

		return
	end

	if file == ''
	then
		return
	end

	local std_item = {
		filename = file,
		text = vim.fn.getline('.'),
		lnum = vim.fn.line('.'),
		col = vim.fn.col('.'),
		type = 'c',
		bufnr = vim.fn.bufnr('%'),
	}

	local prev_item_found = false

	for _, v in ipairs(files_in_bank)
	do
		if v.bufnr == vim.fn.bufnr('%') then
			prev_item_found = true

			if act == 'save' then
				v = std_item
			elseif act == 'remove' then
				v = nil
			end
		end

		if v ~= nil then
			table.insert(items, v)
		end
	end

	if (#items == 0 and act == 'save')
		or prev_item_found == false
	then
		table.insert(items, std_item)
	end

	files_in_bank = items
end

local function working_directory_marks(act)
	local skip_mark = { 'E', 'I', 'N', 'W' }
	local items = {}
	local item = {}
	local mark = {}
	local row, col, bufnr = 0, 0, 0
	local filepath = ''
	local mark_empty = true
	local cwd = vim.fn.getcwd()

	if act == nil then
		act = ''
	else
		act = string.lower(act)
	end

	for mark_to_insert = string.byte('A'), string.byte('Z'), 1 do
		mark = vim.api.nvim_get_mark(string.char(mark_to_insert), {})
		row, col, bufnr = mark[1], mark[2], mark[3]
		filepath = mark[4]
		mark_empty = ((row or col or bufnr) == 0) and (filepath == '')

		if act == 'save' then
			if (mark_empty == false) and (string.char(mark_to_insert) ~= 'Z') then
				goto continue
			end

			if vim.tbl_contains(skip_mark, string.char(mark_to_insert)) then
				goto continue
			end

			row = vim.fn.line('.')
			vim.cmd(row .. 'mark ' .. string.char(mark_to_insert))

			break
		elseif act == 'remove' then
			if (mark_empty == true) or (string.char(mark_to_insert) == 'Z') then
				local delete_mark

				if (string.char(mark_to_insert) == 'A') or (string.char(mark_to_insert) == 'Z' and mark_empty == false) then
					delete_mark = string.char(mark_to_insert)
				else
					delete_mark = string.char(mark_to_insert-1)
				end

				if vim.tbl_contains(skip_mark, delete_mark) then
					goto continue
				end

				vim.cmd('delmarks ' .. delete_mark)

				break
			end
		elseif act == 'clear' then
			if mark_empty == false then
				if vim.tbl_contains(skip_mark, string.char(mark_to_insert)) then
					goto continue
				end

				vim.cmd('delmarks ' .. string.char(mark_to_insert))
			end
		else
			if mark_empty == true then
				goto continue
			end

			if vim.fn.match(vim.fn.fnamemodify(filepath, ':p'), cwd) == -1
				and act ~= 'universal' then
				goto continue
			end

			item = {
				filename = vim.fn.fnamemodify(filepath, ':p'),
				text =  vim.fn.getline(row),
				lnum = row,
				col = col,
				type = string.char(mark_to_insert),
				bufnr = nil,
			}

			table.insert(items, item)
		end

		::continue::
	end

	if #items > 0 then
		vim.fn.setqflist({}, ' ', { title = "universal marks", items = items })
		vim.cmd("silent! copen")
	end
end

local function buffer_marks(act)
	local skip_mark = { 'e', 'i', 'n', 'w' }
	local items = {}
	local item = {}
	local mark = {}
	local row, col = 0, 0
	local mark_empty = true
	local bufnr = vim.fn.bufnr('%')

	local function compare_linenumber(x, y)
		return x.lnum < y.lnum
	end

	if act == nil then
		act = ''
	else
		act = string.lower(act)
	end

	bufnr = vim.fn.bufnr('%')

	for mark_to_insert = string.byte('a'), string.byte('z'), 1 do
		mark = vim.api.nvim_buf_get_mark(0, string.char(mark_to_insert))
		row, col = mark[1], mark[2]
		mark_empty = ((row or col) == 0)

		if string.match(act, 'save') then

			if (mark_empty == false) and (string.char(mark_to_insert) ~= 'z') then
				if string.match(act, 'sort') then
					table.insert(items, {
							filename = vim.fn.expand('%:p'),
							text = vim.fn.getline(row),
							lnum = row,
							col = col,
							type = string.char(mark_to_insert),
							bufnr = bufnr,
						}
					)
				end

				goto continue
			end

			if vim.tbl_contains(skip_mark, string.char(mark_to_insert)) then
				goto continue
			end

			row = vim.fn.line('.')
			col = vim.fn.col('.')

			vim.api.nvim_buf_set_mark(bufnr, string.char(mark_to_insert), row, col, {})

			if string.match(act, 'sort') then
				table.insert(items, {
						filename = vim.fn.expand('%:p'),
						text = vim.fn.getline(row),
						lnum = row,
						col = col,
						type = string.char(mark_to_insert),
						bufnr = bufnr,
					}
				)

				table.sort(items, compare_linenumber)

				local idx = 1
				for j = string.byte('a'), mark_to_insert, 1 do
					if not vim.tbl_contains(skip_mark, string.char(j)) then
						items[idx].type = string.char(j)
						vim.api.nvim_buf_set_mark(
							bufnr, string.char(j), items[idx].lnum, items[idx].col, {})
						idx = idx + 1
					end
				end
			end

			return
		elseif act == 'remove' then
			if (mark_empty == true) or (string.char(mark_to_insert) == 'z') then
				local delete_mark

				if (string.char(mark_to_insert) == 'a') or (string.char(mark_to_insert) == 'z' and mark_empty == false) then
					delete_mark = string.char(mark_to_insert)
				else
					delete_mark = string.char(mark_to_insert-1)
				end

				vim.api.nvim_buf_del_mark(bufnr, delete_mark)

				return
			end
		elseif act == 'clear' then
			if mark_empty == false then
				vim.api.nvim_buf_del_mark(bufnr, string.char(mark_to_insert))
			end
		else
			if mark_empty == true then
				goto continue
			end

			item = {
				filename = vim.fn.expand('%:p'),
				text = vim.fn.getline(row),
				lnum = row,
				col = col,
				type = string.char(mark_to_insert),
				bufnr = bufnr,
			}

			table.insert(items, item)
		end

		::continue::
	end

	if #items > 0 then
		if string.match(act, 'sort') then
			table.sort(items, compare_linenumber)
		end

		vim.fn.setqflist({}, ' ', { title = "buffer marks", items = items })
		vim.cmd("silent! copen")
	end
end
local M = {
	SearchFile = search_file,
	SearchWord = search_word,
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
	FilesBank = files_bank,
	MarkBuf = buffer_marks,
	MarkCwd = working_directory_marks,
}

for name in pairs(M) do
	vim.cmd("command! -nargs=0 -bang " .. name .. " lua print(" .. "require('config.function')." .. name .. "()" .. ")")
end

return M
