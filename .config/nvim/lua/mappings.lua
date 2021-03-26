local vimp = require('vimp')

-- Exit insert mode with `jk`
vimp.inoremap('jk', '<Esc>')
-- Make & work in visual mode
vimp.xnoremap('&', ':s<Up><Return>')
-- Repeat the last macro
vimp.nnoremap('Q', '@@')
-- Make Y work sensibly
vimp.nnoremap('Y', 'yy')
-- Repurpose `s` for deletion without clobbering clipboard
vimp.nnoremap('s', '"_d')
-- Diff with the file on disk
vimp.nnoremap('<Leader>=', ':w !git diff --no-index -- % -<Return>')
-- Disable search highlighting
vimp.nnoremap({'silent'}, '<C-l>', ':nohl<Return>')

-- nvim-luadev
function register_luadev_mappings()
	vimp.add_buffer_maps(function()
		vimp.nmap({'silent'}, '<Leader>ll', ':Luadev<CR>')
		vimp.nmap('<Leader>lr', '<Plug>(Luadev-RunLine)')
		vimp.xmap('<Leader>lr', '<Plug>(Luadev-Run)')
		vimp.xmap('<Leader>lw', '<Plug>(Luadev-RunWord)')
	end)
end

vim.cmd [[ augroup LuaDevMaps ]]
vim.cmd [[ autocmd! ]]
vim.cmd [[ autocmd FileType lua lua register_luadev_mappings() ]]
vim.cmd [[ augroup END ]]

-- neoterm
vimp.inoremap({'silent'}, '<C-s>', '<C-o>:TREPLSendLine<CR>')
vimp.nmap('<C-s>', '<Plug>(neoterm-repl-send-line)')
vimp.nmap('<Leader>s', '<Plug>(neoterm-repl-send)')
vimp.xmap('<Leader>s', '<Plug>(neoterm-repl-send)')
vimp.xmap('<C-s>', '<Plug>(neoterm-repl-send)')
