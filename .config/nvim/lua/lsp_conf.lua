local lspconfig = require 'lspconfig'

local function capabilities()
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities.textDocument.completion.completionItem.snippetSupport = true
	capabilities.textDocument.completion.completionItem.preselectSupport = true
	capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
	capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
	capabilities.textDocument.completion.completionItem.deprecatedSupport = true
	capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
	capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
	capabilities.textDocument.completion.completionItem.resolveSupport = {
		properties = {
			'documentation',
			'detail',
			'additionalTextEdits',
		}
	}
end

if executable('rust-analyzer') then
	lspconfig.rust_analyzer.setup{
		settings = {
			["rust-analyzer"] = {
				cargo = {
					allFeatures = true,
				},
				completion = {
					autoimport = {
						enable = true
					}
				},
				assist = {
					importMergeBehaviour = "full",
					importPrefix = "by_crate"
				}
			}
		},
		capabilities = capabilities(),
	}
end

if executable('clangd') then
	lspconfig.clangd.setup{
		capabilities = capabilities(),
	}
end

if executable('pyls') then
	lspconfig.pyls.setup{
		capabilities = capabilities(),
	}
end

if executable('gopls') then
	lspconfig.gopls.setup{
		capabilities = capabilities(),
	}
end

-- We use NeoMake for diagnostics, so disable them in nvim-lsp
vim.lsp.handlers['textDocument/publishDiagnostics'] = function() end

local vimp = require 'vimp'

-- And some keybindings
vimp.nnoremap({'silent'}, '<leader>r', vim.lsp.buf.rename)
vimp.nnoremap({'silent'}, '<leader>d', vim.lsp.buf.definition)
vimp.nnoremap({'silent'}, '<leader>D', vim.lsp.buf.implementation)
vimp.nnoremap({'silent'}, '<leader>k', vim.lsp.buf.hover)
