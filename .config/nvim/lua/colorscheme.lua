-- Set colorscheme
if vim.g.notepad_mode then
	-- We have to set `background=light` for `one` manually...
	setopt('o', 'background', 'light')
	vim.cmd [[ colorscheme one ]]
else
	-- ..but `atom-dark` sets it for us
	vim.cmd [[ colorscheme atom-dark ]]
end
