" Sections (use <Leader>s to quick jump to section)
" 1. Basic options [S_BASIC]
" 2. Plugins [S_PLUGINS]
" 3. Colors [S_COLORS]
" 4. Autocommands [S_AUTO]
" 5. Mappings [S_MAPPINGS]
" 6. Lightline [S_LIGHTLINE]
" 7. NeoMake [S_NEOMAKE]
" 8. LSP & similar things [S_LSP]
" 9. Firenvim (using NeoVim in browser) [S_FIRENVIM]
" 10. Clap (fuzzy finder) [S_CLAP]
" 11. Miscellanious plugin settings [S_MISC]
" 12. Vimrc editing helpers [S_SELF]

" Basic options [S_BASIC]:

" Fix copying bug on Mac OS
language en_US.UTF-8

" Allow backspace everywhere
set backspace=indent,eol,start
set colorcolumn=100
set completeopt=menuone,noinsert,noselect,longest
set encoding=utf-8
" Invisible split separators
set fillchars+=vert:\  " It's a literal space
set foldmethod=marker
" Disable |-like cursor in NeoVim if not in notepad mode
if has('nvim') && !exists('g:notepad_mode')
	set guicursor=
endif
" Hide abandoned buffers
set hidden
set incsearch
set ignorecase smartcase
if !exists('g:started_by_firenvim')
	" Always show statusline in normal Vim...
	set laststatus=2
else
	" ...and never show it in browser
	set laststatus=0
endif
" Read `vim:` modelines
set modeline
set mouse=a
" Do not show `--MODE--` in bottom line
set noshowmode
set number
set relativenumber
set smarttab tabstop=4 shiftwidth=4
set splitbelow
set splitright
set title
set undodir=~/.vim/undodir
set undofile
" Autocompletion in command mode
set wildmenu
if has('clipboard') || has('xterm_clipboard')
	set clipboard=unnamedplus
endif
syntax on
filetype plugin indent on
let mapleader = ' '

" Plugins [S_PLUGINS]:

call plug#begin('~/.vim/plugged')

if !empty(glob("$HOME/.local.vim"))
	source $HOME/.local.vim
endif

" Dark colorscheme
Plug 'GoldsteinE/vim-atom-dark'
" Light colorscheme (for firenvim)
Plug 'rakr/vim-one'
" Send code to terminal
" Vimteractive is not (yet) NeoVim-compatible
if !has('nvim')
	Plug 'williamjameshandley/vimteractive'
endif
" Custom syntaxes
Plug 'vito-c/jq.vim'
Plug 'neilhwatson/vim_cf3'
Plug 'cespare/vim-toml'
Plug 'gabrielelana/vim-markdown'
Plug 'ekalinin/Dockerfile.vim'
Plug 'rhysd/vim-llvm'
Plug 'idris-hackers/idris-vim'
Plug 'rust-lang/rust.vim'
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
" Fuzzy finder
if has('nvim-0.4.2') || has('patch-8.1.2114')
	Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary!' }
	Plug 'ryanoasis/vim-devicons'
endif
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
" Autocompletion
if has('timers')
	Plug 'prabirshrestha/asyncomplete.vim'
	Plug 'yami-beta/asyncomplete-omni.vim'
	Plug 'prabirshrestha/asyncomplete-file.vim'
endif
if has('nvim-0.5.0')
	" Internal NeoVim LSP configuration helper
	Plug 'neovim/nvim-lsp'
else
	" LSP-like features for Python
	Plug 'davidhalter/jedi-vim'
	" LSP for everything else & autocompletion for Python
	Plug 'autozimu/LanguageClient-neovim', {
	    \ 'branch': 'next',
	    \ 'do': 'bash install.sh',
	    \ }
endif
" Browser support
if has('nvim')
	Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
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
if !exists('g:started_by_firenvim') && !exists('g:notepad_mode')
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

" Disable folding in cf-engine
augroup CfeFold
	autocmd!
	autocmd FileType cf3 set nofoldenable
augroup END

augroup IndentationSettings
	autocmd!
	autocmd FileType python set expandtab
augroup END

" Mappings [S_MAPPINGS]:

" Exit insert mode by `jk`
inoremap jk <Esc>
" Go to defintion by Ctrl+Click
nmap <C-LeftMouse> <LeftMouse><Leader>d
" Make & work in visual mode
xnoremap & :s<Up><Return>
" Diff with file on disk
nnoremap <Leader>= :w !git diff --no-index -- % -<Return>

nnoremap <Leader>n :cnext<Return>
nnoremap <Leader>N :cprev<Return>

" Lightline configuration [S_LIGHTLINE]:

function! LightLineCurrentFunc()
	" current-func-info.vim hangs up when editing C code
	if &ft !=# 'c'
		return cfi#format("%s", "")
	endif
	return ""
endfunction

