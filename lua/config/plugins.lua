local use = require('packer').use

vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()

	use 'wbthomason/packer.nvim' -- Package manager
	use 'neovim/nvim-lspconfig' -- Configurations for Nvim LSP
	-- use 'williamboman/nvim-lsp-installer'
	--	use 'preservim/nerdtree'
	use 'feline-nvim/feline.nvim'
	use 'preservim/tagbar'

	use 'hrsh7th/cmp-nvim-lsp'
	use 'hrsh7th/cmp-buffer'
	use 'hrsh7th/cmp-path'
	use 'hrsh7th/cmp-cmdline'
	use 'hrsh7th/nvim-cmp'
	use 'hrsh7th/cmp-vsnip'
	use 'hrsh7th/vim-vsnip'
	use 'haorenW1025/completion-nvim'

	use { "williamboman/mason.nvim",
		requires = { { 'williamboman/mason-lspconfig.nvim' },
			{ 'neovim/nvim-lspconfig' }
		}
	}

	use { 'nvim-telescope/telescope.nvim',
		tag = '0.1.0',
		requires = { { 'nvim-lua/plenary.nvim' } }
	}

	use { 'Shatur/neovim-session-manager',
		requires = {
			{ 'nvim-lua/plenary.nvim' },
			{ 'kyazdani42/nvim-tree.lua' }
		}
	}

	use { 'kyazdani42/nvim-tree.lua',
		requires = {
			'kyazdani42/nvim-web-devicons', -- optional, for file icons
		},
		tag = 'nightly' -- optional, updated every week. (see issue #1193)
	}

	use { 'akinsho/bufferline.nvim',
		tag = "v2.*",
		requires = 'kyazdani42/nvim-web-devicons'
	}

	use { "akinsho/toggleterm.nvim",
		tag = 'v2.*',
		config = function()
			require("toggleterm").setup()
		end
	}

	use { 'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate',
		config = function() require "setup.treesitter" end,
	}

	use {
		'numToStr/Comment.nvim',
		config = function()
			require('Comment').setup()
		end
	}

	use { "folke/which-key.nvim",
		-- config = function()
		-- 	require("which-key").setup {
		-- 		-- your configuration comes here
		-- 		-- or leave it empty to use the default settings
		-- 		-- refer to the configuration section below
		-- 	}
		-- end,
	}

	use { 'goolord/alpha-nvim',
		config = function()
			require 'alpha'.setup(require 'alpha.themes.dashboard'.config)
		end
	}

	use { 'rmagatti/goto-preview',
		config = function()
			require('goto-preview').setup {}
			require('setup.goto_preview')
		end
	}

	use { 'iamcco/markdown-preview.nvim',
		run = 'cd app && yarn install',
		cmd = 'MarkdownPreview'
	}

	-- use 'sainnhe/gruvbox-material'

	use { 'navarasu/onedark.nvim',
		config = function()
			require('onedark').setup {
				style = 'warmer'
			}
			require('onedark').load()
		end
	}

end)
