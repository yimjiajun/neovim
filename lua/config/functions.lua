function Chwd()
	local current_file_dir = vim.fn.expand('%:p:h')
	vim.loop.chdir(current_file_dir)
end
