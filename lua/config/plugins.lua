vim.api.nvim_set_option('termguicolors', true)	-- enable 24-bit RGB colors for terminals

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)
require("lazy").setup({
	spec = {
		{ 'nvim-lualine/lualine.nvim',
			config = function()
				if vim.g.custom.statusline_support == 1 then
					require('setup.lualines')
				end
			end,
		},

		{ 'preservim/tagbar' },
		-- lsp config in nvim-cmp
		{ 'neovim/nvim-lspconfig' },
		{ "onsails/lspkind-nvim" },
		{ "hrsh7th/cmp-buffer" },
		{ "hrsh7th/cmp-path" },
		{ "hrsh7th/cmp-nvim-lsp" },
		{ "hrsh7th/cmp-nvim-lua" },
		{ "hrsh7th/cmp-calc" },
		{ "hrsh7th/cmp-emoji" },
		{ "hrsh7th/nvim-cmp",
			after = { "nvim-lspconfig" },
			event = "VimEnter",
			config = function()
				require ("setup.cmp")
			end,
		},

		{ 'hrsh7th/vim-vsnip' },
		{ 'hrsh7th/vim-vsnip-integ' },
		{ 'hrsh7th/cmp-vsnip',
			after = { 'nvim-cmp' },
			config = function()
				require ('setup.snippets')
			end,
		},

		{ 'haorenW1025/completion-nvim' },
		-- LSP installer
		{ "williamboman/mason.nvim", },
		{ 'williamboman/mason-lspconfig.nvim',
			after = { "mason.nvim", "nvim-lspconfig" },
			config = function()
				require('setup.mason')
			end
		},

		-- LSP symbols
		{ 'stevearc/aerial.nvim',
			module = "aerial",
			-- cmd = { "AerialToggle", "AerialOpen", "AerialInfo" },
			config = function()
				require ('setup.aerial')
			end,
		},

		-- Neovim UI Enhancer
		{ 'stevearc/dressing.nvim',
			config = function()
				require('setup.dressing')
			end
		},

		{ 'nvim-lua/plenary.nvim' },
		{ 'nvim-telescope/telescope.nvim',
			config = function()
				require('setup.telescope')
			end,
		},

		-- session
		{ 'Shatur/neovim-session-manager',
			config = function()
				require('setup.session_manager')
			end
		},

		-- sidebar
		{ 'kyazdani42/nvim-tree.lua',
			config = function()
				require('setup.nvim_tree')
			end
		},

		-- tab / buffer display
		{ 'akinsho/bufferline.nvim',
			config = function()
				require('setup.bufferline')
			end
		},

		-- terminal
		{ "akinsho/toggleterm.nvim",
			-- lazygit is not installed. Manual Install : https://github.com/jesseduffield/lazygit#ubuntu
			run = "sudo apt install ripgrep fzf",
			config = function()
				require('setup.toggleterm')
			end
		},

		-- git easy diff view
		{ 'sindrets/diffview.nvim' },

		-- programming language highlight
		{ 'nvim-treesitter/nvim-treesitter',
			run = function()
				require('nvim-treesitter.install').update({ with_sync = true })
				require("setup.treesitter")
				vim.cmd([[TSUpdateSync]])
			end,
		},

		-- comment toggle
		{ 'numToStr/Comment.nvim',
			config = function()
				require('Comment').setup()
			end
		},

		-- key mapping tips
		{ "folke/which-key.nvim",
			requires = 'akinsho/toggleterm.nvim',
			config = function()
				require('setup.whichkey')
			end
		},

		-- dashboard
		{ 'goolord/alpha-nvim',
			config = function()
				require 'alpha'.setup(require('setup.alphas').config)
			end
		},

		-- pop up notify
		{ 'rcarriga/nvim-notify',
			config = function()
				require('setup.notify')
			end
		},

		-- git live display
		{ 'lewis6991/gitsigns.nvim',
			config = function()
				require('setup.gitsigns')
			end
		},

		-- git command line
		{ 'tpope/vim-fugitive' },

		-- lsp pop up preview
		{ 'rmagatti/goto-preview',
			config = function()
				require('goto-preview').setup()
				require('setup.goto_preview')
			end
		},

		-- markdown preview
		{ "iamcco/markdown-preview.nvim",
		run = "cd app && npm install",
		setup = function()
			vim.g.mkdp_filetypes = { "markdown" }
			vim.g.mkdp_browser = 'firefox'
		end,
		ft = { "markdown" },
		},

		-- easy motion
		{ 'phaazon/hop.nvim',
			branch = 'v2', -- optional but strongly recommended
			config = function()
				-- you can configure Hop the way you like here; see :h hop-config
				require('setup.hop')
				require('hop').setup ({
					keys = 'etovxqpdygfblzhckisuran',
				})
			end
		},

		-- indent dispaly
		{ 'lukas-reineke/indent-blankline.nvim',
			config = function()
				require('setup.indent_blankline')
			end,
		},

		-- Color display
		{ 'norcalli/nvim-colorizer.lua',
			config = function()
				require('colorizer').setup()
				require('setup.colorizers')
			end,
		},

		-- Themes
		{ 'sam4llis/nvim-tundra',
			config = function()
				require('setup.tundra')
			end,
		},

		{ "sainnhe/gruvbox-material" },
		{ "ellisonleao/gruvbox.nvim", -- optional, for file icons
			config = function ()
				require('setup.gruvbox')
			end
		},

		{ 'kyazdani42/nvim-web-devicons' },
		{ 'ryanoasis/vim-devicons' },
		-- sidebar
		{ 'preservim/nerdtree', },

		-- integrate vim editor on browser
		-- this should also install firenvim from browser store/extension
		{ 'glacambre/firenvim',
			run = function() vim.fn['firenvim#install'](0) end,
			setup = function()
				vim.api.nvim_create_autocmd( "BufEnter", {
					desc = "set markdown filetype when in github txt file",
					pattern = "github.com_*.txt",
					callback = function()
						vim.cmd([[set filetype=markdown]])
					end,
				})
			end,
		},

		{ 'eandrju/cellular-automaton.nvim',
			config = function()
				require('setup.cellular_automaton')
			end,
		},

		-- github copilot
		-- This should run Copilot! setup to authenticate copilot
		{ 'github/copilot.vim' },

		-- Async build ( usage same as :make, makprg, copen, cclose )
		-- Command : Make, Copen
		{ 'tpope/vim-dispatch' },
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
