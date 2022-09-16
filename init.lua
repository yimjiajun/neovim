vim.g.nvim_lsp_support = 1
vim.g.nvim_lualine_simple = 1
vim.g.nvim_buffer_display = 0

for _, source in ipairs {
	"config.plugins",
	"config.settings",
	"config.autocmd",
	"config.keymapping",
	"config.colors",
	"config.custom",
} do
  local status_ok, fault = pcall(require, source)
  if not status_ok then vim.api.nvim_err_writeln("Failed to load " .. source .. "\n\n" .. fault) end
end

if vim.g.nvim_lsp_support == 0 then
	vim.cmd[[source $HOME/.config/nvim/lua/config/vimrc.vim]]
end
