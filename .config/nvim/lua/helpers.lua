function _G.executable(command)
	return vim.fn.executable(command) ~= 0
end

local function _map(api, mode, lhs, rhs, params)
	if params == nil then
		params = {}
	end
	if type(rhs) == 'function' then
		params.callback = rhs
		rhs = ''
	end
	params.noremap = true
	if params.re ~= nil then
		params.re = nil
		params.noremap = nil
	end

	api(mode, lhs, rhs, params)
end

function _G.map(mode, lhs, rhs, params)
	_map(vim.api.nvim_set_keymap, mode, lhs, rhs, params)
end

function _G.bufmap(buf, mode, lhs, rhs, params)
	local function api(mode, lhs, rhs, params)
		vim.api.nvim_buf_set_keymap(buf, mode, lhs, rhs, params)
	end
	_map(api, mode, lhs, rhs, params)
end

_G.augroup = function(name, opts)
	if opts == nil then
		opts = {}
	end
	return vim.api.nvim_create_augroup(name, opts)
end
_G.autocmd = vim.api.nvim_create_autocmd
