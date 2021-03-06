-- Installing packer.nvim
local execute = vim.api.nvim_command
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
execute(
	'!git clone https://github.com/wbthomason/packer.nvim '..install_path
)
end

vim.cmd [[ packadd packer.nvim ]]

require('packer').startup(function()
	-- Package manager itself
	use {'wbthomason/packer.nvim', opt = true}
	-- Lua mappings helper
	use 'svermeulen/vimpeccable'
	-- Lua plugins writing helper
	use 'bfredl/nvim-luadev'
	-- Dark colorscheme
	use 'GoldsteinE/vim-atom-dark'
	-- Light colorscheme (for notepad mode)
	use 'rakr/vim-one'
	-- Custom syntaxes
	use 'vito-c/jq.vim'
	use 'cespare/vim-toml'
	use 'gabrielelana/vim-markdown'
	use 'ekalinin/Dockerfile.vim'
	use 'rhysd/vim-llvm'
	use 'idris-hackers/idris-vim'
	use 'elixir-editors/vim-elixir'
	use 'rust-lang/rust.vim'
	use 'lifepillar/pgsql.vim'
	use 'lervag/vimtex'
	use 'ziglang/zig.vim'
	use {'zetzit/vim', as = 'zz.vim'}
	-- Read .editorconfig
	use 'editorconfig/editorconfig-vim'
	-- Linters integration
	use 'neomake/neomake'
	-- Status line
	use 'itchyny/lightline.vim'
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
		}
	}
	-- Terminal helper
	use 'kassio/neoterm'
	-- Sign column
	use 'airblade/vim-gitgutter'
	use 'kshenoy/vim-signature'
	-- Git helper
	use 'tpope/vim-fugitive'
	-- Easy HTML typing
	use 'mattn/emmet-vim'
	-- Highlight current word
	use 'RRethy/vim-illuminate'
	-- Start page (do not use in notepad mode)
	if not vim.g.notepad_mode then
		use 'mhinz/vim-startify'
	end
	-- Calculate startup time
	use 'tweekmonster/startuptime.vim'
	-- Internal NeoVim LSP configuration helper
	use 'neovim/nvim-lspconfig'
	-- Completion engine
	use 'hrsh7th/nvim-compe'
	if executable('g++') or executable('clang++') then
		vim.g.treesitter_enabled = true
		-- TreeSitter-based syntax highlighting & text objects
		use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
		use 'nvim-treesitter/playground'
	end
	-- Screenshoting code
	if executable('silicon') then
		use 'segeljakt/vim-silicon'
	end
end)
