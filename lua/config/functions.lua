local lfs = require("lfs")

local function get_dirs_with_pattern(pattern)
  for dir in lfs.dir(".") do
    if dir ~= "." and dir ~= ".." then
      local dir_path = "./" .. dir
      local mode = lfs.attributes(dir_path, "mode")
      if mode == "directory" and dir:match(pattern) then
				print('Found directory: ' .. dir_path)
				return dir_path
      end
    end
  end
	return nil
end

local function get_file_dir()
	local current_file_dir = vim.fn.expand('%:p:h')
	print(current_file_dir)
	return current_file_dir
end

local function get_file_name()
	local current_file_name = vim.fn.expand('%:t')
	print(current_file_name)
	return current_file_name
end

local function do_chg_wd()
	local current_file_dir = get_file_dir()
	print('Changing working directory to: ' .. current_file_dir)
	vim.loop.chdir(current_file_dir)
end

vim.myfn = {
	doChgwd = do_chg_wd,
	getFileDir = get_file_dir,
	getFileName = get_file_name,
	getDirWithPattern = get_dirs_with_pattern,
}

return vim.myfn
