local function Setting_view()
	vim.opt.background = "dark"
	if vim.fn.trim(vim.fn.execute('colorscheme')) == 'default' then
		vim.cmd('colorscheme habamax')
	end

	if vim.o.loadplugins == true then
		vim.opt.timeoutlen = 100
	else
		vim.opt.timeoutlen = 300
	end

	vim.opt.updatetime = 400
	vim.opt.showmode = true
	vim.opt.laststatus = 2
	vim.opt.cmdheight = 1
	vim.opt.relativenumber = true
	vim.opt.number = true
	vim.opt.wrap = true
	vim.opt.linebreak = true
	vim.opt.splitbelow = true
	vim.opt.splitright = false
	vim.opt.wildmenu = true
	vim.opt.cursorline = true
	vim.opt.cursorcolumn = false
	vim.opt.tabstop = 4
	vim.opt.shiftwidth = 4
	vim.opt.syntax = "on"
	vim.opt.listchars = { tab = "| ", trail = "·", extends = "…", precedes = "…", nbsp = "␣" }
	vim.opt.list = true
	if vim.fn.has("termguicolors") == 1 then
		vim.opt.termguicolors = true
	end

	require('config.function').SetStatusline()
end

local function Setting_editor()
	vim.opt.ignorecase = true
	vim.opt.smartcase = true
	vim.opt.showmatch = true
	vim.opt.autoindent = true
	vim.opt.smartindent = true
	vim.opt.backup = false
	vim.opt.writebackup = false
	vim.opt.swapfile = false
	vim.opt.clipboard = "unnamedplus"

	if vim.opt.undodir == "" then
		local local_share_path = vim.fn.stdpath('data')
		local local_undodir = local_share_path .. '/undo'

		if vim.fn.isdirectory(local_undodir) == 0 then
			vim.fn.mkdir(local_undodir, "p")
		end

		vim.opt.undodir = local_undodir
	end

	vim.opt.undofile = true
end

local function Setting_buffer()
	vim.opt.hidden = true
	vim.opt.lazyredraw = true
end

local function Setting_netrw()
	vim.g.netrw_liststyle = 3
	vim.g.netrw_banner = 0
	vim.g.netrw_browser_split = 4
	vim.g.netrw_altv = 1
	vim.g.netrw_winsize = 25
end

vim.opt.compatible = false
Setting_view()
Setting_editor()
Setting_buffer()
Setting_netrw()
