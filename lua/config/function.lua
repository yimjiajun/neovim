
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
		local git_branch = require('features.git').Branch().Get()
		vim.o.statusline = " %<%t [" .. git_branch .. "] %h%m%r%w%= / %Y / 0x%02B / %-10.(%l,%c%V%) / %-4P"
		vim.o.statusline = vim.o.statusline .. "/ %{strftime('%b %d / %H:%M')} "
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

	if mode == "latest" then
		status = compiler.LastSelect()
	else
		status = compiler.Selection()
	end

	if status == nil then
		vim.api.nvim_echo({{"\nBuild not found\n", "ErrorMsg"}}, false, {})
		return
	end

	if status == false then
		return
	end

	local cmd = "make"

	if vim.fn.exists(":Make") > 0 then
		cmd = "Make"
	end

	vim.cmd(cmd)
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
	Terminal = terminal,
	GetBuffers = get_buffers,
	GetMarks = get_marks,
	GetJumplist = get_jumplist,
	GetRegisterList = get_register_list,
	SetStatusline = set_statusline,
	SetFileFormat = setup_file_format,
	CreateCtags = create_ctags,
	Build = build,
	ToggleQuickFix = toggle_quickfix,
	ListFunctions = list_functions
}
