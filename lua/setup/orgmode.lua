local ret = {}
vim.g.orgmode_dir = vim.fn.stdpath('data') .. '/org'

local function setup_org_bullets()
	local P = require('org-bullets')
	P.setup {
		concealcursor = false, -- If false then when the cursor is on a line underlying characters are visible
		symbols = {
			-- list symbol
			list = "•",
			-- headlines can be a list
			headlines = { "◉", "○", "✸", "✿" },
			checkboxes = {
				half = { "", "OrgTSCheckboxHalfChecked" },
				done = { "✓", "OrgDone" },
				todo = { "˟", "OrgTODO" },
			},
		}
	}
	return P
end


local function setup_orgmode_file_path()
	local path = vim.g.orgmode_dir
	local url = 'https://github.com/yimjiajun/schedule.git'

	if vim.fn.isdirectory(path) == 0 then
		vim.fn.mkdir(path, "p")
		vim.fn.system("git clone " .. url .. " " .. path)
	end

	if vim.fn.isdirectory(path) then
		if vim.fn.system([[git status --porcelain=v1 | wc -l]]) == 0 then
			vim.fn.system("git -C " .. path .. " pull ")
		end
	end
end

local function setup_orgmode_autocmd()
	vim.api.nvim_create_augroup( "orgmode", { clear = true })
	vim.api.nvim_create_autocmd( "VimLeavePre", {
		desc = "Push orgmode changes to remote",
		group = "orgmode",
		pattern = "*",
		callback = function()
			local function get_orgmode_remote_path()
				local path

				if vim.fn.has('unix') == 0 then
					return nil
				end
				local remote_path = vim.fn.expand("$HOME/Dropbox")

				if vim.fn.isdirectory("/run/WSL") == 1 and vim.fn.isdirectory(remote_path) == 0 then
					local dir = vim.fn.system([[find /mnt/c/Users/*/ -maxdepth 1 -type d \( -iname "Dropbox" ! -path "*All Users*" \) -print -quit 2>/dev/null]])
					dir = dir:gsub('\n', '')
					local sys_cmd = 'ln -s' .. ' ' .. dir .. ' ' .. remote_path
					vim.fn.system(sys_cmd)
					print("Org-mode: Created symlink for WSL <Dropbox> for orgmode ... " .. remote_path)
				end

				path = vim.fn.expand(remote_path)

				if vim.fn.isdirectory(path) == 0 then
					print("Org-mode: <Dropbox> directory not found: " .. path)
					path = nil
				end

				return path
			end

			local path = vim.g.orgmode_dir
			local git_status_chg = 0

			if vim.fn.isdirectory(path) == 0 then
				return
			end

			git_status_chg = vim.fn.system("git -C " .. path .. " status --porcelain=v1 | wc -l")

			if tonumber(git_status_chg, 10) == 0 then
				return
			end

			vim.fn.system("git -C " .. path .. " add .")
			vim.fn.system("git -C " .. path .. " commit -m'" .. vim.fn.getcwd() .. "'")
			vim.fn.system("git -C " .. path .. " push ")

			local remote_path = get_orgmode_remote_path()

			if remote_path == nil then
				return
			end

			remote_path = remote_path .. "/" .. vim.fn.fnamemodify(vim.g.orgmode_dir, ":t")

			if vim.fn.isdirectory(remote_path) == 0 then
				vim.api.nvim_echo({{"Org-mode: Creating remote directory ... " .. remote_path, "WarningMsg"}}, true, {})
				vim.fn.mkdir(remote_path, "p")
			end

			if vim.fn.isdirectory(remote_path .. "/.git") == 0 then
				vim.api.nvim_echo({{"Org-mode: git in remote path is not found ! ...\nSkip update remote server", "WarningMsg"}}, true, {})
				vim.fn.system("git -C " .. remote_path .. " clean --fdx ")
				vim.fn.system("git -C " .. remote_path .. " reset --hard ")
			end

			vim.fn.system("git -C " .. remote_path .. " pull ")
		end,
	})
end

local function setup_whichkey()
	if pcall(require, "which-key") then
		vim.api.nvim_create_autocmd( "FileType", {
			desc = "Append orgmode keybindings to which-key",
			group = "orgmode",
			callback = function()
				vim.api.nvim_set_keymap('n', '<leader>ou', [[<cmd> lua require('setup.orgmode').UpdateRep() <CR>]], { silent = true })

				local wk = require("which-key")
				wk.register({
					['?'] = "org mode help",
				}, { prefix = "g" })

				wk.register({
					o = { name = "Orgmode",
						a = { "Open agenda prompt" },
						c = { "Open capture prompt" },
						u = { "Update local repository" },
					},
				}, { prefix = "<leader>" })

			end,
		})
	end
end

local function orgmode_file_create(path)
	local p = path
	local f = { 'refile.org', 'todo.org', 'journal.org', 'calendar.org', 'schedule.org' }

	if vim.fn.isdirectory(p) == 0 then
		vim.fn.mkdir(p, "p")
	end

	for _, v in ipairs(f) do
		if vim.fn.filereadable(p .. '/' .. v) == 0 then
			local new_file = io.open(p .. '/' .. v, "w")

			if new_file == nil then
				print("Org-mode: Unable to create file ... " .. p .. '/' .. v)
				return
			end

			new_file:write("#+TITTLE: " .. v .. "\n")
			new_file:close()
			print("Org-mode: Created file ... " .. p .. '/' .. v)
		end
	end
end

local function orgmode_update_repository()
	local path = vim.g.orgmode_dir
	vim.fn.system("git -C " .. path .. " pull ")
end


setup_orgmode_file_path()

if vim.fn.isdirectory(vim.g.orgmode_dir) == 0 then
	return ret
end

local usr_org_file = vim.g.orgmode_dir .. '/' .. "refile.org"
local usr_org_agenda_files = { vim.g.orgmode_dir .. '/' .. '**/*' }
local usr_org_capture_templates = {
	T = {
		description = 'Todo',
		template = '* TODO %?\n %u',
		target = vim.fn.fnamemodify(usr_org_file, ":h") .. '/todo.org',
	},
	j = 'Journal',
	jj = {
		description = 'New Journal Entry',
		template = '** %<%Y-%m-%d> %<%A>',
		target = vim.fn.fnamemodify(usr_org_file, ":h") .. '/journal.org',
	},
	ja = {
		description = 'New',
		template = '*** %U\n%?',
		target = vim.fn.fnamemodify(usr_org_file, ":h") .. '/journal.org',
	},
	s = {
		description = 'Schedule',
		template = '* %?\n\tSCHEDULE: %t',
		target = vim.fn.fnamemodify(usr_org_file, ":h") .. '/schedule.org',
	},
	f = {
		description = 'record file',
		template = '** %f%U\n\t%?',
		target = vim.fn.fnamemodify(usr_org_file, ":h") .. '/refile.org',
	},
	e =  'Event',
	eo = {
		description = 'one time',
		template = '** %?\n\tSCHEDULE: %t\t:PROPERTIES:\n\t:STYLE: habit\n\t:NOTE:\n\t:END:\n',
		target = vim.fn.fnamemodify(usr_org_file, ":h") .. '/calendar.org',
		headline = 'one-time'
	},
	es = {
		description = 'schedule',
		template = '** %?\n\tSCHEDULE: %T\n\t:PROPERTIES:\n\t:STYLE: habit\n\t:NOTE:\n\t:END:\n',
		target = vim.fn.fnamemodify(usr_org_file, ":h") .. '/calendar.org',
		headline = 'schedule'
	}
}

local M = {
	org_agenda_files = usr_org_agenda_files,
	org_default_notes_file = usr_org_file,
	org_capture_templates = usr_org_capture_templates,
}

require('orgmode').setup_ts_grammar()
require('orgmode').setup(M)
orgmode_file_create(vim.fn.fnamemodify(usr_org_file, ":h"))
setup_orgmode_autocmd()
setup_whichkey()

ret = {
	setup = M,
	UpdateuRep = orgmode_update_repository,
	SetupOrgBullets = setup_org_bullets,
}

return ret
