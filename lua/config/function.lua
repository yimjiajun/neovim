local build_cmd_list = {
  { name = "Vim", cmd = "vim --version" },
}

local function search_file()
	if vim.fn.exists(':Telescope') then
		vim.cmd('Telescope find_files')
	else
		local regex_file = vim.fn.input("File to search (regex): ")
		vim.cmd("silent! find ./**/" .. regex_file)
	end
end

local function search_word(extension)
	vim.fn.setreg('"', extension)

	if vim.fn.exists(':Telescope') then
		require('telescope.builtin').live_grep({prompt_title='search word', default_text=vim.fn.expand('<cword>'), glob_pattern={vim.fn.getreg('"')}})
		return
	end

	if vim.fn.executable("rg") == 0 then
		vim.cmd([[cexpr system('rg --vimgrep ' .. expand('<cword>') .. ' ./**/' .. getreg('"'))]])
	else
		vim.cmd([[silent! vimgrep /]] .. vim.fn.expand("<cword>") .. [[/gj ./**/]] .. vim.fn.getreg('"'))
	end

	vim.cmd("silent! tab +copen")
end

local function search_fuzzy(extension, vim_mode)
	if vim.fn.exists(':Telescope') and vim_mode ~= 1 then
		require('telescope.builtin').live_grep({prompt_title='search all', glob_pattern={"**/*", "!.*"}})
		return
	end

	local word = vim.fn.input("Enter word to search: ")

	if word == "" then
		word = vim.fn.expand("<cword>")
	end

	vim.fn.setreg('"', extension)
	vim.fn.setreg('-', word)

	if vim.fn.executable("rg") == 1 then
		vim.cmd([[cexpr system('rg --vimgrep --smart-case ' .. getreg('-') .. ' ./**/' .. getreg('"'))]])
	else
		vim.cmd([[silent! vimgrep /]] .. vim.fn.getreg('-') .. [[/gj ./**/]] .. vim.fn.getreg('"'))
	end

	vim.cmd("silent! tab +copen")
end

local function git_diff(mode)
  local cmd = vim.g.git_func_cmd
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
	local cmd = vim.g.git_func_cmd
	if mode == "graph" then
		vim.cmd(string.format("%s %s", cmd, "log --oneline --graph"))
	elseif mode == "commit_count" then
		vim.cmd(string.format("%s %s", cmd, "rev-list HEAD --count"))
	elseif mode == "diff" then
		vim.cmd(string.format("%s %s", cmd, "log --patch"))
	else
	  if vim.fn.exists(':Telescope') then
		  require('telescope.builtin').git_commits()
		  return
	  end
	  vim.cmd(string.format("%s %s", cmd, "log"))
  end
end

local function git_status(mode)
  local cmd = vim.g.git_func_cmd
  if mode == "short" then
    vim.cmd(string.format("%s %s", cmd, "status --short"))
  elseif mode == "check_whitespace" then
    vim.cmd(string.format("%s %s", cmd, "diff-tree --check $(git hash-object -t tree /dev/null) HEAD"))
  else
	  if vim.fn.exists(':Telescope') then
		  require('telescope.builtin').git_status()
		  return
	  end
	  vim.cmd(string.format("%s %s", cmd, "status"))
	end
end

local function git_add(mode)
  local cmd = vim.g.git_func_cmd
  if mode == "patch" then
    vim.cmd(string.format("%s %s", cmd, "add -p"))
  elseif mode == "all" then
    vim.cmd(string.format("%s %s", cmd, "add ."))
  else
    vim.cmd(string.format("%s %s", cmd, "add -i"))
  end
end

local function git_commit(mode)
  local cmd = vim.g.git_func_cmd
  if mode == "amend" then
    vim.cmd(string.format("%s %s", cmd, "commit --amend"))
  else
    vim.cmd(string.format("%s %s", cmd, "commit"))
  end
end

local function git_function_setup()
  if vim.fn.exists(":FloatermNew") == 1 then
    vim.g.git_func_cmd = "FloatermNew --width=0.9 --height=0.9 git "
  elseif vim.fn.exists(":Git") == 1 then
    vim.g.git_func_cmd = "Git"
  else
    vim.g.git_func_cmd = "!git"
  end
end

local function terminal(mode)
	if mode == "split" then
		vim.cmd("sp | term")
	elseif mode == "vertical" then
		vim.cmd("vs | term")
	elseif mode == "selection" then
		local shell = vim.fn.input("Select shell (bash, sh, zsh, powershell.exe): ")
		if vim.fn.exists(":ToggleTerm") then
			vim.cmd("TermExec cmd='" .. shell .. "'")
		else
			vim.cmd("tabnew | term " .. shell)
		end
	else
		if vim.fn.exists(":ToggleTerm") then
			vim.cmd("ToggleTerm")
		else
			vim.cmd("tabnew | term")
		end
	end
end

local function get_buffers(mode)
	if mode == "list" then
		if vim.fn.exists(':Telescope') then
			require('telescope.builtin').buffers()
			return
		end
		vim.cmd("ls")
	end
end

local function get_marks(mode)
	if vim.fn.exists(':Telescope') then
		require('telescope.builtin').marks()
		return
	end
	vim.cmd("marks")
end

local function get_jumplist(mode)
	if vim.fn.exists(':Telescope') then
		require('telescope.builtin').jumplist()
		return
	end
	vim.cmd("jump")
end

local function get_register_list(mode)
	if vim.fn.exists(':Telescope') then
		require('telescope.builtin').registers()
		return
	end
	vim.cmd("registers")
end

local function set_statusline(mode)
	if mode == "ascii" then
		vim.o.statusline = " %<%f%h%m%r%=%b\\ 0x%B\\ \\ %l,%c%V\\ %P"
	elseif mode == "byte" then
		vim.o.statusline = " %<%f%=\\ [%1*%M%*%n%R%H]\\ %-19(%3l,%02c%03V%)%O'%02b'"
	else
		vim.o.statusline = " %<%f\\ %h%m%r%=%-14.(%l,%c%V%)\\ %P"
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
	else
		if vim.fn.isdirectory(path) == 1 and vim.fn.filereadable(src) == 1 then
			vim.cmd("source " .. src)
		else
			vim.cmd("echohl WarningMsg | echo 'src not found!' | echohl none")
		end
	end
end

local function create_ctags()
	print('Creating ctags ...')

	local success = os.execute("ctags -R . && sort -u -o tags tags")

	if success then
		vim.api.nvim_echo({{"Ctags created !", "MoreMsg"}}, true, {})
	else
		vim.api.nvim_echo({{"Failed to create ctags !", "ErrorMsg"}}, true, {})
	end
end

local function build()
	if vim.fn.exists(':Make') and vim.fn.exists("$TMUX") then
		vim.cmd("Make")
	else
		vim.cmd("make")
	end
end

git_function_setup()

local M = {
	SearchFile = search_file,
	SearchWord = search_word,
	FuzzySearch = search_fuzzy,
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
	Session = session,
	CreateCtags = create_ctags,
	Build = build,
}

return M
