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
				"hrsh7th/cmp-vsnip",
				"hrsh7th/vim-vsnip-integ",
				"hrsh7th/vim-vsnip",
				"haorenW1025/completion-nvim",
			},
			event = "VimEnter",
			config = function()
				require ("setup.cmp")
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

		{ "sainnhe/gruvbox-material",
			dependencies = { "ellisonleao/gruvbox.nvim" },
			config = function ()
				require('setup.gruvbox')
			end
		},

		{ 'williamboman/mason-lspconfig.nvim',
			after = { "mason.nvim", "nvim-lspconfig" },
			dependencies = { "williamboman/mason.nvim" },
			config = function()
				require('setup.mason')
			end
		},

		{	'nvim-telescope/telescope.nvim',
			tag = '0.1.1',
			dependencies = { 'nvim-lua/plenary.nvim' },
			config = function()
				require('setup.telescope')
			end
		},

		{ 'numToStr/Comment.nvim',
			config = function()
				require('Comment').setup()
			end
		},

		{ 'tpope/vim-dispatch' },

		{ "folke/zen-mode.nvim",
			config = function()
				require("setup.zen_mode")
			end
		},

		{ 'github/copilot.vim',
			build = function()
				print('Exit neovim and re-enter to run :Copilot! to register API key')
			end,
		},

		{ "akinsho/toggleterm.nvim",
			config = function()
				require('setup.toggleterm')
			end
		},

		{ 'lewis6991/gitsigns.nvim',
			config = function()
				require('setup.gitsigns')
			end
		},

		{ 'goolord/alpha-nvim',
			config = function()
				require('alpha').setup(require('setup.alphas').config)
			end
		},

		{ 'nvim-orgmode/orgmode',
			dependencies = "nvim-treesitter/nvim-treesitter",
			build = function()
				vim.cmd[[TSUpdate org]]
			end,
			config = function()
				require('setup.orgmode')
			end
		},

		{ "akinsho/org-bullets.nvim",
			ft = {'org'},
			dependencies = "nvim-orgmode/orgmode",
			config = function()
				require('setup.orgmode').SetupOrgBullets()
			end,
		},

		{ "folke/which-key.nvim",
			config = function()
				require('setup.whichkey')
			end
		},

		{ "tpope/vim-surround",
			config = function()
				require('setup.surround')
			end
		},

		{ "plasticboy/vim-markdown",
			dependencies = {
				"godlygeek/tabular",
				'dhruvasagar/vim-table-mode' },
			ft = { "markdown" },
			config = function()
				require('setup.vim-markdown')
			end,
		},

		{ 'rmagatti/goto-preview',
			config = function()
				require('setup.goto-preview')
			end
		},
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