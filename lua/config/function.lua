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

local M = {
	SearchFile = search_file,
	SearchWord = search_word,
	FuzzySearch = search_fuzzy,
}

return M
