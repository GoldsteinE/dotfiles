" Sections (use <Leader>s to quick jump to section)
" 1. Basic options [S_BASIC]
" 2. Plugins [S_PLUGINS]
" 3. Colors [S_COLORS]
" 4. Autocommands [S_AUTO]
" 5. Mappings [S_MAPPINGS]
" 6. Lightline [S_LIGHTLINE]
" 7. NeoMake [S_NEOMAKE]
" 8. LSP & similar things [S_LSP]
" 9. Clap (fuzzy finder) [S_CLAP]
" 10. Miscellanious plugin settings [S_MISC]
" 11. Vimrc editing helpers [S_SELF]

" Fix copying bug on Mac OS
try
	language en_US.UTF-8
catch
	" Locale probably isn't installed
endtry

" Allow backspace everywhere
set backspace=indent,eol,start
" Show 100 columns width limit
set colorcolumn=100
" Show tab completion window
set completeopt=menuone,noinsert,noselect,longest
" Set internal encoding to UTF-8 for Vim
set encoding=utf-8
" Invisible split separators
set fillchars+=vert:\  " It's a literal space
" Explicit folding
set foldmethod=marker
" Disable |-like cursor in NeoVim if not in notepad mode
if has('nvim') && !exists('g:notepad_mode')
	set guicursor=
endif
" Hide abandoned buffers
set hidden
" Enable incremental search
set incsearch
" Preview s/// changes
set inccommand=nosplit
" Ignore case if search string is all lowercase
set ignorecase smartcase
" Show statusline
set laststatus=2
" Read `vim:` modelines
set modeline
" Enable mouse support
set mouse=a
" Do not show `--MODE--` in bottom line
set noshowmode
" Show both numbers AND relative numbers
set number relativenumber
" Better indentation & set tab width to 4
set smarttab tabstop=4 shiftwidth=4
" Set default split directions to intuitive
set splitbelow splitright
" Allow (Neo)Vim to set terminal title
set title
" Enable undo persistence
set undofile
" Tell Vim to save file to separate dir
set undodir=~/.vim/undodir
" Enable autocompletion in command mode
set wildmenu
" Enable system clipboard integration
if has('clipboard') || has('xterm_clipboard')
	set clipboard=unnamedplus
endif
" Enable syntax highlighting
syntax on
" Enable filetype handling & filetype-based indentation
filetype plugin indent on
" Tell (Neo)Vim that <Leader> is space
let mapleader = ' '

" Plugins [S_PLUGINS]:

call plug#begin('~/.vim/plugged')

" Allow local instances to add plugins
if !empty(glob("$HOME/.local.vim"))
	source $HOME/.local.vim
endif

" Dark colorscheme
Plug 'GoldsteinE/vim-atom-dark'
" Light colorscheme (for notepad mode)
Plug 'rakr/vim-one'
" Custom syntaxes
Plug 'vito-c/jq.vim'
Plug 'cespare/vim-toml'
Plug 'gabrielelana/vim-markdown'
Plug 'ekalinin/Dockerfile.vim'
Plug 'rhysd/vim-llvm'
Plug 'idris-hackers/idris-vim'
Plug 'rust-lang/rust.vim'
Plug 'lifepillar/pgsql.vim'
Plug 'lervag/vimtex'
Plug 'ziglang/zig.vim'
" Read .editorconfig
Plug 'editorconfig/editorconfig-vim'
" Linters integration
Plug 'neomake/neomake'
" Status line
Plug 'itchyny/lightline.vim'
Plug 'tyru/current-func-info.vim'
" Status line colors
Plug 'sainnhe/lightline_foobar.vim'
" Typing helpers
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'michaeljsmith/vim-indent-object'
" Filetype icons
Plug 'ryanoasis/vim-devicons'
" Fuzzy finder
Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary!' }
" Sign column
Plug 'airblade/vim-gitgutter'
Plug 'kshenoy/vim-signature'
" Git helper
Plug 'tpope/vim-fugitive'
" Easy HTML typing
Plug 'mattn/emmet-vim'
" Highlight current word
Plug 'RRethy/vim-illuminate'
" Start page (do not use in notepad mode)
if !exists('g:notepad_mode')
	Plug 'mhinz/vim-startify'
