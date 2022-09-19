vim.g.custom = {
	-- support native nvim LSP ( 0: disabled native nvim LSP and replaced by coc.nvim )
	lsp_support = 1,
	-- display statusline as simple line
	lualine_simple = 1,
	-- display buffer
	buffer_display = 0,
}

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

if vim.g.custom.lsp_support == 0 then
	vim.cmd[[source $MYVIMRC/../lua/config/vimrc.vim]]
end
