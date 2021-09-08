local function feed(keys)
	vim.fn.feedkeys(vim.api.nvim_replace_termcodes(keys, true, true, true), 'y')
end

local cmp = require 'cmp'
cmp.setup {
	completion = {
		autocomplete = false
	},

	sources = {
		{ name = 'nvim_lsp' },
		{ name = 'nvim_lua' },
		{ name = 'latex_symbols' },
		{ name = 'path' },
		{ name = 'buffer' },
		{ name = 'calc' },
	},

	mapping = {
		['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 's' }),
		['<C-n>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' }),
		['<C-p>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 's' }),
		['<S-Tab>'] = cmp.mapping(function(fallback)
			if vim.fn.pumvisible() == 1 then
				feed('<C-p>')
			else
				fallback()
			end
		end, { 'i', 's' }),
		['<Tab>'] = cmp.mapping(function(fallback)
			if vim.fn.pumvisible() == 1 then
				feed('<C-n>')
			else
				local line = vim.fn.getline('.')
				line = string.sub(line, 1, vim.fn.col('.') - 1)
				if string == nil or string.match(line, "%S") == nil then
					fallback()
				else
					feed('<C-Space>')
				end
			end
		end, { 'i', 's' }),
		['<CR>'] = cmp.mapping(
			cmp.mapping.confirm({ select = false, behavior = cmp.ConfirmBehavior.Insert }),
			{ 'i', 's' }
		),
		['<C-e>'] = cmp.mapping.close(),
		['<C-d>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
	}
}
