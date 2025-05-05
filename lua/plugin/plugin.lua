local function setup()
    if os.getenv('NVIM_NOPLUGIN')then
        return
    end

    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

    if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({
            "git", "clone", "--filter=blob:none",
            "https://github.com/folke/lazy.nvim.git", "--branch=stable",
            lazypath
        })
    end

    vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

    require("lazy").setup({
        spec = {
            {
                'neovim/nvim-lspconfig',
                config = function()
                    require('plugin.lsp').Setup()
                end
            }, {
                'williamboman/mason.nvim',
                dependencies = {
                    "williamboman/mason-lspconfig.nvim", "neovim/nvim-lspconfig"
                },
                config = function()
                    require("mason").setup()
                    require("mason-lspconfig").setup {
                        ensure_installed = vim.g.custom.lsp
                    }
                end
            }, {
                'hrsh7th/nvim-cmp',
                dependencies = {
                    'neovim/nvim-lspconfig', 'hrsh7th/cmp-buffer',
                    'hrsh7th/cmp-nvim-lsp', 'saadparwaiz1/cmp_luasnip',
                    'L3MON4D3/LuaSnip'
                },
                config = function()
                    require('plugin.cmp').Setup()
                end
            }, {
                'rmagatti/goto-preview',
                config = function()
                    require('plugin.goto_preview').Setup()
                end
            }, {
                'nvimtools/none-ls.nvim',
                config = function()
                    require('plugin.none_ls').Setup()
                end
            }, {
                'nvim-treesitter/nvim-treesitter',
                build = function()
                    require('nvim-treesitter.install').update({ with_sync = true })
                    require("plugin.treesitter")
                    vim.cmd([[TSUpdateSync]])
                end,
                config = function()
                    require("plugin.treesitter").Setup()
                end
            }, {
                "folke/neodev.nvim",
                opts = {},
                config = function()
                    require('neodev').setup()
                end
            }, {
                'tpope/vim-dispatch',
                config = function()
                    require('plugin.dispatch').Setup()
                end
            }, {
                "mfussenegger/nvim-dap",
                config = function()
                    require('plugin.dap').Setup()
                end
            }, {
                "rcarriga/nvim-dap-ui",
                dependencies = {
                    "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"
                },
                config = function()
                    require('dapui').setup()
                    require('plugin.dap_ui').Setup()
                end
            }, {
                "mfussenegger/nvim-dap-python",
                dependencies = { "mfussenegger/nvim-dap" },
                build = function()
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
                end
            }, {
                'tpope/vim-fugitive',
                config = function()
                    require('plugin.fugitive').Setup()
                end
            }, {
                'lewis6991/gitsigns.nvim',
                config = function()
                    require('plugin.gitsigns').Setup()
                end
            }, {
                'nvim-telescope/telescope.nvim',
                tag = '0.1.4',
                dependencies = { 'nvim-lua/plenary.nvim' },
                config = function()
                    require('plugin.telescope').Setup()
                end
            }, {
                "nvim-telescope/telescope-live-grep-args.nvim",
                dependencies = { 'nvim-telescope/telescope.nvim' },
                config = function()
                    require('plugin.telescope').SetupLiveGrepArgs()
                end
            }, {
                'dhruvmanila/telescope-bookmarks.nvim',
                dependencies = {
                    'nvim-telescope/telescope.nvim', 'kkharji/sqlite.lua'
                },
                build = "pip3 install buku",
                config = function()
                    require('plugin.telescope').SetupBookmarks()
                end
            }, {
                'github/copilot.vim',
                build = function()
                    print('Exit neovim and re-enter to run :Copilot! to register API key')
                end
            }, {
                "akinsho/toggleterm.nvim",
                config = function()
                    require('plugin.toggleterm').Setup()
                end
            }, {
                'stevearc/oil.nvim',
                dependencies = { "nvim-tree/nvim-web-devicons" },
                opts = {},
                config = function()
                    require('plugin.oil').Setup()
                end
            }, {
                'preservim/tagbar',
                config = function()
                    local keymap = vim.api.nvim_set_keymap

                    keymap('n', '<leader>tt', [[<cmd> TagbarToggle fc <CR>]], {
                        silent = true,
                        desc = 'tag lists'
                    })
                    vim.g.tagbar_sort = 0 -- sort by order of appearance
                end
            }, {
                'goolord/alpha-nvim',
                config = function()
                    require('plugin.alphas').Setup()
                end
            }, {
                "folke/which-key.nvim",
                priority = 1000,
                config = function()
                    require('plugin.whichkey').Setup()
                end
            }, {
                "kylechui/nvim-surround",
                version = "*",
                event = "VeryLazy",
                config = function()
                    require('plugin.surround').Setup()
                end
            }, {
                "iamcco/markdown-preview.nvim",
                ft = { "markdown" },
                build = "cd app && npm install",
                config = function()
                    require('plugin.markdown-preview').Setup()
                end
            }, {
                "CopilotC-Nvim/CopilotChat.nvim",
                dependencies = {
                    { "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
                    { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
                },
                build = "make tiktoken", -- Only on MacOS or Linux
                opts = {},
                config = function()
                    require('plugin.copilotchat').Setup()
                end
            }, {
                'chrisbra/csv.vim',
                config = function()
                    require('plugin.csv').Setup()
                end
            }, {
                "jbyuki/venn.nvim",
                config = function()
                    require('plugin.venn').Setup()
                end
            }, {
                'itchyny/calendar.vim',
                config = function()
                    local credentials = os.getenv('HOME') .. "/.cache/calendar.vim/credentials.vim"

                    if vim.fn.filereadable(credentials) > 0 then
                        vim.g.calendar_google_calendar = 1
                        vim.g.calendar_google_task = 1
                        vim.g.calendar_frame = "unicode_round"
                        vim.cmd("source " .. credentials)
                    end
                end
            }, {
                'MeanderingProgrammer/markdown.nvim',
                name = 'render-markdown', -- Only needed if you have another plugin named markdown.nvim
                dependencies = { 'nvim-treesitter/nvim-treesitter' },
                config = function()
                    require('render-markdown').setup({})
                end
            }, {
                'isakbm/gitgraph.nvim',
                dependencies = { "sindrets/diffview.nvim" },
                opts = {
                    symbols = {
                        merge_commit = '●',
                        commit = '○',
                        merge_commit_end = '✗',
                        commit_end = '┳'
                    },
                    format = {
                        timestamp = '%H:%M:%S %d-%m-%Y',
                        fields = {
                            'hash', 'timestamp', 'author', 'branch_name', 'tag'
                        }
                    },
                    hooks = {
                        -- Check diff of a commit
                        on_select_commit = function(commit)
                            vim.notify('DiffviewOpen ' .. commit.hash .. '^!')
                            vim.cmd(':DiffviewOpen ' .. commit.hash .. '^!')
                        end,
                        -- Check diff from commit a -> commit b
                        on_select_range_commit = function(from, to)
                            vim.notify('DiffviewOpen ' .. from.hash .. '~1..' .. to.hash)
                            vim.cmd(':DiffviewOpen ' .. from.hash .. '~1..' .. to.hash)
                        end
                    }
                },
                keys = {
                    {
                        "<leader>ggl",
                        function()
                            require('gitgraph').draw({}, {
                                all = true,
                                max_count = 5000
                            })
                        end,
                        desc = "GitGraph - Draw"
                    }
                }
            }, { "sindrets/diffview.nvim" }
        },
        defaults = {
            -- By default, Your custom plugins will load during startup.
            -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
            lazy = false,
            -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
            -- have outdated releases, which may break your Neovim install.
            version = false -- always use the latest git commit
            -- version = "*", -- try installing the latest stable version for plugins that support semver
        },
        checker = {
            -- automatically check for plugin updates
            enabled = false,
            concurrency = nil, ---@type number? set to 1 to check for updates very slowly
            notify = true, -- get a notification when new updates are found
            frequency = 604800 -- check for updates. Ex. every hour (3600)
        },
        change_detection = {
            -- automatically check for config file changes and reload the ui
            enabled = true,
            notify = true -- get a notification when changes are found
        },
        performance = {
            cache = { enabled = true },
            reset_packpath = true, -- reset the package path to improve startup time
            rtp = {
                -- disable some rtp plugins
                disabled_plugins = {
                    "gzip", -- "matchit",
                    -- "matchparen",
                    -- "netrwPlugin",
                    "tarPlugin", "tohtml", "tutor", "zipPlugin"
                }
            }
        },
        install = { missing = true, colorscheme = { "habamax" } }
    })

    if vim.g.neovide ~= nil and pcall(require, 'plugin.neovide') then
        require('plugin.neovide').Setup()
    end
end

return { Setup = setup }
