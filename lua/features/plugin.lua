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

		{ 'neoclide/coc.nvim',
			branch = 'release',
			build = ':CocInstall coc-clangd coc-lua ' ..
				'coc-markdownlint @yaegassy/coc-marksman ' ..
				'coc-rust-analyzer coc-cmake ' ..
				'coc-pyright coc-snippets',
			init = function ()
				require('setup.coc')
			end
		},

		{ "iamcco/markdown-preview.nvim",
			build = "cd app && npm install",
			config = function()
				require('setup.markdown-preview')
			end,
			ft = { "markdown" },
		},

		{ 'tpope/vim-fugitive',
			config = function ()
				require('setup.fugitive')
			end
		},

		{	'nvim-telescope/telescope.nvim',
			tag = '0.1.1',
			dependencies = { 'nvim-lua/plenary.nvim' },
			config = function()
				require('setup.telescope').setup()
				require('setup.telescope').setup_keymapping()
			end
		},

		{ "nvim-telescope/telescope-live-grep-args.nvim",
			dependencies = { 'nvim-telescope/telescope.nvim' },
			config = function()
				require('setup.telescope').setup_live_grep_args()
			end
		},

		{ 'dhruvmanila/telescope-bookmarks.nvim',
			dependencies = {
				'nvim-telescope/telescope.nvim',
				'kkharji/sqlite.lua',
			},
			build = "pip3 install buku",
			config = function ()
				require('setup.telescope').setup_bookmarks()
			end
		},

		{ 'crispgm/telescope-heading.nvim',
			dependencies = { 'nvim-telescope/telescope.nvim' },
			config = function ()
				require('setup.telescope').setup_heading()
			end,
			ft = { "markdown" },
		},

		{ 'numToStr/Comment.nvim',
			config = function()
				require('Comment').setup()
			end
		},

		{ 'tpope/vim-dispatch',
			config = function()
				require('setup.dispatch')
			end
		},

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
			init = function ()
				require('setup.vim-markdown').init()
			end,
			config = function()
				require('setup.vim-markdown')
			end,
		},

		{ "ellisonleao/glow.nvim",
			config = function ()
				local current_window = vim.api.nvim_get_current_win()
				local window_width = vim.api.nvim_win_get_width(current_window)
				local padding_ratio = 0.8

				require('glow').setup({
					border = "shadow", -- floating window border config
					style = "dark", -- filled automatically with your current editor background, you can override using glow json style
					width = math.ceil(window_width * padding_ratio),
					width_ratio = 0.9, -- maximum width of the glow window compared to the nvim window size (overrides `width`)
					height_ratio = 0.9,
				})
			end,
			cmd = 'Glow',
			ft = { "markdown" },
		},

		{ 'stevearc/oil.nvim',
			dependencies = { "nvim-tree/nvim-web-devicons" },
			opts = {},
			config = function ()
				require('setup.oil')
			end
		},

		{ 'preservim/tagbar',
			config = function ()
				vim.api.nvim_set_keymap('n', '<leader>tt',
					[[<cmd> TagbarToggle fc <CR>]],
					{ silent = true, desc = 'tag lists'})
			end
		},

		{ "jackMort/ChatGPT.nvim",
			dependencies = {
				"nvim-telescope/telescope.nvim",
				"MunifTanjim/nui.nvim",
				"nvim-lua/plenary.nvim",
			},
			event = "VeryLazy",
			config = function()
				require('setup.chatgpt')
			end,
		},

		{ "mfussenegger/nvim-dap",
			build = "pip3 install debugpy",
			config = function()
				require('setup.dap').SetupKeymap()
			end,
		},

		{ "mfussenegger/nvim-dap-python",
			dependencies = { "mfussenegger/nvim-dap" },
			build = function ()
				os.execute([[
					mkdir ~/.local/share/.virtualenvs
					cd ~/.local/share/.virtualenvs
					python -m venv debugpy
					debugpy/bin/python -m pip install debugpy
				]])
			end,
			ft = { "python" },
			config = function()
				require('dap-python').setup('~/.local/share/.virtualenvs/debugpy/bin/python')
				require('setup.dap').SetupKeymap('python')
				require('setup.dap').SetupPython()
			end,
		},

		{ "rcarriga/nvim-dap-ui",
			dependencies = { "mfussenegger/nvim-dap" },
			config = function()
				require('dapui').setup()
				require('setup.dap').SetupUI()
			end,
		},

		{ "olimorris/onedarkpro.nvim",
			priority = 1000,
			config = function()
				require('setup.color_scheme').OneDarkPro()
			end,
		},

		{ "luisiacc/gruvbox-baby",
			priority = 1000,
			config = function()
				require('setup.color_scheme').GruvboxBaby()
			end,
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

require('config.autocmd').plugin_autocmd_setup()
