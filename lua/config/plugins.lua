local use = require('packer').use

vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()

	use 'wbthomason/packer.nvim' -- Package manager
	use { 'neovim/nvim-lspconfig',
		config = function()
			require('setup.lspconfig')
		end
	}

	use {
		'nvim-lualine/lualine.nvim',
		requires = { 'kyazdani42/nvim-web-devicons', opt = true },
		config = function()
			require('setup.lualines')
		end,
	}

	use 'preservim/tagbar'

	use { "hrsh7th/nvim-cmp",
		requires = {
			{ "onsails/lspkind-nvim", module = "lspkind" },
			{ "hrsh7th/cmp-buffer", module = "cmp_buffer" },
			{ "hrsh7th/cmp-path", module = "cmp_path" },
			{ "hrsh7th/cmp-nvim-lsp", module = "cmp_nvim_lsp" },
			{ "hrsh7th/cmp-nvim-lua", module = "cmp_nvim_lua" },
			{ "hrsh7th/cmp-calc", module = "cmp_calc" },
			{ "hrsh7th/cmp-emoji", module = "cmp_emoji" },
			{ "quangnguyen30192/cmp-nvim-ultisnips", module = "cmp_nvim_ultisnips" },
			{ "tzachar/cmp-tabnine",
				run = "./install.sh",
				module = "cmp_tabnine",
			},
			{ "honza/vim-snippets", opt = true },
			{ "SirVer/ultisnips",
				opt = true,
				wants = "vim-snippets",
			},
		},
		event = "InsertEnter",
		wants = "ultisnips",
		config = function()
		    require ("setup.cmp")
		end,
	}

	use 'haorenW1025/completion-nvim'

	-- Neovim UI Enhancer
	use { 'stevearc/dressing.nvim',
		config = function()
			require('setup.dressing')
		end
	}

	-- LSP symbols
	use { 'stevearc/aerial.nvim',
		module = "aerial",
		cmd = { "AerialToggle", "AerialOpen", "AerialInfo" },
		config = function()
			require ('setup.aerial')
		end,
	}

	use { "williamboman/mason.nvim",
		requires = {
			{ 'williamboman/mason-lspconfig.nvim' },
			{ 'neovim/nvim-lspconfig' },
		},
		config = function()
			require('setup.mason')
		end
	}

	use { 'nvim-telescope/telescope.nvim',
		tag = '0.1.0',
		requires = { { 'nvim-lua/plenary.nvim' } },
		config = function()
			require('setup.telescope')
		end,
	}

	use { 'Shatur/neovim-session-manager',
		requires = {
			{ 'nvim-lua/plenary.nvim' },
			{ 'kyazdani42/nvim-tree.lua' },
		},
		config = function()
			require('setup.session_manager')
		end
	}

	use { 'kyazdani42/nvim-tree.lua',
		requires = {
			'kyazdani42/nvim-web-devicons', -- optional, for file icons
		},
		tag = 'nightly', -- optional, updated every week. (see issue #1193)
		config = function()
			require('setup.nvim_tree')
		end
	}

	use { 'akinsho/bufferline.nvim',
		tag = "v2.*",
		requires = 'kyazdani42/nvim-web-devicons',
		config = function()
			require('setup.bufferline')
		end
	}

	use { "akinsho/toggleterm.nvim",
		tag = 'v2.*',
		-- lazygit is not installed. Manual Install : https://github.com/jesseduffield/lazygit#ubuntu
		run = "sudo apt install ripgrep fzf",
		config = function()
			 require('setup.toggleterm')
		end
	}

	use {
		'nvim-treesitter/nvim-treesitter',
		run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
		config = function()
			require "setup.treesitter"
		end,
	}

	use {
		'numToStr/Comment.nvim',
		config = function()
			require('Comment').setup()
		end
	}

	use { "folke/which-key.nvim",
		requires = 'akinsho/toggleterm.nvim',
		config = function()
			require('setup.whichkey')
		end
	}

	use { 'goolord/alpha-nvim',
		config = function()
		    require 'alpha'.setup(require('setup.alphas').config)
		end
	}

	use { 'rcarriga/nvim-notify',
		config = function()
			require('setup.notify')
		end
	}

	use { 'lewis6991/gitsigns.nvim',
		config = function()
			require('setup.gitsigns')
		end
	}

	use { 'rmagatti/goto-preview',
		config = function()
			require('goto-preview').setup {}
			require('setup.goto_preview')
		end
	}

	use{ "iamcco/markdown-preview.nvim",
		run = "cd app && npm install",
		setup = function()
			vim.g.mkdp_filetypes = { "markdown" }
			vim.g.mkdp_browser = 'firefox'
		end,
		ft = { "markdown" },
	}

	use { 'phaazon/hop.nvim',
		branch = 'v2', -- optional but strongly recommended
		config = function()
			-- you can configure Hop the way you like here; see :h hop-config
			require('setup.hop')
			require('hop').setup {
				keys = 'etovxqpdygfblzhckisuran',
			}
		end
	}

	use { 'lukas-reineke/indent-blankline.nvim',
		config = function()
			require('setup.indent_blankline')
		end,
	}

	use { 'norcalli/nvim-colorizer.lua',
		config = function()
			require('colorizer').setup()
			require('setup.colorizers')
		end,
	}

	use { 'karb94/neoscroll.nvim',
		config = function()
			require('neoscroll').setup()
			require('setup.neoscrolls')
		end,
	}
	-- use 'sainnhe/gruvbox-material'

	use { 'navarasu/onedark.nvim',
		config = function()
			require('onedark').setup {
				style = 'warmer'
			}
			require('setup.onedarks')
			require('onedark').load()
		end
	}
end)