endif
" Calculate startup time
Plug 'tweekmonster/startuptime.vim'
if has('nvim-0.5.0')
	" Internal NeoVim LSP configuration helper
	Plug 'neovim/nvim-lspconfig'
	Plug 'neovim/nvim-lsp'
	Plug 'nvim-lua/completion-nvim'
	Plug 'hrsh7th/vim-vsnip'
	Plug 'hrsh7th/vim-vsnip-integ'
	" TreeSitter-based syntax highlight & text objects
	Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
	Plug 'nvim-treesitter/playground'
endif
" Screenshoting code
if executable('silicon')
	Plug 'segeljakt/vim-silicon'
endif
call plug#end()

augroup AutoInstallPlugins
	autocmd!
	autocmd VimEnter *
	  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
	  \|   PlugInstall --sync | q
	  \| endif
augroup END

" Colors [S_COLORS]:

" Enable RGB colors
set termguicolors
if !exists('g:notepad_mode')
	" `atom-dark` sets background=dark...
	colorscheme atom-dark
else
	" but for `one` we need to set it manually
	set background=light
	colorscheme one
endif

" Autocommands [S_AUTO]:

" Enable highlight while in incsearch and disable it afterwards
augroup VimIncsearchHl
	autocmd!
	autocmd CmdlineEnter [/\?] set hlsearch
	autocmd CmdlineLeave [/\?] set nohlsearch
augroup END

" Mappings [S_MAPPINGS]:

" Exit insert mode by `jk`
inoremap jk <Esc>
" Make & work in visual mode
xnoremap & :s<Up><Return>
" Repeat the last macro
nnoremap Q @@
" Make Y work sensibly
nnoremap Y y$
" Repurpose `s` for deletion without clobbering clipboard
nnoremap s "_d
" Diff with the file on disk
nnoremap <Leader>= :w !git diff --no-index -- % -<Return>
" Move to next/previous error
nnoremap <Leader>n :cnext<Return>
nnoremap <Leader>N :cprev<Return>
" Disable search highlighting
nnoremap <silent> <C-l> :nohl<Return>

" Lightline configuration [S_LIGHTLINE]:

function! LightLineCurrentFunc()
	return cfi#format("%s", "")
endfunction

function! LightLineFileType()
	return WebDevIconsGetFileTypeSymbol() . ' ' . &filetype
endfunction

let g:lightline = {
	\ 'colorscheme': 'wombat',
	\ 'active': {
	\ 	'left': [ [ 'mode', 'paste' ],
	\             [ 'readonly', 'filename', 'modified', 'gitbranch', 'current_func' ] ]
	\  },
	\ 'component_function': {
	\	'gitbranch': 'fugitive#head',
	\	'current_func': 'LightLineCurrentFunc',
	\   'filetype': 'LightLineFileType',
	\  }
	\ }

if exists('g:notepad_mode')
	let g:lightline.colorscheme = 'ayu_light'
endif

" Pretty arrows in statusline
let g:lightline.separator = {
	\ 'left': nr2char(57520), 'right': nr2char(57522)
	\ }

let g:lightline.subseparator = {
	\ 'left': nr2char(57521), 'right': nr2char(57523)
	\ }

" NeoMake configuration [S_NEOMAKE]:

" Disable neomake if first or last 5 lines of the file contain `neomake: skip`
function! CheckNeomakeSkip()
	for linenr in range(5)
		if match(getline(linenr), 'neomake: skip') != -1
		\ || match(getline(line('$') - linenr), 'neomake: skip') != -1
			silent NeomakeDisableBuffer
			silent call neomake#virtualtext#hide()
			NeomakeClean
			return
		endif
	endfor
	let [disabled, source] = neomake#config#get_with_source('disabled', 0)
	if disabled && source ==# 'buffer'
		silent NeomakeEnableBuffer
		Neomake
	endif
