local vimp = require 'vimp'
local builtin = require 'telescope.builtin'
local actions = require 'telescope.actions'
local previewers = require 'telescope.previewers'

require('telescope').setup {
	defaults = {
		mappings = {
			i = {
				["<c-j>"] = actions.move_selection_next,
				["<c-k>"] = actions.move_selection_previous,
			}
		},
		file_previewer = previewers.vim_buffer_cat.new,
		grep_previewer = previewers.vim_buffer_vimgrep.new,
		qflist_previewer = previewers.vim_buffer_qflist.new
	}
}

-- Mappings
vimp.nnoremap('<leader>f', builtin.find_files)
-- Not `g` because of ergonomics; `l` means `lines (in all files)`
vimp.nnoremap('<leader>l', builtin.live_grep)
vimp.nnoremap('<leader>L', builtin.grep_string)
-- Lines in the current buffer
vimp.nnoremap('<leader>;', builtin.current_buffer_fuzzy_find)
-- Buffers (useful after long go-to-definition chains)
vimp.nnoremap('<leader>b', builtin.buffers)
-- LSP references
vimp.nnoremap('<leader>gr', builtin.lsp_references)
-- LSP symbols in the current document
vimp.nnoremap('<leader>gs', builtin.lsp_document_symbols)
-- LSP symbols in the project
vimp.nnoremap('<leader>ws', builtin.lsp_workspace_symbols)
-- LSP code actions under cursor
vimp.nnoremap('<leader>a', builtin.lsp_code_actions)
