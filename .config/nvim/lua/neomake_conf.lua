-- Disable neomake if first or last 5 lines of the file contain `neomake: skip`
function check_neomake_skip()
	local line
	local lines = vim.api.nvim_buf_get_lines(0, 0, 4, false)
	local line_count = vim.api.nvim_buf_line_count(0)
	vim.list_extend(
		lines,
		vim.api.nvim_buf_get_lines(0, line_count - 5, line_count, false)
	)
	for idx, line in ipairs(lines) do
		if line:find("neomake: skip") then
			vim.cmd [[ silent NeomakeDisableBuffer ]]
			vim.cmd [[ silent call neomake#virtualtext#hide() ]]
			vim.cmd [[ NeomakeClean ]]
			return
		end
	end
	local ds = vim.fn['neomake#config#get_with_source'](
		'disabled', 0
	)
	if ds[1] ~= 0 and ds[2] == 'buffer' then
		vim.cmd [[ silent NeomakeEnableBuffer ]]
		vim.cmd [[ Neomake ]]
	end
end

function neomake_refresh()
	vim.cmd [[ silent call neomake#virtualtext#hide() ]]
	vim.cmd [[ silent call neomake#virtualtext#show() ]]
end

vim.cmd [[ augroup Neomake ]]
vim.cmd [[ autocmd! ]]
vim.cmd [[ autocmd BufEnter,InsertLeave,TextChanged * call v:lua.check_neomake_skip() ]]
vim.cmd [[ autocmd User NeomakeJobFinished call v:lua.neomake_refresh() ]]
vim.cmd [[ augroup END ]]

vim.g.neomake_highlight_lines = 1
vim.g.neomake_highlight_columns = 0

-- NeoMake linters config
vim.g.neomake_shellcheck_args = {'-fgcc'}
do
	local python_makers = {'python'}
	if executable('flake8') then
		table.insert(python_makers, 'flake8')
	end
	if executable('mypy') then
		table.insert(python_makers, 'mypy')
	end
	if executable('pylint') then
		table.insert(python_makers, 'pylint')
	end
	vim.g.neomake_python_enabled_makers = python_makers
end
vim.g.neomake_rust_enabled_makers = {}
vim.g.neomake_cpp_enabled_makers = {}

-- Sign column symbols
vim.g.neomake_error_sign = {
	text = vim.fn.nr2char(10007),
	texthl = 'NeomakeErrorSign'
}
vim.g.neomake_warning_sign = {
	text = vim.fn.nr2char(9998),
	texthl = 'NeomakeWarningSign'
}
vim.g.neomake_info_sign = {
	text = vim.fn.nr2char(10148),
	texthl = 'NeomakeInfoSign'
}
vim.g.neomake_message_sign = {
	text = vim.fn.nr2char(10148),
	texthl = 'NeomakeMessageSign'
}

-- Run all makers with 200ms timeout in all modes
vim.fn['neomake#configure#automake']('nrwi', 200)
