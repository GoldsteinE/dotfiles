-- Helpers for other config parts
function executable(command)
	return vim.fn.executable(command) ~= 0
end

-- Basic options
require 'basic_options'
-- Plugins
require 'plugins'
-- Set colorscheme
require 'colorscheme'
-- Lightline configuration
require 'lightline_conf'
-- LSP & similar things
require 'lsp_conf'
-- Completion
require 'compe_conf'
-- Neomake configuration
require 'neomake_conf'
-- telescope.nvim configuration
require 'telescope_conf'
-- TreeSitter configuration
if vim.g.treesitter_enabled then
	require 'treesitter_conf'
end

-- Mappings:
local vimp = require('vimp')
-- Exit insert mode with `jk`
vimp.inoremap('jk', '<Esc>')
-- Make & work in visual mode
vimp.xnoremap('&', ':s<Up><Return>')
-- Repeat the last macro
vimp.nnoremap('Q', '@@')
-- Make Y work sensibly
vimp.nnoremap('Y', 'yy')
-- Repurpose `s` for deletion without clobbering clipboard
vimp.nnoremap('s', '"_d')
-- Diff with the file on disk
vimp.nnoremap('<Leader>=', ':w !git diff --no-index -- % -<Return>')
-- Disable search highlighting
vimp.nnoremap({'silent'}, '<C-l>', ':nohl<Return>')

-- Miscellaneous plugins settings:
-- Illuminate
vim.g.Illuminate_delay = 50
vim.g.Illuminate_ftHighlightGroups = {
	['python:blacklist'] = {
		'pythonInclude', 'pythonStatement', 'pythonAsync'
	}
}

-- nvim-luadev
function register_luadev_mappings()
	vimp.add_buffer_maps(function()
		vimp.nmap({'silent'}, '<Leader>ll', ':Luadev<CR>')
		vimp.nmap('<Leader>lr', '<Plug>(Luadev-RunLine)')
		vimp.xmap('<Leader>lr', '<Plug>(Luadev-Run)')
		vimp.xmap('<Leader>lw', '<Plug>(Luadev-RunWord)')
	end)
end

-- neoterm
vimp.inoremap({'silent'}, '<C-s>', '<C-o>:TREPLSendLine<CR>')
vimp.nmap('<C-s>', '<Plug>(neoterm-repl-send-line)')
vimp.nmap('<Leader>s', '<Plug>(neoterm-repl-send)')
vimp.xmap('<Leader>s', '<Plug>(neoterm-repl-send)')
vimp.xmap('<C-s>', '<Plug>(neoterm-repl-send)')

vim.cmd [[ augroup LuaDevMaps ]]
vim.cmd [[ autocmd! ]]
vim.cmd [[ autocmd FileType lua lua register_luadev_mappings() ]]
vim.cmd [[ augroup END ]]

-- Emmet
vim.g.user_emmet_expandabbr_key = '<C-y>y'

-- Signature
-- Use colors from gitgutter for marks
vim.g.SignatureMarkTextHLDynamic = 1
vim.g.SignatureMarkerTextHLDynamic = 1

-- Markdown
vim.g.markdown_enable_spell_checking = 0
vim.g.markdown_enable_conceal = 0

-- Silicon
vim.g.silicon = {
	theme = 'OneHalfDark',
	output = '/tmp/silicon-{time:%Y-%m-%d%H%M%S}.png',
	['pad-vert'] = 0,
	['pad-horiz'] = 0,
	['round-corner'] = false,
	['window-controls'] = false
}

-- Vimtex
vim.g.tex_flavor = 'latex'

-- Icons on the start screen
vim.cmd [[
function! StartifyEntryFormat()
	return 'WebDevIconsGetFileTypeSymbol(absolute_path) . "  " . entry_path'
endfunction
]]

-- init.lua editing helpers (former S_SELF):
vim.cmd [[ augroup S_SELF ]]
vim.cmd [[ autocmd! BufReadPre,FileReadPre init.lua set path+=~/.config/nvim/lua ]]
vim.cmd [[ augroup END ]]
