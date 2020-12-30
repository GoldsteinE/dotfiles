function lightline_filetype()
	return vim.fn.WebDevIconsGetFileTypeSymbol() .. ' ' .. vim.bo.filetype
end

vim.g.lightline = {
	colorscheme = 'wombat',
	separator = {
		left = vim.fn.nr2char(57520),
		right = vim.fn.nr2char(57522)
	},
	subseparator = {
		left = vim.fn.nr2char(57521),
		right = vim.fn.nr2char(57523)
	},
	active = {
		left = {
			{ 'mode', 'paste' },
			{ 'readonly', 'filename', 'modified', 'gitbranch', 'current_func' }
		}
	},
	component_function = {
		gitbranch = 'FugitiveHead',
		current_func = 'cfi#get_func_name',
	},
	component = {
		filetype = '%{v:lua.lightline_filetype()}',
	},
}

if vim.g.notepad_mode then
	vim.g.lightline.colorscheme = 'ayu_light'
end
