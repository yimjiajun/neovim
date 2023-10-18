local function native_package_install()
	local packages = {}
	local d = vim.fn.has('win32') ~= 0 and "\\" or "/"
	local path = vim.fn.stdpath('data') .. d .. 'site' .. d .. 'pack' .. d .. 'jun' .. d .. 'start'

	if vim.fn.isdirectory(path) == 0 then
		vim.api.nvim_echo({ { "package: create package directory ... " .. path } }, false, {})
		vim.fn.mkdir(path, "p")
	end

	for i, v in ipairs(packages) do
		local pack_dir = path .. d .. v.name
		if vim.fn.isdirectory(pack_dir) == 0 then
			vim.api.nvim_echo({ { "package: download " .. v.name } }, false, {})
			vim.fn.system("git clone " .. v.url .. " " .. pack_dir)
		end
	end
end

local function setup()
	if vim.g.enable_plugin == 0 then
		native_package_install()
		return
	end

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
					require('plugin.lsp')
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
					require('plugin.cmp')
				end
			},
			{ 'rmagatti/goto-preview',
				config = function()
					require('plugin.goto_preview')
				end,
			},
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
					require("plugin.treesitter")
				end,
			},
			{ 'p00f/clangd_extensions.nvim' },
			{ "folke/neodev.nvim",
				opts = {},
				config = function()
					require('neodev').setup()
				end
			},
			{ "iamcco/markdown-preview.nvim",
				build = "cd app && npm install",
				config = function()
					require('plugin.markdown-preview')
				end,
				ft = { "markdown" },
			},
			{ 'tpope/vim-fugitive',
				config = function ()
					require('plugin.fugitive')
				end
			},
			{	'nvim-telescope/telescope.nvim',
				tag = '0.1.1',
				dependencies = { 'nvim-lua/plenary.nvim' },
				config = function()
					require('plugin.telescope').setup()
					require('plugin.telescope').setup_keymapping()
				end
			},
			{ "nvim-telescope/telescope-live-grep-args.nvim",
				dependencies = { 'nvim-telescope/telescope.nvim' },
				config = function()
					require('plugin.telescope').setup_live_grep_args()
				end
			},
			{ 'dhruvmanila/telescope-bookmarks.nvim',
				dependencies = {
					'nvim-telescope/telescope.nvim',
					'kkharji/sqlite.lua',
				},
				build = "pip3 install buku",
				config = function ()
					require('plugin.telescope').setup_bookmarks()
				end
			},
			{ 'crispgm/telescope-heading.nvim',
				dependencies = { 'nvim-telescope/telescope.nvim' },
				config = function ()
					require('plugin.telescope').setup_heading()
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
					require('plugin.dispatch')
				end
			},
			{ "folke/zen-mode.nvim",
				config = function()
					require("plugin.zen_mode")
				end
			},
			{ 'github/copilot.vim',
				build = function()
					print('Exit neovim and re-enter to run :Copilot! to register API key')
				end,
			},
			{ "akinsho/toggleterm.nvim",
				config = function()
					require('plugin.toggleterm')
				end
			},
			{ 'lewis6991/gitsigns.nvim',
				config = function()
					require('plugin.gitsigns')
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
			{ "tpope/vim-surround",
				config = function()
					require('plugin.surround')
				end
			},
			{ "plasticboy/vim-markdown",
				dependencies = {
					"godlygeek/tabular",
					'dhruvasagar/vim-table-mode' },
				ft = { "markdown" },
				init = function ()
					require('plugin.vim-markdown').init()
				end,
				config = function()
					require('plugin.vim-markdown')
				end,
			},
			{ "folke/noice.nvim",
				event = "VeryLazy",
				dependencies = { "MunifTanjim/nui.nvim" },
				config = function()
					require("plugin.noice").Setup()
				end,
			},
			{ "ellisonleao/glow.nvim",
				config = function ()
					local current_window = vim.api.nvim_get_current_win()
					local window_width = vim.api.nvim_win_get_width(current_window)
					local padding_ratio = 0.8

					require('glow').setup({
						border = "shadow", -- floating window border config
						style = "dark",
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
					require('plugin.oil')
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
					require('plugin.chatgpt')
				end,
			},
			{ 'chrisbra/csv.vim',
				config = function ()
					function _G.load_csv_filetype()
							if vim.fn.exists('did_load_csvfiletype') then
								return
							end

							local did_load_csvfiletype = 1

							if did_load_csvfiletype == 1 then
								vim.bo.filetype = 'csv'
							end
					end

					vim.api.nvim_create_autocmd("BufRead", {
						desc = "csv format display",
						group = "format",
						pattern = "{*.csv,*.dat}",
						callback = function()
							_G.load_csv_filetype()
						end,
					})

					vim.api.nvim_create_autocmd("BufNewFile", {
						desc = "csv format display",
						group = "format",
						pattern = "{*.csv,*.dat}",
						callback = function()
							_G.load_csv_filetype()
						end,
					})
				end,
			},
			{ "mfussenegger/nvim-dap",
				config = function()
					require('plugin.dap').SetupKeymap()
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
					require('plugin.dap').SetupKeymap('python')
					require('plugin.dap').SetupPython()
				end,
			},
			{ "rcarriga/nvim-dap-ui",
				dependencies = { "mfussenegger/nvim-dap" },
				config = function()
					require('dapui').setup()
					require('plugin.dap').SetupUI()
				end,
			},
			{ "olimorris/onedarkpro.nvim",
				priority = 1000,
				config = function()
					require('plugin.color_scheme').OneDarkPro()
				end,
			},
			{ "luisiacc/gruvbox-baby",
				priority = 1000,
				config = function()
					require('plugin.color_scheme').GruvboxBaby()
				end,
			},
			{ "ellisonleao/gruvbox.nvim",
				priority = 1000,
				config = function()
					require('plugin.color_scheme').Gruvbox()
				end,
			},
			{ "sainnhe/gruvbox-material",
				priority = 1000,
				config = function()
					require('plugin.color_scheme').GruvboxMaterial()
				end,
			},
			{ 'sam4llis/nvim-tundra',
				priority = 1000,
				config = function()
					require('plugin.color_scheme').Tundra()
				end,
			},
			{ "jbyuki/venn.nvim",
				config = function()
					require('plugin.venn').Setup()
				end,
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
	})
end

return {
	Setup = setup,
}
