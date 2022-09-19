lua << EOF
if vim.fn.has('win32') == 1 then
	vim.cmd[[source $MYVIMRC/../lua/setup/vim_plug.vim]]
	vim.cmd[[source $MYVIMRC/../lua/setup/coc.vim]]
	vim.cmd[[source $MYVIMRC/../lua/setup/fzf.vim]]
else
	vim.cmd[[source $HOME/.config/nvim/lua/setup/vim_plug.vim]]
	vim.cmd[[source $HOME/.config/nvim/lua/setup/coc.vim]]
	vim.cmd[[source $HOME/.config/nvim/lua/setup/fzf.vim]]
end
EOF
