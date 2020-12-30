local lspconfig = require 'lspconfig'
if executable('rust-analyzer') then
	lspconfig.rust_analyzer.setup{
		settings = {
			["rust-analyzer"] = {
				completion = {
					enableAutoimportCompletions = true
				},
				assist = {
					importMergeBehaviour = "full",
					importPrefix = "by_crate"
				}
			}
		}
	}
elseif executable('rls') then
	lspconfig.rls.setup{}
end

if executable('clangd') then
	lspconfig.clangd.setup{}
end

if executable('pyls') then
	lspconfig.pyls.setup{}
end

if executable('gopls') then
	lspconfig.gopls.setup{}
end

-- Make nvim-lsp work with Clap
vim.lsp.callbacks['textDocument/references'] = function(_, _, result)
	if not result then return end

	vim.lsp.util.set_qflist(vim.lsp.util.locations_to_items(result))
	vim.cmd [[ Clap quickfix ]]
end

vim.lsp.callbacks['textDocument/documentSymbol'] = function(_, _, result, _, bufnr)
	if not result or vim.tbl_isempty(result) then return end

	vim.lsp.util.set_qflist(vim.lsp.util.symbols_to_items(result, bufnr))
	vim.cmd [[ Clap quickfix ]]
end

-- We use NeoMake for diagnostics, so disable them in nvim-lsp
vim.lsp.callbacks['textDocument/publishDiagnostics'] = nil

local vimp = require 'vimp'

-- Configure tab completion
vimp.imap({'silent'}, '<Tab>', '<Plug>(completion_smart_tab)')
vimp.imap({'silent'}, '<S-Tab>', '<Plug>(completion_smart_s_tab)')
vimp.imap('<C-l>', '<Plug>(vsnip-jump-next)')
vimp.imap('<C-h>', '<Plug>(vsnip-jump-prev)')

-- And some keybindings
vimp.nnoremap({'silent'}, '<leader>r', vim.lsp.buf.rename)
vimp.nnoremap({'silent'}, '<leader>d', vim.lsp.buf.definition)
vimp.nnoremap({'silent'}, '<leader>D', vim.lsp.buf.implementation)
vimp.nnoremap({'silent'}, '<leader>k', vim.lsp.buf.hover)
vimp.nnoremap({'silent'}, '<leader>gr', vim.lsp.buf.references)
vimp.nnoremap({'silent'}, '<leader>gs', vim.lsp.buf.document_symbol)
