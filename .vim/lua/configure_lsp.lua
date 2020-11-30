local lspconfig = require 'lspconfig'

local executable = vim.fn.executable

if executable('rust-analyzer') then
	lspconfig.rust_analyzer.setup{}
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
