local function get_dir()
	local current_file_dir = vim.fn.expand('%:p:h')
	vim.fn.setreg('+', tostring(current_file_dir))
	return current_file_dir
end

local function get_name()
	local current_file_name = vim.fn.expand('%:t')
	vim.fn.setreg('+', tostring(current_file_name))
	return current_file_name
end

local function get_full_path()
	local path = vim.fn.expand('%:p')
	vim.fn.setreg('+', tostring(path))
	return path
end

local function get_path()
	local path = vim.fn.expand('%')
	vim.fn.setreg('+', tostring(path))
	return path
end

local function get_files(path)
	local uv = vim.loop
	local files = {}
	local handle = uv.fs_scandir(path)

	if handle then
		while true do
			local name, type = uv.fs_scandir_next(handle)

			if not name then
				break
			end

			if type == "file" then
				table.insert(files, name)
			end
		end
	end

	return files
end

local function recursive_file_search(dir, file_pattern)
	local uv = vim.loop
	local files_search_found = {}

	local function file_search(directory, pattern)
		if pcall(require, 'lfs') == false then
			vim.api.nvim_echo({{"lfs not found ... recursive file search failed ...", "ErrorMsg"}}, false, {})
			return
		end

		local lfs = require('lfs')

		if directory == nil or vim.fn.len(directory) == 0 then
			directory = uv.cwd()
		end

		if pattern == nil then
			pattern = "*"
		end

		for file in lfs.dir(directory) do
			if file ~= "." and file ~= ".." then
				local delim = "/"

				if vim.fn.has('unix') ~= 1 then
					delim = "\\"
				end

				local filePath = directory .. delim .. file
				local attributes = lfs.attributes(filePath)

				if attributes.mode == "file" and file:match(pattern) then
					if #files_search_found == 0 then
						files_search_found = { filePath }
					else
						table.insert(files_search_found, filePath)
					end
				elseif attributes.mode == "directory" then
					file_search(filePath, pattern)
				end
			end
		end
	end

	file_search(dir, file_pattern)

	return files_search_found
end

local function check_extension_file_exist(extension)
	if extension == nil then
		extension = vim.fn.expand("%:e")
	end

	local cmd = "find . -type f -name " .. '"*.' .. extension .. '"' .. " -print -quit | wc -l"
	local result = tonumber(vim.fn.system(cmd))

	return result
end

local function search_file()
	local regex_file = vim.fn.input("File to search (regex): ")

	if regex_file == "" or regex_file == nil then
		return
	end

	local files = recursive_file_search(vim.loop.cwd(), regex_file)
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

local function json_write(tbl, path)
	if tbl == nil then
		vim.api.nvim_echo({{"empty table ...", "ErrorMsg"}}, false, {})
		return false
	end

	if path == nil or #path == 0 then
		vim.api.nvim_echo({{"file path is empty ...", "ErrorMsg"}}, false, {})
		return false
	end

	local json_format = vim.json.encode(tbl)
	local file = io.open(path, "w")

	if file == nil then
		vim.api.nvim_echo({{"file open failed ...",
			"ErrorMsg"}}, false, {})
		return false
	end

	file:write(json_format)
	file:close()

	return true
end

local function json_read(path)
	if path == nil then
		vim.api.nvim_echo({{"file path is empty ...", "ErrorMsg"}}, false, {})
		return false
	end

	local file = io.open(path, "r")

	if file == nil then
		vim.api.nvim_echo({{"file open failed ...", "ErrorMsg"}}, false, {})
		return nil
	end

	local json_format = file:read("*a")
	file:close()

	if #json_format == 0 then
		return {}
	end

	return vim.json.decode(json_format)
end

local function setup()
	local skip_functions = { '^Setup$', '^.*Json$' }

	for name in pairs(require('features.files')) do
		for _, skip in ipairs(skip_functions) do
			if name:match(skip) ~= nil then
				goto continue
			end
		end

		local callback = "require('features.files')." .. name .. "()"
		vim.cmd("command! -nargs=0 -bang " .. "File" .. name .. " lua print(" .. callback .. ")" )
		::continue::
	end
end

return {
	GetDir = get_dir,
	GetName = get_name,
	GetPath = get_path,
	GetFullPath = get_full_path,
	GetAll = get_files,
	ChkExtExist = check_extension_file_exist,
	RecurSearch = recursive_file_search,
	Search = search_file,
	SetJson = json_write,
	GetJson= json_read,
	Setup = setup,
}
