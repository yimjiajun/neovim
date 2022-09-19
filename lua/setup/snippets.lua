if vim.fn.has('win32') == 1 then
    vim.cmd[[source $MYVIMRC/../lua/setup/snippets.vim]]
else
	vim.cmd[[source $HOME/.config/nvim/lua/setup/snippets.vim]]
end
