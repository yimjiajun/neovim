local function search_word(extension, mode)
	local word, cmd

	if extension == nil then
		extension = vim.fn.input("Enter filetype to search: ", vim.fn.expand("%:e"))
	end

	if extension == "" then
		extension = "*"
	end

	if mode ~= 'cursor' then
		word = vim.fn.input("Enter word to search: ")
	else
		word = vim.fn.expand("<cword>")
	end

	if word == "" then
		return
	end

	vim.fn.setreg('/', tostring(word))

	if vim.fn.executable("rg") == 1 then
		if extension == "*" then
			extension = [[--glob "*"]]
		else
			extension = string.format([[--glob "*.%s"]], extension)
		end

		local opts = " --no-ignore "

		if mode == 'complete' then
			opts = opts .. " --case-sensitive "
		else
			opts = opts .. " --smart-case "
		end

		vim.fn.setreg('e', extension)
		vim.fn.setreg('o', opts)
		cmd = [[cgetexpr system('rg --vimgrep ' .. getreg('o') .. " --regexp " .. getreg('/') .. " " .. getreg('e'))]]
	else
		if extension ~= "*" then
			extension = [[*.]] .. extension
		end

		vim.fn.setreg('e', tostring(extension))
		cmd = [[silent! vimgrep /]] .. vim.fn.getreg('/') .. [[/gj ./**/]] .. vim.fn.getreg('e')
	end

	vim.cmd("silent! " .. cmd  .. " | silent! +copen 5")
	vim.fn.setqflist({}, 'r', { title = "search word: " .. vim.fn.getreg('/') })
end

local function search_word_by_file(file, mode)
	local word, cmd

	if file == nil or file == "" then
		search_word("*", "normal")
	end

	if mode ~= 'cursor' then
		word = vim.fn.input("Enter word to search: ")
	else
		word = vim.fn.expand("<cword>")
	end

	if word == "" then
		return
	end

	vim.fn.setreg('/', tostring(word))

	if vim.fn.executable("rg") == 1 then
		file = string.format("{%s,./**/%s}", file, file)
		local opts = " --no-ignore "

		if mode == 'complete' then
			opts = opts .. " --case-sensitive "
		else
			opts = opts .. " --smart-case "
		end

		vim.fn.setreg('e', file)
		vim.fn.setreg('o', opts)
		cmd = [[cgetexpr system('rg --vimgrep ' .. getreg('o') .. " --regexp " .. getreg('/') .. " " .. getreg('e'))]]
	else
		vim.fn.setreg('e', tostring(file))
		cmd = [[silent! vimgrep /]] .. vim.fn.getreg('/') .. [[/gj ./**/]] .. vim.fn.getreg('e')
	end

	vim.cmd("silent! " .. cmd  .. " | silent! +copen 5")
	vim.fn.setqflist({}, 'r', { title = "search word in file: " .. vim.fn.getreg('/') })
end

local function search_word_by_buffer()
	vim.fn.setreg('/', vim.fn.expand("<cword>"))
	vim.cmd([[silent! vimgrep /]] .. vim.fn.getreg('/') .. [[/gj %]])
	vim.fn.setqflist({}, 'r', { title = "search buffer: " .. vim.fn.getreg('/') })
	vim.cmd("silent! +copen 5")
end

local function setup()
end

return {
	Search = search_word,
	SearchByFile = search_word_by_file,
	SearchByBuffer = search_word_by_buffer,
	Setup = setup,
}
