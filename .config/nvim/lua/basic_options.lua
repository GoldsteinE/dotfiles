-- vim.o/vim.wo/vim.bo helper
local function setopt(mode, opt, value)
	vim[mode][opt] = value
	if mode ~= 'o' then
		vim.o[opt] = value
	end
end

-- Fix copying bug on Mac OS
-- Fails if locale isn't installed, so pcall
pcall(function()
	vim.cmd [[ language en_US.UTF-8 ]]
end)

-- Allow backspace everywhere
setopt('o', 'backspace', 'indent,eol,start')
-- Show 100 columns width limit
setopt('wo', 'colorcolumn', '100')
-- Show tab completion window
setopt('o', 'completeopt', 'menuone,noinsert,noselect')
-- Invisible split separators
setopt('wo', 'fillchars', 'vert: ')
-- Explicit folding
setopt('wo', 'foldmethod', 'marker')
-- Enable RGB colors
setopt('o', 'termguicolors', true)
-- Disable |-like cursor if not in notepad mode
if not vim.g.notepad_mode then
	setopt('o', 'guicursor', '')
end
-- Hide abandoned buffers
setopt('o', 'hidden', true)
-- Preview s/// changes
setopt('o', 'inccommand', 'nosplit')
-- Ignore case if search string is all-lowercase
setopt('o', 'ignorecase', true)
setopt('o', 'smartcase', true)
-- Read `vim:` modelines
setopt('bo', 'modeline', true)
-- Enable mouse support
setopt('o', 'mouse', 'a')
-- Do not show `--MODE--` in the bottom line
setopt('o', 'showmode', false)
-- Show both line numbers AND relative numbers
setopt('wo', 'number', true)
setopt('wo', 'relativenumber', true)
-- Set tab width to 4
setopt('bo', 'tabstop', 4)
setopt('bo', 'shiftwidth', 4)
-- More intuitive split directions
setopt('o', 'splitbelow', true)
setopt('o', 'splitright', true)
-- Allow NeoVim to set terminal title
setopt('o', 'title', true)
-- Enable undo persistence
setopt('bo', 'undofile', true)
-- Enable system clipboard integration
if vim.fn.has('clipboard') ~= 0 then
	setopt('o', 'clipboard', 'unnamedplus')
end
-- Enable syntax highlighting
vim.cmd [[ syntax on ]]
-- Enable filetype handling & filetype-based indentation
vim.cmd [[ filetype plugin indent on ]]
-- Tell NeoVim that <Leader> is space
vim.g.mapleader = ' '

-- Enable search highlight while in incsearch and disable it afterwards
vim.cmd [[ augroup VimIncsearchHl ]]
vim.cmd [[ autocmd! ]]
vim.cmd [[ autocmd CmdlineEnter [/\?] set hlsearch ]]
vim.cmd [[ autocmd CmdlineLeave [/\?] set nohlsearch ]]
vim.cmd [[ augroup END ]]
