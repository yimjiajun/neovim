vim.g.mkdp_filetypes = { "markdown" }

vim.g.browser = nil
if vim.fn.has("mac") == 1 then
	vim.g.mkdp_browser = 'safari'
elseif vim.fn.has("win32") == 1 then
	vim.g.mkdp_browser = 'MicrosoftEdge.exe'
elseif vim.fn.has("unix") == 1 then
	if vim.fn.isdirectory("/run/WSL") == 1 then
		vim.g.mkdp_browser = 'MicrosoftEdge.exe'
	else
		if vim.fn.executable("google-chrome") == 1 then
			vim.g.mkdp_browser = 'google-chrome'
		elseif vim.fn.executable("firefox") == 1 then
			vim.g.mkdp_browser = 'firefox'
		end
	end
end
