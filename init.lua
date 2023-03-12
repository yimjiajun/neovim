for _, source in ipairs {
	"config.custom",
	"config.plugins",
	"config.settings",
	"config.autocmd",
	"config.keymapping",
	"config.colors",
	"config.compiler",
	"config.functions",
} do
  local status_ok, fault = pcall(require, source)
  if not status_ok then vim.api.nvim_err_writeln("Failed to load " .. source .. "\n\n" .. fault) end
end

if vim.g.custom.lsp_support == 0 then
	if vim.fn.has('win32') == 1 then
		vim.cmd[[source $MYVIMRC/../lua/config/vimrc.vim]]
	else
		vim.cmd[[source $HOME/.config/nvim/lua/config/vimrc.vim]]
	end
end