let g:lightline = {
	\ 'colorscheme': 'wombat',
	\ 'active': {
	\ 	'left': [ [ 'mode', 'paste' ],
	\             [ 'readonly', 'filename', 'modified', 'gitbranch', 'current_func' ] ]
	\  },
	\ 'component_function': {
	\	'gitbranch': 'fugitive#head',
	\	'current_func': 'LightLineCurrentFunc'
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

" Disable neomake if first or last 5 lines of file contain `neomake: skip`
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
		\ | call neomake#virtualtext#show() 
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
if has('timers')
	call asyncomplete#register_source(
		\ asyncomplete#sources#omni#get_source_options({
		\ 	'name': 'omni',
		\ 	'whitelist': ['*'],
		\ 	'priority': 100,
		\ 	'completor': function('asyncomplete#sources#omni#completor')
		\ })
	\ )
	call asyncomplete#register_source(
		\ asyncomplete#sources#file#get_source_options({
		\ 	'name': 'file',
		\ 	'whitelist': ['*'],
		\ 	'priority': 10,
		\ 	'completor': function('asyncomplete#sources#file#completor')
		\ })
	\ )

	let g:asyncomplete_auto_popup = 0
	function! s:check_back_space() abort
		let col = col('.') - 1
		return !col || getline('.')[col - 1]  =~ '\s'
	endfunction

	inoremap <silent><expr> <TAB>
	  \ pumvisible() ? "\<C-n>" :
	  \ <SID>check_back_space() ? "\<TAB>" :
	  \ asyncomplete#force_refresh()
	inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
endif

if has('nvim-0.5.0')
	" Using shiny new nvim-lsp
	" Configure language servers
	if executable('rls')
		lua require'nvim_lsp'.rls.setup{}
	elseif executable('rust-analyzer')
		lua require'nvim_lsp'.rust_analyzer.setup{}
	endif
	if executable('clangd')
		lua require'nvim_lsp'.clangd.setup{}
	endif
	if executable('pyls')
		lua require'nvim_lsp'.pyls.setup{}
	endif
	if executable('gopls')
		lua require'nvim_lsp'.gopls.setup{}
	endif
	" Enable autocompletion
	augroup LSPOmniFunc
		autocmd!
		autocmd FileType c setlocal omnifunc=v:lua.vim.lsp.omnifunc
		autocmd FileType cpp setlocal omnifunc=v:lua.vim.lsp.omnifunc
		autocmd FileType python setlocal omnifunc=v:lua.vim.lsp.omnifunc
		autocmd FileType rust setlocal omnifunc=v:lua.vim.lsp.omnifunc
		autocmd FileType go setlocal omnifunc=v:lua.vim.lsp.omnifunc
	augroup END
	" We use NeoMake for diagnostics, so disable them in nvim-lsp
	lua vim.lsp.callbacks['textDocument/publishDiagnostics'] = nil
	nnoremap <silent> <leader>r <cmd>lua vim.lsp.buf.rename()<CR>
	nnoremap <silent> <leader>d <cmd>lua vim.lsp.buf.definition()<CR>
	nnoremap <silent> <leader>D <cmd>lua vim.lsp.buf.implementation()<CR>
	nnoremap <silent> <leader>k <cmd>lua vim.lsp.buf.hover()<CR>
	nnoremap <silent> <leader>gr <cmd>call luaeval("vim.lsp.buf.references()")<CR>
	nnoremap <silent> <leader>gs <cmd>call luaeval("vim.lsp.buf.document_symbol()")<CR>

	lua <<END
vim.lsp.callbacks['textDocument/references'] = function(_, _, result)
	if not result then return end
	vim.lsp.util.set_qflist(vim.lsp.util.locations_to_items(result))
	vim.api.nvim_command('Clap quickfix')
end
vim.lsp.callbacks['textDocument/documentSymbol'] = function(_, _, result, _, bufnr)
	if not result or vim.tbl_isempty(result) then return end
	vim.lsp.util.set_qflist(vim.lsp.util.symbols_to_items(result, bufnr))
	vim.api.nvim_command('Clap quickfix')
end
END
else
	" Using LangugeClient-neovim and Jedi
	let g:LanguageClient_serverCommands = {
	    \ 'rust': ['/usr/bin/rls'],
	    \ 'python': ['/usr/bin/env', 'pyls'],
		\ 'c': ['/usr/bin/clangd'],
		\ 'cpp': ['/usr/bin/clangd'],
		\ }
	" Do not stop LSP when closing last file of type
	let g:LanguageClient_autoStop = 0
	" We use NeoMake for diagnostics, so disable them in LanguageClient-neovim
	let g:LanguageClient_diagnosticsEnable = 0
	nnoremap <silent> <leader>d :call LanguageClient#textDocument_definition()<CR>
	nnoremap <silent> <leader>r :call LanguageClient#textDocument_rename()<CR>

	" Use right for `go to definition`
	let g:jedi#use_splits_not_buffers = 'right'
	" Do not show autocompletion when `.` is pressed
	let g:jedi#popup_on_dot = 0
endif

" Firenvim (using NeoVim in browser) [S_FIRENVIM]:

if exists('g:started_by_firenvim')
	let g:firenvim_config = { 'localSettings': {} }
	let fc = g:firenvim_config['localSettings']
	let fc['.*'] = { 'takeover': 'never' }
	au BufEnter github.*.txt set filetype=markdown
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

" Vimteractive
if executable('ipython')
	let g:vimteractive_default_shells = {
	\ 'python': 'ipython'
	\ }
endif

" Silicon
let g:silicon = {
	\ 'theme': 'OneHalfDark',
	\ 'window-controls': v:false,
	\ 'output': '/tmp/silicon-{time:%Y-%m-%d%H%M%S}.png',
	\ 'pad-horiz': 0,
	\ 'pad-vert': 0,
	\ 'round-corner': v:false,
	\ }

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
