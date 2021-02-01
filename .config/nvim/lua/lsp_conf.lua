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

-- We use NeoMake for diagnostics, so disable them in nvim-lsp
vim.lsp.callbacks['textDocument/publishDiagnostics'] = nil

local vimp = require 'vimp'

-- And some keybindings
vimp.nnoremap({'silent'}, '<leader>r', vim.lsp.buf.rename)
vimp.nnoremap({'silent'}, '<leader>d', vim.lsp.buf.definition)
vimp.nnoremap({'silent'}, '<leader>D', vim.lsp.buf.implementation)
vimp.nnoremap({'silent'}, '<leader>k', vim.lsp.buf.hover)
