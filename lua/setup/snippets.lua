if vim.fn.has('win32') then

else
	vim.cmd[[source $HOME/.config/nvim/lua/setup/snippets.vim]]
end
