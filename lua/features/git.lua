local function run_git_cmd(args)
	local cmd = "git"

	if vim.fn.exists(":Git") > 0 then
		cmd = "Git"
	end

	if cmd == "git" then
		if vim.fn.expand("%:h") ~= "" then
			cmd = string.format("%s %s %s", cmd, "-C", vim.fn.expand("%:p:h"))
		end

		vim.cmd(string.format("%s %s %s", "term", cmd, args))
	else
		vim.cmd(string.format("%s %s", cmd, args))
	end
end

local function check_repo_exists()
	vim.fn.system('git rev-parse --is-inside-work-tree')

	if vim.v.shell_error ~= 0 then
		return false
	end

	return true
end

local function branch()
	local function lists()
		if check_repo_exists() == false then
			return ''
		end

		local b = vim.fn.system("git branch --show-current")

		if b ~= '' then
			return vim.fn.trim(b)
		end

		local commita_hash = vim.fn.system("git rev-parse --short HEAD")

		return vim.fn.trim(commita_hash)
	end

	local function remote_lists()
		run_git_cmd("branch -r")
	end

	local function default()
		run_git_cmd("branch")
	end

	return {
		Get = lists,
		Remote = remote_lists,
		Default = default,
	}
end

local function remote()
	local function get_url(remote_name)
		if check_repo_exists() == false then
			return ''
		end

		return vim.fn.trim(vim.fn.system('git config --get remote.' .. remote_name ..'.url'))
	end

  local function get_remote()
    local remotes = vim.fn.system("git remote")

    if remotes == '' then
      return {}
    end

    return vim.fn.split(remotes, '\n')
  end

	local function default()
		run_git_cmd("remote -v")
	end

	return {
    Get = get_remote,
		GetUrl = get_url,
		Default = default
	}
end

local function diff()
	local function staged()
		run_git_cmd("diff --staged")
	end

	local function latest()
		run_git_cmd("diff HEAD~")
	end

	local function staged_extension()
		local extension = vim.fn.input("Enter extension to git diff (staged): ", vim.fn.expand("%:e"))
		run_git_cmd("diff ./**/*." .. extension)
	end

	local function working_directory_extension()
		local extension = vim.fn.input("Enter extension to git diff (working directory): ", vim.fn.expand("%:e"))
		run_git_cmd("diff ./**/*." .. extension)
	end

	local function working_directory_file()
		local file = vim.fn.input("Enter file to git diff (working directory): ", vim.fn.expand("%:t"))
		run_git_cmd("diff ./**/" .. file)
	end

	local function staged_file()
		local file = vim.fn.input("Enter file to git diff (staged): ", vim.fn.expand("%:t"))
		run_git_cmd("diff ./**/" .. file)
	end

	local function default()
		run_git_cmd("diff")
	end

	return {
		Staged = staged,
		Latest = latest,
		SExt = staged_extension,
		WExt = working_directory_extension,
		SFile = staged_file,
		WFile = working_directory_file,
		Default = default
	}
end

local function log()
	local function graph()
		run_git_cmd("log --oneline --graph")
	end

	local function commit_count()
		run_git_cmd("rev-list HEAD --count")
	end

	local function content_change()
		run_git_cmd("log --patch")
	end

	local function file_change()
		run_git_cmd("log --stat")
	end

	local function default()
		run_git_cmd("log")
	end

	return {
		Graph = graph,
		CommitCount = commit_count,
		Patch = content_change,
		Stat = file_change,
		Default = default,
	}
end

local function status()
	local function short()
		run_git_cmd("status --short")
	end

	local function check_whitespace()
		local commit = vim.fn.system('git hash-object -t tree /dev/null')
		run_git_cmd(string.format("%s %s %s", "diff-tree --check", vim.fn.trim(commit), "HEAD"))
	end

	local function default()
		if vim.fn.exists(":Git") ~= 0 then
			run_git_cmd("")
		else
			run_git_cmd("status")
		end
	end

	return {
		Short = short,
		ChkWhitespace = check_whitespace,
		Default = default,
	}
end

local function add()
	local function patch()
		run_git_cmd("add -p")
	end

	local function all()
		run_git_cmd("add .")
	end

	local function default()
		run_git_cmd("add -i")
	end

	return {
		Patch = patch,
		All = all,
		Default = default,
	}
end

local function commit()
	local function amend()
		run_git_cmd("commit --amend")
	end

	local function default()
		run_git_cmd("commit")
	end

	return {
		Amend = amend,
		Default = default,
	}
end

local function setup()
  local repo = require('features.files').GetJson(vim.fn.stdpath('config') .. '/repo.json')

  if repo == nil or #repo == 0 then
    goto setup_end
  end

  for _, v in ipairs(repo) do
    local path = vim.fn.stdpath('data') .. '/' .. v.name

    if v.url == nil or v.url == '' then
      goto continue
    end

    if vim.fn.isdirectory(path) == 0 then
      require('features.common').AsyncCommand({ commands = {
        'git clone ' .. v.url .. ' ' ..  path,
        'mkdir -p ' .. path,
      }, timeout = 120, allow_fail = true})
    end

    ::continue::
  end

  ::setup_end::
  return
end

return {
	ChkRepoExists = check_repo_exists,
	Branch = branch,
	Remote = remote,
	Diff = diff,
	Log = log,
	Status = status,
	Add = add,
	Commit = commit,
	Setup = setup,
}
