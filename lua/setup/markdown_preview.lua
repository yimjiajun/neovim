local os = vim.bo.fileformat:upper()

if (os == 'UNIX') then
	vim.api.nvim_set_var('mkdp_browser', 'firefox')
elseif (os == 'MAC') then
	vim.api.nvim_set_var('mkdp_browser', 'MicrosoftEdge.exe')
else
	vim.api.nvim_set_var('mkdp_browser', 'safari')
end
