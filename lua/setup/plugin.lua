local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end

vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("lazy").setup({
	spec = {
		{ 'nvim-treesitter/nvim-treesitter',
			run = function()
				require('nvim-treesitter.install').update({ with_sync = true })
				require("setup.treesitter")
				vim.cmd([[TSUpdateSync]])
			end,
		},
		{ 'neovim/nvim-lspconfig' },
		{ "hrsh7th/nvim-cmp",
			after = { "nvim-lspconfig" },
			dependencies = {
				"onsails/lspkind-nvim",
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-path",
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-nvim-lua",
				"hrsh7th/cmp-calc",
				"hrsh7th/cmp-emoji",
			},
			event = "VimEnter",
			config = function()
				require ("setup.cmp")
			end,
		},
		{ "nvim-cmp",
			dependencies = {
				"hrsh7th/cmp-vsnip",
				"hrsh7th/vim-vsnip-integ",
				"hrsh7th/vim-vsnip",
				"haorenW1025/completion-nvim",
			},
			config = function()
				require ("setup.snippets")
			end,
		},

		{ "iamcco/markdown-preview.nvim",
			build = "cd app && npm install",
			config = function()
				require('setup.markdown-preview')
			end,
			ft = { "markdown" },
		},

		{ 'tpope/vim-fugitive' },
	},

	defaults = {
		-- By default, Your custom plugins will load during startup.
		-- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
		lazy = false,
		-- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
		-- have outdated releases, which may break your Neovim install.
		version = false, -- always use the latest git commit
		-- version = "*", -- try installing the latest stable version for plugins that support semver
	},
	install = { colorscheme = { "gruvbox-material", "gruvbox", "habamax" } },
	checker = {
		-- automatically check for plugin updates
		enabled = false,
		concurrency = nil, ---@type number? set to 1 to check for updates very slowly
		notify = true, -- get a notification when new updates are found
		frequency = 604800, -- check for updates. Ex. every hour (3600)
	},
	change_detection = {
		-- automatically check for config file changes and reload the ui
		enabled = true,
		notify = true, -- get a notification when changes are found
	},
	performance = {
		cache = { enabled = true, },
		reset_packpath = true, -- reset the package path to improve startup time
		rtp = {
			-- disable some rtp plugins
			disabled_plugins = {
				"gzip",
				-- "matchit",
				-- "matchparen",
				-- "netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})
