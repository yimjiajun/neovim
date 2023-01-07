-- examples for your init.lua

-- OR setup with some options
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    adaptive_size = false,
		width = 50,
    mappings = {
      list = {
        { key = "h", action = "parent_node" },
      },
    },
		float = {
			enable = false,
			open_win_config = {
				relative = "cursor",
				border = "rounded",
				width = 30,
				height = 30,
				row = 1,
				col = 1,
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

