local keymap = vim.keymap.set
local opts = function(desc)
    return { noremap = true, silent = true, desc = desc }
end
local opts_output = function(desc)
    return { noremap = true, silent = false, desc = desc }
end

local function setting_key_move()
    keymap('i', '<C-b>', '<Left>', opts('insert backward'))
    keymap('i', '<C-f>', '<Right>', opts('insert forward'))
    keymap('n', '<C-u>', '<C-u>zz', opts('move up of half screen'))
    keymap('n', '<C-d>', '<C-d>zz', opts('move down of half screen'))
    keymap('n', 'j', 'jzz', opts('move down a line with center screen'))
    keymap('n', 'k', 'kzz', opts('move up a line with center screen'))
    keymap('n', 'n', 'nzz', opts('search next match word with center screen'))
    keymap('n', 'N', 'Nzz', opts('search previous match word with center screen'))
    keymap('n', '<C-]>', '<C-]>zz', opts('jump tag with center screen'))
    keymap('n', '<C-o>', '<C-o>zz', opts('jump previous tag with center screen'))
    keymap('n', '<C-i>', '<C-i>zz', opts('jump previous tag file with center screen'))
    keymap('n', 'gd', 'gdzz', opts('jump definations with center screen'))
    keymap('n', 'g;', 'g;zz', opts('jump last change with center screen'))
    keymap('n', 'g,', 'g,zz', opts('jump next last change with center screen'))
    keymap('n', '#', '#zz', opts('jump backward match word with center screen'))
    keymap('n', '*', '*zz', opts('jump forward match word with center screen'))
    keymap('n', 'u', 'uzz', opts('undo with center screen'))
    keymap('n', '<c-r>', '<c-r>zz', opts('redo with center screen'))
end

