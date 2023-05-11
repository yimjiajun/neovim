local lfs = require("lfs")

local function get_dirs_with_pattern(pattern)
	for dir in lfs.dir(".") do
		if dir ~= "." and dir ~= ".." then
			local dir_path = "./" .. dir
			local mode = lfs.attributes(dir_path, "mode")
			if mode == "directory" and dir:match(pattern) then
				return dir_path
			end
		end
	end
	return nil
end

local function get_file_dir()
	local current_file_dir = vim.fn.expand('%:p:h')
	return current_file_dir
end

local function get_file_name()
	local current_file_name = vim.fn.expand('%:t')
	return current_file_name
end

local function do_chg_wd()
	local current_file_dir = get_file_dir()
	print('Changing working directory to: ' .. current_file_dir)
	vim.loop.chdir(current_file_dir)
end

local ret = {
	DoChgWd = do_chg_wd,
	GetFileDir = get_file_dir,
	GetFileName = get_file_name,
	GetDirWithPattern = get_dirs_with_pattern,
}

for name in pairs(ret) do
	vim.cmd("command! -nargs=0 -bang " .. name .. " lua print(" .. "require('features.system')." .. name .. "()" .. ")")
end

vim.cmd("command! -nargs=1 GetDirWithPattern lua print(require('features.system').GetDirWithPattern(<f-args>))")

return ret
