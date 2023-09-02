vim.g.vim_git = "!git"

local function search_file()
	local regex_file = vim.fn.input("File to search (regex): ")
	vim.cmd("silent! find ./**/" .. regex_file)
end

local function search_word(extension, mode)
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

	local word = vim.fn.input("Enter word to search: ")

	if word == "" then
		word = vim.fn.expand("<cword>")
	end

	vim.fn.setreg('"', tostring(extension))
	vim.fn.setreg('-', tostring(word))

	local cmd = [[silent! vimgrep /]] .. vim.fn.getreg('-') .. [[/gj ]] .. vim.fn.getreg('"')

	if vim.fn.executable("rg") == 1 then
		cmd = [[cexpr system('rg --vimgrep --smart-case ' .. ' "' .. getreg('-') .. '" ' .. getreg('"'))]]

	end

	vim.cmd("silent! " .. cmd  .. " | silent! +copen 20")
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
	local path = vim.fn.stdpath('data') .. '/sessions'
	local session_name = vim.fn.substitute(vim.fn.expand(vim.fn.getcwd()), '/', '_', 'g') .. ".vim"
	local src = path .. '/' .. session_name

	if mode == "save" then
		if vim.fn.isdirectory(path) == 0 then
			vim.fn.mkdir(path, "p")
		end

		vim.cmd("mksession! " .. src)

	elseif mode == "selection" then
		local sessions = vim.fn.systemlist("ls -t " .. path)
		local lists = {}

		for i, v in ipairs(sessions) do
			lists[i] = string.format("%3d. %s", i, v)
		end

		require('features.common').DisplayTitle("Select Session to Load")
		local s = vim.fn.inputlist(lists)

		if s > 0 then
			vim.cmd("source " .. path .. '/' .. sessions[s])
		end
	else
		if vim.fn.isdirectory(path) == 1 and vim.fn.filereadable(src) == 1 then
			vim.cmd("source " .. src)
		else
			vim.cmd("echohl WarningMsg | echo 'src not found!' | echohl none")
		end
	end
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
		vim.cmd('highlight MarkdownHeading guifg=Black guibg=DarkOrange')
		vim.cmd([[match MarkdownHeading /^#\s.*/]])
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


local function files_bank(act)
	local title = 'Files Bank'
	local file = vim.fn.expand('%:#')
	local items = {}

	if act == nil or act == ''
	then
		items = vim.fn.getqflist({ title = title, items = 0 }).items

		vim.fn.setqflist({}, 'r', {
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
		type = 'f',
		bufnr = nil,
	}

	local prev_item_found = false

	for _, v in ipairs(vim.fn.getqflist({ title = title, items = 0 }).items)
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

	vim.fn.setqflist({}, 'r', { title = title, items = items })
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
	Session = session,
	CreateCtags = create_ctags,
	Build = build,
	ToggleQuickFix = toggle_quickfix,
	FilesBank = files_bank,
}

for name in pairs(M) do
	vim.cmd("command! -nargs=0 -bang " .. name .. " lua print(" .. "require('config.function')." .. name .. "()" .. ")")
end

return M