local function setting_key_buffer()
    keymap('i', '<C-s>', '<C-o>:w<CR>', opts('save'))
    keymap('n', '<leader><BS>', [[<cmd>%bd|e#|bd#|'<CR>|<CR>|`"]], opts('delete all other buffers'))
    keymap('n', '<C-c>', ':bd<CR>',
        opts('delete buffer'))
    keymap('n', '<esc><BS>', ':cclose<CR>', opts('close quickfix window'))
    keymap('n', 'cxz', '<cmd>bp<CR>', { noremap = true })
    keymap('n', 'zxc', '<cmd>bn<CR>', { noremap = true })
    keymap('n', '<leader>c', ':lua require("config.function").ToggleQuickFix() <CR>',
        opts('open quickfix'))
    keymap('n', '<M-j>', '<cmd> cn <CR>z.',
        opts('jump to next quickfix content'))
    keymap('n', '<M-k>', '<cmd> cp <CR>z.',
        opts('jump to previous quickfix content'))
    keymap('n', '<leader>w', [[<cmd> lua require("config.function").GetBuffers("list") <CR> | :b ]],
        opts('read buffer list'))
    keymap('n', '<leader>q', [[<cmd> lua require("config.function").GetMarks("default") <CR>]],
        opts('read marks list'))
    keymap('n', '<leader>h', [[<cmd> lua require("config.function").GetJumplist("default") <CR>]],
        opts('read jump list'))
    keymap('n', '<leader>r', [[<cmd> lua require("config.function").GetRegisterList("default") <CR>]],
        opts('read register list'))
    keymap('n', '<leader>te', [[<cmd> lua require("config.function").SetFileFormat() <CR>]],
        opts('trigger file format setup'))
end

local function setting_key_view()
    keymap('n', '<BS>', ':set hlsearch!<CR>',
        opts('toggle search match word highlight'))
end

local function setting_key_edit()
    keymap('i', 'zxc', '<ESC>', opts('escape insert mode'))
    keymap('i', 'cxz', '<ESC><cmd>bp<CR>', opts('switch to previous buffer'))
    keymap('t', 'zxc', '<C-\\><C-n>', opts('escape insert mode from terminal'))
    keymap('t', 'cxz', '<C-\\><C-n><cmd>bp<CR><cmd>only<CR>', opts('switch to previous buffer'))
    keymap('i', '()', '()<ESC>i', opts('insert ()'))
    keymap('i', '{}', '{}<ESC>i', opts('insert {}'))
    keymap('i', '""', '""<ESC>i', opts('insert ""'))
    keymap('i', "''", "''<ESC>i", opts([[insert '']]))
    keymap('i', '{<CR>', '{<CR>}<C-o>O', opts('insert paragraph {}'))
    keymap('i', '(<CR>', '(<CR>)<C-o>O', opts('insert paragraph ()'))
    keymap('i', '[<CR>', '[<CR>]<C-o>O', opts('insert paragraph []'))
    keymap('i', '"<CR>', '"<CR>"<C-o>O', opts('insert paragraph ""'))
    keymap('i', "'<CR>", "'<CR>'<C-o>O", opts([[insert paragraph '']]))
end

local function setting_key_yank()
    keymap('n', 'x', '"_x', opts('delete character without save into register'))
    keymap('n', 'X', '"_X', opts('delete backward character without save into register'))
    keymap('v', 'x', '"_x', opts('delete characters without save into register'))
    keymap('v', 'X', '"_X', opts('delete backward characters without save into register'))
    keymap('v', 'p', '"_dp', opts(''))
end

local function setting_key_leader()
    if vim.fn.has('nvim-0.5') == 1 then
        vim.g.mapleader = ' '
        vim.g.maplocalleader = ' '
    else
        vim.api.nvim_set_var('mapleader', ' ')
        vim.api.nvim_set_var('maplocalleader', ' ')
    end
end

local function setting_key_newtr()
    vim.keymap.set('n', '<Leader>E', function()
        if vim.fn.exists(':Explore') > 0 then
            vim.cmd('Explore')
        else
            keymap('n', '<Leader>E', ':e %:h/', opts_output('start from file directory'))
            vim.api.nvim_feedkeys(' E', 'm', false)
        end
    end, opts(''))

    vim.keymap.set('n', '<Leader>e', function()
        if vim.fn.exists(':Lexplore') > 0 then
            vim.cmd('Lexplore')
        else
            keymap('n', '<Leader>e', ':e ./', opts_output('start from current working directory'))
            vim.api.nvim_feedkeys(' e', 'm', false)
        end
    end, opts(''))
end

local function setting_key_search()
    keymap('n', '<Leader>fs', [[<cmd> lua require("features.string").SetupSearchOptions() <CR>]],
        opts('search options setup'))
    keymap('n', '<Leader>ff', [[:find ./**/*]],
        opts_output('find file'))
    keymap('n', '<Leader>fF', [[<cmd> lua require("features.files").Search() <CR>]],
        opts('find files without ignore'))
    keymap('n', '<Leader>fA', [[<cmd> lua require("features.string").Search(nil) <CR>]],
        opts('file all string'))
    keymap('n', '<Leader>fa', [[<cmd> lua require("features.string").Search(nil, {case_sensitive = true}) <CR>]],
        opts('find all string with case sensitive'))
    keymap('n', '<Leader>fw',
           [[<cmd> lua require("features.string").Search('', {extension = string.format("*.%s",vim.fn.expand("%:e"))}) <CR>]],
           opts('find cursor word with current file extension'))
    keymap('n', '<Leader>fW', [[<cmd> lua require("features.string").Search('') <CR>]],
        opts('find cursor word with all files'))
    keymap('n', '<Leader>fc', [[<cmd> lua require("features.string").Search(nil, {extension = "*.c"}) <CR>]],
        opts('find cursor word with .c'))
    keymap('n', '<Leader>fC',
           [[<cmd> lua require("features.string").Search(nil, {extension = "{*.c,*.h,*.cpp}"}) <CR>]],
        opts('find cursor word with .c/.h/.cpp'))
    keymap('n', '<Leader>fh', [[<cmd> lua require("features.string").Search(nil, {extension = "*.h"}) <CR>]],
        opts('find word in .h'))
    keymap('n', '<Leader>fD', [[<cmd> lua require("features.string").Search(nil, {extension = "{*.dts,*.dtsi}"}) <CR>]],
           opts('find word in .dts/.dtsi'))
    keymap('n', '<Leader>fK', [[<cmd> lua require("features.string").Search(nil, {extension = "Kconfig"}) <CR>]],
        opts('find word in Kconfig'))
    keymap('n', '<Leader>fk', [[<cmd> lua require("features.string").Search(nil, {extension = "*.conf"}) <CR>]],
        opts('find word in .conf'))
    keymap('n', '<Leader>fm', [[<cmd> lua require("features.string").Search(nil, {extension = "CMakeLists.txt"}) <CR>]],
           opts('find word in CMakeLists'))
    keymap('n', '<Leader>fM',
           [[<cmd> lua require("features.string").Search(nil, {extension = "{*.md,*.rst,*.txt}"}) <CR>]],
        opts('find word in .md/.rst/.txt'))
    keymap('n', '<Leader>fv', [[<cmd> lua require("features.string").Search(nil, {extension=''}) <CR>]],
        opts('find word in noplugin mode by input extension'))
    keymap('n', '<Leader>fV',
           [[<cmd> lua require("features.string").Search(nil, {extension='',case_sensitive = true}) <CR>]],
        opts('find word in noplugin by input extension with case sensitive'))
    keymap('n', '<Leader>fb', [[<cmd> lua require("features.string").SearchByBuffer() <CR>]],
        opts('find word in current buffer'))
    keymap('n', '<Leader>fd', (vim.fn.executable('rg') == 0) and
            [[<cmd> lua require("features.string").Search(nil, { extension = string.format("%s/../**/*", vim.fn.expand('%:h')), vimgrep = true }) <CR>]] or
            [[<cmd> lua require("features.string").Search(nil, {extension = string.format("%s/../", vim.fn.expand('%:h')), extension_is_regexp_path = true }) <CR>]],
        opts('find word start from previous directory'))
    if vim.version().major < 1 or vim.version().minor < 10 then
        keymap('n', 'gcc', [[<cmd> lua require("features.string").ToggleComment() <CR>]], 
            opts('comment a line'))
        keymap('v', 'gcc', [[<ESC> | gv | <cmd> lua require("features.string").ToggleComment() <CR> | <ESC>]],
            opts('comment selected lines'))
    end
end

local function setting_key_git()
    keymap('n', '<Leader>ggl', [[<cmd> lua require("features.git").Log().Graph() <CR>]],
        opts('git log'))
    keymap('n', '<Leader>ggL', [[<cmd> lua require("features.git").Log().Default() <CR>]],
        opts('git log with contents'))
    keymap('n', '<Leader>ggH', [[<cmd> lua require("features.git").Log().Diff() <CR>]],
        opts(''))
    keymap('n', '<Leader>ggC', [[<cmd> lua require("features.git").Log().CommitCount() <CR>]],
        opts('git commit count'))
    keymap('n', '<Leader>ggd', [[<cmd> lua require("features.git").Diff().Default()<CR>]],
        opts('git diff on current file'))
    keymap('n', '<Leader>ggD', [[<cmd> lua require("features.git").Diff().Latest() <CR>]],
        opts('git diff with commit'))
    keymap('n', '<Leader>ggh', [[<cmd> lua require("features.git").Diff().Staged() <CR>]],
        opts('git diff with staged files'))
    keymap('n', '<Leader>ggs', [[<cmd> lua require("features.git").Status().Default() <CR>]],
        opts('git status'))
    keymap('n', '<Leader>ggS', [[<cmd> lua require("features.git").Status().Short() <CR>]],
        opts('git status with short information'))
    keymap('n', '<Leader>ggw', [[<cmd> lua require("features.git").Status().ChkWhitespace() <CR>]],
        opts('git check whitespace'))
    keymap('n', '<Leader>ggp', [[<cmd> lua require("features.git").Add().Patch() <CR>]],
        opts('git add'))
    keymap('n', '<Leader>gga', [[<cmd> lua require("features.git").Add().Default() <CR>]],
        opts('git add with interactive'))
    keymap('n', '<Leader>ggA', [[<cmd> lua require("features.git").Add().All() <CR>]],
        opts('git add all'))
    keymap('n', '<Leader>ggc', [[<cmd> lua require("features.git").Commit().Default() <CR>]],
        opts('git commit'))
end

local function setting_key_terminal()
    keymap('n', '<leader>ts', [[<cmd> lua require("config.function").Terminal("split") <CR>]],
        opts('open terminal with split window'))
    keymap('n', '<leader>tv', [[<cmd> lua require("config.function").Terminal("vertical") <CR>]],
        opts('open terminal with vertical window'))
    keymap('n', '<leader>tf', [[<cmd> lua require("config.function").Terminal("default") <CR>]],
        opts('open terminal'))
end

local function setting_key_session()
    if pcall(require, 'features.session') == false then
        return
    end

    keymap('n', '<leader>os', [[<cmd> lua require("features.session").Get() <CR>]],
        opts('open session from opened editor path'))
    keymap('n', '<leader>oS', [[<cmd> lua require("features.session").Select() <CR>]],
        opts('open session selection'))
end

local function setting_key_features()
    keymap('n', '<leader>tc', [[<cmd> lua require("config.function").CreateCtags() <CR>]],
        opts('create ctags'))
    keymap('n', '<leader>tt', [[<cmd> lua require("config.function").ListFunctions() <CR>]],
        opts('lists current buffer functions'))
    keymap('n', '<leader>b', [[<cmd> lua require("config.function").Build() <CR>]],
        opts('build'))
    keymap('n', '<leader>B', [[<cmd> lua require("config.function").Build("latest") <CR>]],
        opts('build all'))
    keymap('n', '<leader>vb', [[<cmd> lua require("features.bookmarks").Review() <CR>]],
        opts('review bookmarks'))
    keymap('n', '<leader>sb', [[<cmd> lua require("features.bookmarks").Save() <CR>]],
        opts('save bookmark'))
    keymap('n', '<leader>sB', [[<cmd> lua require("features.bookmarks").Rename() <CR>]],
        opts('rename bookmark'))
    keymap('n', '<leader>Sb', [[<cmd> lua require("features.bookmarks").Remove() <CR>]],
        opts('remove bookmark'))
    keymap('n', '<leader>SB', [[<cmd> lua require("features.bookmarks").Clear() <CR>]],
        opts('clear bookmark'))
    keymap('n', '<leader>ob', [[<cmd> lua require("features.bookmarks").Get() <CR>]],
        opts('open current working directory bookmarks'))
    keymap('n', '<leader>oB', [[<cmd> lua require("features.bookmarks").GetAll() <CR>]],
        opts('open all bookmarks'))
    keymap('n', '<M-n>', [[<cmd> lua require("features.bookmarks").Next() <CR>zz]],
        opts('jump forward to bookmark'))
    keymap('n', '<M-p>', [[<cmd> lua require("features.bookmarks").Prev() <CR>zz]],
        opts('jump backwrd to bookmark'))

    keymap('n', '<leader>ot', [[<cmd> lua require("features.todo").Get() <CR>]], 
        opts('open todo list'))
    keymap('n', '<leader>st', [[<cmd> lua require("features.todo").Add() <CR>]],
        opts('create new todo list'))

    keymap('n', '<leader>sm', [[<cmd> lua require('features.marks').Buffer('save') <CR>]],
        opts('create mark'))
    keymap('n', '<leader>Sm', [[<cmd> lua require('features.marks').Buffer('remove') <CR>]],
        opts('remove mark'))
    keymap('n', '<leader>Su', [[<cmd> lua require('features.marks').Buffer('clear') <CR>]],
        opts('clear marks'))
    keymap('n', '<leader>om', [[<cmd> lua require('features.marks').Buffer() <CR>]],
        opts('open marks'))
    keymap('n', '<leader>ou', [[<cmd> lua require('features.marks').Buffer('sort') <CR>]],
        opts('sort marks'))
    keymap('n', '<leader>sM', [[<cmd> lua require('features.marks').All('save') <CR>]],
        opts('save marks'))
    keymap('n', '<leader>SM', [[<cmd> lua require('features.marks').All('remove') <CR>]],
        opts('remove all marks'))
    keymap('n', '<leader>SU', [[<cmd> lua require('features.marks').All('clear') <CR>]],
        opts('clear all marks'))
    keymap('n', '<leader>oM', [[<cmd> lua require('features.marks').All() <CR>]],
        opts('open marks list'))
    keymap('n', '<leader>oU', [[<cmd> lua require('features.marks').All('universal') <CR>]],
        opts('open all marks list'))
end

local function setting_abbreviations()
    vim.cmd([[cnoremap <expr> / wildmenumode() ? "\<C-Y>" : "/"]])
    vim.cmd([[cnoremap <expr> * getcmdline() =~ './\*$' ? '*/*' : '*']])
    vim.cmd([[cnoreabbr <expr> %% fnameescape(expand('%:p'))]])
end

local function setting_key_working_directory()
    if pcall(require, 'features.session') == false then
        return
    end

    keymap('n', '<leader>tww', [[<cmd> lua require('features.session').SaveWD() <CR>]],
           { silent = true, desc = 'save current working directory' })
    keymap('n', '<leader>tws', [[<cmd> lua require('features.session').ChgSaveWD() <CR>]], {
        silent = true,
        desc = 'change to path as working directory and save previos working directory'
    })
    keymap('n', '<leader>twS', [[<cmd> lua require('features.session').SelWD() <CR>]],
           { silent = true, desc = 'selection of saved working directory' })
    keymap('n', '<leader>twC', [[<cmd> lua require('features.session').ClrWD() <CR>]],
           { silent = true, desc = 'clear all the saved working directory' })
end

local function setting_key_system()
    if pcall(require, 'features.system') == false then
        return
    end

    keymap('n', '<leader>vci', [[<cmd> lua require('features.system').GetCalendar() <CR>]],
           { silent = true, desc = 'show calendar' })
    keymap('n', '<leader>vsb', [[<cmd> lua require('features.system').GetBatInfo() <CR>]],
           { silent = true, desc = 'show battery info' })
end

local function setup()
    setting_key_leader()
    setting_key_move()
    setting_key_buffer()
    setting_key_view()
    setting_key_edit()
    setting_key_yank()
    setting_key_newtr()
    setting_key_search()
    setting_key_git()
    setting_key_terminal()
    setting_key_session()
    setting_key_features()
    setting_abbreviations()
    setting_key_working_directory()
    setting_key_system()
end

return { Setup = setup }