endfunction

augroup NeomakeSkip
	autocmd!
	autocmd BufEnter,InsertLeave,TextChanged * call CheckNeomakeSkip()
augroup END

" Show virtualtext on each message
augroup NeomakeVirtualText
	autocmd!
	autocmd User NeomakeJobFinished
		\ silent call neomake#virtualtext#hide()
		\ | silent call neomake#virtualtext#show() 
augroup END

let g:neomake_highlight_lines = 1
let g:neomake_highlight_columns = 0

" NeoMake linters config
let g:neomake_shellcheck_args = ['-fgcc']
let g:neomake_python_enabled_makers = ['python']
if executable('flake8')
	let g:neomake_python_enabled_makers += ['flake8']
endif
if executable('mypy')
	let g:neomake_python_enabled_makers += ['mypy']
endif
if executable('pylint')
	let g:neomake_python_enabled_makers += ['pylint']
endif
let g:neomake_rust_cargo_command = ['+nightly', 'clippy', '-Zunstable-options']

" Sign column symbols
let g:neomake_error_sign = {
	\ 'text': nr2char(10007),
	\ 'texthl': 'NeomakeErrorSign'
	\ }

let g:neomake_warning_sign = {
	\ 'text': nr2char(9998),
	\ 'texthl': 'NeomakeWarningSign'
	\ }

let g:neomake_info_sign = {
	\ 'text': nr2char(10148),
	\ 'texthl': 'NeomakeInfoSign'
	\ }

let g:neomake_message_sign = {
	\ 'text': nr2char(10148),
	\ 'texthl': 'NeomakeMessageSign'
	\ }

" Run all makers with 200ms timeout in all modes
call neomake#configure#automake('nrwi', 200)

" LSP & similar things [S_LSP]:

" Autocompletion
if has('nvim-0.5.0')
	" Using shiny new nvim-lspconfig
	lua require'configure_lsp'

	" Enable autocompletion
	augroup LSPOmniFunc
		autocmd!
		autocmd FileType c setlocal omnifunc=v:lua.vim.lsp.omnifunc
		autocmd FileType cpp setlocal omnifunc=v:lua.vim.lsp.omnifunc
		autocmd FileType python setlocal omnifunc=v:lua.vim.lsp.omnifunc
		autocmd FileType rust setlocal omnifunc=v:lua.vim.lsp.omnifunc
		autocmd FileType go setlocal omnifunc=v:lua.vim.lsp.omnifunc
	augroup END
	" We use NeoMake for diagnostics, so disable them in nvim-lspconfig
	imap <silent> <Tab> <Plug>(completion_smart_tab)
	imap <silent> <S-Tab> <Plug>(completion_smart_s_tab)
	imap <C-l> <Plug>(vsnip-jump-next)
	imap <C-h> <Plug>(vsnip-jump-prev)
	" We use NeoMake for diagnostics, so disable them in nvim-lsp
	lua vim.lsp.callbacks['textDocument/publishDiagnostics'] = nil
	nnoremap <silent> <leader>r <cmd>lua vim.lsp.buf.rename()<CR>
	nnoremap <silent> <leader>d <cmd>lua vim.lsp.buf.definition()<CR>
	nnoremap <silent> <leader>D <cmd>lua vim.lsp.buf.implementation()<CR>
	nnoremap <silent> <leader>k <cmd>lua vim.lsp.buf.hover()<CR>
	nnoremap <silent> <leader>gr <cmd>lua vim.lsp.buf.references()<CR>
	nnoremap <silent> <leader>gs <cmd>lua vim.lsp.buf.document_symbol()<CR>
endif

" Clap (fuzzy finder) [S_CLAP]

