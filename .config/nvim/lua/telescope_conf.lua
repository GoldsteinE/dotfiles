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

map('n', '<leader>f', builtin.find_files)
-- Not `g` because of ergonomics; `l` means `lines (in all files)`
map('n', '<leader>l', builtin.live_grep)
map('n', '<leader>L', builtin.grep_string)
-- Lines in the current buffer
map('n', '<leader>;', builtin.current_buffer_fuzzy_find)
-- Buffers (useful after long go-to-definition chains)
map('n', '<leader>b', builtin.buffers)
-- LSP references
map('n', '<leader>gr', builtin.lsp_references)
-- LSP symbols in the current document
map('n', '<leader>gs', builtin.lsp_document_symbols)
-- LSP symbols in the project
map('n', '<leader>ws', builtin.lsp_workspace_symbols)
