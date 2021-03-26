-- Helpers for other config parts
function executable(command)
	return vim.fn.executable(command) ~= 0
end

-- Basic options
require 'basic_options'

-- Installing packer.nvim
local execute = vim.api.nvim_command
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
execute(
	'!git clone https://github.com/wbthomason/packer.nvim '..install_path
)
end

local function file(name)
	require(name)
end

require('packer').startup(function()
	-- Package manager itself
	use 'wbthomason/packer.nvim'
	-- Lua mappings helper
	use { 'svermeulen/vimpeccable', config = file('mappings') }
	-- Lua plugins writing helper
	use 'bfredl/nvim-luadev'
	-- Dark colorscheme
	use {
		'GoldsteinE/vim-atom-dark',
		config = function()
			vim.cmd [[ colorscheme atom-dark ]]
		end
	}
	-- Custom syntaxes
	use 'vito-c/jq.vim'
	use 'cespare/vim-toml'
	use 'ekalinin/Dockerfile.vim'
	use 'rhysd/vim-llvm'
	use 'idris-hackers/idris-vim'
	use 'elixir-editors/vim-elixir'
	use 'rust-lang/rust.vim'
	use 'lifepillar/pgsql.vim'
	use {
		'lervag/vimtex',
		config = function()
			vim.g.tex_flavor = 'latex'
		end
	}
	use 'ziglang/zig.vim'
	use { 'zetzit/vim', as = 'zz.vim' }
	-- Read .editorconfig
	use 'editorconfig/editorconfig-vim'
	-- Linters integration
	use { 'neomake/neomake', config = file('neomake_conf') }
	-- Status line
	use { 'itchyny/lightline.vim', config = file('lightline_conf') }
	use 'tyru/current-func-info.vim'
	-- Status line colors
	use 'sainnhe/lightline_foobar.vim'
	-- Typing helpers
	use 'tpope/vim-surround'
	use 'tpope/vim-repeat'
	use 'b3nj5m1n/kommentary'
	-- Filetype icons
	use 'ryanoasis/vim-devicons'
	-- Fuzzy finder
	use {
		'nvim-telescope/telescope.nvim',
		requires = {
			{'nvim-lua/popup.nvim'},
			{'nvim-lua/plenary.nvim'},
			{'kyazdani42/nvim-web-devicons'}
		},
		config = file('telescope_conf'),
		after = 'vimpeccable',
	}
	-- Terminal helper
	use 'kassio/neoterm'
	-- Sign column
	use 'airblade/vim-gitgutter'
	use {
		'kshenoy/vim-signature',
		config = function()
			vim.g.SignatureMarkTextHLDynamic = 1
			vim.g.SignatureMarkerTextHLDynamic = 1
		end,
	}
	-- Git helper
	use 'tpope/vim-fugitive'
	-- Easy HTML typing
	use {
		'mattn/emmet-vim',
		config = function()
			vim.g.user_emmet_expandabbr_key = '<C-y>y'
		end,
	}
	-- Highlight current word
	use {
		'RRethy/vim-illuminate',
		config = function()
			vim.g.Illuminate_delay = 50
			vim.g.Illuminate_ftHighlightGroups = {
				['python:blacklist'] = {
					'pythonInclude', 'pythonStatement', 'pythonAsync'
				}
			}
		end,
	}
	-- Start page
	use {
		'mhinz/vim-startify',
		config = function()
			vim.cmd [[
			function! StartifyEntryFormat()
				return 'WebDevIconsGetFileTypeSymbol(absolute_path) . "  " . entry_path'
			endfunction
			]]
		end
	}
	-- Calculate startup time
	use 'tweekmonster/startuptime.vim'
	-- Internal NeoVim LSP configuration helper
	use { 'neovim/nvim-lspconfig', file('lsp_conf') }
	-- Completion engine
	use { 'hrsh7th/nvim-compe', config = file('compe_conf') }
	if executable('g++') or executable('clang++') then
		vim.g.treesitter_enabled = true
		-- TreeSitter-based syntax highlighting & text objects
		use {
			'nvim-treesitter/nvim-treesitter',
			run = ':TSUpdate',
			config = file('treesitter_conf'),
		}
		use 'nvim-treesitter/playground'
	end
	-- Screenshoting code
	if executable('silicon') then
		use {
			'segeljakt/vim-silicon',
			config = function()
				vim.g.silicon = {
					theme = 'OneHalfDark',
					output = '/tmp/silicon-{time:%Y-%m-%d%H%M%S}.png',
					['pad-vert'] = 0,
					['pad-horiz'] = 0,
					['round-corner'] = false,
					['window-controls'] = false
				}
			end,
		}
	end
end)

-- init.lua editing helpers (former S_SELF):
vim.cmd [[ augroup S_SELF ]]
vim.cmd [[ autocmd! BufReadPre,FileReadPre init.lua set path+=~/.config/nvim/lua ]]
vim.cmd [[ augroup END ]]
