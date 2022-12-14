local use = require('packer').use

vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()

	use 'wbthomason/packer.nvim' -- Package manager

	use {
		'nvim-lualine/lualine.nvim',
		requires = { 'kyazdani42/nvim-web-devicons', opt = true },
		config = function()
			if vim.g.custom.statusline_support == 1 then
				require('setup.lualines')
			end
		end,
	}

	use { 'preservim/tagbar' }

	if vim.g.custom.lsp_support == 1 then
		use 'neovim/nvim-lspconfig' -- lsp config in nvim-cmp

		use { "hrsh7th/nvim-cmp",
			after = { "nvim-lspconfig" },
			requires = {
				{ "onsails/lspkind-nvim", module = "lspkind" },
				{ "hrsh7th/cmp-buffer", module = "cmp_buffer" },
				{ "hrsh7th/cmp-path", module = "cmp_path" },
				{ "hrsh7th/cmp-nvim-lsp", module = "cmp_nvim_lsp" },
				{ "hrsh7th/cmp-nvim-lua", module = "cmp_nvim_lua" },
				{ "hrsh7th/cmp-calc", module = "cmp_calc" },
				{ "hrsh7th/cmp-emoji", module = "cmp_emoji" },
				-- { "tzachar/cmp-tabnine",
				-- 	run = "./install.sh",
				-- 	module = "cmp_tabnine",
				-- },

			},
			event = "VimEnter",
			config = function()
				require ("setup.cmp")
			end,
		}

		use { 'hrsh7th/cmp-vsnip',
			after = { 'nvim-cmp' },
			requires = {
				{ 'hrsh7th/vim-vsnip' },
				{ 'hrsh7th/vim-vsnip-integ' },
			},
			config = function()
				require ('setup.snippets')
			end,
			event = "InsertEnter",
		}

		use 'haorenW1025/completion-nvim'

		-- LSP installer
		use { "williamboman/mason.nvim",
			requires = {
				{ 'williamboman/mason-lspconfig.nvim' },
				{ 'neovim/nvim-lspconfig' },
			},
		}

		use { 'williamboman/mason-lspconfig.nvim',
			after = { "mason.nvim", "nvim-lspconfig" },
			config = function()
				require('setup.mason')
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
	else

	end

	-- Neovim UI Enhancer
	use { 'stevearc/dressing.nvim',
		config = function()
			require('setup.dressing')
		end
	}

	use { 'nvim-telescope/telescope.nvim',
		tag = '0.1.0',
		requires = { { 'nvim-lua/plenary.nvim' } },
		config = function()
			require('setup.telescope')
		end,
	}

	-- session
	use { 'Shatur/neovim-session-manager',
		requires = {
			{ 'nvim-lua/plenary.nvim' },
			{ 'kyazdani42/nvim-tree.lua' },
		},
		config = function()
			require('setup.session_manager')
		end
	}

	-- sidebar
	use { 'kyazdani42/nvim-tree.lua',
		requires = {
			'kyazdani42/nvim-web-devicons', -- optional, for file icons
		},
		tag = 'nightly', -- optional, updated every week. (see issue #1193)
		config = function()
			require('setup.nvim_tree')
		end
	}

	-- tab / buffer display
	use { 'akinsho/bufferline.nvim',
		tag = "v2.*",
		requires = 'kyazdani42/nvim-web-devicons',
		config = function()
			require('setup.bufferline')
		end
	}

	-- terminal
	use { "akinsho/toggleterm.nvim",
		tag = 'v2.*',
		-- lazygit is not installed. Manual Install : https://github.com/jesseduffield/lazygit#ubuntu
		run = "sudo apt install ripgrep fzf",
		config = function()
			 require('setup.toggleterm')
		end
	}

	-- git easy diff view
	use { 'sindrets/diffview.nvim',
		requires = 'nvim-lua/plenary.nvim'
	}

	-- programming language highlight
	use { 'nvim-treesitter/nvim-treesitter',
		run = function()
			require('nvim-treesitter.install').update({ with_sync = true })
			vim.cmd([[TSUpdateSync]])
		end,
		config = function()
			require "setup.treesitter"
		end,
	}

	-- comment toggle
	use { 'numToStr/Comment.nvim',
		config = function()
			require('Comment').setup()
		end
	}

	-- key mapping tips
	use { "folke/which-key.nvim",
		requires = 'akinsho/toggleterm.nvim',
		config = function()
			require('setup.whichkey')
		end
	}

	-- dashboard
	use { 'goolord/alpha-nvim',
		config = function()
		    require 'alpha'.setup(require('setup.alphas').config)
		end
	}

	-- pop up notify
	use { 'rcarriga/nvim-notify',
		config = function()
			require('setup.notify')
		end
	}

	-- git live display
	use { 'lewis6991/gitsigns.nvim',
		config = function()
			require('setup.gitsigns')
		end
	}

	-- git command line
	use { 'tpope/vim-fugitive' }

	-- lsp pop up preview
	use { 'rmagatti/goto-preview',
		config = function()
			require('goto-preview').setup {}
			require('setup.goto_preview')
		end
	}

	-- markdown preview
	use{ "iamcco/markdown-preview.nvim",
		run = "cd app && npm install",
		setup = function()
			vim.g.mkdp_filetypes = { "markdown" }
			vim.g.mkdp_browser = 'firefox'
		end,
		ft = { "markdown" },
	}

	-- easy motion
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

	-- indent dispaly
	use { 'lukas-reineke/indent-blankline.nvim',
		config = function()
			require('setup.indent_blankline')
		end,
	}

	-- Color display
	use { 'norcalli/nvim-colorizer.lua',
		config = function()
			require('colorizer').setup()
			require('setup.colorizers')
		end,
	}

	-- Smooth sroll
	use { 'karb94/neoscroll.nvim',
		config = function()
			require('neoscroll').setup()
			require('setup.neoscrolls')
		end,
	}

	-- Themes
	use { 'sam4llis/nvim-tundra',
		config = function()
			require('setup.tundra')
		end,
	}
	use { "ellisonleao/gruvbox.nvim",
		config = function ()
			require('setup.gruvbox')
		end
	}

	use { 'kyazdani42/nvim-web-devicons' }
	-- use { 'ryanoasis/vim-devicons' }
	-- sidebar
 	use { 'preservim/nerdtree',
		requires = 'ryanoasis/vim-devicons'
	}

	-- integrate vim editor on browser
	-- this should also install firenvim from browser store/extension
	use { 'glacambre/firenvim',
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
	}

end)
