require('compe').setup {
	enabled = true;
	autocomplete = false;
	source = {
		path = true;
		nvim_lsp = true;
		nvim_lua = true;
		buffer = true;
		calc = {
			priority = 100;
		};
	};
}

vimp.inoremap({'silent', 'expr'}, '<Tab>', function()
	if vim.fn.pumvisible() ~= 0 then
		return '<C-n>'
	end

	local line = vim.fn.getline('.')
	line = string.sub(line, 1, vim.fn.col('.') - 1)
	if string == nil or string.match(line, "%S") == nil then
		return '<Tab>'
	end
	return vim.fn['compe#complete']()
end)

vimp.inoremap({'silent'}, '<S-Tab>', '<C-p>')
vimp.inoremap({'silent', 'expr'}, '<CR>', "compe#confirm('<CR>')")
vimp.inoremap({'silent', 'expr'}, '<C-e>', "compe#close('<C-e>')")
