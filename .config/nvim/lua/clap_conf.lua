vim.g.clap_theme = 'atom_dark'
vim.g.clap_layout = { relative = 'editor' }
vim.g.clap_selected_sign = {
	text = vim.fn.nr2char(10148),
	texthl = 'ClapSelectedSign',
	linehl = 'ClapSelected'
}
vim.g.clap_current_selection_sign = {
	text = vim.fn.nr2char(10095),
	texthl = 'ClapCurrentSelectionSign',
	linehl = 'ClapCurrentSelection'
}

-- Mappings
vimp.nnoremap({'silent'}, '<Leader>f', ':Clap files<Return>')
-- Not `g` because of ergonomics; `l` means `lines (in all files)`
vimp.nnoremap({'silent'}, '<leader>l', ':Clap grep<Return>')
vimp.nnoremap({'silent'}, '<leader>L', ':Clap grep ++query=<cword><Return>')
vimp.nnoremap({'silent'}, '<leader>p', ':Clap yanks<Return>')
-- Lines in current buffer
vimp.nnoremap({'silent'}, '<leader>;', ':Clap blines<Return>')
vimp.nnoremap({'silent'}, '<leader>:', ':Clap blines ++query=<cword><Return>')
-- Buffers (useful after long go-to-definition chains)
vimp.nnoremap({'silent'}, '<leader>b', ':Clap buffers<Return>')
