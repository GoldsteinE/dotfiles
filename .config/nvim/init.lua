-- Helpers for other config parts
function _G.executable(command)
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

require('packer').startup(function()
	-- Package manager itself
	use 'wbthomason/packer.nvim'
	-- Lua mappings helper
	use { 'svermeulen/vimpeccable', config = function() require('mappings') end }
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
	use 'LnL7/vim-nix'
	use 'ziglang/zig.vim'
	use { 'zetzit/vim', as = 'zz.vim' }
	use 'elubow/cql-vim'
	-- Read .editorconfig
	use 'editorconfig/editorconfig-vim'
	-- Linters integration
	use { 'neomake/neomake', config = function() require('neomake_conf') end }
	-- Status line
	use { 'itchyny/lightline.vim', config = function() require('lightline_conf') end }
	use 'tyru/current-func-info.vim'
	-- Status line colors
	use 'sainnhe/lightline_foobar.vim'
	-- Typing helpers
	use 'tpope/vim-surround'
	use 'tpope/vim-repeat'
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
		config = function() require('telescope_conf') end,
		after = 'vimpeccable',
	}
	-- Terminal helper
	use {
		'kassio/neoterm',
		config = function()
			vim.g.neoterm_default_mod = 'below'
			vim.g.neoterm_autoinsert = 1
		end
	}
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
	-- Copy link to Git{Hub,Lab}
	use {
		'ruanyl/vim-gh-line',
		config = function()
			if executable('xclip') then
				-- space at the end is important
				vim.g.gh_open_command = 'c() { echo -n "$@" | xclip -i -selection clipboard }; c '
			end
		end
	}
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
	-- Internal NeoVim LSP configuration helper
	use { 'neovim/nvim-lspconfig', config = function() require('lsp_conf') end }
	-- Completion engine
	use {
		'hrsh7th/nvim-cmp',
		config = function() require('cmp_conf') end,
		requires = {
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			'hrsh7th/cmp-calc',
			'hrsh7th/cmp-nvim-lua',
			'kdheepak/cmp-latex-symbols',
		},
	}
	if executable('g++') or executable('clang++') then
		vim.g.treesitter_enabled = true
		-- TreeSitter-based syntax highlighting & text objects
		use {
			'nvim-treesitter/nvim-treesitter',
			run = ':TSUpdate',
			config = function() require('treesitter_conf') end,
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
