-- examples for your init.lua

-- OR setup with some options
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    adaptive_size = false,
    mappings = {
      list = {
        { key = "u", action = "dir_up" },
      },
    },
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})

vim.api.nvim_create_autocmd( "FileType", {
	desc = "Highlight colors",
	pattern = "NvimTree",
	callback = function()
		vim.cmd([[highlight NvimTreeVertSplit guibg=bg guifg=bg]])
	end,
})
