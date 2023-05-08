local build_cmd_list = {
  { name = "Vim", cmd = "vim --version" },
}

local function search_file()
  local regex_file = vim.fn.input("File to search (regex): ")
  vim.cmd("silent! find ./**/" .. regex_file)
end

local function search_word(extension)
	vim.fn.setreg('"', extension)

	if vim.fn.executable("rg") == 0 then
		vim.cmd([[cexpr system('rg --vimgrep ' .. expand('<cword>') .. ' ./**/' .. getreg('"'))]])
	else
		vim.cmd([[silent! vimgrep /]] .. vim.fn.expand("<cword>") .. [[/gj ./**/]] .. vim.fn.getreg('"'))
	end

	vim.cmd("silent! tab +copen")
end

local function search_fuzzy(extension)
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
    vim.cmd(string.format("%s %s", cmd, "rev-list --count"))
  elseif mode == "diff" then
    vim.cmd(string.format("%s %s", cmd, "log --patch"))
  else
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
    if vim.g.loaded_fzf_vim == "1" then
      vim.cmd("GFiles?")
    else
      vim.cmd(string.format("%s %s", cmd, "status"))
    end
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
}

return M
