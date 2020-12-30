require 'nvim-treesitter.configs'.setup {
	ensure_installed = { "rust", "c", "cpp", "python", "toml", "query", "lua" },
	highlight = {
		enable = true,
		custom_captures = {
			["include"] = "Keyword",
			["attribute_item.meta_item.identifier"] = "PreProc"
		}
	},
	indent = {
		enable = true
	},
	playground = {
		enable = true
	}
}