if has('nvim-0.4.2') || has('patch-8.1.2114')
	" Mappings
	nnoremap <silent> <Leader>f :Clap files<Return>
	" Not `g` because of ergonomics; `l` means `lines (in all files)`
	nnoremap <silent> <leader>l :Clap grep<Return>
	nnoremap <silent> <leader>L :Clap grep ++query=<cword><Return>
	nnoremap <silent> <leader>p :Clap yanks<Return>
	" Lines in current buffer
	nnoremap <silent> <leader>; :Clap blines<Return>
	nnoremap <silent> <leader>: :Clap blines ++query=<cword><Return>
	" Buffers (useful after long go-to-definition chains)
	nnoremap <silent> <leader>b :Clap buffers<Return>
	let g:clap_theme = 'atom_dark'
	let g:clap_layout = { 'relative': 'editor' }
	let g:clap_selected_sign = {
		\ 'text': nr2char(10148),
		\ 'texthl': 'ClapSelectedSign',
		\ 'linehl': 'ClapSelected'
		\ }
	let g:clap_current_selection_sign = {
		\ 'text': nr2char(10095),
		\ 'texthl': 'ClapCurrentSelectionSign',
		\ 'linehl': 'ClapCurrentSelection'
		\ }
endif

" Miscellanious plugin settings [S_MISC]:

" Enable TreeSitter
if has('nvim-0.5.0')
lua <<END
require 'nvim-treesitter.configs'.setup {
	ensure_installed = { "rust", "c", "cpp", "python", "toml", "query" },
	highlight = {
		enable = true,
		custom_captures = {
			["include"] = "Keyword",
			["attribute_item.meta_item.identifier"] = "PreProc"
		}
	},
	indent = {
		enable = true
	},
	playground = {
		enable = true
	}
}
END
endif


" Illuminate
let g:Illuminate_delay = 50
let g:Illuminate_ftHighlightGroups = {
	\ 'python:blacklist': ['pythonInclude', 'pythonStatement', 'pythonAsync']
	\ }
let g:Illuminate_ftblacklist = ['debchangelog', 'vim']

" Emmet
let g:user_emmet_expandabbr_key = '<C-y>y'

" Signature
" Use colors from gitgutter for marks
let g:SignatureMarkTextHLDynamic = 1
let g:SignatureMarkerTextHLDynamic = 1

" Markdown
let g:markdown_enable_spell_checking = 0
let g:markdown_enable_conceal = 0

" Silicon
let g:silicon = {
	\ 'theme': 'OneHalfDark',
	\ 'window-controls': v:false,
	\ 'output': '/tmp/silicon-{time:%Y-%m-%d%H%M%S}.png',
	\ 'pad-horiz': 0,
	\ 'pad-vert': 0,
	\ 'round-corner': v:false,
	\ }

" Startify
function! StartifyEntryFormat()
	return 'WebDevIconsGetFileTypeSymbol(absolute_path) . "  " . entry_path'
endfunction

" Vimtex
let g:tex_flavor = 'latex'

" Fast :PlugUpdate
command! UP PlugClean | PlugUpdate | qall

" Vimrc editing helpers [S_SELF]:

function! VimrcGoToSection()
	if match(getline('.'), '\[[S]_') !=# -1
		normal 0
		call search('\[[S]_')
		silent normal l*z.
	endif
endfunction

function! VimrcFiletypeSettings()
	" Go to section on <leader>S
	nnoremap <buffer> <silent> <Leader>s :call VimrcGoToSection()<CR>
	" Source current file on <leader>V
	nnoremap <buffer> <Leader>v :w<CR> :source %<CR> :e!<CR>
	" Highlight section headers
	syntax match VimrcSectionHeader /^"\s*\d*\.*\s*\zs.*\ze\[S_.\{-1,}\]:\=$/ contained containedin=vimLineComment
	highlight! link VimrcSectionHeader Macro
	highlight VimrcSectionHeader gui=bold
endfunction

augroup VimrcEditing
	autocmd!
	autocmd FileType vim call VimrcFiletypeSettings()
augroup END
