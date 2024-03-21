local function setup()
	local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

	if not vim.loop.fs_stat(lazypath) then
		vim.fn.system({ "git", "clone",
			"--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
	end

	vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

	require("lazy").setup({
		spec = {
			{ 'neovim/nvim-lspconfig',
				config = function ()
					require('plugin.lsp').Setup()
				end
			},
			{ 'williamboman/mason.nvim',
				dependencies = {
					"williamboman/mason-lspconfig.nvim",
					"neovim/nvim-lspconfig",
				},
				config = function ()
					local install_lsp = {}
					for _, lang in ipairs(vim.g.custom.lsp) do
						if lang == 'clangd' and vim.loop.os_uname().machine == 'aarch64' then
							goto continue
						end
						table.insert(install_lsp, lang)
						::continue::
					end

					require("mason").setup()
					require("mason-lspconfig").setup {
						ensure_installed = install_lsp,
					}
				end
			},
			{ 'hrsh7th/nvim-cmp',
				dependencies = {
					'neovim/nvim-lspconfig',
					'hrsh7th/cmp-buffer',
					'hrsh7th/cmp-nvim-lsp',
					'saadparwaiz1/cmp_luasnip',
					'L3MON4D3/LuaSnip'
				},
				config = function ()
					require('plugin.cmp').Setup()
				end
			},
			{ 'rmagatti/goto-preview',
				config = function()
					require('plugin.goto_preview').Setup()
				end,
			},
			{ 'p00f/clangd_extensions.nvim' },
			{ 'nvimtools/none-ls.nvim',
				config = function()
					require('plugin.none_ls').Setup()
				end,
			},
			{ 'nvim-treesitter/nvim-treesitter',
				build = function()
					require('nvim-treesitter.install').update({ with_sync = true })
					require("plugin.treesitter")
					vim.cmd([[TSUpdateSync]])
				end,
				config = function()
					require("plugin.treesitter").Setup()
				end,
			},
			{ "folke/neodev.nvim",
				opts = {},
				config = function()
					require('neodev').setup()
				end
			},
			{ 'tpope/vim-dispatch',
				config = function()
					require('plugin.dispatch').Setup()
				end
			},
			{ "mfussenegger/nvim-dap",
				config = function()
					require('plugin.dap').Setup()
				end,
			},
			{ "rcarriga/nvim-dap-ui",
				dependencies = { "mfussenegger/nvim-dap" },
				config = function()
					require('dapui').setup()
					require('plugin.dap_ui').Setup()
				end,
			},
			{ "mfussenegger/nvim-dap-python",
				dependencies = { "mfussenegger/nvim-dap" },
				build = function ()
					os.execute([[
						mkdir ~/.local/share/.virtualenvs 1>/dev/null 2>&1
						cd ~/.local/share/.virtualenvs
						python -m venv debugpy
						debugpy/bin/python -m pip install debugpy
					]])
				end,
				ft = { "python" },
				config = function()
					require('dap-python').setup('~/.local/share/.virtualenvs/debugpy/bin/python')
					require('plugin.dap').Keymap().Python()
					require('plugin.dap_python').Setup()
				end,
			},
			{ 'tpope/vim-fugitive',
				config = function ()
					require('plugin.fugitive').Setup()
				end
			},
			{ 'lewis6991/gitsigns.nvim',
				config = function()
					require('plugin.gitsigns').Setup()
				end
			},
			{	'nvim-telescope/telescope.nvim',
				tag = '0.1.4',
				dependencies = { 'nvim-lua/plenary.nvim' },
				config = function()
					require('plugin.telescope').Setup()
				end
			},
			{ "nvim-telescope/telescope-live-grep-args.nvim",
				dependencies = { 'nvim-telescope/telescope.nvim' },
				config = function()
					require('plugin.telescope').SetupLiveGrepArgs()
				end
			},
			{ 'dhruvmanila/telescope-bookmarks.nvim',
				dependencies = {
					'nvim-telescope/telescope.nvim',
					'kkharji/sqlite.lua',
				},
				build = "pip3 install buku",
				config = function ()
					require('plugin.telescope').SetupBookmarks()
				end
			},
			{ 'github/copilot.vim',
				build = function()
					print('Exit neovim and re-enter to run :Copilot! to register API key')
				end,
			},
			{ "akinsho/toggleterm.nvim",
				config = function()
					require('plugin.toggleterm').Setup()
				end
			},
			{ 'stevearc/oil.nvim',
				dependencies = { "nvim-tree/nvim-web-devicons" },
				opts = {},
				config = function ()
					require('plugin.oil').Setup()
				end
			},
			{ 'preservim/tagbar',
				config = function ()
					local keymap = vim.api.nvim_set_keymap

					keymap('n', '<leader>tt', [[<cmd> TagbarToggle fc <CR>]], { silent = true, desc = 'tag lists'})
				end
			},
			{ 'goolord/alpha-nvim',
				config = function()
					require('alpha').setup(require('plugin.alphas').config)
				end
			},
			{ "folke/which-key.nvim",
				priority = 1000,
				config = function()
					require('plugin.whichkey').Setup()
				end
			},
			{ "kylechui/nvim-surround",
				version = "*",
				event = "VeryLazy",
				config = function()
					require('plugin.surround').Setup()
				end
			},
			{ "plasticboy/vim-markdown",
				dependencies = {
					"godlygeek/tabular",
					'dhruvasagar/vim-table-mode' },
				ft = { "markdown" },
				init = function ()
					require('plugin.vim-markdown').Init()
				end,
				config = function()
					require('plugin.vim-markdown').Setup()
				end,
			},
			{ "iamcco/markdown-preview.nvim",
				ft = { "markdown" },
				build = "cd app && npm install",
				config = function()
					require('plugin.markdown-preview').Setup()
				end,
			},
			{ "jackMort/ChatGPT.nvim",
				dependencies = {
					"nvim-telescope/telescope.nvim",
					"MunifTanjim/nui.nvim",
					"nvim-lua/plenary.nvim",
				},
				event = "VeryLazy",
				config = function()
					require('plugin.chatgpt').Setup()
				end,
			},
			{ 'chrisbra/csv.vim',
				config = function ()
					require('plugin.csv').Setup()
				end,
			},
			{ "jbyuki/venn.nvim",
				config = function()
					require('plugin.venn').Setup()
				end,
			},
			{ 'kepano/flexoki-neovim',
				name = 'flexoki',
				config = function ()
					vim.cmd("colorscheme flexoki-dark")
					vim.cmd("highlight Pmenu blend=0")
				end
			}
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
		install = {
			missing = true,
			colorscheme = { "default" },
		},
	})

	if vim.g.neovide ~= nil and pcall(require, 'plugin.neovide') then
		require('plugin.neovide').Setup()
	end
end

return {
	Setup = setup,
}
