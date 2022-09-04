local use = require('packer').use

vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()

	use 'wbthomason/packer.nvim' -- Package manager
	use { 'neovim/nvim-lspconfig',
		config = function()
			require('setup.lspconfig')
		end
	}
	-- use 'williamboman/nvim-lsp-installer'
	--	use 'preservim/nerdtree'
	use { 'feline-nvim/feline.nvim',
		config = function()
			require('setup.feline')
		end
	}
	use 'preservim/tagbar'

	use { 'hrsh7th/nvim-cmp',
		opt = true,
		requires = {
			{ 'hrsh7th/cmp-nvim-lsp' },
			{ 'hrsh7th/cmp-buffer' },
			{ 'hrsh7th/cmp-path' },
			{ 'hrsh7th/cmp-cmdline' },
			{ 'hrsh7th/nvim-cmp' },
			{ 'hrsh7th/cmp-vsnip', opt = true },
			{ 'hrsh7th/vim-vsnip', opt = true },
		},
		config = function()
			require('setup.cmp')
		end
	}
	use 'haorenW1025/completion-nvim'

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
		requires = { { 'nvim-lua/plenary.nvim' } }
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
		run = "sudo apt install ripgrep fzf ranger",
		config = function()
			require("toggleterm").setup()
		end
	}

	if (vim.fn.has('Darwin') == 1) then
	else
		use { 'nvim-treesitter/nvim-treesitter',
			config = function()
				require "setup.treesitter"
			end,
			run = ':TSUpdate',
		}
	end

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
		--
		requires = 'akinsho/toggleterm.nvim',
		config = function()
			require('setup.whichkey')
		end
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
		run = "cd app && npm install",
		setup = function()
			vim.g.mkdp_filetypes = { "markdown" }
			-- require('setup.markdown_preview')
		end,
		ft = { "markdown" },
	}

	-- use 'sainnhe/gruvbox-material'

	use { 'navarasu/onedark.nvim',
		config = function()
			require('onedark').setup {
				style = 'warmer'
			}
			require('onedark').load()
			require('setup.onedark')
		end
	}

end)
